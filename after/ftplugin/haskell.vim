" Vim filetype plugin
" Language:       haskell
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 June 06
" ======================================================================================

let s:cpo_save = &cpo
set cpo&vim


setlocal formatoptions=crql1jb formatoptions-=o formatoptions-=t
setlocal expandtab autoindent shiftround
setlocal shiftwidth=4 softtabstop=2 tabstop&
setlocal foldmethod=marker foldmarker=\\begin,\\end

command! -nargs=+ PointFree :echo system('pointfree "'.<q-args>.'"')

function! HaskellModuleHeader() abort
  let repo_name = split(system("git root"), '/')[-1]
  let curr_date = strftime("%Y %b %d")
  return "-- |\n"
     \ . "-- Module:        module.name\n"
     \ . "-- Author:        Steven Ward <stevenward94@gmail.com>\n"
     \ . "-- URL:           https://github.com/StevenWard94/".repo_name
     \ . "-- Last Change:   ".curr_date . "\n"
     \ . "--\n"
endfunction
nmap <Leader>-- "=HaskellModuleHeader()<CR>:0put =<CR>

let &cpo = s:cpo_save
unlet! s:cpo_save
