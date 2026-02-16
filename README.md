# Terminal Menu 🛰️

A [gum](https://github.com/charmbracelet/gum)-powered launcher for the small internet, terminal toys, and everyday tools. Navigate BBSes, MUDs, Gopherholes, tilde servers, and your favorite CLI tools from one menu.

```
  ╔══════════════════════════════╗
  ║      Terminal Menu           ║
  ╚══════════════════════════════╝
   🌐 Small Internet
   🎮 Toys
   🔧 Tools
   🎵 Media
```

Arrow keys to navigate. Enter to launch. Escape to go back.

## Why?

The small internet is alive — BBSes with active communities, MUDs with players, Gopherholes with writers, tilde servers with neighbors. But the addresses are scattered across forum posts and wiki pages. This puts them all in one place, alongside the terminal tools you actually use.

## Install

### Dependencies

- [gum](https://github.com/charmbracelet/gum) — the menu UI
- [luit](https://invisible-island.net/luit/) — character encoding for BBSes (optional but recommended)
- [lynx](https://lynx.invisible-island.net/) — text-mode web/Gopher browser (for Gopherholes)
- [mpv](https://mpv.io/) — media player (for SomaFM radio streams)
- python3 — for config parsing
- telnet — for BBS/telnet connections

```bash
# macOS
brew install gum luit telnet lynx mpv

# Linux (Debian/Ubuntu)
sudo apt install luit telnet lynx mpv
# Install gum: https://github.com/charmbracelet/gum#installation
```

### Setup

```bash
git clone https://github.com/brezgis/terminal-menu.git
chmod +x terminal-menu/menu.sh

# Add an alias
echo "alias menu='bash $(pwd)/terminal-menu/menu.sh'" >> ~/.bashrc
source ~/.bashrc
```

Then just type `menu`.

## Make It Yours

### Change the title

Set the `TERMINAL_MENU_TITLE` environment variable:

```bash
export TERMINAL_MENU_TITLE="ghostwriter's den"
```

Add it to your `.bashrc` to make it permanent.

### Change the colors

Edit the color variables at the top of `menu.sh`. Defaults are [Catppuccin Mocha](https://github.com/catppuccin/catppuccin):

```bash
PINK="#f5c2e7"
MAUVE="#cba6f7"
BLUE="#89b4fa"
GREEN="#a6e3a1"
```

Some other themes to try:
- **Dracula:** `#ff79c6`, `#bd93f9`, `#8be9fd`, `#50fa7b`
- **Gruvbox:** `#d3869b`, `#d3869b`, `#83a598`, `#b8bb26`
- **Nord:** `#b48ead`, `#b48ead`, `#88c0d0`, `#a3be8c`

### Add your own entries

```bash
menu edit
```

This opens the config file (`~/.config/terminal-menu/entries.json`) in your editor. The structure:

```json
{
  "categories": {
    "🌐 Small Internet": {
      "subcategories": {
        "🖥️  BBSes": [
          {"name": "My Favorite BBS", "cmd": "luit -encoding CP437 telnet bbs.example.com", "desc": "A cool BBS"}
        ]
      }
    },
    "🎮 Toys": {
      "entries": [
        {"name": "cbonsai", "cmd": "cbonsai -l", "desc": "Grow a bonsai tree"}
      ]
    }
  }
}
```

**Categories** can have either:
- `subcategories` — nested menus (like Small Internet → BBSes, MUDs, etc.)
- `entries` — flat list of items

**Each entry** has:
- `name` — what shows in the menu
- `cmd` — shell command to run
- `desc` — short description shown next to the name

### Reset to defaults

```bash
menu reset
```

## What's in the default config?

### 🌐 Small Internet

**BBSes** — Bulletin Board Systems, the original social networks. Connect via telnet to message boards that have been running since the 90s (some since the 80s). Real communities with real people discussing everything from DOS hardware to daily life. Messages federate between BBSes through networks like [FidoNet](https://en.wikipedia.org/wiki/FidoNet) and DOVE-Net — your post on one BBS propagates to every other BBS in the network.

Included: Dawn of Demise, ISCABBS, Archaic Binary, Capitol City Online, Palantir BBS

**MUDs & Games** — Text-based multiplayer worlds. [Legend of the Red Dragon](http://lord.stabs.org/) is the classic BBS door game. [Aardwolf](http://www.aardwolf.com/) is one of the most active MUDs still running. [Telehack](http://telehack.com/) simulates the 1980s internet.

**Telnet Toys** — Fun stuff: [Mapscii](https://github.com/rastapasta/mapscii) (zoomable world map in Braille characters), NASA's solar system database, live Bitcoin price.

**Gopherholes** — [Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) is a protocol from 1991 that competed with the web and lost. It's pure hierarchical menus and plain text. No JavaScript, no ads, no tracking. There's a small but active revival community. Browsed via [lynx](https://lynx.invisible-island.net/).

**Tildes** — Shared Unix servers where you get a shell account and a community. SSH in, write scripts, make a homepage, chat with neighbors. The BBS ethos reborn on modern Unix. You need to apply for an account (links in the menu). Learn more at [tildeverse.org](https://tildeverse.org/).

### 🎮 Toys

Terminal eye candy: cbonsai (grow a bonsai tree), cmatrix (Matrix rain), sl (steam locomotive), fortune | cowsay.

### 🔧 Tools

Daily drivers: lazygit (Git TUI), neovim, micro, glow (markdown reader), fastfetch (system info).

### 🎵 Media

**Music Apps** — spotify_player (Spotify TUI).

**SomaFM Radio** — [SomaFM](https://somafm.com/) is independent, listener-supported internet radio that's been running since 2000. No ads, no tracking, just good music. Streams play via [mpv](https://mpv.io/) in the terminal. Ctrl+C to stop. Stations included:

- **Groovesalad** — ambient/downtempo
- **DEF CON Radio** — hacker conference vibes
- **Drone Zone** — atmospheric ambient
- **Lush** — mellow vocals & electronic
- **Secret Agent** — Bond soundtracks & lounge

## BBS Tips for Beginners

- **Use a throwaway password.** Telnet is unencrypted — never reuse a real password.
- **Don't enter real personal info.** Use a handle, fake name, junk email.
- **Navigation:** Single-letter commands — R (read), P (post), Q (quit/back), O (logoff), J (jump to board), * (list boards).
- **ANSI art looks garbled?** Your terminal is probably reading CP437 as UTF-8. The `luit -encoding CP437` wrapper fixes this, or use [SyncTERM](https://syncterm.bbsdev.net/) for native support.
- **Tilde servers use SSH** (encrypted) — these are safe to use real credentials on.
- **Messages federate.** When you post on a DOVE-Net or FidoNet board, your message propagates to every other BBS in the network. You're not just posting to one server.

## The Small Internet

The small internet is everything that isn't the commercial web. BBSes, Gopher, Gemini, tildes, MUDs, IRC — communities that run on open protocols, personal servers, and the volunteer labor of sysops. No algorithms, no ads, no engagement metrics. Just people talking to people.

Some starting points beyond this menu:
- [Telnet BBS Guide](https://www.telnetbbsguide.com/) — directory of 983 active BBSes
- [Floodgap Gopher](https://gopher.floodgap.com/gopher/) — the Gopher hub (web proxy; use `lynx gopher://gopher.floodgap.com` for the real thing)
- [Gemini Protocol](https://geminiprotocol.net/) — the modern small web
- [tildeverse.org](https://tildeverse.org/) — directory of tilde communities
- [Awesome Gemini](https://github.com/kr1sp1n/awesome-gemini) — curated Gemini resources
- [SomaFM](https://somafm.com/) — independent internet radio since 2000

## License

MIT — do whatever you want with it.
