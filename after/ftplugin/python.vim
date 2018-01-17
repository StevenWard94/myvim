" Vim filetype plugin
" Language:    Python
" Author:      Steven Ward <stevenward94@gmail.com>
" Last Change: 2017 Sep 6
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

function! s:GetPython() abort
  if local#utils#has_plugin('python-mode') == 0
    return 'disable'
  endif
  let l:version_long = system('python --version')
  if empty(l:version_long) || l:version_long =~? '^.*command not found'
    return 'disable'
  elseif l:version_long =~? '^python 2'
    return 'python'
  else
    return 'python3'
  endif
endfunction

let g:pymode_python = s:GetPython()
