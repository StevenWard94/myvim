" vim: set foldmarker=\\begin,\\end foldmethod=marker foldlevel=0 tw=120 fo=cr1jb wm=0 expandtab sw=2 ts=2 sts=2 nospell:

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

  set background=dark
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

  " when opening an existing file, restore cursor to its position at end of last edit \begin
  if !exists('g:sw_override_restorecursor') || g:sw_override_restorecursor == 0
    function! RestoreCursor()
      if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
      endif
    endfunction

    augroup cursor_restore
      autocmd!
      autocmd BufWinEnter * :call RestoreCursor()
    augroup END
  endif
  " for git commit msg, put cursor at start of file instead
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG :call setpos('.', [0, 1, 1, 0])
  " \end

  " Setting up directories \begin
    set backup
    if has('persistent_undo')
      set undofile
      set undolevels=1000
      set undoreload=10000
    endif

    if !exists('g:sw_override_views') || g:sw_override_views == 0
      let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    endif
  " \end

  " fix this up
  set tw=120 fo=cr1jb wm=0 et sw=4 ts=4 sts=4
  set nowrap nopaste autoindent smartindent

" \end

" User Interface Settings \begin

  if &t_Co < 256 | let &t_Co = 256 | endif
  if !exists('g:sw_override_colors') || g:sw_override_colors == 0
    if exists('g:molokai_original') | unlet g:molokai_original | endif
    let g:rehash256 = 1
    colorscheme molokai
  endif

  set tabpagemax=15
  set showmode

  set cursorline
  highlight clear SignColumn      " make SignColumn background match editor
  highlight clear LineNr          " current line # row will have same background w/ relativenumber set

  if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
  endif

  if has('statusline')
    set laststatus=2

    set statusline=%<%f\                    " show filename
    set statusline+=%w%h%m%r                " show different i/o/status options
    if filereadable(expand("~/.vim/bundle/fugitive"))
      set statusline+=%{fugitive#statusline()}
    endif
    set statusline+=\ [%{&ff}/%Y]           " show filetype
    set statusline+=\ [%{getcwd()}]         " show current working directory
    set statusline+=%=%-14.(%l,%c%V)\ %p%%  " show (right-aligned) file-navigation info
  endif

  set backspace=indent,eol,start
  set linespace=0
  set number
  set relativenumber
  set showmatch
  set incsearch
  set hlsearch
  set winminheight=0
  set ignorecase
  set smartcase
  set wildmenu
  set wildmode=last:longest,full
  set whichwrap=b,s,h,l,<,>,[,]
  set scrolljump=-10                              " when cursor leaves screen (not <C-E>, etc.) auto-scroll 10% winheight
  set scrolloff=3
  set foldenable
  set list
  set listchars=tab:»›,trail:∅,extends:Ϟ,nbsp:∙   " mark potentially problematic whitespace
" \end

" Text Formatting Settings \begin
  set nowrap
  set autoindent smartindent
  set formatoptions=cr1jb
  set textwidth=120 wrapmargin=0
  set expandtab
  set shiftwidth=4 tabstop=4 softtabstop=4
  set nojoinspaces                                " remove extra space (leave single space) between two joined lines
  set splitright splitbelow                       " :vsplit -> new window to right of old    :split -> new window below old
  "set matchpairs+=<:>                             " add '<' & '>' to list of matching pairs for use w/ '%'
  set pastetoggle=<F12>                           " enable toggling between ':set paste' & ':set nopaste' with F12 key
  "set comments=sl:/*,mb:*,elx*/                  " autoformat comment blocks -- no guarantees, idk what this does

  " Function & autocommands to strip whitespace \begin
    if !exists('g:sw_override_stripwsp') || g:sw_override_stripwsp == 0
      autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xmlyml,perl,sql :autocmd BufWritePre <buffer> :call StripTrailingWhitespace()
    endif
  " \end

  "autocmd FileType go :autocmd BufWritePre <buffer> :Fmt
  autocmd BufNewFile,BufRead *.html.twig :set filetype=html.twig
  autocmd FileType haskell,puppet,ruby,vim,yml :setlocal expandtab shiftwidth=2 softtabstop=2
