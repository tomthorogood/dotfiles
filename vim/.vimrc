syntax on
filetype indent plugin on
set paste
set number
set hlsearch
autocmd BufWritePre *.* :%s/\s\+$//e
