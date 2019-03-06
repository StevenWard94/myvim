" Vim syntax file
" Language:    bash (sh)
" Author:      Steven Ward <stevenward94@gmail.com>
" Last Change: 2018 Feb 8
"
" Sets the 'g:is_bash' variable used by $VIMRUNTIME/syntax/sh.vim for bash scripts that
" do not begin with a bash shebang and are, therefore, not automatically detected as
" bash scripts - primarily for files like '.bashrc', '.bash_aliases', etc.

if !exists('g:is_kornshell') && !exists('g:is_bash') && !exists('g:is_posix') && !exists('g:is_sh') && expand("%:t") =~ '\M^.bash'
  let g:is_bash = 1
endif
