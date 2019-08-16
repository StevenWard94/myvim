" Utility functions defined for local use.
"
" Author:      Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/dotfiles/vim/autoload/local/
" Last Change: 2019 Aug 15
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


" Function to insert a timestamp in RFC 3339 format (using 'T' before the time)
" The optional argument allows user to specify the 'FMT' value of date's --rfc-3339 flag
"     If argument is not specified, 'seconds' is used as the value for 'FMT'
" Timestamp format: '[YYYY-MM-DD]T[HH:MM:SS][+/-][ZZ:ZZ]'  (assumes '--rfc-3339=seconds')
" Example: 2019-08-15T17:20:06-05:00    (this example uses '--rfc-3339=seconds')
function! local#utils#rfc3339_timestamp(...) abort
  let l:fmt_value = 'seconds'

  if a:0 > 1
    if a:1 ==? 'date' || a:1 ==? 'dates' || a:1 ==? 'day' || a:1 ==? 'days'
      let l:fmt_value = 'date'
    elseif a:1 ==? 'nanosecond' || a:1 ==? 'nanoseconds' || a:1 ==? 'ns'
      let l:fmt_value = 'ns'
    endif
  endif

  return "normal! i\<C-r>=trim(system(" . '"date --rfc-3339=' . l:fmt_value . ' | sed ' . "'s/ /T/'" . '"))' . "\<CR>"
endfunction
