" Utility functions defined for local use.
"
" Author:      Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/dotfiles/vim/autoload/local/
" Last Change: 2017 May 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" define a helpful environment variable that points to vim user directory
function! local#utils#define_vimhome()
  if exists("$MYVIMRC")
    let l:vim_home = fnamemodify(expand("$MYVIMRC"), ":p:h").'/.vim'
    if isdirectory(l:vim_home)
      return l:vim_home
    endif
  endif
  if !exists("$VIMHOME") && exists("$HOME")
    let l:ls_home = split(system('ls -A $HOME'), '\n')
    let l:index = match(l:ls_home, '^\.vim$')
    if l:index != -1
      return l:ls_home[index]
    endif
  endif
  if exists("$VIMHOME")
    return $VIMHOME    " environment variable (alias) pointing to $VIMHOME
  endif
endfunction


" Function to check if a plugin has been installed to the '.vim/bundle' directory.
function! local#utils#has_plugin(plug) abort
  if empty($VIMHOME)
    return 0
  endif
  if isdirectory($VIMHOME.'/bundle/'.a:plug) || isdirectory($VIMHOME.'/plugin/'.a:plug)
    return 1
  elseif filereadable($VIMHOME.'/autoload/'.a:plug) || filereadable($VIMHOME.'/plugin/'.a:plug)
    return 1
  endif
  return 0
endfunction
