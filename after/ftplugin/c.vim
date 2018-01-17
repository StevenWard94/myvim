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

let g:syntastic_c_compiler_options = s:SetGCCOptions()
