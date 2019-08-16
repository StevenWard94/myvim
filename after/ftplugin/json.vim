" Vim filetype plugin
" Language:       JSON
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2019 Aug 15
" ======================================================================================

setlocal foldmethod=syntax

" see: local#utils#rfc3339_timestamp() in .vim/autoload/local/utils.vim for more info
command! -nargs=? Timestamp execute local#utils#rfc3339_timestamp(<f-args>) 
