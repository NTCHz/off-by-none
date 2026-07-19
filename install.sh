#!/usr/bin/env bash
# Installs Claude Code skills from this folder into ~/.claude/skills.
#
# Usage:
#   ./install.sh                      # install ALL skills in this folder
#   ./install.sh off-by-none another-skill  # install only the named skills
#   ./install.sh --list               # show installable skills
#
# A skill = a real directory (not symlink) under skills/ containing SKILL.md.
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_ROOT="$HOME/.claude/skills"

available() {
  local d
  for d in "$SRC_DIR"/skills/*/; do
    d="${d%/}"
    [ -L "$d" ] && continue
    [ -f "$d/SKILL.md" ] || continue
    basename "$d"
  done
}

if [ "${1:-}" = "--list" ]; then
  available
  exit 0
fi

skills=()
if [ $# -ge 1 ]; then
  for name in "$@"; do
    if [ ! -f "$SRC_DIR/skills/$name/SKILL.md" ]; then
      echo "error: unknown skill '$name' — run $0 --list" >&2
      exit 1
    fi
    skills+=("$name")
  done
else
  while IFS= read -r s; do skills+=("$s"); done < <(available)
fi

if [ ${#skills[@]} -eq 0 ]; then
  echo "error: no skills found next to this script" >&2
  exit 1
fi

installed=0
for name in "${skills[@]}"; do
  src="$SRC_DIR/skills/$name"
  dest="$DEST_ROOT/$name"
  if [ "$src" = "$dest" ]; then
    echo "skip $name (already in place)"
    continue
  fi
  [ -f "$dest/SKILL.md" ] && echo "overwrite $name"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  echo "installed $name -> $dest"
  installed=$((installed + 1))
done

echo
echo "Done: $installed skill(s) installed."
echo "Restart any running Claude Code session to pick them up."
