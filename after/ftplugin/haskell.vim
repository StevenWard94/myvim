" Vim filetype plugin
" Language:       haskell
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2019 Jul 5
" ======================================================================================

set textwidth=88 formatoptions=c1jbql formatoptions-=r nowrap nopaste
set shiftwidth=4 softtabstop=2 tabstop& expandtab
set autoindent smartindent
set backspace-=indent

command! -nargs=1 PointFree :echo system('pointfree '.<q-args>)

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
