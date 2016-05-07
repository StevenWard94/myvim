" vim: nowrap:fo=cr1jb:sw=2:sts=2:ts=8:nolist:
" ----------------------------------------------------------------------------------------
"
" Vim indent file
" Language:             eRuby
" Maintainer:           Tim Pope <vimNOSPAM@tpope.org>
" URL:                  https://github.com/vim-ruby/vim-ruby
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------------------

if exists('b:did_indent')
  finish
endif

runtime! indent/ruby.vim
unlet! b:did_indent
setlocal indentexpr=

if exists('b:eruby_subtype')
  execute "runtime! indent/" . b:eruby_subtype . ".vim"
else
  runtime! indent/html.vim
endif
unlet! b:did_indent

" Force HTML indent to not keep state
let b:html_indent_usestate = 0

if &l:indentexpr == ''
  if &l:cindent
    let &l:indentexpr = 'cindent(v:lnum)'
  else
    let &l:indentexpr = 'indent(prevnonblank(v:lnum - 1))'
  endif
endif
let b:eruby_subtype_indentexpr = &l:indentexpr

let b:did_indent = 1

setlocal indentexpr=GetErubyIndent()
setlocal indentkeys=o,O,*<Return>,<>>,{,},0),0],o,O,!^F,=end,=else,=elsif,=rescue,=ensure,=when

" Only define the function once
if exists("*GetErubyIndent")
  finish
endif

function! GetErubyIndent(...)
  " The value of a single shift-width
  if exists('*shiftwidth')
    let sw = shiftwidth()
  else
    let sw = &sw
  endif

  if a:0 && a:1 == '.'
    let v:lnum = line('.')
  elseif a:0 && a:1 =~ '^\d'
    let v:lnum = a:1
  endif
