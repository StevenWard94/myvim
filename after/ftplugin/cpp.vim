" Vim filetype plugin
" Language:       C++
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Oct 26
" ======================================================================================

let g:syntastic_cpp_checkers = [ 'gcc' ]
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -I/usr/include/c++/5 -Wall'

let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_check_header = 1

set colorcolumn=88
highlight ColorColumn ctermbg=darkgray

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=4 softtabstop=2 tabstop&vim

set cindent
set cinoptions=g0.5s,h0.5s,i2s,+2s,(2s,w1,W2s,m1,L0.5s

function! CppHeaderComment() abort
  let l:repo_name = split(system("git root"), '/')[-1]
  let l:repo_name = strpart(repo_name, 0, strchars(l:repo_name) - 1)
  let l:path      = expand("%:p")
  let l:proj_path = strpart(l:path, match(l:path, l:repo_name))
  let l:curr_date = strftime("%Y %b %d")
  let l:tw        = &textwidth

  return "/" . repeat('*', l:tw - 5) . "//**\n"
     \ . " * Author:       Steven Ward <stevenward94@gmail.com>\n"
     \ . " * File:         " . l:proj_path . "\n"
     \ . " * URL:          https://github.com/StevenWard94/" . repo_name . "\n"
     \ . " * Last Change:  " . l:curr_date . "\n"
     \ . " " . repeat('*', l:tw - 5) . "/\n"
endfunction
nmap /** "=CppHeaderComment()<CR>:0put =<CR>G
