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
  " NOTE: since this file is my '.vimrc' AND 'nvim/init.vim', I use !has('nvim') to hide options and
  " commands that cause errors in neovim (usually b/c nvim removed an option that still exists in vim)
  if !has('nvim')
    if &term[:4] ==? 'xterm' || &term[:5] ==? 'screen' || &term[:3] ==? 'rxvt'
      inoremap <silent> <C-[>OC <RIGHT>
    endif
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

  " make sure non-ASCII keys behave correctly ('term' option is 'vim only' - removed in neovim)
  if !has('nvim')
    if !has('gui')
      set term=$TERM
    endif
  endif

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

    " a function to generate the string for 'backupdir' option based on the cwd
    function ConfigureBackups()
      let l:backuploc = ""
      if getcwd() == $HOME
        let l:backuploc = "~/.archived/bak.d/homedir.d,~/.archived/bak.d/lost+found"
      else
        let l:backuploc = (expand("%:p:h:t")[0] == '.') ? expand("%:p:h:t")[1:] : expand("%:p:h:t")
        let l:backuploc = '~/.archived/bak.d/' . l:backuploc . ',./.bak.d,~/.archived/bak.d/lost+found'
      endif
      return l:backuploc
    endfunction

    " autocmd group to set 'backupdir' to the return value of ConfigureBackup() and to set the
    "   'backupext' option (vim default is just a tilde, '~') to '__@{timestamp}.bak~', obviously
    "   with '{timestamp}' being replaced by a timestamp
    " for example, if a file, ~/dir/.alsodir/filename , was saved at 12:30 on November 23, 2016, then the
    " backup's path would be:   ~/.archived/bak.d/alsodir/filename__@2016Nov231230.bak~
    "   NOTE: the missing '.' in '.alsodir' is deliberate, if the containing directory name begins with a '.'
    "   it is removed and the rest of the name is used for the directory name in ~/.archived/bak.d/
    "augroup configure_backups
     " autocmd!
      "autocmd BufWritePre * :let &backupdir = ConfigureBackups()
      "autocmd BufWritePre * :let &backupext = '__@' . strftime("%Y%b%d%X") . '.bak~'
    "augroup END

    " config for persistent_undo and .un~ files removed until I can make it less annoying...
    "if has('persistent_undo')
      "set undofile
      "set undolevels=1000
      "set undoreload=10000
    "endif

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

  if filereadable(expand("~/.nvim/colors/jellybeans.vim"))
    let g:jellybeans_use_term_italics = !exists('g:jellybeans_use_term_italics') ? 1 : g:jellybeans_use_term_italics
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
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " show (right-aligned) file-navigation info
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
  set wildmode=list:longest,full                  " show a list of possible completions (longest matches then all) instead of auto-completing
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

  autocmd BufNewFile,BufRead *.coffee set filetype=coffee

  " workarounds for vim-commentary and broken highlighting with Haskell
  augroup haskell_fixes
    autocmd!
    autocmd FileType haskell :setlocal commentstring=--\ %s
    autocmd FileType haskell,rust :if &spell | setlocal nospell | endif
  augroup END
" \end

" Key Mappings & Remappings \begin

  " Setting up the <leader> key for custom mappings - default is '\' but this changes it to ',' b/c it's near home row
  if !exists('g:sw_override_leader')
    let mapleader = ','
  else
    let mapleader = g:sw_override_leader
  endif
  if !exists('g:sw_override_locleader')
    let maplocalleader = '_'
  else
    let maplocalleader = g:sw_override_locleader
  endif

  " Mappings to quickly open config (.vimrc), edit it and then apply it
  if !exists('g:sw_override_econfigmap') || g:sw_override_econfigmap == 0
    let s:sw_econfigmap = '<leader>ec'
  else
    let s:sw_econfigmap = g:sw_override_econfigmap
  endif
  if !exists('g:sw_override_aconfigmap') || g:sw_override_aconfigmap == 0
    let s:sw_aconfigmap = '<leader>ac'
  else
    let s:sw_aconfigmap = g:sw_override_aconfigmap
  endif

  " Mappings for easier movement between tabs & windows while in Normal mode
  if !exists('g:sw_override_easywindows') || g:sw_override_easywindows == 0
    nmap <C-J> <C-W>j<C-W>_
    nmap <C-K> <C-W>k<C-W>_
    nmap <C-L> <C-W>l<C-W>\<Bar>
    nmap <C-H> <C-W>h<C-W>\<Bar>
  endif

  " Use 'virtual' line navigation for 'j' and 'k'
  noremap j gj
  noremap k gk

  " Mappings for use with 'RelativeWrap(key,...)' in "Helper Functions"
  "   these map start/end of line motion commands to behave relative to the current row instead of moving to the
  "   start/end of a 'text line' when the 'wrap' option is set - e.g a sentence is wrapped at column 50 into two rows,
  "   commands like '$', '0', '^', etc. will only jump to column 1 of column 50 of the current row instead of wrapping
  "   with the sentence --- these seem more "intuitive" to me when I'm trying to work/remember mappings quickly
  if !exists('g:sw_override_relativewrap') || g:sw_override_relativewrap == 0
    " [essentially] Map a prefixed 'g' to each linewise motion key in Normal, Operator-Pending, and Visual+Select modes
    noremap $ :call RelativeWrap("$")<CR>
    noremap <End> :call RelativeWrap("$")<CR>
    noremap 0 :call RelativeWrap("0")<CR>
    noremap <Home> :call RelativeWrap("0")<CR>
    noremap ^ :call RelativeWrap("^")<CR>
    " the following 2 override the above mappings for $ and <End> in Operator-Pending mode to
    "   force inclusive motion when used with ':execute normal!'
    onoremap $ v:call RelativeWrap("$")<CR>
    onoremap <End> v:call RelativeWrap("$")<CR>
    " now override Visual+Select mode mappings for all keys to ensure RelativeWrap() executes with a correct 'vsel' value
    vnoremap $ :<C-U>call RelativeWrap("$", 1)<CR>
    vnoremap <End> :<C-U>call RelativeWrap("$", 1)<CR>
    vnoremap 0 :<C-U>call RelativeWrap("0", 1)<CR>
    vnoremap <Home> :<C-U>call RelativeWrap("0", 1)<CR>
    vnoremap ^ :<C-U>call RelativeWrap("^", 1)<CR>
  endif

  " Some helpful "autocorrects" for capitalization mistaked in commands
  if !exists('g:sw_override_shiftslips') || g:sw_override_shiftslips == 0
    if has('user_commands')
      command! -bang -nargs=* -complete=file E e<bang> <args>
      command! -bang -nargs=* -complete=file W w<bang> <args>
      command! -bang -nargs=* -complete=file Wq wq<bang> <args>
      command! -bang -nargs=* -complete=file WQ wq<bang> <args>
      command! -bang Wa wa<bang>
      command! -bang WA wa<bang>
      command! -bang Q q<bang>
      command! -bang QA qa<bang>
      command! -bang Qa qa<bang>
    endif
    cmap Tabe tabe
  endif

  " Map 'Y' to behave like 'C' or 'D' in Normal mode (i.e. 'yank' from cursor to end of line)
  nnoremap Y y$

  " Mappings for <leader>fn where 'n' is foldlevel for ':set foldlevel=n' -- makes pagewise folding/unfolding easier \begin
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>
  " \end

  " Enable toggling of search-result highlighting (instead of clearing of results) with <leader>/
  if exists('g:sw_override_hlsearch') && g:sw_override_hlsearch != 0
    nmap <silent> <leader>/ :nohlsearch<CR>
  else
    nmap <silent> <leader>/ :set invhlsearch<CR>
  endif

  " Mapping to quickly find markers for git-merge conflicts
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Shortcuts!!!  \begin

    " change 'working directory' to that of currently active buffer
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " indent shifting while in Visual mode will no longer exit Visual mode
    vnoremap < <gv
    vnoremap > >gv

    " enable use of the repeat operator for selections in Visual mode (!)
    "   http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " actually writes files when they should have been opened with 'sudo' but weren't
    cmap w!! w !sudo tee % >/dev/null

    " some ':edit' mode helpers [http://vimcasts.org/e/14]
    " conflicted with previously mapped keys for editing/applying my .vimrc
    "cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
    "map <leader>ew :e %%
    "map <leader>es :sp %%
    "map <leader>ev :vsp %%
    "map <leader>et :tabe %%

    " make viewport sizes equal
    map <leader>= <C-w>=

    " map <leader>ff to display all lines with match to the keyword under cursor and ask which line to jump to
    nmap <leader>ff [I:let nr = input("Which one: ")<Bar>execute "normal " . nr . "[\t"<CR>

    " easier horizontal scrolling
    map zl zL
    map zh zH

    " easier auto-formatting
    nnoremap <silent> <leader>q gwip

    " not sure what this does and it had a 'FIXME' w/ pull request so it's out for now, source: http://github.com/spf13/spf13-vim.git
    " FIXME: revert this - see f70be548
    " quickly toggle fullscreen mode for GVim and TermVim - requires that 'wmctrl' be in PATH
    " map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
  " \end

" \end

" Helper Functions \begin
  if !exists('g:sw_override_relativewrap') || g:sw_override_relativewrap == 0
    function! RelativeWrap(key,...)
      let vsel = ""
      if a:0
        let vsel="gv"
      endif
      if &wrap
        execute "normal!" vsel . "g" . a:key
      else
        execute "normal!" vsel . a:key
      endif
      unlet vsel
    endfunction
  endif
" \end
