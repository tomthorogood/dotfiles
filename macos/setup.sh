#!/usr/bin/env bash

HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

echo "Installing Homebrew"

if ! command brew --help; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages"
brew bundle --file="$HERE/Brewfile"

PLIST_SRC="$HERE/launchd/com.tomthorogood.dotfiles-sync.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.tomthorogood.dotfiles-sync.plist"
if [ -f "$PLIST_SRC" ]; then
    mkdir -p "$HOME/Library/LaunchAgents"
    cp "$PLIST_SRC" "$PLIST_DEST"
    launchctl load "$PLIST_DEST"
    echo "✓ Installed dotfiles-sync launchd agent"
fi
