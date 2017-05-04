" Vim filetype plugin
" Language:       C++
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Apr 22
" ======================================================================================

let g:syntastic_cpp_checkers = [ 'gcc' ]
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libstdc++'

let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_check_header = 1

let g:easytags_autorecurse = 1
let g:easytags_include_members = 1

set colorcolumn=88
highlight ColorColumn ctermbg=darkgray

set textwidth=88 formatoptions=cr1jb nowrap nopaste
set expandtab shiftwidth=2 softtabstop=2 tabstop&vim

set cindent
set cinoptions=g0.5s,h0.5s,i2s,+2s,(2s,w1,W2s,m1,L0.5s,N-s

function! CppHeaderComment() abort
  let l:file_info = s:get_file_info()

  let l:curr_date = strftime("%Y %b %d")
  let l:tw        = &textwidth

  return "/" . repeat('*', l:tw - 5) . "//**\n"
     \ . " * Author:       Steven Ward <stevenward94@gmail.com>\n"
     \ . " * File:         " . l:file_info.proj_path . "\n"
     \ . ( l:file_info.repo_name == "" ? "" :
     \   " * URl:file_info.          https://github.com/StevenWard94/" . l:file_info.repo_name . "\n" )
     \ . " * Last Change:  " . l:curr_date . "\n"
     \ . " " . repeat('*', l:tw - 5) . "/\n"
endfunction
nmap /** "=CppHeaderComment()<CR>:0put =<CR>G


"function! s:setup_tagfiles_location() abort
"  if exists('b:tags_location') && b:tags_location != ""
"    return
"  endif
"
"  let l:file_info = s:get_file_info()
"  let [ l:fpath, l:gitpath ] = [ l:file_info.path, l:file_info.repo_path ]
"  let l:levels = 1
"  let l:relpath = ""
"  let l:tagpath = s:dec_path_depth(l:fpath, l:levels)
"  let l:tagfile = ''
"
"  while l:tagpath !~ l:gitpath
"    let l:relpath = (l:levels > 1) ? l:relpath.'../' : ""
"    if isdirectory(l:tagpath.'/tags')
"      if filewritable(l:tagpath.'/tags/.tags')
"        let l:tagfile = strlen(l:relpath) ? l:relpath : './'
"        let l:tagfile .= 'tags/.tags'
"        break
"      endif
"    elseif filewritable(l:tagpath.'/.tags')
"      let l:tagfile = strlen(l:relpath) ? l:relpath : './'
"      let l:tagfile .= '.tags'
"      break
"    else
"      let l:levels += 1
"      let l:tagpath = s:dec_path_depth(l:fpath, l:levels)
"    endif
"  endwhile
"
"  if !strlen(l:tagfile)
"    " basically checks if the file is part of a normal project structure; if so, use ../.tags - otherwise, use ./.tags
"    let l:other_dirs = split(system( 'ls -AF /' . join(split(l:fpath, '/')[:-3], '/') ), '\n')
"    let l:tagfile = ( match(l:other_dirs, '\(incl\(ude\)\?\|src\|head\(er\)\?\|libs\?\|tests\?\)\/') != -1 ) ? '../.tags' : './.tags'
"  endif
"
"  return l:tagfile
"endfunction
set tags=../.tags


function! s:dec_path_depth(full_path, levels_up) abort
  if a:levels_up == 0
    return a:full_path
  endif
  let l:split_path = split(a:full_path, '/')
  execute 'let l:cut_path = l:split_path[:-'.(a:levels_up + 1).']'
  return join(l:cut_path, '/')
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
