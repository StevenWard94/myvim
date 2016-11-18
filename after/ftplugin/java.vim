" Vim filetype plugin
" Language:       Java
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Nov 5
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

if exists(':NERDTree')
  map <C-n> :NERDTreeToggle 
endif
