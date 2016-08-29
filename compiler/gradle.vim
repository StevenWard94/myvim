" vim: tw=120:fo=cr1jb:et:sw=4:sts=4:nofoldenable:
" --------------------------------------------------------------------------------------
"
" Vim Compiler File
" Language:           Java
" Compiler:           gradle
" Original Author:    Niklas Lindström <http://neverspace.net>
" Last Change:        2012 Sep 24
" --------------------------------------------------------------------------------------

if exists("current_compiler")
  finish
endif
let current_compiler = "gradle"

if exists(":CompilerSet") != 2    " older Vim always used ':setlocal'
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=gradle

CompilerSet errorformat=
    \%-G:%.%\\+,
    \%E%f:\ %\\d%\\+:\ %m\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
    \%E%>%f:\ %\\d%\\+:\ %m,%C\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
    \%-G\\s%#,
    \%-GBUILD\ SUCCESSFUL#,
    \%-GTotal\ \time:\ %.%#
