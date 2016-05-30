" Vim plugin to add user-commands I wanted
" Path:         ~/.vim/plugin/home_library.vim
" Maintainer:   Steven Ward <stevenward94@gmail.com>
" URL:          https://github.com/StevenWard94/myvim
" Last Change:  2016 May 30
" --------------------------------------------------------------------------------------

" Definition of commands \begin
  " The commands are automatically defined when vim loads this plugin on startup but the
  " functions they call are not. The 'FuncUndefined' autocmd will be triggered the first
  " time one of these commands are used and the remainder of the script will be sourced
  " b/c the 's:did_load' variable will exists at that time and the early ':finish'
  " command will not be called. (See ':help write-plugin-quickload')

  if !exists('s:LIB_loaded')
    command! -nargs=? Scriptnames :call <SID>LIB_Ex2Scratch('scriptnames', <f-args>)
    command! -nargs=+ Scratch :call <SID>LIB_Ex2Scratch(<f-args>)

    " this is why all the functions in the script start with 'LIB_'
    execute 'autocmd FuncUndefined LIB_* :source ' . expand('<sfile>')
    let s:LIB_loaded = 1
    finish
  endif
" \end

" LIB_Ex2Scratch( command, ... )  \begin
  " Script to view the output of any Ex command in a "scratch buffer"
  " Source: http://vim.wikia.com/wiki/List_loaded_scripts
  function! s:LIB_Ex2Scratch (command, ...) abort
    redir => lines
    let l:more_save = &more
    set nomore
    execute a:command
    redir END
    let &more = l:more_save
    unlet l:more_save

    call feedkeys("\<CR>")
    new | setlocal buftype=nofile bufhidden=hide noswapfile
    put = lines

    if a:0 > 0
      execute 'vglobal/'.a:1.'/delete'
    endif
    if a:command == 'scriptnames'
      %substitute#^[[:space:]]*[[:digit:]]\+:[[:space:]]*##e
    endif

    silent %substitute/\%^\_s*\n\|\_s*\%$
    let l:height = line('$') + 3
    execute 'normal! z'.height."\<CR>"
    unlet l:height
    0
  endfunction
" \end
