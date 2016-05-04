" vim: nowrap:fo=cr1jb:sw=2:sts=2:ts=8:noet:nolist:
" ----------------------------------------------------------------------------------------------------------------------
"
" Vim syntax file
" Language:             Ruby
" Maintainer:           Doug Kearns <dougkearns@gmail.com>
" URL:                  https://github.com/vim-ruby/vim-ruby
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------------------------------------------------
"
" Previous Maintainer:	Mirko Nasato
" Thanks to perl.vim authors, and to Reimer Behrends. :-) (MN)
" ----------------------------------------------------------------------------------------------------------------------

if exists('b:current_syntax')
  finish
endif

if has('folding') && exists('ruby_fold')
  setlocal foldmethod=syntax
endif

syn cluster rubyNotTop contains=@rubyExtendedStringSpecial,@rubyRegexpSpecial,@rubyDeclaration,rubyConditional,rubyExceptional,rubyMethodExceptional,rubyTodo

if exists('ruby_space_errors')
  if !exists('ruby_no_trail_space_error')
    syn match rubySpaceError display excludenl "\s\+$"
  endif
  if !exists('ruby_no_tab_space_error')
    syn match rubySpaceError display " \+\t"me=e-1
  endif
endif

" Operators
if exists('ruby_operators')
  syn match  rubyOperator "[~!^|*/%+-]\|&\.\@!\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::"
  syn match  rubyOperator "->\|-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!="
  syn region rubyBracketOperator matchgroup=rubyOperator start="\%(\w[?!]\=\|[]})]\)\@<=\[\s*" end="\s*]" contains=ALLBUT,@rubyNotTop
endif

" Expression Substitution and Backslash Notation
syn match rubyStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}"						    contained display
syn match rubyStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match rubyQuoteEscape  "\\[\\']"

syn region rubyInterpolation	      matchgroup=rubyInterpolationDelimiter start="#{" end="}" contained contains=ALLBUT,@rubyNotTop
syn match  rubyInterpolation	      "#\%(\$\|@@\=\)\w\+"    display contained contains=rubyInterpolationDelimiter,rubyInstanceVariable,rubyClassVariable,rubyGlobalVariable,rubyPredefinedVariable
syn match  rubyInterpolationDelimiter "#\ze\%(\$\|@@\=\)\w\+" display contained
syn region rubyNoInterpolation	      start="\\#{" end="}"	      contained
syn match  rubyNoInterpolation	      "\\#{"		      display contained
syn match  rubyNoInterpolation	      "\\#\%(\$\|@@\=\)\w\}"  display contained
syn match  rubyNoInterpolation	      "\\#\$\W"		      display contained

syn match  rubyDelimEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region rubyNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=rubyString end=")"  transparent contained
syn region rubyNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=rubyString end="}"  transparent contained
syn region rubyNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=rubyString end=">"  transparent contained
syn region rubyNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=rubyString end="\]" transparent contained

" These are mostly Oniguruma ready
syn region rubyRegexpComment    matchgroup=rubyRegexpSpecial   start="(?#"								  skip="\\)"  end=")"  contained
syn region rubyRegexpParens	matchgroup=rubyRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@rubyRegexpSpecial
syn region rubyRegexpBrackets	matchgroup=rubyRegexpCharClass start="\[\^\="								  skip="\\\]" end="\]" contained transparent contains=rubyStringEscape,rubyRegexpEscape,rubyRegexpCharClass oneline
syn match  rubyRegexpCharClass  "\\[DdHhSsWw]"	       contained display
syn match  rubyRegexpCharClass  "\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  rubyRegexpEscape     "\\[].*?+^$|\\/(){}[]" contained
syn match  rubyRegexpQuantifier "[*?+][?+]\="	       contained display
syn match  rubyRegexpQuantifier "{\d\+\%(,\d*\)\=}?\=" contained display
syn match  rubyRegexpAnchor     "[$^]\|\\[ABbGZz]"     contained display
syn match  rubyRegexpDot	"\."		       contained display
syn match  rubyRegexpSpecial    "|"                    contained display
syn match  rubyRegexpSpecial    "\\[1-9]\d\=\d\@!"     contained display
syn match  rubyRegexpSpecial    "\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  rubyRegexpSpecial    "\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  rubyRegexpSpecial    "\\g<\%([a-z_]\w*\|-\=\d\+\)>"                contained display
syn match  rubyRegexpSpecial    "\\g'\%([a-z_]\w*\|-\=\d\+\)'"                contained display

syn cluster rubyStringSpecial	      contains=rubyInterpolation,rubyNoInterpolation,rubyStringEscape
syn cluster rubyExtendedStringSpecial contains=@rubyStringSpecial,rubyNestedParentheses,rubyNestedCurlyBraces,rubyNestedAngleBrackets,rubyNestedSquareBrackets
syn cluster rubyRegexpSpecial         contains=rubyInterpolation,rubyNoInterpolation,rubyStringEscape,rubyRegexpSpecial,rubyRegexpEscape,rubyRegexpBrackets,rubyRegexpCharClass,rubyRegexpDot,rubyRegexpQuantifier,rubyRegexpAnchor,rubyRegexpParens,rubyRegexpComment

" Numbers and ASCII Codes
syn match rubyASCIICode "\%(\w\|[]})\"'/]\)\@<!\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"

