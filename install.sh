#!/usr/bin/env bash
# Symlink steering/*.md into the Kiro global steering directory.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_DIR="$SCRIPT_DIR/steering"
TARGET_DIR="${KIRO_STEERING_DIR:-$HOME/.kiro/steering}"

mkdir -p "$TARGET_DIR"

shopt -s nullglob
files=("$SOURCE_DIR"/*.md)
if [ "${#files[@]}" -eq 0 ]; then
  echo "error: no steering files found in $SOURCE_DIR" >&2
  exit 1
fi

for src in "${files[@]}"; do
  name="$(basename "$src")"
  dest="$TARGET_DIR/$name"

  if [ -L "$dest" ]; then
    old="$(readlink "$dest")"
    if [ "$old" = "$src" ]; then
      echo "ok: $name"
    else
      ln -sfn "$src" "$dest"
      echo "relinked: $name (was $old)"
    fi
  elif [ -e "$dest" ]; then
    if cmp -s "$src" "$dest"; then
      rm "$dest"
      ln -s "$src" "$dest"
      echo "linked: $name (replaced identical copy)"
    else
      backup="$dest.bak"
      # Never overwrite an existing backup.
      if [ -e "$backup" ] || [ -L "$backup" ]; then
        backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      fi
      mv "$dest" "$backup"
      ln -s "$src" "$dest"
      echo "linked: $name (backed up to $backup)"
    fi
  else
    ln -s "$src" "$dest"
    echo "linked: $name"
  fi
done

# Remove links this script created whose source file was deleted or renamed.
for link in "$TARGET_DIR"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$SOURCE_DIR"/*)
      if [ ! -e "$link" ]; then
        rm "$link"
        echo "removed stale link: $(basename "$link")"
      fi
      ;;
  esac
done

echo
echo "note: 'kiro-cli chat --v3' skips symlinked steering files" \
  "(https://github.com/kirodotdev/Kiro/issues/9787); the default v2 engine loads them."
