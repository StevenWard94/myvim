" Vim filetype plugin
" Language:       Java
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Sep 12
" ======================================================================================

set textwidth=100 formatoptions+=1jb
set shiftwidth=2 softtabstop=2

if exists(':SyntasticInfo')
  let g:syntastic_java_checker = 'javac'
  let g:syntastic_java_javac_classpath = "./lib/*.jar\n./src"
endif

if exists(':NERDTree')
  map <C-n> :NERDTreeToggle 
endif
