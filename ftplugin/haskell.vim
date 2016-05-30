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

  if !isdirectory(expand(hvn_config_dir))
    execute '! mkdir -p ' . hvn_config_dir
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

" Vim UI for Haskell \begin1

  " set 7 lines to the cursor for movement with j/k
  setlocal scrolloff=7

  " always show current position
  if !&ruler
    set ruler
  endif
  if !&number || !&relativenumber
    set number relativenumber
  endif

  " change 'list' option to show whitespace differently
  setlocal list
  setlocal listchars=tab:>\ ,trail:-,nbsp:+

  " height of the command bar
  if &cmdheight > 1
    setlocal cmdheight=1
  endif

  " make sure backspace wraps correctly
  setlocal backspace=eol,start,indent
  setlocal whichwrap+=<,>,h,l

  " ensure searches act right
  setlocal ignorecase smartcase

  " highlight search results -- <leader>/ still mapped to 'set invhlsearch<CR>'
  setlocal hlsearch incsearch

  " turn off 'redraw' when executing macros -- better performance
  setlocal lazyredraw

  " make sure 'magic' is on
  setlocal magic

  " show matching brackets and blink them for 2/10 of a second
  setlocal showmatch matchtime=2

  " turn off terminal bells
  setlocal noerrorbells
  setlocal novisualbell t_vb=

  " disable background color erase (BCE) so that colorschemes display properly in
  " 256-color tmux & GNU screen terminal emulators
  " see: http://snk.tuxfamily.org/log/vim-256color-bce.html
  if &term =~ '256color'
    set t_ut=
  endif

  " mapping to force redraw
  map <silent> <leader>r :redraw!<CR>

  " mapping to turn mouse mode on/off
  nnoremap <leader>ma :set mouse=a<CR>
  nnoremap <leader>mo :set mouse=<CR>
  setlocal mouse=a    " default to mouse mode on
" \end1

" Colors and Fonts for Haskell \begin1
  try
    colorscheme wombat256mod
  catch
  endtry

  highlight! link SignColumn LineNr

  " use pleasant but easily visible search highlighting
  highlight   Search  ctermfg=white  ctermbg=173   cterm=NONE  guifg=#ffffff   guibg=#e5786d   gui=NONE
  highlight!  link Visual Search
  
  " match wombat colors in NERDTree
  highlight   Directory   ctermfg=#8ac6f2

  " searing red -- very visible cursor
  highlight   Cursor  guibg=red

  " use same color behind concealed unicode characters
  highlight clear Conceal

  " don't blink cursor when in normal mode
  set guicursor=n-v-c:block-Cursor
  set guicursor+=n-v-c:blinkon0

  " extra options for gui
  if has('gui_running')
    setlocal guioptions-=T
    setlocal guioptions-=e
    setlocal guitablabel=%M\ %t
  endif
  set t_Co=256

  " set utf8 as default encoding and en_US as standard language
  " control block prevents this from occurring in nvim, since that causes issues
  if !has('nvim')
    setlocal encoding=utf8
  endif

  " use UNIX as default file format for eol escapes (<CR>, \n\r, etc.)
  set fileformats=unix,dos,mac
" \end1
