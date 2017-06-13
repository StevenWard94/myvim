" Vim autoload script for "Learn Python the Hard Way" files
" Language:       Python
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jun 11
" ======================================================================================

function! local#lpthw#insert_exercise_header(filename) abort
  let l:exnum = matchstr(a:filename, '\v[0-9]+')
  let l:curr_date = strftime("%Y %b %d")

  return  '# File:        ' . a:filename . "\n"
      \ . '# Description: "Exercise ' . l:exnum . '" of "Learn Python the Hard Way"' . "\n"
      \ . '# Last Change: ' . l:curr_date . "\n\n"
endfunction
