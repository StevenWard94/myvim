" Vim filetype plugin
" Language:       C++
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Oct 05
" ======================================================================================

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=2 softtabstop=2

set colorcolumn=100
highlight ColorColumn ctermbg=darkgray

let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
