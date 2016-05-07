" vim: nowrap:fo=cr1jb:sw=2:sts=2:ts=8:nolist:indentexpr=:
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
syn region rubyString matchgroup=rubyStringDelimiter start="%[qw]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"  end="\z1"  skip="\\\\\|\\\z1"  fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[qw]{"				    end="}"    skip="\\\\\|\\}"    fold  contains=rubyNestedCurlyBraces,rubyDelimEscape
syn region rubyString matchgroup=rubyStringDelimiter start="%[qw]<"				    end=">"    skip="\\\\\|\\>"	   fold  contains=rubyNestedAngleBrackets,rubyDelimEscape
syn region rubyString matchgroup=rubyStringDelimiter start="%[qw]\["				    end="\]"   skip="\\\\\|\\\]"   fold	 contains=rubyNestedSquareBrackets,rubyDelimEscape
syn region rubyString matchgroup=rubyStringDelimiter start="%[qw]("				    end=")"    skip="\\\\\|\\)"	   fold  contains=rubyNestedParentheses,rubyDelimEscape
syn region rubyString matchgroup=rubyStringDelimiter start="%q\z(\s\)"				    end="\z1"  skip="\\\\\|\\\z1"  fold
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%s\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"	    end="\z1"  skip="\\\\\|\\\z1"  fold
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%s{"				    end="}"    skip="\\\\\|\\}"	   fold  contains=rubyNestedCurlyBraces,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%s<"				    end=">"    skip="\\\\\|\\>"	   fold  contains=rubyNestedAngleBrackets,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%s\["				    end="\]"   skip="\\\\\|\\\]"   fold	 contains=rubyNestedSsuareBrackets,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%s("				    end=")"    skip="\\\\\|\\)"	   fold  contains=rubyNestedParentheses,rubyDelimEscape
syn region rubyString matchgroup=rubyStringDelimiter start="%s\z(\s\)"				    end="\z1"  skip="\\\\\|\\\z1"  fold

" Generalized Double Quoted String, Array of Strings, and Shell Command Output
" Note: '%=' is NOT matched here as the beginning of a double quoted string
syn region rubyString matchgroup=rubyStringDelimiter start="%\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"	     end="\z1"  skip="\\\\\|\\\z1"  contains=@rubyStringSpecial						 fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[QWx]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"  end="\z1"  skip="\\\\\|\\\z1"  contains=@rubyStringSpecial						 fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[QWx]\={"				     end="}"    skip="\\\\\|\\}"    contains=@rubyStringSpecial,rubyNestedCurlyBraces,rubyDelimEscape    fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[QWx]\=<"				     end=">"    skip="\\\\\|\\>"    contains=@rubyStringSpecial,rubyNestedAngleBrackets,rubyDelimEscape  fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[QWx]\=\["				     end="\]"   skip="\\\\\|\\\]"   contains=@rubyStringSpecial,rubyNestedSquareBrackets,rubyDelimEscape fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[QWx]\=("				     end=")"    skip="\\\\\|\\)"    contains=@rubyStringSpecial,rubyNestedParentheses,rubyDelimEscape    fold
syn region rubyString matchgroup=rubyStringDelimiter start="%[Qx]\z(\s\)"		             end="\z1"  skip="\\\\\|\\\z1"  contains=@rubyStringSpecial						 fold

" Array of Symbols
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%i\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"	    end="\z1"  skip="\\\\\|\\\z1"  fold
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%i{"				    end="}"    skip="\\\\\|\\}"	   fold  contains=rubyNestedCurlyBraces,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%i<"				    end=">"    skip="\\\\\|\\>"	   fold  contains=rubyNestedAngleBrackets,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%i\["				    end="\]"   skip="\\\\\|\\\]"   fold	 contains=rubyNestedSsuareBrackets,rubyDelimEscape
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%i("				    end=")"    skip="\\\\\|\\)"	   fold  contains=rubyNestedParentheses,rubyDelimEscape

" Array of Interpolated Symbols
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%I\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"	    end="\z1"  skip="\\\\\|\\\z1"  contains=@rubyStringSpecial						fold
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%I{"				    end="}"    skip="\\\\\|\\}"	   contains=@rubyStringSpecial,rubyNestedCurlyBraces,rubyDelimEscape    fold  
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%I<"				    end=">"    skip="\\\\\|\\>"	   contains=@rubyStringSpecial,rubyNestedAngleBrackets,rubyDelimEscape  fold  
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%I\["				    end="\]"   skip="\\\\\|\\\]"   contains=@rubyStringSpecial,rubyNestedSquareBrackets,rubyDelimEscape fold	 
syn region rubySymbol matchgroup=rubySymbolDelimiter start="%I("				    end=")"    skip="\\\\\|\\)"	   contains=@rubyStringSpecial,rubyNestedParentheses,rubyDelimEscape    fold  

