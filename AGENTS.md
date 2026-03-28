# AGENTS.md

Guide for AI agents working in this repository.

## Project Overview

Personal **dotfiles** repository for a macOS system (Apple Silicon / Homebrew). It tracks shell configuration, CLI tool settings, fonts, app preferences, LaunchAgents, and utility scripts. There is no application source code, no build system, and no test suite.

The repository is designed to be copied into `$HOME` on a Mac via `bootstrap.sh`.

## Repository Structure

```
.                           # Root = $HOME layout
├── bootstrap.sh            # Applies all dotfiles to $HOME via rsync
├── .bash_profile           # Login shell: env vars, PATH, colors, tool setup
├── .bashrc                 # Interactive shell: prompt, history, completions, fzf
├── .bash_aliases           # Shell aliases (git, ls, python, etc.)
├── .bash_functions         # Shell functions (printTable, sqlite2csv, gi)
├── .zprofile               # Zsh login shell: env vars, PATH (mirrors .bash_profile)
├── .zshrc                  # Zsh interactive shell: prompt, history, completions, fzf
├── .editorconfig           # EditorConfig (spaces, indent 4, LF)
├── .eslintrc.js            # ESLint defaults (indent 4, single quotes, semicolons)
├── .gitignore              # Whitelist-based: ignores everything, then un-ignores tracked files
├── .gitignore_global       # Global gitignore (macOS, Sublime, common junk)
├── .hgignore_global        # Mercurial global ignore
├── .curlrc / .wgetrc       # HTTP client defaults (user-agent, timeouts)
├── .lynxrc                 # Lynx browser config (UTF-8, micro as editor)
├── .nanorc                 # Nano editor config (autoindent, tabs→spaces, tabsize 4)
├── .npmrc                  # npm config (progress=false)
├── .psqlrc                 # psql config (micro as editor, :expand macro)
├── .ansible.cfg            # Ansible defaults (vault, python3 interpreter)
├── .selected_editor        # System default editor → micro
├── .ollama/config.json     # Ollama LLM runtime config (GPU, 36 GB RAM, 12 threads)
│
├── .config/
│   ├── btop/btop.conf          # btop system monitor
│   ├── cheat/conf.yml          # cheat cheatsheets config
│   ├── crush/crush.json        # Crush AI agent (Ollama provider, qwen3:30b)
│   ├── espanso/                # Text expander (snippets, dates, IP lookup)
│   ├── htop/htoprc             # htop config
│   ├── lazydocker/config.yml   # lazydocker TUI
│   ├── lazygit/config.yml      # lazygit TUI (empty — defaults)
│   ├── mc/                     # Midnight Commander (ini, extensions, syntax)
│   ├── micro/settings.json     # micro editor (geany colorscheme)
│   ├── neofetch/config.conf    # neofetch system info display
│   ├── opencode/config.json    # OpenCode AI agent (Ollama provider)
│   ├── ripasso/settings.toml   # ripasso password manager
│   ├── terminal/               # macOS Terminal.app themes (lilac dark/light)
│   ├── thefuck/settings.py     # thefuck auto-corrector
│   └── zed/settings.json       # Zed editor (One Light/Dark, Prettier, Copilot)
│
├── .local/
│   ├── bin/
│   │   ├── terminal-theme-switcher   # Switches Terminal.app dark/light theme
│   │   └── metadata_never_index.sh   # Drops .metadata_never_index in junk dirs
│   └── share/mc/                     # MC skins and syntax files
│
└── Library/                          # macOS ~/Library tracked items
    ├── Application Support/          # lazydocker, lazygit, tera configs
    ├── Containers/                   # CotEditor, TextEdit sandboxed prefs (plist)
    ├── Fonts/                        # Fira Code Nerd Font, monofur, Ubuntu, Syne Mono
    ├── LaunchAgents/                 # com.lilac.terminal-theme-switcher.plist
    └── Preferences/                  # App and system plists:
        ├── .GlobalPreferences.plist   #   System-wide (accent color, languages, dark mode)
        ├── com.apple.dock.plist       #   Dock layout and hot corners
        ├── com.apple.finder.plist     #   Finder view settings
        ├── com.apple.HIToolbox.plist  #   Keyboard input sources (US + Russian)
        ├── com.apple.symbolichotkeys.plist
        ├── com.apple.AppleMultitouchMouse.plist
        ├── com.apple.AppleMultitouchTrackpad.plist
        ├── com.apple.driver.AppleBluetoothMultitouch.mouse.plist
        ├── com.apple.driver.AppleBluetoothMultitouch.trackpad.plist
        ├── com.apple.driver.AppleHIDMouse.plist
        ├── com.apple.controlcenter.plist
        ├── com.apple.menuextra.clock.plist
        ├── com.apple.spaces.plist
        ├── com.apple.wallpaper.plist
        ├── com.adguard.mac.adguard.plist
        ├── com.apple.Terminal.plist   #   Terminal.app themes and prefs
        ├── co.gitup.mac.plist         #   GitUp
        ├── app.kaleidoscope.v3.plist  #   Kaleidoscope
        ├── com.superultra.Homerow.plist
        ├── com.tinyapp.TablePlus.plist
        └── glow/glow.yml             #   Glow markdown viewer
```

## Gitignore Strategy (Critical)

