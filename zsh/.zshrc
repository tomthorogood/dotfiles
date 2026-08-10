export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

eval "$(starship init zsh)"

# Machine-local secrets/overrides not tracked in dotfiles.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
