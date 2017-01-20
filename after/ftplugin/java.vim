" Vim filetype plugin
" Language:       Java
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Dec 04
" ======================================================================================

if match(expand("%:p"), '\/etc\/') != -1
  set textwidth=80
  set formatoptions+=1 fo+=j fo+=b fo-=o
  set shiftwidth=4 softtabstop=4
else
  set textwidth=100
  set formatoptions+=1 fo+=j fo+=b
  set shiftwidth=2 softtabstop=2
endif

set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

let g:easytags_autorecurse = 1
let g:easytags_include_members = 1

map <F9>  :make<CR>:copen<CR>
map <F10> :cprevious<CR>
map <F10> :cnext<CR>

let g:syntastic_java_javac_classpath = "./lib/*.jar:./src:./bin:./lib/*.jar:./src:./bin:"

if exists(':NERDTree')
  map <C-n> :NERDTreeToggle 
endif