" Here Document
syn region rubyHeredocStart matchgroup=rubyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zs\%(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)+  end=+$+  oneline contains=ALLBUT,@rubyNotTop
syn region rubyHeredocStart matchgroup=rubyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zs"\%([^"]*\)"+					 end=+$+  oneline contains=ALLBUT,@rubyNotTop
syn region rubyHeredocStart matchgroup=rubyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zs'\%([^']*\)'+					 end=+$+  oneline contains=ALLBUT,@rubyNotTop
syn region rubyHeredocStart matchgroup=rubyStringDelimiter start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zs`\%([^`]*\)`+					 end=+$+  oneline contains=ALLBUT,@rubyNotTop

syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+2	 matchgroup=rubyStringDelimiter  end=+^\z1$+	    contains=rubyHeredocStart,rubyHeredoc,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<"\z([^"]*\)"\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+2					 matchgroup=rubyStringDelimiter  end=+^\z1$+	    contains=rubyHeredocStart,rubyHeredoc,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<'\z([^']*\)'\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+2					 matchgroup=rubyStringDelimiter  end=+^\z1$+	    contains=rubyHeredocStart,rubyHeredoc,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]})"'.]\)\s\|\w\)\@<!<<`\z([^`]*\)`\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+2					 matchgroup=rubyStringDelimiter  end=+^\z1$+	    contains=rubyHeredocStart,rubyHeredoc,@rubyStringSpecial  fold keepend

syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<[-~]\z(\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*\)\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+3  matchgroup=rubyStringDelimiter  end=+^\s*\zs\z1$+  contains=rubyHeredocStart,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<[-~]"\z([^"]*\)"\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+3				         matchgroup=rubyStringDelimiter  end=+^\s*\zs\z1$+  contains=rubyHeredocStart,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<[-~]'\z([^']*\)'\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+3				         matchgroup=rubyStringDelimiter  end=+^\s*\zs\z1$+  contains=rubyHeredocStart,@rubyStringSpecial  fold keepend
syn region rubyString  start=+\%(\%(class\|::\)\_s*\|\%([]}).]\)\s\|\w\)\@<!<<[-~]`\z([^`]*\)`\ze\%(.*<<[-~]\=['`"]\=\h\)\@!+hs=s+3				         matchgroup=rubyStringDelimiter  end=+^\s*\zs\z1$+  contains=rubyHeredocStart,@rubyStringSpecial  fold keepend


if exists('main_syntax') && main_syntax == 'eruby'
  let b:ruby_no_expensive = 1
endif


syn match  rubyAliasDeclaration    "[^[:space:];#.()]\+"  contained  contains=rubySymbol,rubyGlobalVariable,rubyPredefinedVariable  nextgroup=rubyAliasDeclaration2 skipwhite
syn match  rubyAliasDeclaration2   "[^[:space:];#.()]\+"  contained  contains=rubySymbol,rubyGlobalVariable,rubyPredefinedVariable
syn match  rubyMethodDeclaration   "[^[:space:];#(]\+"    contained  contains=rubyConstant,rubyBoolean,rubyPseudoVariable,rubyInstanceVariable,rubyClassVariable,rubyGlobalVariable
syn match  rubyClassDeclaration    "[^[:space:];#<]\+"    contained  contains=rubyConstant,rubyOperator
syn match  rubyModuleDeclaration   "[^[:space:];#<]\+"    contained  contains=rubyConstant,rubyOperator

syn match  rubyFunction            "\<[_[:alpha:]][_[:alnum:]]*[?!=]\=[[:alnum:]_.:?!=]\@!"       contained  containedin=rubyMethodDeclaration
syn match  rubyFunction            "\%(\s\|^\)\@<=[_[:alpha:]][_[:alnum:]]*[?!=]\=\%(\s\|$\)\@="  contained  containedin=rubyAliasDeclaration,rubyAliasDeclaration2
syn match  rubyFunction            "\%([[:space:].]\|^\)\@<=\%(\[\]=\=\|\*\*\|[-+!~]@\=\|[*/%|&^~]\|<<\|>>\|[<>]=\=\|<=>\|===\|[=!]=\|[=!]\~\|!\|`\)\%([[:space:];#(]\|$\)\@="  contained  containedin=rubyAliasDeclaration,rubyAliasDeclaration2,rubyMethodDeclaration

