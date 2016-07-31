"=======================================================================================
" Vim syntax plugin to add conceal operators for haskell files
" File:           haskell.vim (conceal enhancement)
" Author:         Vincent Berthoux <twinside@gmail.com>
" Last Change:    2011 Sep 07
" Version:        1.3.2
" Require:
"   set nocompatible
"     somewhere in your .vimrc
"
"   Vim 7.3 or Vim compiled with '+conceal' patch
"   Fulfilled by compiling Vim using '--with-features=[big | huge]'
"
" Usage:
"   Place this file in...
"     ~/.vim/after/syntax directory (Linux/MacOSX/BSD...)
"     ~/vimfiles/after/syntax directory (Windows)
"
"   Vim encoding must also be set  to 'utf-8'
"
" Changelog:
"   - 1.3.1: putting undefined in extra conceal, not appearing on windows
"   - 1.3: adding new arrow characters used by GHC in Unicode extension
"   - 1.2: fixing conceal level to be local (thanks Erlend Hamberg)
"   - 1.1: better handling of non-utf-8 systems, and avoid some
"           concealing operations on windows for some fonts
"=======================================================================================

if exists('g:no_haskell_conceal') || !has('conceal') || &encoding != 'utf-8'
  finish
endif

" vim: set fileencoding=utf-8:
syntax match hsNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ
syntax match hsNiceOperator "<-" conceal cchar=←
syntax match hsNiceOperator "->" conceal cchar=→
syntax match hsNiceOperator "\<sum\>" conceal cchar=Σ
syntax match hsNiceOperator "\<product\>" conceal cchar=Π
syntax match hsNiceOperator "\<sqrt\>" conceal cchar=√
syntax match hsNiceOperator "\<pi\>" conceal cchar=π
syntax match hsNiceOperator "==" conceal cchar=≡
syntax match hsNiceOperator "\/=" conceal cchar=≠
syntax match hsNiceOperator ">>" conceal cchar=»

let s:extraConceal = 1
" Some windows fonts don't support some of the characters,
" so if one of them is the main font, then we don't load the
" problem characters
if has('win32')
  let s:incompleteFont = [ 'Consolas'
                      \ , 'Lucida Console'
                      \ , 'Courier New'
                      \ ]
  let s:mainfont = substitute( &guifont, '^\([^:,]\+\).*', '\1', '')
  for s:fontName in s:incompleteFont
    if s:mainfont ==? s:fontName
      let s:extraConceal = 0
      break
    endif
  endfor
endif

if s:extraConceal
  syntax match hsNiceOperator "\<undefined\>" conceal cchar=⊥

  " Match GT and LT without messing up Kleisli composition
  syntax match hsNiceOperator "<=\ze[^<]" conceal cchar=≤
  syntax match hsNiceOperator ">=\ze[^>]" conceal cchar=≥

  syntax match hsNiceOperator "=>" conceal cchar=⇒
  syntax match hsNiceOperator "=\zs<<" conceal cchar=«

  syntax match hsNiceOperator ">>>" conceal cchar=⋙

  " Redefining to get proper '::' concealing
  syntax match hs_DeclareFunction /^[a-z_(]\S*\(\s\|\n\)*::/me=e-2 nextgroup=hsNiceOperator contains=hs_FunctionName,hs_OpFunctionName
  syntax match hsNiceOperator "\:\:" conceal cchar=∷

  syntax match hsNiceOperator "++" conceal cchar=⧺
  syntax match hsNiceOperator "\<forall\>" conceal cchar=∀
  syntax match hsNiceOperator "-<" conceal cchar=↢
  syntax match hsNiceOperator ">-" conceal cchar=↣
  syntax match hsNiceOperator "-<<" conceal cchar=⤛
  syntax match hsNiceOperator ">>-" conceal cchar=⤜
  syntax match hsNiceOperator "*" conceal cchar=×
  syntax match hsNiceOperator "`div`" conceal cchar=÷

  " Only replace the dot - avoid taking spaces around the dot
  syntax match hsNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
  syntax match hsNiceOperator "\.\." conceal cchar=⋯

  syntax match hsQQEnd "|\]" contained conceal cchar=〛
  "syntax match hsQQEnd "|\]" contained conceal=〚

  syntax match hsNiceOperator "`elem`" conceal cchar=∈
  syntax match hsNiceOperator "`notElem`" conceal cchar=∉
  syntax match hsNiceOperator "`union`" conceal cchar=∪
  syntax match hsNiceOperator "`intersect`" conceal cchar=∩
  syntax match hsNiceOperator "\\\\\ze[[:alpha:][:space:]_([]" conceal cchar=\

  syntax match hsNiceOperator "||\ze[[:alpha:][:space:]_([]" conceal cchar=∨
  syntax match hsNiceOperator "&&\ze[[:alpha:][:space:]_([]" conceal cchar=∧
  syntax match hsNiceOperator "\<not\>" conceal cchar=¬

  syntax match hsNiceOperator "!!" conceal cchar=‼
endif

highlight link hsNiceOperator Operator
highlight! link Conceal Operator
setlocal conceallevel=2
