#!/bin/bash
# Terminal Menu — a gum-powered launcher for the small internet and terminal life
#
# Install: brew install gum
# Usage: menu
# Config: ~/.config/terminal-menu/entries.json

set -euo pipefail

CONFIG_DIR="${HOME}/.config/terminal-menu"
CONFIG_FILE="${CONFIG_DIR}/entries.json"

# Colors (Catppuccin Mocha — change these to match your theme)
PINK="#f5c2e7"
MAUVE="#cba6f7"
BLUE="#89b4fa"
GREEN="#a6e3a1"
PEACH="#fab387"
TEXT="#cdd6f4"
SURFACE="#313244"

# Menu title — make it yours!
MENU_TITLE="${TERMINAL_MENU_TITLE:-Terminal Menu}"

# Initialize config if missing
init_config() {
    mkdir -p "$CONFIG_DIR"
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" << 'EOF'
{
  "categories": {
    "🌐 Small Internet": {
      "subcategories": {
        "🖥️  BBSes": [
          {"name": "Dawn of Demise", "cmd": "luit -encoding CP437 telnet tdod.org 5000", "desc": "Synchronet BBS"},
          {"name": "ISCABBS", "cmd": "telnet bbs.iscabbs.com", "desc": "Oldest free online community"},
          {"name": "Archaic Binary", "cmd": "luit -encoding CP437 telnet bbs.archaicbinary.net", "desc": "Active Synchronet BBS"},
          {"name": "Capitol City Online", "cmd": "luit -encoding CP437 telnet capitolcityonline.net", "desc": "Synchronet BBS"},
          {"name": "Palantir BBS", "cmd": "luit -encoding CP437 telnet palantirbbs.ddns.net", "desc": "Pensacola, FL"}
        ],
        "🐉 MUDs & Games": [
          {"name": "Aardwolf", "cmd": "telnet aardmud.org 4000", "desc": "Popular active MUD"},
          {"name": "Legend of the Red Dragon", "cmd": "telnet lord.stabs.org", "desc": "The classic BBS door game"},
          {"name": "Telehack", "cmd": "telnet telehack.com", "desc": "1980s internet simulator"},
          {"name": "Chess (FICS)", "cmd": "telnet freechess.org 5000", "desc": "Free Internet Chess Server"}
        ],
        "🌍 Telnet Toys": [
          {"name": "Mapscii", "cmd": "telnet mapscii.me", "desc": "Braille world map in terminal"},
          {"name": "NASA Horizons", "cmd": "telnet horizons.jpl.nasa.gov 6775", "desc": "Solar system data query"},
          {"name": "Bitcoin Ticker", "cmd": "telnet ticker.bitcointicker.co 10080", "desc": "Live BTC price"}
        ],
        "🕳️  Gopherholes": [
          {"name": "Floodgap Gopher", "cmd": "curl -s gopher://gopher.floodgap.com | less", "desc": "The main Gopher hub"},
          {"name": "SDF Gopherspace", "cmd": "curl -s gopher://sdf.org | less", "desc": "SDF public access Unix"}
        ],
        "🏠 Tildes": [
          {"name": "tilde.town", "cmd": "ssh tilde.town", "desc": "Apply: tilde.town/signup"},
          {"name": "tilde.club", "cmd": "ssh tilde.club", "desc": "Apply: tilde.club"},
          {"name": "cosmic.voyage", "cmd": "ssh cosmic.voyage", "desc": "Collaborative sci-fi universe"}
        ]
      }
    },
    "🎮 Toys": {
      "entries": [
        {"name": "cbonsai", "cmd": "cbonsai -l", "desc": "Grow a bonsai tree"},
        {"name": "cmatrix", "cmd": "cmatrix", "desc": "Matrix rain"},
        {"name": "sl", "cmd": "sl", "desc": "Steam locomotive"},
        {"name": "fortune | cowsay", "cmd": "fortune | cowsay", "desc": "Fortune cookie cow"}
      ]
    },
    "🔧 Tools": {
      "entries": [
        {"name": "lazygit", "cmd": "lazygit", "desc": "Git TUI"},
        {"name": "htop", "cmd": "htop", "desc": "Process monitor"},
        {"name": "neovim", "cmd": "nvim", "desc": "Text editor"},
        {"name": "glow", "cmd": "glow", "desc": "Markdown reader"},
        {"name": "fastfetch", "cmd": "fastfetch", "desc": "System info"}
      ]
    },
    "🎵 Media": {
      "entries": [
        {"name": "spotify_player", "cmd": "spotify_player", "desc": "Spotify TUI"},
        {"name": "cava", "cmd": "cava", "desc": "Audio visualizer"},
        {"name": "SomaFM Groovesalad", "cmd": "curl -s https://somafm.com/groovesalad256.pls | grep File1 | cut -d= -f2 | xargs afplay", "desc": "Ambient/downtempo radio"},
        {"name": "SomaFM DEF CON", "cmd": "curl -s https://somafm.com/defcon256.pls | grep File1 | cut -d= -f2 | xargs afplay", "desc": "Hacker conference radio"},
        {"name": "SomaFM Drone Zone", "cmd": "curl -s https://somafm.com/dronezone256.pls | grep File1 | cut -d= -f2 | xargs afplay", "desc": "Atmospheric ambient"}
      ]
    }
  }
}
EOF
        echo "Created config at $CONFIG_FILE"
        echo "Edit it to add your own entries: menu edit"
    fi
}

