" Vim specialized filetype plugin
" Language:       Python (for files in my repository for "Learn Python the Hard Way")
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jun 13
" ======================================================================================

let s:fname = expand("%")
if s:fname =~? '\v^ex[0-9]+\.py$'
  if match(getline(1), '\v.') == -1
    normal! gg
    put! =local#lpthw#insert_exercise_header(s:fname)
    normal! G
  endif
endif