syn cluster rubyDeclaration    contains=rubyAliasDeclaration,rubyAliasDeclaration2,rubyMethodDeclaration,rubyModuleDeclaration,rubyClassDeclaration,rubyFunction,rubyBlockParameter


" Keywords
" Note: the following keywords have already been defined (and thus are not defined here):
"     begin  case  class  def  do  end  for  if  module  unless  until  while
syn match   rubyControl         "\<\%(and\|break\|in\|next\|not\|or\|redo\|rescue\|retry\|return\)\>[?!]\@!"
syn match   rubyOperator        "\<defined?"  display
syn match   rubyKeyword         "\<\%(super\|yield\)\>[?!]\@!"
syn match   rubyBoolean         "\<\%(true\|false\)\>[?!]\@!"
syn match   rubyPseudoVariable  "\<\%(nil\|self\|__ENCODING__\|__dir__\|__FILE__\|__LINE__\|__callee__\|__method__\)\>[?!]\@!"        " TODO: reorganize
syn match   rubyBeginEnd        "\<\%(BEGIN\|END\)\>[?!]\@!"


" Expensive Mode - match 'end' with the appropriate opening keyword for syntax
"   based folding and special highlighting of module/class/method definitions
if !exists('b:ruby_no_expensive') && !exists('ruby_no_expensive')
  syn match  rubyDefine  "\<alias\>"   nextgroup=rubyAliasDeclaration   skipwhite skipnl
  syn match  rubyDefine  "\<def\>"     nextgroup=rubyMethodDeclaration  skipwhite skipnl
  syn match  rubyDefine  "\<undef\>"   nextgroup=rubyFunction           skipwhite skipnl
  syn match  rubyClass   "\<class\>"   nextgroup=rubyClassDeclaration   skipwhite skipnl
  syn match  rubyModule  "\<module\>"  nextgroup=rubyModuleDeclaration  skipwhite skipnl

  syn region rubyMethodBlock  start="\<def\>"     matchgroup=rubyDefine   end="\%(\<def\_s\+\)\@<!\<end\>"  contains=ALLBUT,@rubyNotTop fold
  syn region rubyBlock        start="\<class\>"   matchgroup=rubyClass    end="\<end\>"                     contains=ALLBUT,@rubyNotTop fold
  syn region rubyBlock        start="\<module\>"  matchgroup=rubyModule   end="\<end\>"                     contains=ALLBUT,@rubyNotTop fold
  syn region rubyDoBlock      start="\<do\>"      matchgroup=rubyControl  end="\<end\>"                     contains=ALLBUT,@rubyNotTop fold

  " Modifiers
  syn match  rubyConditionalModifier  "\<\%(if\|unless\)\>"     display
  syn match  rubyRepeatModifier       "\<\%(while\|until\)\>"   display

  " curly bracket block or hash literal
  syn region rubyCurlyBlock     matchgroup=rubyCurlyBlockDelimiter  start="{"                       end="}"   contains=ALLBUT,@rubyNotTop fold
  syn region rubyArrayLiteral   matchgroup=rubyArrayDelimiter       start="\%(\w\|[\]})]\)\@<!\["   end="]"   contains=ALLBUT,@rubyNotTop fold

  " statements without 'do'
  syn region rubyBlockExpression        matchgroup=rubyControl      start="\<begin\>"   end="\<end\>"   contains=ALLBUT,@rubyNotTop fold
  syn region rubyCaseExpression         matchgroup=rubyConditional  start="\<case\>"    end="\<end\>"   contains=ALLBUT,@rubyNotTop fold
  syn region rubyConditionalExpression  matchgroup=rubyConditional  start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*%&^|+=-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![?!]\)\s*\)\@<=\%(\\\n\s*\)\@<!\%(if\|unless\)\>"   end="\%(\%(\%(\.\@<!\.\)\|::\)\s*\)\@<!\<end\>"   contains=ALLBUT,@rubyNotTop fold

  syn match  rubyConditional        "\<\%(then\|else\|when\)\>[?!]\@!"                            contained containedin=rubyCaseExpression
  syn match  rubyConditional        "\<\%(then\|else\|elsif\)\>[?!]\@!"                           contained containedin=rubyConditionalExpression

  syn match  rubyExceptional        "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!"   contained containedin=rubyBlockExpression
  syn match  rubyMethodExceptional  "\<\%(\%(\%(;\|^\)\s*\)\@<=rescue\|else\|ensure\)\>[?!]\@!"   contained containedin=rubyMethodBlock

  " statements with optional 'do'
  syn region rubyOptionalDoLine     start="\<for\>[?!]\@!"  start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>"  matchgroup=rubyRepeat,rubyOptionalDo  end="\%(\<do\>\)" end="\ze\%(;\|$\)"  oneline contains=ALLBUT,@rubyNotTop
  syn region rubyRepeatExpression   start="\<for\>[?!]\@!"  start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>"  matchgroup=rubyRepeat                 end="\<end\>"     contains=ALLBUT,@rubyNotTop   nextgroup=rubyOptionalDoLine fold


  if !exists('ruby_minlines')
    let ruby_minlines = 500
  endif
  execute "syn sync minlines=" . ruby_minlines


