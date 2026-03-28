# dotfiles

Personal macOS dotfiles — shell config, CLI tools, fonts,
editor settings, app preferences, and utility scripts.

Designed for macOS on Apple Silicon with Homebrew.

## What's inside

| Category        | What gets configured                   |
| --------------- | -------------------------------------- |
| Shell           | bash, fzf, thefuck, prompt, history    |
| Editors         | micro, nano, Zed, Sublime Text         |
| Git             | lazygit, global gitignore              |
| Docker          | lazydocker                             |
| System monitors | btop, htop, neofetch                   |
| File managers   | Midnight Commander (skins & syntax)    |
| Text expansion  | espanso (snippets, dates, IP lookup)   |
| AI / LLM        | Ollama, Crush, OpenCode, Zed Agent     |
| HTTP clients    | curl, wget, lynx                       |
| Databases       | psql, sqlite3                          |
| Infrastructure  | Ansible, Hetzner Cloud, Google Cloud   |
| Fonts           | Fira Code Nerd Font, monofur, Ubuntu   |
| macOS           | Terminal.app, LaunchAgents, prefs      |

---

## Creating a new user from an existing one

The full workflow: clone an existing user profile
(e.g. **daisy**) for the look and feel, then layer these
dotfiles on top for shell and CLI tool configuration.

### Prerequisites

- Admin access (or another admin account)
- The source user (daisy) should be logged out

### Step 1 — Create the new user account

Using System Settings:

> **System Settings → Users & Groups → Add User**

Or from the command line:

```bash
sudo sysadminctl -addUser <newuser> \
    -fullName "New User" -password "<password>"
```

> **Do not log in as the new user yet.** The home
> directory needs to be populated first.

### Step 2 — Clone the source user's profile

Copy the source user's home directory into the new one,
excluding identity-bound and cache directories that would
cause problems:

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

**Copied (look & feel):**

- `Library/Preferences/` — Dock, Finder, app settings
- `Library/Fonts/` — installed fonts
- `Library/LaunchAgents/` — scheduled tasks
- `.config/` — CLI tool settings
- Desktop wallpaper, Dock layout, Finder sidebar
- Terminal.app themes & preferences

**Excluded (identity-bound):**

- `Library/Keychains/` — credentials
- `Library/Accounts/` — Apple ID link
- `Library/Cookies/` — browser cookies
- `Library/Biome/` — system analytics
- `Library/Mail/` — email data
- `Library/Messages/` — iMessage data
- `Library/Safari/` — browsing data
- `Library/Caches/` — temporary data
- `.ssh/` — keys and known hosts

### Step 3 — Apply dotfiles on top

Log in as the new user, then:

```bash
git clone https://github.com/ditte-shy/dotfiles.git \
    ~/.dotfiles
```

Preview what will be written:

```bash
~/.dotfiles/bootstrap.sh --dry-run
```

Apply:

```bash
~/.dotfiles/bootstrap.sh
```

This rsyncs all tracked config files from the repo into
`$HOME`, giving you the latest shell setup, editor configs,
fonts, tool settings, and macOS system preferences.

After applying, force macOS to pick up the new preference
files:

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

2. **Create `~/.secrets`** with any API tokens or
   credentials the shell expects (`.bash_profile` sources
   this file if it exists)

3. **Sign in to apps** — iCloud, GitHub, Copilot, etc.
   need fresh authentication

4. **Verify Homebrew** — if not installed, run:

    ```bash
    /bin/bash -c "$(curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

5. **Install all packages** from the Brewfile (formulae,
   casks, and Mac App Store apps):

    ```bash
    brew bundle --file=~/.dotfiles/Brewfile
    ```

---

## Using just the dotfiles (without cloning a user)

If you only want the shell and CLI config on an existing
user:

```bash
git clone https://github.com/ditte-shy/dotfiles.git \
    ~/.dotfiles
