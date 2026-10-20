#!/usr/bin/env bash

set -e

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )
SOURCE_ROOT=${DOTFILES_SOURCE_ROOT:-$HERE}

link_path() {
  source=$1
  destination=$2

  if [ ! -e "$source" ]; then
    echo "Missing source path: $source" >&2
    return 1
  fi

  mkdir -p "$(dirname "$destination")"

  if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
    return
  fi

  if [ -e "$destination" ] || [ -L "$destination" ]; then
    if [ -d "$source" ] && [ -d "$destination" ]; then
      if ! diff -qr "$source" "$destination" > /dev/null; then
        echo "Refusing to replace divergent path: $destination" >&2
        return 1
      fi
    elif [ -f "$source" ] && [ -f "$destination" ]; then
      if ! cmp -s "$source" "$destination"; then
        echo "Refusing to replace divergent path: $destination" >&2
        return 1
      fi
    else
      echo "Refusing to replace divergent path: $destination" >&2
      return 1
    fi

    if [ -d "$destination" ] && [ ! -L "$destination" ]; then
      rm -r "$destination"
    else
      rm "$destination"
    fi
  fi

  ln -s "$source" "$destination"
  echo "Linked $destination → $source"
}

link_path \
  "$SOURCE_ROOT/.github/copilot-instructions.md" \
  "$HOME/.copilot/copilot-instructions.md"

for source in "$SOURCE_ROOT"/.agents/skills/*; do
  [ -d "$source" ] || continue
  link_path "$source" "$HOME/.agents/skills/$(basename "$source")"
done

for source in "$SOURCE_ROOT"/.github/agents/*.md; do
  [ -f "$source" ] || continue
  link_path "$source" "$HOME/.copilot/agents/$(basename "$source")"
done
