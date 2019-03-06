" Vim filetype plugin
" Language:       Ruby
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2018 Jun 18
" ======================================================================================

let g:syntastic_ruby_checkers = [ 'mri' ]


function! s:RubocopChecker(...) abort
  let l:action = ''
  let l:ruby_checkers = [ ]

  if exists('g:syntastic_ruby_checkers')
    let l:ruby_checkers = copy(g:syntastic_ruby_checkers)
  else
    let l:ruby_checkers = [ 'mri' ]
  endif

  if a:0 > 0
    let l:action = a:1
  else
    let l:action = ( index(l:ruby_checkers, 'rubocop') == -1 ) ? 'on' : 'off'
  endif

  if l:action =~? 'on'
    if index(l:ruby_checkers, 'rubocop') == -1
      call add(l:ruby_checkers, 'rubocop')
    endif
  elseif l:action =~? 'off'
    let l:rubocop_idx = index(l:ruby_checkers, 'rubocop')
    if l:rubocop_idx != -1
      call remove(l:ruby_checkers, l:rubocop_idx)
    endif
    unlet l:rubocop_idx
  else
    echoerr "RubocopChecker: Error: Optional argument must be either 'on' or 'off'."
  endif

  return l:ruby_checkers
endfunction

command! ToggleRubocop :let g:syntastic_ruby_checkers = s:RubocopChecker()
command! EnableRubocop :let g:syntastic_ruby_checkers = s:RubocopChecker('on')
command! DisableRubocop :let g:syntastic_ruby_checkers = s:RubocopChecker('off')


setlocal formatoptions-=r
setlocal formatoptions-=o
