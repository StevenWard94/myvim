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
syn match rubyASCIICode "\%(\w\|[]})\"'/]\)\@<!\%(?\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"
syn match rubyInteger   "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*r\=i\=\>"							        display
syn match rubyInteger   "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)r\=i\=\>"					        display
syn match rubyInteger   "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*r\=i\=\>"							        display
syn match rubyInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*r\=i\=\>"							        display
syn match rubyFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*r\=i\=\>"				        display
syn match rubyFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)r\=i\=\>"   display

" Identifiers
syn match  rubyLocalVariableOrMethod  "\<[_[:lower:]][_[:alnum:]]*[?!=]\="  contains=NONE display transparent
syn match  rubyBlockArgument	      "&[_[:lower:]][_[:alnum:]]"	   contains=NONE display transparent

syn match  rubyConstant		      "\%(\%(^\|[^.]\)\.\s*\)\@<!\<\u\%(\w\|[^\x00-\x7F]\)*\>\%(\s*(\)\@!"
syn match  rubyClassVariable	      "@@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"			   display
syn match  rubyInstanceVariable	      "@\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"			   display
syn match  rubyGlobalVariable	      "$\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\|-.\)"
syn match  rubySymbol		      "[]})\"':]\@<!:\%(\^\|\~@\|\~\|<<\|<=>\|<=\|<\|===\|[=!]=\|[=!]\~\|!@\|!\|>>\|>=\|>\||\|-@\|-\|/\|\[]=\|\[]\|\*\*\|\*\|&\|%\|+@\|+\|`\)"
syn match  rubySymbol		      "[]})\"':]\@<!:\$\%(-.\|[`~<=>_,;:!?/.'"@$*\&+0]\)"
syn match  rubySymbol		      "[]})\"':]\@<!:\%(\$\|@@\=\)\=\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"
syn match  rubySymbol		      "[]})\"':]\@<!:\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\%([?!=]>\@!\)\="
syn region rubySymbol		      start="[]})\"':]\@<!:'"  end="'"  skip="\\\\\|\\'"  contains=rubyQuoteEscape    fold
syn region rubySymbol		      start="[]})\"':]\@<!:\"" end="\"" skip="\\\\\|\\\"" contains=@rubyStringSpecial fold

syn match  rubyCapitalizedMethod      "\%(\%(^\|[^.]\)\.\s*\)\@<!\<\u\%(\w\|[^\x00-\x7F]\)*\>\%(\s*(\)*\s*(\@="

syn match  rubyBlockParameter         "\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*"  contained
syn region rubyBlockParameterList     start="\%(\%(\<do\>\|{\)\s*\)\@<=|"  end="|"   oneline display contains=rubyBlockParameter

syn match  rubyInvalidVariable	      "$[^ A-Za-z_-]"
syn match  rubyPredefinedVariable     #$[!$&"'*+,./0:;<=>?@\`~]#
syn match  rubyPredefinedVariable     "$\d\+"											display
syn match  rubyPredefinedVariable     "$_\>"											display
syn match  rubyPredefinedVariable     "$-[0FIKadilpvw]\>"									display
syn match  rubyPredefinedVariable     "$\%(deferr\|defout\|stderr\|stdin\|stdout\)\>"					        display
syn match  rubyPredefinedVariable     "$\%(DEBUG\|FILENAME\|KCODE\|LOADED_FEATURES\|LOAD_PATH\|PROGRAM_NAME\|SAFE\|VERBOSE\)\>" display
syn match  rubyPredefinedConstant     "\%(\%(^\|[^.]\)\.\s*\)\@<!\<\%(ARGF\|ARGV\|ENV\|DATA\|FALSE\|NIL\|STDERR\|STDIN\|STDOUT\|TOPLEVEL_BINDING\|TRUE\)\>\%(\s*(\)\@!"
syn match  rubyPredefinedConstant     "\%(\%(^\|[^.]\)\.\s*\)\@<!\<\%(RUBY_\%(VERSION\|RELEASE_DATE\|PLATFORM\|PATCHLEVEL\|REVISION\|DESCRIPTION\|COPYRIGHT\|ENGINE\)\)\>\%(\s*(\)\@!"

" Normal Regular Expression
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elsif\|when\|not\|then\|else\)\|[;\~=!|&(,{[<>?:*+-]\)\s*\)\@<=/" end="/[iomxneus]*" skip="\\\\\|\\/" contains=@rubyRegexpSpecial fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="\%(\h\k*\s\+\)\@<=/[ \t=]\@!"                                                                                    end="/[iomxneus]*" skip="\\\\\|\\/" contains=@rubyRegexpSpecial fold

" Generalized Regular Expression
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1[iomxneus]*" skip="\\\\\|\\\z1" contains=@rubyRegexpSpecial fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r{"				end="}[iomxneus]*"   skip="\\\\\|\\}"   contains=@rubyRegexpSpecial fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r<"				end=">[iomxneus]*"   skip="\\\\\|\\>"   contains=@rubyRegexpSpecial,rubyNestedAngleBrackets,rubyDelimEscape fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r\["				end="\][iomxneus]*"  skip="\\\\\|\\\]"  contains=@rubyRegexpSpecial fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r("				end="\)[iomxneus]*"  skip="\\\\\|\\)"   contains=@rubyRegexpSpecial fold
syn region rubyRegexp matchgroup=rubyRegexpDelimiter start="%r\z(\s\)"				end="\z1[iomxneus]*" skip="\\\\\|\\\z1" contains=@rubyRegexpSpecial fold

" Normal String
let s:spell_cluster = exists('ruby_spellcheck_strings') ? ',@Spell' : ''
execute 'syn region rubyString matchgroup=rubyStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" fold contains=@rubyStringSpecial' . s:spell_cluster
execute 'syn region rubyString matchgroup=rubyStringDelimiter start="''" end="''" skip="\\\\\|\\''" fold contains=rubyQuoteEscape'    . s:spell_cluster

" Shell Command Output
syn region rubyString matchgroup=rubyStringDelimiter start="`" end="`" skip="\\\\\|\\`" contains=@rubyStringSpecial fold

" Generalized Single Quoted String, Symbol and Array of Strings
