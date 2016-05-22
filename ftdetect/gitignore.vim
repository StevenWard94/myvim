" vim: fo=cr1jb:sw=2:sts=2:ts=8:nowrap:nospell:
" ------------------------------------------------------------------------------
" File:          gitignore.vim
" Description:   .gitignore ftdetect plugin for vim
" Author:        Roman Dolgushin <rd@roman-dolgushin.ru>
" URL:           https://github.com/rdolgushin/gitignore.vim
" ------------------------------------------------------------------------------

autocmd BufNewFile,BufRead .gitignore* :set filetype=gitignore
