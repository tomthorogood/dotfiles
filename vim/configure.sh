HERE=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}" )" &> /dev/null && pwd )

unlink "${HOME}/.vimrc" 2>/dev/null
ln -s "${HERE}/.vimrc" "${HOME}/.vimrc"