~/.dotfiles/bootstrap.sh --dry-run   # preview
~/.dotfiles/bootstrap.sh             # apply
```

---

## Included system preferences

The repo includes macOS preference plists
(`Library/Preferences/`) so a new user can be fully
configured from the repo alone, without needing to rsync
from an existing user's home directory.

`.GlobalPreferences`
: Accent color, auto dark mode, languages (EN + RU),
  ISO 8601 dates, DuckDuckGo, font smoothing

`com.apple.dock`
: Autohide, left orientation, magnification, tile size,
  hot corners, no recent apps

`com.apple.finder`
: Folders first, column auto-sizing, view settings,
  sidebar, new window target

`com.apple.HIToolbox`
: Keyboard input sources: U.S. + Russian Phonetic

`com.apple.symbolichotkeys`
: Custom keyboard shortcuts

`com.apple.AppleMultitouchMouse`
: Mouse gestures and button modes

`com.apple.AppleMultitouchTrackpad`
: Tap to click, gesture settings, scroll behavior

`com.apple.driver.AppleBluetoothMultitouch.mouse`
: Bluetooth mouse driver settings

`com.apple.driver.AppleBluetoothMultitouch.trackpad`
: Bluetooth trackpad driver settings

`com.apple.driver.AppleHIDMouse`
: HID mouse button mapping

`com.apple.controlcenter`
: Control Center and menu bar item visibility

`com.apple.menuextra.clock`
: Analog clock, date display

`com.apple.spaces`
: Mission Control / Spaces configuration

`com.apple.wallpaper`
: Desktop wallpaper (Sequoia Sunrise)

`com.adguard.mac.adguard`
: AdGuard ad blocker filter and DNS settings

These are deployed alongside everything else by
`bootstrap.sh`. After applying, run the `killall` commands
listed in step 3 above to force macOS to reload them.

---

## Included scripts

| Script                               | Purpose                                  |
| ------------------------------------ | ---------------------------------------- |
| `bootstrap.sh`                       | Apply all dotfiles to `$HOME` via rsync  |
| `.local/bin/terminal-theme-switcher` | Switch Terminal.app dark/light themes    |
| `.local/bin/metadata_never_index.sh` | Prevent Spotlight indexing junk dirs     |
| `.local/bin/init-aiexclude`          | Scaffold AI exclusion files for projects |

---

## Plist hygiene

macOS preference files (`.plist`) store volatile state
like window positions, toolbar layouts, and timestamps
that change constantly and pollute diffs.

A **pre-commit hook** automatically strips these noisy
keys before any plist is committed:

| Component       | Path                              |
| --------------- | --------------------------------- |
| Strip script    | `.local/bin/plist-strip-volatile` |
| Pre-commit hook | `.githooks/pre-commit`            |

### What gets stripped

- `NSWindow Frame *` — window positions and sizes
- `NSSplitView Subview Frames *` — split view dividers
- `NSToolbar Configuration *` — toolbar customizations
- `NSOutlineView Items *`, `NSTableView *` — view state
- `NSNavPanel*`, `NSOSPLastRootDirectory` — file dialogs
- `NSColorPanelMode`, `NSFontPanelAttributes` — panels
- `SULastCheckTime`, `SUHasLaunchedBefore` — Sparkle
- `TB *` — toolbar display settings
- `Window Groups`, `WindowList`, `WindowNumber` — Terminal
- `ScrollerStyle`, `TabSelected`, `findHistory` — UI

The hook runs `plist-strip-volatile` on every staged
binary plist, removes the volatile keys, and re-stages
the cleaned file — all transparently.

### Adding new volatile keys

Edit the `VOLATILE_PREFIXES` or `VOLATILE_EXACT` sets
in `.local/bin/plist-strip-volatile`.

---

## AI ignore files

`init-aiexclude` scaffolds AI context-exclusion files
for any project. It creates `.aiexclude` as the single
source of truth, then generates tool-specific copies
that AI assistants actually read:

- `.geminiignore` (Gemini)
- `.cursorignore` (Cursor)
- `.codeiumignore` (Codeium / Windsurf)
- `.aiignore` (GitHub Copilot)
- `.agentignore` (Codex / other agents)
- `.crushignore` (Crush)

### Home directory

The home directory includes a tailored `.aiexclude` that
prevents AI agents from crawling into caches, runtimes,
cloud state, credentials, and user data when operating
from `$HOME`. `bootstrap.sh` automatically runs
`init-aiexclude --sync` after deploying dotfiles to keep
all targets up to date.

### New projects

```bash
cd ~/projects/my-app
init-aiexclude           # create .aiexclude + 6 targets
init-aiexclude --sync    # regenerate after editing
init-aiexclude --check   # verify targets are in sync
```

---

## Brewfile

All Homebrew formulae, casks, and Mac App Store apps are
declared in `Brewfile`.

```bash
brew bundle                 # install everything
brew bundle check           # verify all installed
brew bundle cleanup         # show unlisted packages
brew bundle cleanup --force # remove unlisted packages
```

To regenerate the Brewfile from the current system state:

```bash
brew bundle dump --force
```

---

## Updating

Pull the latest changes and re-run bootstrap:

```bash
cd ~/.dotfiles
git pull
./bootstrap.sh
```
