" Vim filetype plugin
" Language:       Java
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Oct 08
" ======================================================================================

set textwidth=100 formatoptions+=1jb
set shiftwidth=2 softtabstop=2

if exists(':NERDTree')
  map <C-n> :NERDTreeToggle 
endif
