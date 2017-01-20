" Vim plugin
" Language:     N/A
" Maintainer:   Steven Ward <stevenward94@gmail.com>
" Last Change:  2016 Nov 8
" ======================================================================================
" Orignal file
" Created:      2003
" Author:       Yakov Lerner
" Version:      6.0
" Source:       http://vim.wikia.com/wiki/List_loaded_scripts
" ======================================================================================

function! s:Scratch (command, ...)
  redir => lines
  let l:save_more = &more
  set nomore
  silent execute a:command
  redir END
  let &more = l:save_more
  call feedkeys("\<CR>")
  enew | setlocal buftype=nofile bufhidden=hide noswapfile nonumber norelativenumber
  put=lines
  if a:0 > 0
    execute 'vglobal/' . a:1 . '/delete'
  endif
  if a:command == 'scriptnames'
    %substitute#^[[:space:]]*[[:digit:]]\+:[[:space:]]*##e
  endif
  silent %substitute/\%^\_s*\n\|\_s*\%$
  let l:height = line('$') + 3
  execute 'normal! z' . l:height . "\<CR>"
  unlet l:save_more
  unlet l:height
  0
endfunction

command! -nargs=? Scriptnames :call <SID>Scratch('scriptnames', <f-args>)
command! -nargs=+ Scratch     :call <SID>Scratch(<f-args>)



" Execute 'cmd' while redirecting output.
" Delete all lines that do not match regexp 'filter' (if not empty).
" Delete any blank lines.
" Delete '<whitespace><number>:<whitespace>' from the start of each line.
" Display result in a scratch buffer.
" DEPRECATED: s:Scratch is more generic and works for any ex command
function! Filter_Lines(cmd, filter)
  let l:more_save = &more
  set nomore
  redir => lines
  silent execute a:cmd
  redir END
  let &more = l:more_save
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  put =lines
  g/^\s*$/d
  %s/^\s*\d\+:\s*//e
  if !empty(a:filter)
    execute 'v/' . a:filter . '/d'
  endif
  0
endfunction
