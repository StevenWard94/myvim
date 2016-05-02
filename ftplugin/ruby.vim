" vim: nowrap:fo=c1jb:sw=2:sts=2:ts=8:
" ----------------------------------------------------------------------------------------------------------------------
"
" Vim filetype plugin
" Language:             Ruby
" Maintainer:           Tim Pope <vimNOSPAM@tpope.org>
" URL:                  https://github.com/vim-ruby/vim-ruby
" Release Coordinator:  Doug Kearns <dougkearns@gmail.com>
" ----------------------------------------------------------------------------------------------------------------------

if exists( 'b:did_ftplugin' )
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

if has( 'gui_running' ) && !has( 'gui_win32' )
  setlocal keywordprg=ri\ -T\ -f\ bs
else
  setlocal keywordprg=ri
endif

" Support for Matchit plugin
if exists( 'loaded_matchit' ) && !exists( 'b:match_words' )
  let b:match_ignorecase = 0

  let b:match_words =
        \ '\<\%(if\|unless\|case\|while\|until\|for\|do\|class\|module\|def\|begin\)\>=\@!' .
        \ ':' .
        \ '\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
        \ ':' .
        \ '\%(^\|[^.\:@$]\)\@<=\<end\:\@!\>' .
        \ ',{:},\[:\],(:)'

  let b:match_skip =
        \ "synIDattr(synID(line('.'),col('.'),0),'name') =~ '" .
        \ "\\<ruby\\%(String\\|StringDelimiter\\|ASCIICode\\|Escape\\|" .
        \ "Regexp\\|RegexpDelimiter\\|" .
        \ "Interpolation\\|NoInterpolation\\|Comment\\|Documentation\\|" .
        \ "ConditionalModifier\\|RepeatModifier\\|OptionalDo\\|" .
        \ "Function\\|BlockArgument\\|KeywordAsMethod\\|ClassVariable\\|" .
        \ "InstanceVariable\\|GlobalVariable\\|Symbol\\)\\>'"
endif

setlocal formatoptions-=t formatoptions+=crql

