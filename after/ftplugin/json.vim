" Vim filetype plugin
" Language:       JSON
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2018 Sep 26
" ======================================================================================

setlocal foldmethod=syntax

function! UpdateLastUpdated() abort
  let l:cur_save = getpos('.')
  let l:currLine = getline('.')
  if match(l:currLine, '\c^\s*"[-_a-z0-9]*update') == 0    " '^' in pattern makes match return 0 for any proper match
    if match(l:currLine, '"', 0, 3) != -1                  " if the line has > 2 double quotes (i.e., the property has an old value)
      call cursor(line('.'), match(l:currLine, '"', 0, 3)+2)
      let l:date_str = substitute(system("date --rfc-3339=seconds | sed 's/ /T/'"), '\s*\n\+$', '', '')
      execute "normal! ct\"\<C-R>=l:date_str\<C-M>"
      call setpos('.', l:cur_save)
      return 1
    else
      " TODO: WRITE SCRIPT TO ADD NEW DATE VALUE WITHOUT EXISTING VALUE
      call setpos('.', l:cur_save)
    endif
  else
    call setpos('.', l:cur_save)
    return 0
  endif
endfunction
