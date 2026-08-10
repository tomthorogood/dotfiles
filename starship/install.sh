#!/usr/bin/env bash
HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )
mkdir -p ~/.config

if [[ "$1" == "--reinstall" ]] || ! command starship --version; then
    echo "Installing Starship"
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi

if [[ "$1" == "--reinstall" ]]; then
    unlink ~/.config/starship.toml 2>/dev/null
fi

if [[ ! -L ~/.config/starship.toml ]]; then
    ln -sf ${HERE}/starship.toml ~/.config/starship.toml
fi

echo "Done; starship init is sourced from the tracked zsh/.zshrc — run '. ~/.zshrc' to update your current shell."
