" vim: set foldmarker=\\begin,\\end foldmethod=marker foldlevel=0 tw=120 fo=cr1jb wm=0 expandtab sw=2 ts=2 nospell:

" General Settings \begin

  set nocompatible        " set this first b/c it changes the values of several options

  " identify user's platform ( OSX()->true for mac  LINUX()->true for non-mac/win unix  WINDOWS()->true for win32/64
  execute "silent function! OSX() \n return has('macunix') \n endfunction"
  execute "silent function! LINUX() \n return has('unix') && !has('macunix') && !has('win32unix') \n endfunction"
  execute "silent function! WINDOWS() \n return ( has('win32') || has('win64') ) \n endfunction"

  if !WINDOWS()
    if executable('/bin/bash')
      set shell=/bin/bash
    else
      set shell=/bin/sh
    endif
  endif

  " fix arrow-key issues flagged at: " https://github.com/spf13/spf13-vim/issues/780
  if &term[:4] ==? 'xterm' || &term[:5] ==? 'screen' || &term[:3] ==? 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
  endif

  " use 'helper configs' if they exist \begin
    if filereadable(expand("~/.vim/.config/.vimrc.before"))
      silent source ~/.vimrc.before
    endif
    if filereadable(expand("~/.vim/.config/.vimrc.bundles"))
      silent source ~/.vimrc.bundles
    endif
  " \end

  set background = dark
  " create function to toggle background and map it to <leader>bg \begin
  function! ToggleBackground()
    let s:bgtoggle = &background
    if s:bgtoggle ==# 'dark'
      set background=light
    else
      set background=dark
    endif
  endfunction
  noremap <leader>bg :call ToggleBackground()<CR>
  " \end

  if !has('gui') | set term=$TERM | endif       " make sure non-ASCII keys behave correctly
  filetype plugin indent on
  syntax on
  set mouse=a                                   " enable mouse usage automatically for all modes
  set mousehide                                 " hide cursor when typing
  scriptencoding utf-8                          " tells vim to use utf-8 when reading this file
  " whenever possible, use single vim register for copy/paste in all buffers
  if has('clipboard')
    if has('unnamedplus')
      set clipboard=unnamed,unnamedplus
    else
      set clipboard=unnamed
    endif
  endif

  " automatically change working directory that of the file currently open in the buffer
  if !exists('g:sw_override_autochdir') || g:sw_override_autochdir == 0
    autocmd BufEnter * :if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
  endif

  set shortmess+=filmnrxoOtT                " abbreviate messages from system (avoids 'hit enter' messages)
  set viewoptions=folds,options,cursor,unix,slash
  set virtualedit=onemore
  set history=1000
  set nospell
  autocmd BufEnter,BufNewFile *.git,*.txt,*.md :set spell
  set hidden
  set iskeyword-=.
  set iskeyword-=#
  set iskeyword-=-

  " fix this up
  set tw=120 fo=cr1jb wm=0 et sw=4 ts=4 sts=4
  set nowrap nopaste autoindent smartindent
  colorscheme molokai
  set number
  set relativenumber

" \end
