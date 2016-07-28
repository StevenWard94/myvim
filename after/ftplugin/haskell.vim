" Vim filetype plugin
" Language:       haskell
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 June 03
" ======================================================================================

let s:cpo_save = &cpo
set cpo&vim


setlocal formatoptions=crql1jb
setlocal expandtab shiftround
setlocal shiftwidth=4 softtabstop=4 tabstop=8

let s:width = &l:textwidth

function! HaskellModuleSection(...) abort
  let name = a:0 > 0 ? a:1 : inputdialog("Section name: ")

  return  repeat('-', s:width) . "\n"
        \ . "-- " . name . "\n"
        \ . "\n"
endfunction
nmap <silent> --s "=HaskellModuleSection()<CR>gp


function! HaskellModuleHeader(...) abort
  let name = a:0 > 0 ? a:1 : inputdialog("Module: ")
  let note = a:0 > 1 ? a:2 : inputdialog("Note: ")
  let desc = a:0 > 2 ? a:3 : inputdialog("Description: ")

  return  repeat('-', s:width) . "\n"
        \ . "-- | \n"
        \ . "-- Module      : " . name . "\n"
        \ . "-- Note        : " . note . "\n"
        \ . "-- \n"
        \ . "-- " . desc . "\n"
        \ . "-- \n"
        \ . repeat('-', s:width) . "\n"
        \ . "\n"
endfunction
nmap <silent> --h "=HaskellModuleHeader()<CR>:0put =<CR>

let &cpo = s:cpo_save
unlet! s:cpo_save