setlocal include=^\\s*\\<\\(load\\>\\\|require\\>\\\|autoload\\s*:\\=[\"']\\=\\h\\w*[\"']\\=,\\)
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'\%(\.rb\)\=$','.rb','')
setlocal suffixesadd=.rb

if exists( '&ofu' ) && has( 'ruby' )
  setlocal omnifunc=rubycomplete#Complete
endif

" activate with ':set ballooneval'
if has( 'balloon_eval' ) && exists( '+balloonexpr' )
  setlocal balloonexpr=RubyBalloonexpr()
endif


" TODO:
"setlocal define=^\\s*def

setlocal comments=:#
setlocal commentstring=#\ %s

if !exists( 'g:ruby_version_paths' )
  let g:ruby_version_paths = {}
endif

function! s:query_path( root ) abort
  let code = "print $:.join %q{,}"

  if &shell =~# 'sh'
    let prefix = 'env PATH=' . shellescape($PATH) . ' '
  else
    let prefix = ''
  endif

  if &shellxquote == "'"
    let path_check = prefix . 'ruby -e "' . code . '"'
  else
    let path_check = prefix . "ruby -e '" . code . "'"
  endif

  let cd = haslocaldir( ) ? 'lcd' : 'cd'
  let cwd = getcwd( )

  try
    execute cd fnameescape( a:root )
    let path = split( system( path_check ), ',' )
    execute cd fnameescape( cwd )
    return path
  finally
    execute cd fnameescape( cwd )
  endtry
endfunction


function! s:build_path( path ) abort
  let path = join( map( copy( a:path ), 'v:val ==# "." ? "" : v:val' ), ',' )

  if &g:path !~# '\v^\.%(,/%(usr|emx)/include)=,,$'
    let path = substitute( &g:path, ',,$', ',', '' ) . ',' . path
  endif
  return path
endfunction


if !exists( 'b:ruby_version' ) && !exists( 'g:ruby_path' ) && isdirectory( expand("%:p:h") )
  let s:version_file = findfile( '.ruby-version', '.;' )
  if !empty( s:version_file ) && filereadable( s:version_file )
    let b:ruby_version = get( readfile( s:version_file, '', 1 ), '' )
    if !has_key( g:ruby_version_paths, b:ruby_version )
      let g:ruby_version_paths[b:ruby_version] = s:query_path( fnamemodify( s:version_file, ':p:h' ) )
    endif
  endif
endif

if exists( 'g:ruby_path' )
  let s:ruby_path = type( g:ruby_path ) == type([]) ? join( g:ruby_path, ',' ) : g:ruby_path
elseif has_key( g:ruby_version_paths, get( b:, 'ruby_version', '' ) )
  let s:ruby_paths = g:ruby_version_paths[b:ruby_version]
  let s:ruby_path = s:build_path( s:ruby_paths )
else
  if !exists( 'g:ruby_default_path' )
    if has( 'ruby' ) && has( 'win32' )
      ruby ::VIM::command( 'let g:ruby_default_path = split("%s",",")' % $:.join(%q{,}) )
    elseif executable( 'ruby' )
      let g:ruby_default_path = s:query_path( $HOME )
    else
      let g:ruby_default_path = map( split( $RUBYLIB, ':' ), 'v:val ==# "." ? "" : v:val' )
    endif
  endif
  let s:ruby_paths = g:ruby_default_path
  let s:ruby_path = s:build_path( s:ruby_paths )
endif

if stridx( &l:path, s:ruby_path ) == -1
  let &l:path = s:ruby_path
endif
if exists( 's:ruby_paths' ) && stridx( &l:tags, join( map( copy( s:ruby_paths ), 'v:val."/tags"' ), ',' ) ) == -1
  let &l:tags = &tags . ',' . join( map( copy(s:ruby_paths), 'v:val."/tags"' ), ',' )
endif

if (has( 'gui_win32' ) || has( 'gui_gtk' )) && !exists( 'b:browsefilter' )
  let b:browsefilter = "Ruby Source Files (*.rb)\t*.rb\n" . "All Files (*.*)\t*.*\n"
endif

let b:undo_ftplugin = "setl fo< inc< inex< sua< def< com< cms< path< tags< kp<"
      \."| unlet! b:browsefilter b:match_ignorecase b:match_words b:match_skip"
      \."| if exists('&omnifunc') && has('ruby') | setl omnifunc< | endif"
      \."| if has('balloon_eval') && exists('+bexpr') | setl balloonexpr< | endif"


function! s:map( mode, flags, map ) abort
  let from = matchstr( a:map, '\S\+' )
  if empty( mapcheck( from, a:mode ) )
    execute a:mode . 'map' '<buffer>' . (a:0 ? a:1 : '') a:map
    let b:undo_ftplugin .= '|silent! ' . a:mode . 'unmap <buffer> ' . from
  endif
endfunction


cmap <buffer><script><expr> <Plug><cword> substitute(RubyCursorIdentifier(),'^$',"\022\027",'')
cmap <buffer><script><expr> <Plug><cfile> substitute(RubyCursorFile(),'^$',"\022\006",'')
let b:undo_ftplugin .= "| silent! cunmap <buffer> <Plug><cword>| silent! cunmap <buffer> <Plug><cfile>"

if !exists('g:no_plugin_maps') && !exists('g:no_ruby_maps')
  nmap <buffer><script> <SID>:  :<C-U>
  nmap <buffer><script> <SID>c: :<C-U><C-R>=v:count ? v:count : ''<CR>

  nnoremap <silent> <buffer> [m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','b','n')<CR>
  nnoremap <silent> <buffer> ]m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','','n')<CR>
  nnoremap <silent> <buffer> [M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','b','n')<CR>
  nnoremap <silent> <buffer> ]M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','','n')<CR>
  xnoremap <silent> <buffer> [m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','b','v')<CR>
  xnoremap <silent> <buffer> ]m :<C-U>call <SID>searchsyn('\<def\>','rubyDefine','','v')<CR>
  xnoremap <silent> <buffer> [M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','b','v')<CR>
  xnoremap <silent> <buffer> ]M :<C-U>call <SID>searchsyn('\<end\>','rubyDefine','','v')<CR>

  nnoremap <silent> <buffer> [[ :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','b','n')<CR>
  nnoremap <silent> <buffer> ]] :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','','n')<CR>
  nnoremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','b','n')<CR>
  nnoremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','','n')<CR>
  xnoremap <silent> <buffer> [[ :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','b','v')<CR>
  xnoremap <silent> <buffer> ]] :<C-U>call <SID>searchsyn('\<\%(class\<Bar>module\)\>','rubyModule\<Bar>rubyClass','','v')<CR>
  xnoremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','b','v')<CR>
  xnoremap <silent> <buffer> [] :<C-U>call <SID>searchsyn('\<end\>','rubyModule\<Bar>rubyClass','','v')<CR>

  let b:undo_ftplugin = b:undo_ftplugin
        \."| silent! execute 'unmap <buffer> [[' | silent! execute 'unmap <buffer> ]]' | silent! execute 'unmap <buffer> []' | silent! execute 'unmap <buffer> ]['"
        \."| silent! execute 'unmap <buffer> [m' | silent! execute 'unmap <buffer> ]m' | silent! execute 'unmap <buffer> [M' | silent! execute 'unmap <buffer> ]M'"

  if maparg('im', 'n') == ''
    onoremap <silent> <buffer>