" vim: nowrap:nolist:fo=cr1jb:sw=2:sts=2:ts=8:tw=88:
" --------------------------------------------------------------------------------------
" Vim ftplugin script -- Executed after all other '*/ftplugin/vim.vim' files in &rtp
" Language:       Vim
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/stevenward94/myvim
" Local Path:     ~/.vim/after/ftplugin/vim.vim
" Last Change:    2016 May 23
"
" --------------------------------------------------------------------------------------

let s:cpo_save = &cpo
set cpo-=C

" override 'formatoptions' set by the global ftplugin script, so that the 'o' command in
" normal mode will NOT insert a comment leader on the new line and add options to
" prevent auto-wrapping after a one-letter word or if no space is entered before
" 'textwidth', and to remove unnecessary comment leaders following a 'join' command
setlocal formatoptions-=o formatoptions+=1jb
" just for clarity: formatoptions=cr1jbql

" Format comments to wrap (except for in cases mentioned above) at 88 characters
setlocal textwidth=88

" Setup folding for my usual markers -- \begin . . . \end -- and settings
if !exists(&foldmarker) || &foldmarker ==? '{{{,}}}'
  setlocal foldmarker=\\begin,\\end
endif
setlocal foldmethod=marker
setlocal foldlevel=0

" make sure indentation settings are correct
setlocal expandtab
let &l:shiftwidth = &shiftwidth == 2 ? &shiftwidth : 2
let &l:softtabstop = &softtabstop == 2 ? &softtabstop : 2
let &l:tabstop = &tabstop == 8 ? &tabstop : 8

" other
setlocal nowrap
setlocal nolist
setlocal nospell
setlocal nopaste

let b:undo_ftplugin = b:undo_ftplugin . "| setl et< sw< sts< ts< fmr< fdm< list< wrap< spell< paste<"

let &cpo = s:cpo_save
unlet s:cpo_save
