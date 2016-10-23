" Vim filetype plugin
" Language:       C++
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Oct 19
" ======================================================================================

let g:syntastic_cpp_checkers = [ 'gcc' ]
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -I/usr/include/c++/5 -Wall'

let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_check_header = 1

set colorcolumn=88
highlight ColorColumn ctermbg=darkgray

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=4 softtabstop=2 tabstop&vim
