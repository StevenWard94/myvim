" Vim filetype plugin
" Language:    Python
" Author:      Steven Ward <stevenward94@gmail.com>
" Last Change: 2017 Jun 10
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

set textwidth=80 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=4 softtabstop=4 tabstop=4
set shiftround autoindent smartindent

let g:syntastic_python_checkers = [ 'flake8', 'python' ]

if split(system('git root'), '/')[-1] =~? 'lpthw'
  if filereadable($HOME.'/.vim/ftplugin/lpthw.vim')
    silent source ~/.vim/ftplugin/lpthw.vim
  elseif filereadable($HOME.'/.vim/after/ftplugin/lpthw.vim')
    silent source ~/.vim/after/ftplugin/lpthw.vim
  endif
endif
