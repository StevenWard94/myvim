" ------------------------------------------------------------------------------
" Vim filetype detection script
" Language:       Text files
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/stevenward94/myvim
" Last Change:    2018 Feb 21
" ------------------------------------------------------------------------------

function! s:licensesAreText()
  let l:dir = expand("%:p:h:t")

  if l:dir ==# 'licenses'
    setlocal filetype=text
  endif
  unlet l:dir
endfunction

autocmd BufRead,BufNewFile * :call s:licensesAreText()
