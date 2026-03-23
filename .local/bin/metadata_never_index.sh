#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# metadata_never_index.sh — Prevent Spotlight from indexing junk dirs
# ─────────────────────────────────────────────────────────────────────
#
# macOS Spotlight honours a special empty file called
# .metadata_never_index: when present inside a directory, Spotlight
# (mds/mds_stores) will skip that entire subtree.
#
# This script walks a directory tree, finds well-known "junk"
# directories (node_modules, .git, __pycache__, build artefacts, …)
# and drops a .metadata_never_index file into each one.
# Already-marked directories are left untouched (idempotent).
#
# USAGE
#   metadata_never_index.sh [--dry-run] [ROOT]
#
# ARGUMENTS
#   ROOT        Directory to scan (default: $HOME).
#   --dry-run   Show what would be created without touching the
#               filesystem. Can appear before or after ROOT.
#
# EXAMPLES
#   ./metadata_never_index.sh                   # scan $HOME
#   ./metadata_never_index.sh ~/Projects        # scan specific dir
#   ./metadata_never_index.sh --dry-run         # preview changes
#   ./metadata_never_index.sh --dry-run ~/Code  # preview for ~/Code
#
# NOTES
#   • ~/Library, ~/.Trash, and Photos library are skipped to avoid
#     crawling large macOS system trees.
#   • Edit the TARGETS array below to add/remove directory names.
#   • Edit the SKIP_PATHS array to change which trees are excluded
#     from traversal.
#   • Safe to run repeatedly — only missing markers are created.
#
# AUTHOR
#   lilac, 2025
# ─────────────────────────────────────────────────────────────────────
set -euo pipefail

# Directories that Spotlight should never index.
# Add or remove entries as needed.
TARGETS=(
    node_modules
    .npm
    .nvm
    .local
    .git
    go
    .bun
    .hg
    .svn
    pipx
    __pycache__
    .cache
    .tox
    .venv
    venv
    venvs
    virtenv
    .mypy_cache
    .pytest_cache
    .next
    .nuxt
    dist
    build
    .gradle
    .idea
    .terraform
    Pods
    DerivedData
    .cargo
    target          # Rust build output
    vendor/bundle   # Ruby bundler
    vendor
    .bundle
    elm-stuff
    bower_components
    jspm_packages
    extensions
    .vscode
    .openclaw
    .lmstudio
    .obsidian
    plugins
    bin
    pkg
    site-packages
)

usage() {
    sed -n '/^# USAGE/,/^# ──/{ /^# ──/d; s/^# \{0,3\}//; p; }' "$0"
    exit 0
}

ROOT="${1:-$HOME}"
COUNT=0
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --help|-h) usage ;;
        --dry-run) DRY_RUN=true ;;
        *)         ROOT="$arg" ;;
    esac
done

# Directories to skip entirely during traversal (avoid slow/huge trees).
SKIP_PATHS=(
    "$ROOT/Library"
    "$ROOT/.Trash"
    "$ROOT/Pictures/Photos Library.photoslibrary"
)

should_skip() {
    local dir="$1"
    for skip in "${SKIP_PATHS[@]}"; do
        [[ "$dir" == "$skip" || "$dir" == "$skip"/* ]] && return 0
    done
    return 1
}

is_target() {
    local name="$1"
    for t in "${TARGETS[@]}"; do
        [[ "$name" == "$t" ]] && return 0
    done
    return 1
}

mark() {
    local dir="$1"
    local marker="$dir/.metadata_never_index"
    if [[ ! -f "$marker" ]]; then
        if $DRY_RUN; then
            echo "[dry-run] would create: $marker"
        else
            touch "$marker"
            echo "created: $marker"
        fi
        COUNT=$((COUNT + 1))
    fi
}

scan() {
    local dir="$1"

    should_skip "$dir" && return

    local entries=()
    for entry in "$dir"/*/; do [[ -d "$entry" ]] && entries+=("$entry"); done
    for entry in "$dir"/.*/; do [[ -d "$entry" ]] && entries+=("$entry"); done

    for entry in "${entries[@]}"; do
        entry="${entry%/}"
        local name="${entry##*/}"

        [[ "$name" == "." || "$name" == ".." ]] && continue

        if is_target "$name"; then
            mark "$entry"
        else
            # Don't recurse into already-marked directories
            [[ -f "$entry/.metadata_never_index" ]] && continue
            scan "$entry"
        fi
    done
}

echo "Scanning $ROOT for directories to hide from Spotlight..."
$DRY_RUN && echo "(dry-run mode — no files will be created)"
echo ""

scan "$ROOT"

echo ""
if (( COUNT > 0 )); then
    echo "Done. Marked $COUNT directories."
else
    echo "Done. All target directories were already marked (or none found)."
fi
