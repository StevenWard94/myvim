" vim:fdm=marker:fmr=\\begin,\\end
" ======================================================================================
" Vim plugin configuration file
" Language:       python
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jan 12
" ======================================================================================
" Personal configuration for the python-mode plugin (including all of the plugins it
" provides and manages)

" Pymode Lint Configuration    \begin1
  let g:pymode_lint_on_write = 0
  let g:pymode_lint_checkers = ['pylint', 'pep8']

  if !filereadable(fnamemodify(bufname(""), ":p:h").'/pylintrc') && executable('pylint')
    let l:local_rc = fnamemodify(bufname(""), ":p:h").'/pylintrc'
    if filereadable($HOME.'/.pylintrc')
      execute 'silent !cp -fT ~/.pylintrc ' . l:local_rc
    else
      execute 'silent !pylint --generate-rcfile > ' . l:local_rc
    endif
  endif

" Pymode Rope Configuration    \begin1
  let g:pymode_rope = 0
