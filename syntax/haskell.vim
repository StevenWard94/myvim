" vim: nowrap:tw=120:fo=cr1jb:expandtab:sw=2:sts=2:ts=8:nolist:foldmarker=\\begin,\\end:fdm=marker:fdl=0:
" ---------------------------------------------------------------------------------------------
"
" Vim syntax file \begin1
"
" Modification of Vim's Haskell syntax file:
"   - match types using regexp
"   - highlight top-level functions
"   - use "syntax keyword" instead of "syntax match" where appropriate
"   - functions and types in import and module declarations are matched
"   - removed hs_highlight_more_types (just not needed anymore)
"   - enable spell-checking in ONLY comments and strings
"   - FFI highlighting
"   - QuasiQuotation
"   - top-level template Haskell slices
"   - PackageImport
"
" TODO: find out which versions of vim are still supported
"
" From Original File:
" ===================
"
" Language:             Haskell
" Past Maintainer:      Haskell Cafe mailinglist <haskell-cafe@haskell.org> | until 2010 Feb 21
" Fork Maintainer:      Steven Ward <stevenward94@gmail.com>
" Last Change:          2016 May 20
" Original Author:      John Williams <jrw@pobox.com>
"
" Thanks to Ryan Crumley for suggestions and John Meacham for
" pointing out bugs. Also thanks to Ian Lynaugh and Donald Bruce Stewart
" for providing the inspiration for the inclusion of the handling
" of C preprocessor directives, and for pointing out a bug in the
" end-of-line comment handling.
"
" Options - assign a value to these variables to turn the option on:
"
" hs_highlight_delimiters - Highlight delimiter characters -- users
"                           with a light-colored background will
"                           probably want to turn this on.
"
" hs_highlight_boolean    - Treat 'True' and 'False' as keywords.
" hs_highlight_types      - Treat names of primitive types as keywords.
" hs_highlight_debug      - Highlight names of debugging functions.
" hs_allow_hash_operator  - Don't highlight seemingly incorrect C
"                           preprocessor directives but assume them to
"                           be operators
"
" \end1
" ---------------------------------------------------------------------------------------------

if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

"syntax sync fromstart    "mmhhh.... is this really ok?
syntax sync linebreaks=15 minlines=50 maxlines=500

syn match  hsSpecialChar        contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match  hsSpecialChar        contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match  hsSpecialCharError   contained "\\&\|'''\+"
syn region hsString             start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=hsSpecialChar,@Spell
syn match  hsCharacter          "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1  contains=hsSpecialChar,hsSpecialCharError
syn match  hsCharacter          "^'\([^\\]\|\\[^']\+\|\\'\)'"  contains=hsSpecialChar,hsSpecialCharError

" (Qualified) identifiers \begin1 (no default highlighting)
syn match  ConId  "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[A-Z][a-zA-Z0-9_']*\>"
syn match  VarId  "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[a-z][a-zA-Z0-9_']*\>"

" Infix operators \begin1 -- most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match hsVarSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match hsConSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match hsVarSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match hsConSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"

" Top-Level Template Haskell support \begin1
syn match hsTHIDTopLevel    "^[a-z]\S*"
syn match hsTHTopLevel      "^\$(\?"    nextgroup=hsTHTopLevelName
syn match hsTHTopLevelName  "[a-z]\S*"  contained

" Reserved symbols \begin1 -- cannot be overloaded
syn match   hsDelimiter   "(\|)\|\[\|\]\|,\|;\|_\|{\|}"

syn region  hsInnerParen  start="(" end=")" contained contains=hsInnerParen,hsConSym,hsType,hsVarSym
syn region  hs_InfixOpFunctionName  start="^(" end=")\s*[^:`]\(\W\&\S\&[^'\"`()[\]{}@]\)\+"re=s
      \ contained keepend contains=hsInnerParen,hs_HlInfixOp

syn match   hs_hlFunctionName   "[a-z_]\(\S\&[^,\(\)\[\]]\)*"   contained
syn match   hs_FunctionName     "^[a-z_]\(\S\&[^,\(\)\[\]]\)*"  contained contains=hs_hlFunctionName
syn match   hs_HighliteInfixFunctionName  "`[a-z_][^`]*`"       contained
syn match   hs_InfixFunctionName  "^\S[^=]*`[a-z_][^`]*`"me=e-1 contained contains=hs_HighliteInfixFunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter
syn match   hs_HlInfixOp          "\(\W\&\S\&[^`(){}'[\]]\)\+"  contained contains=hsString
syn match   hs_InfixOpFunctionName  "^\(\(\w\|[[\]{}]\)\+\|\(\".*\"\)\|\('.*'\)\)\s*[^:]=*\(\W\&\S\&[^='\"`()[\]{}@]\)\+"
      \ contained contains=hs_HlInfixOp,hsCharacter

