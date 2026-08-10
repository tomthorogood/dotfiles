#!/usr/bin/env bash
HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

unlink "${HOME}/.zshrc" 2>/dev/null
ln -sf "${HERE}/.zshrc" "${HOME}/.zshrc"

unlink "${HOME}/.zprofile" 2>/dev/null
ln -sf "${HERE}/.zprofile" "${HOME}/.zprofile"
