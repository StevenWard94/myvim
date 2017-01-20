" Vim filetype plugin
" Language:       python
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jan 16
" ======================================================================================

"if exists('b:did_load_pyconf')
"  finish
"endif
"let b:did_load_pyconf = 1

if !filereadable(fnamemodify(bufname(""), ":p:h").'/pylintrc') && executable('pylint')
  let local_rc = fnamemodify(bufname(""), ":p:h").'/pylintrc'
  if filereadable($HOME.'/.pylintrc')
    execute 'silent !cp -fT ~/.pylintrc ' . local_rc
  else
    execute 'silent !pylint --generate-rcfile > ' . local_rc
  endif
endif

" setup AFTER sourcing pymode configurations
let b:syntastic_mode = "passive"

"function! s:LoadPymodeConfig() abort
"  let l:dirs = [ $VIMHOME, $HOME.'/.vim' ]
"  if exists('$MYVIMRC') | call add(l:dirs, fnamemodify(expand("$MYVIMRC"), ":p:h").'/.vim') | endif
"
"  let l:vim_home = ''
"  for dir in l:dirs
"    if isdirectory(dir)
"      let l:vim_home = dir
"      break
"    endif
"    unlet dir
"  endfor
"  if empty(l:vim_home)
"    echohl WarningMsg
"    echomsg "Warning: Unable to locate vim home directory!"
"    echomsg "No pymode configuration was loaded"
"    echomsg "Directory paths searched:" join(filter(l:dirs, '!empty(v:val)'), ', ')
"    echohl None
"    return
"  endif
"
"  let l:sourced = {
"        \    join( [l:vim_home, 'ftplugin'], '/' )          : [],
"        \    join( [l:vim_home, 'after', 'ftplugin'], '/' ) : []
"        \}
"
"  for plugd in keys(l:sourced)
"    if !isdirectory(plugd)
"      unlet l:sourced[plugd]
"      continue
"    endif
"    for file in split(system('ls -A '.plugd), '\n')
"      if file =~? '^py\(thon-\)\?mode[._-]\?\(init\|conf\(ig\)\?\|setup\|rc\)\(\.vim\)?$'
"        let l:sourced[plugd] += [file]
"      endif
"      unlet file
"    endfor
"    unlet plugd
"  endfor
"
"  for [path, file] in items( filter(l:sourced, '!empty(v:val)') )
"    execute 'source ' . join([path, file], '/')
"  endfor
"endfunction
"call s:LoadPymodeConfig()
