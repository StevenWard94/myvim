" vim: set tw=120 fo=cr1jb wm=0 sw=4 ts=4 sts=4 foldenable foldlevel=0 foldmarker=\\begin,\\end foldmethod=marker:
"-----------------------------------------------------------------------------------------------------------------------
"
" Vim completion script
" Language:             Ruby
" Maintainer:           [upstream] Mark Guzman <segfault@hasno.info> | [fork] Steven Ward <stevenward94@gmail.com>
" URL:                  [upstream] https://github.com/vim-ruby/vim-ruby
" Release Coordinator:  [upstream] Doug Kearns <dougkearns@gmail.com>
" Maintainer Version:   [at fork]  0.8.1
"-----------------------------------------------------------------------------------------------------------------------
"
" Ruby IRB/Complete author: Keiju Ishitsuka <keiju@ishitsuka.com>
"-----------------------------------------------------------------------------------------------------------------------

" \begin requirement checks

function! s:ErrMsg(msg)
    echohl ErrorMsg
    echo a:msg
    echohl None
endfunction

if !has('ruby')
    call s:ErrMsg( "Error: RubyComplete [rubycomplete.vim] requires vim compiled with '+ruby'" )
    call s:ErrMsg( "RubyComplete: falling back to syntax completion" )
    " now we fall back to syntax completion, as was prophesized above
    setlocal omnifunc=syntaxcomplete#Complete
    finish
endif

if version < 700
    call s:ErrMsg( "Error: RubyComplete [rubycomplete.vim] requires vim >= 7.0" )
    call s:ErrMsg( "RubyComplete: please update vim to use this plugin" )
    finish
endif
" \end requirement checks

" \begin configuration failsafe initialization
if !exists('g:rubycomplete_rails')
    let g:rubycomplete_rails = 0
endif

if !exists('g:rubycomplete_classes_in_global')
    let g:rubycomplete_classes_in_global = 0
endif

if !exists('g:rubycomplete_buffer_loading')
    let g:rubycomplete_buffer_loading = 0
endif

if !exists('g:rubycomplete_include_object')
    let g:rubycomplete_include_object = 0
endif

if !exists('g:rubycomplete_include_objectspace')
    let g:rubycomplete_include_objectspace = 0
endif
" \end configuration failsafe initialization

" \begin vim-side support functions
let s:rubycomplete_debug = 0

function! s:dprint(msg)
    if s:rubycomplete_debug == 1
        echom a:msg
    endif
endfunction

function! s:GetBufferRubyModule( name, ... )
    if a:0 == 1
        let [snum,enum] = s:GetBufferRubyEntity( a:name, "module", a:1 )
    else
        let [snum,enum] = s:GetBufferRubyEntity( a:name, "module" )
    endif
    return snum . '..' . enum
endfunction

function! s:GetBufferRubyClass( name, ... )
    if a:0 >= 1
        let [snum,enum] = s:GetBufferRubyEntity( a:name, "class", a:1 )
    else
        let [snum,enum] = s:GetBufferRubyEntity( a:name, "class" )
    endif
    return snum . '..' . enum
endfunction

function! s:GetBufferRubySingletonMethods(name)
endfunction

function! s:GetBufferRubyEntity( name, type, ... )
    let lastpos = getpos('.')
    let lastline = lastpos
    if a:0 >= 1
        let lastline = [ 0, a:1, 0, 0 ]
        call cursor( a:1, 0 )
    endif

    let stopline = 1
    let crex = '^\s*\<' . a:type . '\>\s*\<' . escape( a:name, '*' ) . '\>\s*\(<\s*.*\s*\)\?'
    let [lnum,lcol] = searchpos( crex, 'w' )
    "let [lnum,lcol] = searchpairpos( crex . '\zs', '', '\(end\|}\)', 'w' )

    if lnum == 0 && lcol == 0
        call cursor( lastpos[1], lastpos[2] )
        return [0,0]
    endif

    let curpos = getpos('.')
    let [enum,ecol] = searchpairpos( crex, '', '\(end\|}\)', 'wr' )
    call cursor( lastpos[1], lastpos[2] )

    if lnum > enum
        return [0,0]
    endif
    " or, if we actually found the class definition...
    return [lnum,enum]
endfunction

function! s:IsInClassDef( )
    return s:IsPosInClassDef( line('.') )
endfunction

function! s:IsPosInClassDef(pos)
    let [snum,enum] = s:GetBufferRubyEntity( '.*', "class" )
    let ret = 'nil'

    if snum < a:pos && a:pos < enum
        let ret = snum . '..' . enum
    endif
    return ret
endfunction

function! s:GetRubyVarType(v)
    let stopline = 1
    let vtp = ''
    let pos = getpos('.')
    let sstr = '^\s*#\s*@var\s*' . escape( a:v, '*' ) . '\>\s\+[^ \t]\+\s*$'
    let [lnum,lcol] = searchpos( sstr, 'nb', stopline )

    if lnum != 0 && lcol != 0
        call setpos('.',pos)
        let str = getline(lnum)
        let vtp = substitute( str, sstr, '\1', '' )
        return vtp
    endif

    call setpos('.',pos)
    let ctors = '\(now\|new\|open\|get_instance'
    if exists('g:rubycomplete_rails') && g:rubycomplete_rails == 1 && s:rubycomplete_rails_loaded == 1
        let ctors = ctors . '\|find\|create'
    else
    endif
    let ctors = ctors . '\)'

    let fstr = '=\s*\([^ \t]\+.' . ctors . '\>\|[\[{"''/]\|%[xwQqr][(\[{@]\|[A-Za-z0-9@:\-()\.]\+...\?\|lambda\|&\)'
    let sstr = '' . escape( a:v, '*' ) . '\>\s*[+\-*/]*' . fstr
    let [lnum,lcol] = searchpos( sstr, 'nb', stopline )

    if lnum != 0 && lcol != 0
        let str = matchstr( getline(lnum), fstr, lcol )
        let str = substitute( str, '^=\s*', '', '' )

        call setpos('.',pos)
        if str == '"' || str == '''' || stridx(tolower(str), '%q[') != -1
            return 'String'
        elseif str == '[' || stridx(str, '%w[') != -1
            return 'Array'
        elseif str == '{'
            return 'Hash'
        elseif str == '/' || str == '%r{'
            return 'Regexp'
        elseif strlen(str) >= 4 && stridx(str, '..') != 1
            return 'Range'
        elseif stridx(str, 'lambda') != -1 || str == '&'
            return 'Proc'
        elseif strlen(str) > 4
            let l = stridx(str, '.')
            return str[0:l-1]
        end
        return ''
    endif
    call setpos('.',pos)
    return ''
endfunction
" \end vim-side support functions

" \begin vim-side completion functions
function! rubycomplete#Init()
    execute "ruby VimRubyCompletion.preload_rails"
endfunction

function! rubycomplete#Complete( findstart, base )
    "findstart == 1 when we need to get the text length
    if a:findstart
        let line = getline('.')
        let idx = col('.')
        while idx > 0
            let idx -= 1
            let c = line[idx - 1]
            if c =~ '\w'
                continue
            elseif ! c =~ '\.'
                idx = -1
                break
            else
                break
            endif
        endwhile
        return idx
    "findstart == 0 when we need to return the completions list
    else
        let g:rubycomplete_completions = [ ]
        execute "ruby VimRubyCompletion.get_completions('" . a:base . "')"
        return g:rubycomplete_completions
    endif
endfunction
" \end vim-side completion functions
