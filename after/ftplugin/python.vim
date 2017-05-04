" Vim filetype plugin
" Language:    Python
" Author:      Steven Ward <stevenward94@gmail.com>
" Last Change: 2017 May 3
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

set textwidth=80 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set shiftround autoindent smartindent

let g:syntastic_python_checkers = [ 'flake8', 'python' ]
