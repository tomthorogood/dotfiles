#!/usr/bin/env bash

echo "Installing Homebrew"

if ! command brew --help; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages"
brew install coreutils
brew install gh
brew install git
brew install jq
brew install visual-studio-code
brew install yq
brew install starship