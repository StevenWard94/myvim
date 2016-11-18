" Vim plugin
" Language:     N/A
" Maintainer:   Steven Ward <stevenward94@gmail.com>
" Last Change:  2016 Nov 10
" ======================================================================================
" Orignal file
" Created:      2013 May 28
" Source:       https://gist.github.com/kshenoy/3194467
" ======================================================================================

function! GetMapKey(rhs, ...)
  " Description: Get {lhs} of a mapping. Inverse of 'maparg()'.
  " Note that 'hasmapto()' returns a binary result while 'GetMapKey()' returns the value
  " of the {lhs}.
  " Accepts one or more arguments. If additional arguments are omitted, then the mode is
  " assumed to be 'nox'. Otherwise, the mode provided is used.
  let l:mode = a:0 > 0 ? a:1 : ''

  redir => l:mappings
  silent! execute l:mode.'map'
  redir END

  " Convert all text between angle-brackets to lowercase.
  " Required to recognize (e.g.) <c-A> and <C-a> as the same thing.
  " Note: 'Alt' mappings are case-sensitive. However, this is not an issue as these
  " mappings are replaced their appropriate keycodes (e.g. <A-a> becomes á).
  let l:rhs = substitute(a:rhs, '<[^>]\+>', "\\L\\0", 'g')

  for l:map in split(l:mappings, '\n')
    " Get {rhs} for each mapping
    let l:lhs = split(l:map, '\s\+')[1]
    let l:lhs_map = maparg(l:lhs, l:mode)

    if substitute(l:lhs_map, '<[^>]\+>', "\\L\\0", 'g') ==# l:rhs
      return l:lhs
    endif
  endfor
  return ''
endfunction
