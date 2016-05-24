" vim: nolist:fo=cr1jb:sw=2:sts=2:ts=8:fmr=\\begin,\\end:fdm=marker:fdl=0:
" ------------------------------------------------------------------------------ \begin1
" Vim filetype plugin script
" Language:         Haskell
" Maintainer:       Steven Ward <stevenward94@gmail.com>
" Original Source:  https://github.com/begriffs/haskell-vim-now
" Current URL:      https://github.com/StevenWard94/myvim
" Last Change:      2016 May 22
" ------------------------------------------------------------------------------ \end1

" HVN Paths \begin1
  " set XDG_CONFIG_HOME/haskell-vim-now to load user config files
  if exists($XDG_CONFIG_HOME)
    let hvn_config_dir = $XDG_CONFIG_HOME . '/haskell-vim-now'
  else
    let hvn_config_dir = $HOME . '/.config/haskell-vim-now'
  endif

  " pre-config path
  let hvn_config_pre = expand(resolve(hvn_config_dir . '/vimrc.local.pre'))
  " post-config path
  let hvn_config_post = expand(resolve(hvn_config_dir . '/vimrc.local'))
  " user plugins config path
  let hvn_user_plugins = expand(resolve(hvn_config_dir . '/plugins.vim'))
  " stack bin path symlink
  let hvn_stack_bin = expand(resolve(hvn_config_dir . '/.stack-bin'))
" \end1

" Pre-Customization \begin1
  if filereadable(hvn_config_pre)
    execute 'source ' . hvn_config_pre
  endif
" \end1

" General \begin1
  " use indentation for folds
  setlocal foldmethod=indent
  setlocal foldnestmax=5
  setlocal foldlevelstart=99
  setlocal foldcolumn=0

  " set VIM history to 700 lines
  setlocal history=700

  " enable vim to "autoread" when a file is changed elsewhere
  setlocal autoread

  " leader-key (and other key-combos) timeout
  setlocal timeoutlen=2000

  " enable normal use of ',' key w/ a double-press (i.e. ',,')
  noremap ,, ,

  " use 'par' for prettier line formatting
  "set formatprg="PARINIT='rTbgqR B=.,?_A_a Q=_s>|' par\ -w72"

  " use 'stylish haskell' for prettier line formatting w/ Haskell
  let &formatprg = "stylish-haskell"

  " find custom-built 'hasktags', codex, etc.
  let $PATH = expand(hvn_stack_bin) . ':' . $PATH
" \end1

" VIM-Plug \begin1
  call plug#begin('~/.vim/bundle')

  " Support Bundles