# Main menu
main_menu() {
    init_config
    
    while true; do
        local categories
        categories=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
for cat in data['categories']:
    print(cat)
")
        
        local choice
        choice=$(echo "$categories" | gum choose \
            --header "  ╔══════════════════════════════╗
  ║    $MENU_TITLE$(printf '%*s' $((20 - ${#MENU_TITLE})) '')║
  ╚══════════════════════════════╝" \
            --header.foreground "$PINK" \
            --cursor.foreground "$MAUVE" \
            --selected.foreground "$GREEN") || return 0
        
        category_menu "$choice"
    done
}

# Category menu (handles both subcategories and flat entries)
category_menu() {
    local category="$1"
    
    while true; do
        local has_subs
        has_subs=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
cat = data['categories']['$category']
print('yes' if 'subcategories' in cat else 'no')
")
        
        if [ "$has_subs" = "yes" ]; then
            local subcats
            subcats=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
for sub in data['categories']['$category']['subcategories']:
    print(sub)
")
            local sub_choice
            sub_choice=$(echo "$subcats" | gum choose \
                --header "  $category" \
                --header.foreground "$BLUE" \
                --cursor.foreground "$MAUVE" \
                --selected.foreground "$GREEN") || return 0
            
            subcategory_menu "$category" "$sub_choice"
        else
            local entries
            entries=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
for e in data['categories']['$category']['entries']:
    desc = e.get('desc', '')
    print(f\"{e['name']}  ·  {desc}\")
")
            local entry_choice
            entry_choice=$(echo "$entries" | gum choose \
                --header "  $category" \
                --header.foreground "$BLUE" \
                --cursor.foreground "$MAUVE" \
                --selected.foreground "$GREEN") || return 0
            
            local entry_name="${entry_choice%%  ·  *}"
            launch_entry "$category" "" "$entry_name"
        fi
    done
}

# Subcategory menu
subcategory_menu() {
    local category="$1"
    local subcategory="$2"
    
    while true; do
        local entries
        entries=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
for e in data['categories']['$category']['subcategories']['$subcategory']:
    desc = e.get('desc', '')
    print(f\"{e['name']}  ·  {desc}\")
")
        local entry_choice
        entry_choice=$(echo "$entries" | gum choose \
            --header "  $subcategory" \
            --header.foreground "$BLUE" \
            --cursor.foreground "$MAUVE" \
            --selected.foreground "$GREEN") || return 0
        
        local entry_name="${entry_choice%%  ·  *}"
        launch_entry "$category" "$subcategory" "$entry_name"
    done
}

# Launch an entry
launch_entry() {
    local category="$1"
    local subcategory="$2"
    local name="$3"
    
    local cmd
    cmd=$(python3 -c "
import json
with open('$CONFIG_FILE') as f:
    data = json.load(f)
cat = data['categories']['$category']
if '$subcategory':
    entries = cat['subcategories']['$subcategory']
else:
    entries = cat['entries']
for e in entries:
    if e['name'] == '$name':
        print(e['cmd'])
        break
")
    
    if [ -n "$cmd" ]; then
        echo ""
        gum style --foreground "$GREEN" "Launching: $name"
        gum style --foreground "$SURFACE" "$cmd"
        echo ""
        eval "$cmd"
    fi
}

# Handle arguments
case "${1:-}" in
    edit)
        init_config
        ${EDITOR:-vim} "$CONFIG_FILE"
        ;;
    reset)
        rm -f "$CONFIG_FILE"
        init_config
        ;;
    *)
        main_menu
        ;;
esac
