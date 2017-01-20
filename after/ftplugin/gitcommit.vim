" Vim filetype plugin
" Filetype:       gitcommit (git COMMIT_EDITMSG files)
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Dec 22
" ======================================================================================

set nolist shiftwidth=4 noexpandtab spell
set textwidth=72 formatoptions+=t

autocmd! BufEnter COMMIT_EDITMSG :call setpos('.', [0, 1, 1, 0])
