" Vim filetype plugin
" Language:       Vim Help Files
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jun 28
" ======================================================================================

if &readonly
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

setlocal formatoptions+=tcroql1jb textwidth=78
setlocal expandtab shiftwidth=4 softtabstop=2
if has('conceal')
  setlocal conceallevel=2 concealcursor=""
endif

let b:undo_ftplugin = "setl fo< tw< et< sw< sts< cole< cocu<"
let &cpoptions = s:cpo_save
unlet s:cpo_save
