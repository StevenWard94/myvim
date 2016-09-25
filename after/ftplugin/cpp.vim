" Vim filetype plugin
" Language:       C++
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Sep 25
" ======================================================================================

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=2 softtabstop=2

set colorcolumn=100
highlight ColorColumn ctermbg=darkgray

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
