# dotfiles

Personal macOS dotfiles — shell config, CLI tools, fonts, editor settings, app preferences, and utility scripts.

Designed for macOS on Apple Silicon with Homebrew.

## What's inside

| Category        | What gets configured                               |
| --------------- | -------------------------------------------------- |
| Shell           | bash, fzf, thefuck, prompt, history, completions   |
| Editors         | micro, nano, Zed, Sublime Text                     |
| Git             | lazygit, global gitignore                          |
| Docker          | lazydocker                                         |
| System monitors | btop, htop, neofetch                               |
| File managers   | Midnight Commander (custom skins & syntax)         |
| Text expansion  | espanso (snippets, dates, IP lookup)               |
| AI / LLM        | Ollama, Crush, OpenCode, Zed Agent                 |
| HTTP clients    | curl, wget, lynx                                   |
| Databases       | psql, sqlite3                                      |
| Infrastructure  | Ansible, Hetzner Cloud, Google Cloud               |
| Fonts           | Fira Code Nerd Font, monofur, Ubuntu, Syne Mono    |
| macOS           | Terminal.app themes, LaunchAgents, system & app preferences |

---

## Creating a new user from an existing one

The full workflow: clone an existing user profile (e.g. **daisy**) for the look and feel, then layer these dotfiles on top for shell and CLI tool configuration.

### Prerequisites

- Admin access (or another admin account)
- The source user (daisy) should be logged out

### Step 1 — Create the new user account

Using System Settings:

> **System Settings → Users & Groups → Add User**

Or from the command line:

```bash
sudo sysadminctl -addUser <newuser> -fullName "New User" -password "<password>"
```

> **Do not log in as the new user yet.** The home directory needs to be populated first.

### Step 2 — Clone the source user's profile

Copy the source user's home directory into the new one, excluding identity-bound and cache directories that would cause problems:

```bash
sudo rsync -aE /Users/daisy/ /Users/<newuser>/ \
    --exclude='.Trash' \
    --exclude='Library/Keychains' \
    --exclude='Library/Accounts' \
    --exclude='Library/Biome' \
    --exclude='Library/Cookies' \
    --exclude='Library/Mail' \
    --exclude='Library/Messages' \
    --exclude='Library/Safari' \
    --exclude='Library/Calendars' \
    --exclude='Library/Caches' \
    --exclude='Library/Saved Application State' \
    --exclude='Library/SyncedPreferences' \
    --exclude='Library/PersonalizationPortrait' \
    --exclude='.ssh'
```

Then fix ownership:

```bash
sudo chown -R <newuser>:staff /Users/<newuser>
```

#### What gets copied vs. excluded

| Copied (look & feel)                                | Excluded (identity-bound)            |
| --------------------------------------------------- | ------------------------------------ |
| `Library/Preferences/` — Dock, Finder, app settings | `Library/Keychains/` — credentials   |
| `Library/Fonts/` — installed fonts                  | `Library/Accounts/` — Apple ID link  |
| `Library/LaunchAgents/` — scheduled tasks           | `Library/Cookies/` — browser cookies |
| `.config/` — CLI tool settings                      | `Library/Biome/` — system analytics  |
| Desktop wallpaper, Dock layout, Finder sidebar      | `Library/Mail/` — email data         |
| Terminal.app themes & preferences                   | `Library/Messages/` — iMessage data  |
|                                                     | `Library/Safari/` — browsing data    |
|                                                     | `Library/Caches/` — temporary data   |
|                                                     | `.ssh/` — keys and known hosts       |

### Step 3 — Apply dotfiles on top

Log in as the new user, then:

```bash
git clone https://github.com/ditte-shy/dotfiles.git ~/.dotfiles
```

Preview what will be written:

```bash
~/.dotfiles/bootstrap.sh --dry-run
```

Apply:

```bash
~/.dotfiles/bootstrap.sh
```

This rsyncs all tracked config files from the repo into `$HOME`, giving you the latest shell setup, editor configs, fonts, tool settings, and macOS system preferences.

After applying, force macOS to pick up the new preference files:

```bash
killall cfprefsd      # flush preferences cache
killall Dock
killall Finder
killall SystemUIServer
killall ControlCenter
```

### Step 4 — Post-setup

A few things that need manual attention after cloning:

1. **Generate new SSH keys**

    ```bash
    ssh-keygen -t ed25519 -C "${USER}"
    ```

2. **Create `~/.secrets`** with any API tokens or credentials the shell expects
   (`.bash_profile` sources this file if it exists)

3. **Sign in to apps** — iCloud, GitHub, Copilot, etc. need fresh authentication

