#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# bootstrap.sh — Apply dotfiles from this repo onto the current user
# ─────────────────────────────────────────────────────────────────────
#
# Copies (rsync) every tracked file in this repo into $HOME, preserving
# the directory layout.  Files that are repo-only (README, AGENTS.md,
# .git, etc.) are excluded.
#
# USAGE
#   ./bootstrap.sh              # apply to $HOME
#   ./bootstrap.sh --dry-run    # preview without writing
#
# Run as the target user, NOT as root.
# ─────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${HOME}"
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --help|-h)
            sed -n '/^# USAGE/,/^# ──/{ /^# ──/d; s/^# \{0,3\}//; p; }' "$0"
            exit 0
            ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

RSYNC_OPTS=(-rlptE --no-perms --no-owner --no-group)

if $DRY_RUN; then
    RSYNC_OPTS+=(--dry-run)
    echo "(dry-run mode — no files will be written)"
    echo ""
fi

RSYNC_OPTS+=(
    --exclude='.git'
    --exclude='.gitignore'
    --exclude='AGENTS.md'
    --exclude='README.md'
    --exclude='bootstrap.sh'
)

echo "Applying dotfiles from ${REPO_DIR} to ${TARGET} ..."
echo ""

rsync "${RSYNC_OPTS[@]}" -v "${REPO_DIR}/" "${TARGET}/"

echo ""

####################################################################
### Set default shell to bash for the current user #################
####################################################################

CURRENT_SHELL="$(dscl . -read "/Users/${USER}" UserShell 2>/dev/null | awk '{print $2}')"
if [[ "${CURRENT_SHELL}" != "/bin/bash" ]]; then
    echo "Default shell is ${CURRENT_SHELL}, changing to /bin/bash ..."
    chsh -s /bin/bash
    echo "Default shell changed to /bin/bash."
else
    echo "Default shell is already /bin/bash."
fi

echo ""
echo "Done."

####################################################################
### Generate AI ignore files from .aiexclude #######################
####################################################################

if [[ -f "${TARGET}/.aiexclude" ]] && command -v init-aiexclude &> /dev/null; then
    echo ""
    echo "Syncing AI ignore files from .aiexclude ..."
    init-aiexclude --sync "${TARGET}"
elif [[ -f "${TARGET}/.aiexclude" ]] && [[ -x "${TARGET}/.local/bin/init-aiexclude" ]]; then
    echo ""
    echo "Syncing AI ignore files from .aiexclude ..."
    "${TARGET}/.local/bin/init-aiexclude" --sync "${TARGET}"
fi
