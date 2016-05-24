" vim: nolist:fo=cr1jb:sw=2:sts=2:ts=8:
" ------------------------------------------------------------------------------
" Vim filetype detection script
" Language:       Haskell
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/stevenward94/myvim
" Last Change:    2016 May 22
" Description:    Automatically sets filetype=haskell for files in my personal
"                 script directories. Probably useless to anyone other than me...
" ------------------------------------------------------------------------------

function! s:LearningHaskell()
  let l:fname = expand("%")
  let l:fdir = expand("%:p:h:t")

  if (l:fdir ==# 'LearningHaskell.d' || l:fdir ==? 'haskell.d') && l:fname !~ '^\.\+\f\+$'
    setlocal filetype=haskell
  endif

  unlet l:fname
  unlet l:fdir
endfunction

autocmd BufRead,BufNewFile * :call s:LearningHaskell()
