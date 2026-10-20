#!/usr/bin/env bash

[[ "$1" == "-g" ]] && set -x

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

"$HERE/sync-copilot.sh"

if [[ -n "${CODESPACE_VSCODE_FOLDER}" ]]; then
    echo "Setting up codespaces environment."
    ${HERE}/codespaces/setup.sh
elif [[ "$(uname -a)" =~ "Darwin" ]]; then
    echo "Setting up macOS environment."
    ${HERE}/macos/setup.sh
fi

echo "Configuring git"
${HERE}/git/configure.sh "$@"

echo "Configuring vim"
${HERE}/vim/configure.sh

echo "Configuring zsh"
${HERE}/zsh/configure.sh

echo "Installing/configuring starship"
${HERE}/starship/install.sh