The `.gitignore` uses a **whitelist pattern**: it starts with `*` (ignore everything) then selectively un-ignores files with `!` prefixes. To track a new file:

1. Add `!path/to/file` (and every parent directory) to `.gitignore`
2. For directories, un-ignore the directory first, then the files inside it
3. Example pattern for a nested file:
   ```
   !.config/toolname/
   !.config/toolname/config.yml
   ```

Secrets (`.secrets`, `.pgpass`, `.ssh/*`) are **always** ignored and must never be committed.

## Key Conventions

### File Formatting
- **Indentation**: 4 spaces (set in `.editorconfig`; Makefiles use tabs)
- **Line endings**: LF (Unix-style)
- **Charset**: UTF-8
- **Trailing whitespace**: trimmed
- **Final newline**: inserted

### Shell Scripts
- Bash (`#!/bin/bash`), POSIX-compatible where possible
- `shellcheck` directives present (`# shellcheck shell=bash`, `# shellcheck disable=...`)
- `set -euo pipefail` in standalone scripts
- Decorative ASCII art banner at top of each main dotfile (rose/flower motif)
- Heavy use of section dividers: `####################################################################`
- Date-stamped with "Est." creation date and "Happy BirthDay!" comment

### Commit Style
- Imperative mood, concise
- Examples from history: `Add configuration files for various CLI tools and editors`, `Add terminal theme switcher and config files for new tools`

### Editor Preferences
- **CLI editor**: `micro` (fallback: `nano`)
- **GUI editor**: `zed` (fallback: `subl`)
- Both set via `$EDITOR` and `$VISUAL` in `.bash_profile`

## Tools and Ecosystem

The dotfiles configure these tools (all installed via Homebrew on macOS):

| Category         | Tools                                                 |
|------------------|-------------------------------------------------------|
| Shell            | bash, zsh, fzf, thefuck                               |
| Editors          | micro, nano, Zed, Sublime Text                        |
| Git TUI          | lazygit                                               |
| Docker TUI       | lazydocker                                            |
| System monitors  | btop, htop, neofetch                                  |
| File managers    | Midnight Commander (mc)                               |
| Text expansion   | espanso                                               |
| Password manager | ripasso                                               |
| HTTP clients     | curl, wget, lynx                                      |
| AI/LLM           | Ollama (local), Crush, OpenCode, Zed Agent (Copilot)  |
| Databases        | psql (PostgreSQL), sqlite3                            |
| Infrastructure   | Ansible, Hetzner Cloud (hcloud), Google Cloud         |
| Languages        | Node.js (nvm), Python (pyenv), Go, Bun                |
| Fonts            | Fira Code Nerd Font, monofur, Ubuntu, Syne Mono       |

## No Build, Test, or Lint Commands

This is a configuration-only repository. There are:
- No package managers (no `package.json`, `go.mod`, etc.)
- No test frameworks
- No CI/CD pipelines
- No Makefile

Executable scripts:
- `bootstrap.sh` — rsync all dotfiles from the repo into `$HOME` (supports `--dry-run`)
- `.local/bin/terminal-theme-switcher` — switches macOS Terminal.app between dark/light themes
- `.local/bin/metadata_never_index.sh` — prevents Spotlight from indexing junk directories

## Common Tasks

### Adding a new dotfile
1. Place the file at its correct `$HOME`-relative path in the repo
2. Add whitelist entries to `.gitignore` (directory + file)
3. Commit

### Adding a new tool's config
1. Create the config at `.config/<toolname>/` mirroring where the tool expects it
2. Un-ignore in `.gitignore`:
   ```
   !.config/toolname/
   !.config/toolname/config.yml
   ```
3. Commit

### Adding macOS app preferences
1. Place `.plist` at `Library/Preferences/` or `Library/Containers/<bundle-id>/...`
2. Un-ignore in `.gitignore` (every path component)
3. Note: `.plist` files are binary — they can be read with `defaults read` or `plutil -p`

## Gotchas

- **Whitelist gitignore**: Forgetting to un-ignore a parent directory will silently prevent tracking a file. Always check `git status` after adding entries.
- **Binary plists**: macOS `.plist` files in `Library/` are binary. Use `plutil -convert xml1` to make them human-readable before diffing, or `defaults read <path>` to inspect.
- **Plist reload**: After copying plists into `~/Library/Preferences/`, run `killall cfprefsd` to flush the preferences cache, then restart affected processes (`killall Dock`, `killall Finder`, `killall SystemUIServer`, `killall ControlCenter`).
- **ASCII art headers**: Each main bash file starts with a ~48-line decorative ASCII art block. Preserve it when editing. Don't remove or reformat it.
- **Section dividers**: The bash files use triple rows of `#` characters (`####...`) as section dividers. Keep this visual style when adding new sections.
- **Espanso has Russian snippets**: Some espanso triggers use Cyrillic (`:спс`, `:ок`). The repo has multilingual content.
- **Lazygit config is empty**: `config.yml` exists but is blank — lazygit uses pure defaults.
- **Homebrew paths are hardcoded**: Several configs reference `/opt/homebrew/` (Apple Silicon Homebrew prefix). These won't work on Intel Macs (`/usr/local/`) without adjustment.
- **Secrets sourced at runtime**: `.bash_profile` sources `~/.secrets` if it exists. This file is never committed.
