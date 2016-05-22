" vim: fo=cr1jb:nowrap:sw=2:sts=2:ts=8:
" ------------------------------------------------------------------------------
" Vim syntax file
" Language:     .gitignore
" Maintainer:   Roman Dolgushin <rd@roman-dolgushin.ru>
" URL:          https://github.com/rdolgushin/gitignore.vim
" ------------------------------------------------------------------------------

if exists('b:current_syntax')
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'conf'
endif

runtime! syntax/conf.vim
unlet b:current_syntax

let b:current_syntax = 'gitignore'

setlocal commentstring=#%s
