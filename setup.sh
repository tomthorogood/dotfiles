#!/usr/bin/env bash

[[ "$1" == "-g" ]] && set -x

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

if [ -f "$HERE/.github/copilot-instructions.md" ]; then
  mkdir -p "$HOME/.copilot"
  ln -sf "$HERE/.github/copilot-instructions.md" "$HOME/.copilot/copilot-instructions.md"
  echo "✓ Linked copilot-instructions.md → ~/.copilot/copilot-instructions.md"
fi

if [[ -n "${CODESPACE_VSCODE_FOLDER}" ]]; then
    echo "Setting up codespaces environment."
    ${HERE}/codespaces/setup.sh
elif [[ "$(uname -a)" =~ "Darwin" ]]; then
    echo "Setting up macOS environment."
    ${HERE}/macos/setup.sh
fi
