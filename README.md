# dotfiles

Personal macOS dotfiles and configuration, managed with a bare-ish git repo rooted at `$HOME`.

## Setup on a new machine

```sh
git clone <repo-url> ~
git config core.hooksPath .githooks
```

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
