" Vim filetype plugin
" Language:       git commit messages ("gitcommit") 
" Maintainer:     Steven Ward <stevenward94@gmail.com>
" URL:            https://github.com/StevenWard94/myvim
" Last Change:    2016 Nov 16
" ======================================================================================

setlocal nolist shiftwidth=4 noexpandtab spell

autocmd! BufEnter COMMIT_EDITMSG :call setpos('.', [0, 1, 1, 0])
