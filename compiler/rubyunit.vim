" vim: fo=cr1jb:nowrap:sw=2:sts=2:ts=8:
" ----------------------------------------------------------------------------------------------------------------------
" Vim compiler file
" Language:             Test::Unit - Ruby Unit Testing Framework
" Maintainer:           Tim Pope <vimNOSPAM@tpope.org>
" URL:                  https://github.com/vim-ruby/vim-ruby
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------------------------------------------------

if exists( 'current_compiler' )
  finish
endif
let current_compiler = 'rubyunit'

if exists( ':CompilerSet' ) != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=testrb
" CompilerSet makeprg=ruby\ -Itest
" CompilerSet makeprg=m

CompilerSet errorformat=
      \%W\ %\\+%\\d%\\+)\ Failure:,
      \%C%m\ [%f:%l]:,
      \%E\ %\\+%\\d%\\+)\ Error:,
      \%C%m:,
      \%C\ \ \ \ \ %f:%l:%.%#,
      \%C%m,
      \%Z\ %#,
      \%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
