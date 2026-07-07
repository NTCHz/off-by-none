#!/usr/bin/env bash
# Updates installed Claude Code skills from this folder.
#
# Usage:
#   ./update.sh                      # update ALL skills installed from here
#   ./update.sh off-by-none another-skill  # update only the named skills
#
# If this folder is a git clone, it pulls the latest first, then re-installs
# (overwrites) into ~/.claude/skills via install.sh.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git -C "$SRC_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "git repo detected — pulling latest..."
  git -C "$SRC_DIR" pull --ff-only || echo "warning: git pull failed — updating from local files as-is"
else
  echo "not a git clone — using files as-is (get a fresh copy to actually update)"
fi

exec "$SRC_DIR/install.sh" "$@"
