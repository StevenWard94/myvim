" vim: tw=120:fo=cr1jb:et:sw=4:sts=4:nofoldenable:
" --------------------------------------------------------------------------------------
"
" Vim Compiler File
" Language:           Java
" Compiler:           maven3
" Original Author:    Niklas Lindström <http://neverspace.net>
" Last Change:        2012 Sep 24
" --------------------------------------------------------------------------------------

if exists("current_compiler")
  finish
endif
let current_compiler = "maven3"

if exists(":CompilerSet") != 2    " compatibility with older versions of Vim
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=mvn

CompilerSet errorformat=
    \%-G[%\\(ERROR]%\\)%\\@!%.%#,
    \%A%[%^[]%\\@=%f:[%l\\,%v]\ %m,
    \%W[ERROR]\ %f:[%l\\,%v]\ %m,
    \%-Z\ %#,
    \%-Clocation\ %#:%.%#,
    \%C%[%^:]%#%m,
    \%-G%.%#]]
