" Vim filetype plugin
" Language:       HTML
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2019 Feb 02
" ======================================================================================

set expandtab
set shiftwidth=2 softtabstop=4 tabstop&vim
set formatoptions+=t textwidth=120

let g:syntastic_html_checkers = [ 'tidy', 'htmlhint' ]

