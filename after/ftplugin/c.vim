" Vim filetype plugin
" Language:       C
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Nov 21
" ======================================================================================

" Enable some additional syntax highlighting features
let c_gnu = 1
let c_comment_strings = 1

" Settings for Syntastic to check C code
let g:syntastic_c_checkers = [ 'gcc' ]
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -std=c99 -Wall -Wextra -pedantic'

let g:syntastic_c_remove_include_errors = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_c_check_header = 1


let g:easytags_autorecurse = 1
let g:easytags_include_members = 1


function! CHeaderComment() abort
  let l:file_info = s:get_file_info()

  let l:curr_date = strftime("%Y %b %d")
  let l:tw        = &textwidth

  return "/" . repeat('*', l:tw - 5) . "//**\n"
     \ . " * Author:       Steven Ward <stevenward94@gmail.com>\n"
     \ . " * File:         " . l:file_info.proj_path . "\n"
     \ . " * Last Change:  " . l:curr_date . "\n"
     \ . " " . repeat('*', l:tw - 5) . "/\n"
endfunction
nmap /** "=CHeaderComment()<CR>:0put =<CR>G


set colorcolumn=90
highlight ColorColumn ctermbg=236 

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=2 softtabstop=2 tabstop&vim

set cindent
set cinoptions=g0.5s,h0.5s,i2s,+2s,(2s,w1,W2s,m1,L0.5s,N-s)

set tags=../.tags,./.tags


function! s:SetGCCOptions() abort
  let l:dirpath = expand("%:p:h")
  let l:dirpath_up = expand("%:p:h:h")

  let l:paths = [ l:dirpath.'/include', l:dirpath.'/incl', l:dirpath_up.'/include', l:dirpath_up.'/incl' ]

  let l:c_compiler_options = ' -std=c99 -Wall -Wextra -pedantic'

  for l:include_path in l:paths
    if isdirectory(l:include_path)
      let l:c_compiler_options = l:c_compiler_options . ' -I' . l:include_path
    endif
    unlet l:include_path
  endfor

  return l:c_compiler_options

endfunction


function! s:get_file_info() abort
  let l:file_info = { }
  let l:file_info.path = expand("%:p")
  if strlen( system("git root 2>/dev/null") ) > 0
    let l:file_info.repo_path = system("git root")
    let l:repo = split(l:file_info.repo_path, '/')[-1]
    let l:file_info.repo_name = strpart(l:repo, 0, strchars(l:repo) - 1)
    let l:file_info.proj_path = strpart(l:file_info.path, match(l:file_info.path, l:file_info.repo_name))
  else
    let l:file_info.repo_path = ""
    let l:file_info.repo_name = ""
    let l:file_info.proj_path = l:file_info.path
  endif

  return l:file_info
endfunction

let g:syntastic_c_compiler_options = s:SetGCCOptions()