syn match   hs_OpFunctionName   "(\(\W\&[^(),\"]\)\+)"  contained
"syn region hs_Function   start="^["'a-z_([{]"  end="=\(\s\|\n\|\w\|[([]\)"   keepend extend
syn region  hs_Function   start="^["'a-zA-Z_([{]\(\(.\&[^=]\)\|\(\n\s\)\)*="  end="\(\s\|\n\|\w\|[([]\)"
      \ contains=hs_OpFunctionName,hs_InfixOpFunctionName,hs_InfixFunctionName,hs_FunctionName,hsType,hsConSym,hsVarSym,hsString,hsCharacter

syn match   hs_DeclareFunction  "^[a-z_(]\S*\(\s\|\n\)*::"  contains=hs_FunctionName,hs_OpFunctionName

" hi hs_InfixOpFunctionName   guibg=bg
" hi hs_Function              guibg=green
" hi hs_InfixFunctionName     guibg=red
" hi hs_DeclareFunction       guibg=red

syn keyword hsStructure data family class where instance default deriving
syn keyword hsTypedef   type newtype

syn keyword hsInfix     infix infixl infixr
syn keyword hsStatement do case of let in
syn keyword hsConditional if then else

"if exists('hs_highlight_types')
  " Primitive types from the standard prelude and libraries
  syn match hsType  "\<[A-Z]\(\S\&[^,.]\)*\>"
  syn match hsType  "()"
"endif

" Not real keywords, but close
if exists('hs_highlight_boolean') && hs_highlight_boolean != 0
  " Boolean constants from the standard prelude
  syn keyword hsBoolean True False
endif

syn region hsPackageString  start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl  end=+"+ end='$' contains=cSpecial contained
syn match  hsModuleName     excludenl "\([A-Z]\w*\.\?\)*" contained

syn match   hsImport        "\<import\>\s\+\(qualified\s\+\)\?\(\<\(\w\|\.\)*\>\)"  contains=hsModuleName,hsImportLabel nextgroup=hsImportParams,hsImportIllegal skipwhite
syn keyword hsImportLabel   import qualified  contained

syn match   hsImportIllegal "\w\+"  contained

syn keyword hsAsLabel       as      contained
syn keyword hsHidingLabel   hiding  contained

syn match   hsImportParams  "as\s\+\(\w\+\)"  contained contains=hsModuleName,hsAsLabel nextgroup=hsImportParams,hsImportIllegal  skipwhite
syn match   hsImportParams  "hiding"          contained contains=hsHidingLabel nextgroup=hsImportParams,hsImportIllegal  skipwhite
syn region  hsImportParams  start="(" end=")" contained contains=hsBlockComment,hsLineComment,hsType,hsDelimTypeExport,hs_hlFunctionName,hs_OpFunctionName nextgroup=hsImportIllegal  skipwhite

"hi hsImport          guibg=red
"hi hsImportParams    guibg=bg
"hi hsImportIllegal   guibg=bg
"hi hsModuleName      guibg=bg


" New module highlighting \begin1
syn region  hsDelimTypeExport   start="\<[A-Z]\(\S\&[^,.]\)*\>("  end=")"   contained contains=hsType

syn keyword hsExportModuleLabel module  contained
syn match   hsExportModule      "\<module\>\(\s\|\t\|\n\)*\([A-Z]\w*\.\?\)*"  contained contains=hsExportModuleLabel,hsModuleName

syn keyword hsModuleStartLabel  module  contained
syn keyword hsModuleWhereLabel  where  contained

syn match   hsModuleStart       "^module\(\s\|\n\)*\(\<\(\w\|\.\)*\>\)\(\s\|\n\)*"  contains=hsModuleStartLabel,hsModuleName  nextgroup=hsModuleCommentA,hsModuleExports,hsModuleWhereLabel

syn region  hsModuleCommentA    start="{-"  end="-}"  contains=hsModuleCommentA,hsCommentTodo,@Spell contained  nextgroup=hsModuleCommentA,hsModuleExports,hsModuleWhereLabel   skipwhite skipnl
syn match   hsModuleCommentA    "--.*\n"  contains=hsCommentTodo,@Spell contained   nextgroup=hsModuleCommentA,hsModuleExports,hsModuleWhereLabel   skipwhite skipnl

syn region  hsModuleExports     start="(" end=")" contained
      \ nextgroup=hsModuleCommentB,hsModuleWhereLabel   skipwhite skipnl
      \ contains=hsBlockComment,hsLineComment,hsType,hsDelimTypeExport,hs_hlFunctionName,hs_OpFunctionName,hsExportModule

syn match   hsModuleCommentB    "--.*\n"  contains=hsCommentTodo,@Spell contained nextgroup=hsModuleCommentB,hsModuleWhereLabel   skipwhite skipnl
syn region  hsModuleCommentB    start="{-" end="-}"   contains=hsModuleCommentB,hsCommentTodo,@Spell contained nextgroup=hsModuleCommentB,hsModuleWhereLabel  skipwhite skipnl
" \end1 module highlighting

" FFI Support \begin1
syn keyword hsFFIForeign        foreign         contained
syn keyword hsFFIImportExport   export          contained
syn keyword hsFFICallConvention ccall stdcall   contained
syn keyword hsFFISafety         safe unsafe     contained

syn region  hsFFIString       start=+"+  skip=+\\\\\|\\"+  end=+"+    contained contains=hsSpecialChar
syn match   hsFFI excludenl   "\<foreign\>\(.\&[^\"]\)*\"\(.\)*\"\(.\)*\"\(\s\|\n\)*\(.\)*::"
      \ keepend   contains=hsFFIForeign,hsFFIImportExport,hsFFICallConvention,hsFFISafety,hsFFIString,hs_OpFunctionName,hs_hlFunctionName
" \end1

syn match   hsNumber            "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>"
syn match   hsFloat             "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"

" Comments \begin1
syn keyword hsCommentTodo       TODO FIXME XXX TBD  contained
