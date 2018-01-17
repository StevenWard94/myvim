
function! s:MakefileBackupsFTDetect()
  let l:fname = expand("%")

  if l:fname =~? '\.\?makefile\.[0-9]\~\?$'
    setlocal filetype=make
  endif

  unlet l:fname
endfunction

autocmd BufRead,BufNewFile *makefile*,.*makefile* :call s:MakefileBackupsFTDetect()
