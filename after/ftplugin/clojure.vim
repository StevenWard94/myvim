" Vim filetype plugin
" Language:       clojure
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2017 Jan 5
" ======================================================================================

let b:delimitMate_quotes = "\" `"
setlocal nolist
setlocal textwidth=80 formatoptions+=t
setlocal foldmethod=marker foldmarker=\\begin,\\end