4. **Verify Homebrew** — if not installed, run:

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

5. **Install CLI tools** that the dotfiles expect (fzf, micro, lazygit, etc.):
    ```bash
    brew install fzf micro lazygit lazydocker btop htop neofetch \
        thefuck espanso midnight-commander glow cheat ripasso ollama
    ```

---

## Using just the dotfiles (without cloning a user)

If you only want the shell and CLI config on an existing user:

```bash
git clone https://github.com/ditte-shy/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap.sh --dry-run   # preview
~/.dotfiles/bootstrap.sh             # apply
```

---

## Included system preferences

The repo includes macOS preference plists (`Library/Preferences/`) so a new user can be fully configured from the repo alone, without needing to rsync from an existing user's home directory.

| Plist | What it configures |
| ----- | ------------------ |
| `.GlobalPreferences.plist` | Accent color (graphite), auto dark mode, languages (EN + RU), date format (ISO 8601), DuckDuckGo search, alert sound, font smoothing |
| `com.apple.dock.plist` | Autohide, left orientation, magnification, tile size, hot corners, no recent apps |
| `com.apple.finder.plist` | Folders first, column auto-sizing, view settings, sidebar, new window target |
| `com.apple.HIToolbox.plist` | Keyboard input sources: U.S. + Russian Phonetic |
| `com.apple.symbolichotkeys.plist` | Custom keyboard shortcuts (Spotlight disabled on most Fn keys) |
| `com.apple.AppleMultitouchMouse.plist` | Mouse gestures and button modes |
| `com.apple.AppleMultitouchTrackpad.plist` | Trackpad: tap to click, gesture settings, scroll behavior |
| `com.apple.driver.AppleBluetoothMultitouch.mouse.plist` | Bluetooth mouse driver settings |
| `com.apple.driver.AppleBluetoothMultitouch.trackpad.plist` | Bluetooth trackpad driver settings |
| `com.apple.driver.AppleHIDMouse.plist` | HID mouse button mapping |
| `com.apple.controlcenter.plist` | Control Center and menu bar item visibility |
| `com.apple.menuextra.clock.plist` | Analog clock, date display, no day-of-week |
| `com.apple.spaces.plist` | Mission Control / Spaces configuration |
| `com.apple.wallpaper.plist` | Desktop wallpaper (Sequoia Sunrise) |
| `com.adguard.mac.adguard.plist` | AdGuard ad blocker filter and DNS settings |

These are deployed alongside everything else by `bootstrap.sh`. After applying, run the `killall` commands listed in step 3 above to force macOS to reload them.

---

## Included scripts

| Script                               | Purpose                                                 |
| ------------------------------------ | ------------------------------------------------------- |
| `bootstrap.sh`                       | Apply all dotfiles to `$HOME` via rsync                 |
| `.local/bin/terminal-theme-switcher` | Switch Terminal.app between lilac dark and light themes |
| `.local/bin/metadata_never_index.sh` | Prevent Spotlight from indexing junk directories        |

---

## Plist hygiene

macOS preference files (`.plist`) store volatile state like window positions, toolbar layouts, and timestamps that change constantly and pollute diffs.

A **pre-commit hook** automatically strips these noisy keys before any plist is committed:

| Component | Path |
|---|---|
| Strip script | `.local/bin/plist-strip-volatile` |
| Pre-commit hook | `.githooks/pre-commit` |

### What gets stripped

- `NSWindow Frame *` — window positions and sizes
- `NSSplitView Subview Frames *` — split view divider positions
- `NSToolbar Configuration *` — toolbar customizations
- `NSOutlineView Items *`, `NSTableView *` — view state
- `NSNavPanel*`, `NSOSPLastRootDirectory` — file dialog state
- `NSColorPanelMode`, `NSFontPanelAttributes` — panel state
- `SULastCheckTime`, `SUHasLaunchedBefore` — Sparkle update timestamps
- `TB *` — toolbar display settings
- `Window Groups`, `WindowList`, `WindowNumber` — Terminal window state
- `ScrollerStyle`, `TabSelected`, `findHistory`, `replaceHistory` — UI ephemera

The hook runs `plist-strip-volatile` on every staged binary plist, removes the volatile keys, and re-stages the cleaned file — all transparently.

### Adding new volatile keys

Edit the `VOLATILE_PREFIXES` or `VOLATILE_EXACT` sets in `.local/bin/plist-strip-volatile`.

---

## Updating

Pull the latest changes and re-run bootstrap:

```bash
cd ~/.dotfiles
git pull
./bootstrap.sh
```
