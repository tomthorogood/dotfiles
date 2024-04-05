#!/usr/bin/env bash
SNIPPET_BEGINNING="### STARSHIP INIT ###"
SNIPPET_END="### STARSHIP END ###"
HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )
mkdir -p ~/.config

if [[ "$SHELL" =~ "zsh" ]]; then
    starship_shell=zsh
    snippet_target=~/.zshrc
elif [[ "$SHELL" =~ "bash" ]]; then
    starship_shell=bash
    snippet_target=~/.bashrc
else
    echo "Unsupported shell for auto install: $SHELL"
    exit 1
fi

if [[ "$1" == "--reinstall" ]] || ! command starship --version; then
    echo "Installing Starship"
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
fi

if [[ "$1" == "--reinstall" ]]; then
    unlink ~/.config/starship.toml 2>/dev/null
fi

if [[ -f ~/.config/starship.toml ]]; then
    ln -s ${HERE}/starship.toml ~/.config/starship.toml
fi

if [[ "$1" == "--reinstall" ]]; then
    sed -i '' "/${SNIPPET_BEGINNING}/,/${SNIPPET_END}/d" "${snippet_target}"
fi

if ! grep "${SNIPPET_BEGINNING}" ${snippet_target}; then
    echo $SNIPPET_BEGINNING >> ${snippet_target}
    cmd="eval \"\$(starship init $starship_shell)\""
    echo "$cmd" >> ${snippet_target}
    echo $SNIPPET_END >> ${snippet_target}
    . ${snippet_target}
fi

echo "Done; you should run '. ${snippet_target}' to update your own shell."
