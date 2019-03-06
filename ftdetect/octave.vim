" Vim filetype detection script
" Language:       Octave
" Author:         Jussi Virtanen <github@jvirtanen.org>
" Source URL:     https://github.com/jvirtanen/vim-octave/blob/master/ftdetect/octave.vim
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/stevenward94/myvim
" Last Change:    2019 Feb 14
" Description:    Sets filetype to 'octave' for Matlab (.m) & Octave (.oct) scripts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Matlab
autocmd BufRead,BufNewFile *.m set filetype=octave

" Octave
autocmd BufRead,BufNewFile *.oct set filetype=octave
