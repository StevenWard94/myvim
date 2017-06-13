" Vim filetype plugin
" Language:       clojure
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 May 14
" ======================================================================================

let b:delimitMate_quotes = "\" `"
setlocal nolist
setlocal textwidth=80 formatoptions+=t
setlocal foldmethod=marker foldmarker=\\begin,\\end

function! s:get_file_ns() abort
  let buf = bufnr('%')
  " check if vim-fireplace plugin has done this for us
  if !empty(getbufvar(buf, 'fireplace_ns'))
    return getbufvar(buf, 'fireplace_ns')
  endif
  let l:path_ls = split(expand("%:p"), '/')
  let l:path_ls = l:path_ls[match(l:path_ls, 'src')+1:]
  let l:file_ns = join(l:path_ls, '.')
  let l:file_ns = substitute(l:file_ns, '_', '-', 'g')
  let l:file_ns = substitute(l:file_ns, '\.clj', '', '')
  return l:file_ns
endfunction
let b:file_ns = s:get_file_ns() 

command! -buffer Reload execute "silent normal cqp(use '" . b:file_ns . " :reload)\<CR>" 
command! -buffer ReloadAll execute "silent normal cqp(use '" . b:file_ns . " :reload-all)\<CR>"