else  " i.e.  if exists('b:ruby_no_expensive') || exists('ruby_no_expensive')
  syn match  rubyControl  "\<def\>[?!]\@!"      nextgroup=rubyMethodDeclaration   skipwhite skipnl
  syn match  rubyControl  "\<class\>[?!]\@!"    nextgroup=rubyClassDeclaration    skipwhite skipnl
  syn match  rubyControl  "\<module\>[?!]\@!"   nextgroup=rubyModuleDeclaration   skipwhite skipnl
  syn match  rubyControl  "\<\%(case\|begin\|do\|for\|if\|unless\|while\|until\|else\|elsif\|ensure\|then\|when\|end\)\>[?!]\@!"
  syn match  rubyKeyword  "\<\%(alias\|undef\)\>[?!]\@!"
endif


" Special Methods
if !exists('ruby_no_special_methods')
  syn keyword rubyAccess    public protected private public_class_method private_class_method public_constant private_constant module_function
  " attr is a common variable name
  syn match   rubyAttribute "\%(\%(^\|;\)\s*\)\@<=attr\>\(\s*[.=]\)\@!"
  syn keyword rubyAttribute attr_accessor attr_reader attr_writer
  syn match   rubyControl   "\<\%(exit!\|\%(abort\|at_exit\|exit\|fork\|loop\|trap\)\>[?!]\@!\)"
  syn keyword rubyEval      eval class_eval instance_eval module_eval
  syn keyword rubyException raise fail catch throw
  " false positive with 'include?'
  syn match   rubyInclude   "\<include\>[?!]\@!"
  syn keyword rubyInclude   autoload extend load prepend refine require require_relative using
  syn keyword rubyKeyword   callcc caller lambda proc
endif


" Comments and Documentation
syn match   rubySharpBang   "\%^#!.*"   display
syn keyword rubyTodo        FIXME NOTE TODO OPTIMIZE HACK REVIEW XXX todo   contained
syn match   rubyComment     "#.*"       contains=rubySharpBang,rubySpaceError,rubyTodo,@Spell

if !exists('ruby_no_comment_fold')
  syn region rubyMultilineComment   start="^\s*#.*\n\%(^\s*#\)\@="  end="^\s*#.*\n\%(^\s*#\)\@!"  contains=rubyComment        transparent   fold keepend
  syn region rubyDocumentation      start="^=begin\ze\%(\s.*\)\=$"  end="^=end\%(\s.*\)\=$"       contains=rubySpaceError,rubyTodo,@Spell   fold
else
  syn region rubyDocumentation      start="^=begin\s*$"             end="^=end\s*$"               contains=rubySpaceError,rubyTodo,@Spell
endif


" Note: this is a hack to prevent 'keywords' from being highlighted as such when they are called as methods with an explicit receiver
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(alias\|and\|begin\|break\|case\|class\|def\|defined\|do\|else\)\>"            transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(elsif\|end\|ensure\|false\|for\|if\|in\|module\|next\|nil\)\>"                transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(not\|or\|redo\|refine\|rescue\|retry\|return\|self\|super\|then\|true\)\>"    transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(undef\|unless\|until\|when\|while\|yield\|BEGIN\|END\|__FILE__\|__LINE__\)\>" transparent contains=NONE

syn match  rubyKeywordAsMethod    "\<\%(alias\|begin\|case\|class\|def\|do\|end\)[?!]"          transparent contains=NONE
syn match  rubyKeywordAsMethod    "\<\%(if\|module\|refine\|undef\|unless\|until\|while\)[?!]"  transparent contains=NONE

syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(abort\|at_exit\|attr\|attr_accessor\|attr_reader\)\>"                         transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(attr_writer\|autoload\|callcc\|catch\|caller\)\>" 			      transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(eval\|class_eval\|instance_eval\|module_eval\|exit\)\>"                       transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(extend\|fail\|fork\|include\|lambda\)\>"                                      transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(load\|loop\|prepend\|private\|proc\|protected\)\>"                            transparent contains=NONE
syn match  rubyKeywordAsMethod    "\%(\%(\.\@<!\.\)\|::\)\_s*\%(public\|require\|require_relative\|raise\|throw\|trap\|using\)\>"             transparent contains=NONE

syn match  rubySymbol             "\%([{(,]\_s*\)\@<=\l\w*[!?]\=::\@!"he=e-1
syn match  rubySymbol             "[]})\"':]\@<!\%(\h\|[^\x00-x7F]\)\%(\w\[^\x00-\x7F]\)*[!?]\=:[[:space:],]\@="he=e-1
syn match  rubySymbol             "\%([{(,]\_s*\)\@<=[[:space:],{]\l\w*[!?]\=::\@!"hs=s+1,he=e-1
syn match  rubySymbol             "[[:space:],{(]\%(\h\[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*[!?]\=:[[:space:],]\@="hs=s+1,he=e-1

" __END__ Directive
syn region rubyData   matchgroup=rubyDataDirective  start="^__END__$" end="\%$"   fold


hi default link rubyClass                   rubyDefine
hi default link rubyModule                  rubyDefine
hi default link rubyMethodExceptional       rubyDefine
hi default link rubyDefine                  Define
hi default link rubyFunction                Function
hi default link rubyConditional             Conditional
hi default link rubyConditionalModifier     rubyConditional
hi default link rubyExceptional             rubyConditional
hi default link rubyRepeat                  Repeat
hi default link rubyRepeatModifier          rubyRepeat
hi default link rubyOptionalDo              rubyRepeat
hi default link rubyControl                 Statement
hi default link rubyInclude                 Include
hi default link rubyInteger                 Number
hi default link rubyASCIICode               Character
hi default link rubyFloat                   Float
hi default link rubyBoolean                 Boolean
hi default link rubyException               Exception
if !exists('ruby_no_identifiers')
  hi default link rubyIdentifier            Identifier
else
  hi default link rubyIdentifier            NONE
endif
hi default link rubyClassVariable           rubyIdentifier
hi default link rubyConstant                Type
hi default link rubyGlobalVariable          rubyIdentifier
hi default link rubyBlockParameter          rubyIdentifier
hi default link rubyInstanceVariable        rubyIdentifier
hi default link rubyPredefinedIdentifier    rubyIdentifier
hi default link rubyPredefinedConstant      rubyPredefinedIdentifier
hi default link rubyPredefinedVariable      rubyPredefinedIdentifier
hi default link rubySymbol                  Constant
hi default link rubyKeyword                 Keyword
hi default link rubyOperator                Operator
hi default link rubyBeginEnd                Statement
hi default link rubyAccess                  Statement
hi default link rubyAttribute               Statement
hi default link rubyEval                    Statement
hi default link rubyPseudoVariable          Constant
hi default link rubyCapitalizedMethod       rubyLocalVariableOrMethod

hi default link rubyComment                 Comment
hi default link rubyData                    Comment
hi default link rubyDataDirective           Delimiter
hi default link rubyDocumentation           Comment
hi default link rubyTodo                    Todo

hi default link rubyQuoteEscape             rubyStringEscape
hi default link rubyStringEscape            Special
hi default link rubyInterpolationDelimiter  Delimiter
hi default link rubyNoInterpolation         rubyString
hi default link rubySharpBang               PreProc
hi default link rubyRegexpDelimiter         rubyStringDelimiter
hi default link rubySymbolDelimiter         rubySymbol
hi default link rubyStringDelimiter         Delimiter
hi default link rubyHeredoc                 rubyString
hi default link rubyString                  String
hi default link rubyRegexpEscape            rubyRegexpSpecial
hi default link rubyRegexpQuantifier        rubyRegexpSpecial
hi default link rubyRegexpAnchor            rubyRegexpSpecial
hi default link rubyRegexpDot               rubyRegexpCharClass
hi default link rubyRegexpCharClass         rubyRegexpSpecial
hi default link rubyRegexpSpecial           Special
hi default link rubyRegexpComment           Comment
hi default link rubyRegexp                  rubyString

hi default link rubyInvalidVariable         Error
hi default link rubyError                   Error
hi default link rubySpaceError              rubyError


let b:current_syntax = "ruby"
