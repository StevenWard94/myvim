""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Compiler File
" Compiler:     GHC
" Maintainer:   Claus Reinke <claus.reinke@talk21.com>
" Last Change:  2011 Jan 22
"
" part of haskell plugins: http://projects.haskell.org/haskellmode-vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"
" ------------------------------ paths & quickfix settings first
"

if exists('current_compiler') && current_compiler == "ghc"
  finish
endif
let current_compiler = "ghc"

let s:scriptname = 'ghc.vim'

if !haskellmode#GHC()
  finish
endif

if !exists('b:ghc_staticoptions")
  let b:ghc_staticoptions = ''
endif

" set makeprg (for quickfix mode)
execute 'setlocal makeprg=' . g:ghc . '\ ' . escape(b:ghc_staticoptions,' ') . '\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc . '\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc . '\ --make\ %'

" quickfix mode:
" fetch file/line-info from error message
" TODO: how to distinguish multiline errors from warnings?
"       (both have the same header and errors have no common id-tag)
"       how to remove first empty message in results list?
setlocal errorformat=
                    \%-Z\ %#,
                    \%W%f:%l:%c:\ Warning:\ %m,
                    \%E%f:%l:%c:\ %m,
                    \%E%>%f:%l:%c:,
                    \%+C\ \ %#%m,
                    \%W%>%f:%l:%c:,
                    \%+C\ \ %#%tarning:\ %m,

" ghc already reports (partially) to stderr...
setlocal shellpipe=2>

"
" ------------------------------ but ghc can do a lot more for us...
"

" allow override of map leader
if !exists('maplocalleader')
  let maplocalleader = '_'
endif

" initialize map of identifiers to their respective types
" associative map updates to 'changedtick'
if !exists('b:ghc_types')
  let b:ghc_types = {}
  let b:my_changedtick = b:changedtick
endif

if exists('g:haskell_functions')
  finish
endif
let g:haskell_functions = "ghc"

" avoid hit enter prompts
set cmdheight=3


" edit static GHC options
" TODO: add completion for options/packages?
command! GHCStaticOptions call GHC_StaticOptions()
function! GHC_StaticOptions()
  let b:ghc_staticoptions = input('GHC static options: ', b:ghc_staticoptions)
  execute 'setlocal makeprg=' . g:ghc . '\ ' . escape(b:ghc_staticoptions,' ') . '\ -e\ :q\ %'
  let b:my_changedtick -= 1
endfunction


map <LocalLeader>T :call GHC_ShowType(1)<CR>
map <LocalLeader>t :call GHC_ShowType(0)<CR>
function! GHC_ShowType(addTypeDecl)
  let namsym = haskellmode#GetNameSymbol(getline('.'),col('.'),0)
  if namsym == []
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name  = (qual == '') ? unqual : qual.'.'.unqual
  let pname = ( symb ? '('.name.')' : name )
  let ok    = GHC_HaveTypes()
  if !has_key(b:ghc_types, name)
    redraw   " the redraw command happens to hide messages from GHC_HaveTypes
    if &modified
      let comment = " (buffer has unsaved changes)"
    elseif !ok
      let comment = " (try ':make' to see any GHCi errors)"
    else
      let comment = ""
    endif
    echo pname "unknown type".comment
  else
    redraw
    for type in split(b:ghc_types[name], ' -- ')
      echo pname "::" type
      if a:addTypeDecl
        call append( line('.')-1, pname . " :: " . type )
      endif
    endfor
  endif
endfunction


" show type of identifier under cursor in balloon
" TODO: it isn't a good idea to tie potentially time-consuming tasks
"       (e.g. querying GHCi for the types) to cursor movements (#14).
"       Currently, we ask the user to call :GHCReload explicitly.
"       Should there be an option to reenable the old implicit querying?
if has('balloon_eval')
  set ballooneval
  set balloondelay=600
  set balloonexpr=GHC_TypeBalloon()
  function! GHC_TypeBalloon()
    if exists('b:current_compiler') && b:current_compiler == "ghc"
      let [line] = getbufline(v:beval_bufnr, v:beval_lnum)
      let namsym = haskellmode#GetNameSymbol(line, v:beval_col, 0)
      if namsym == []
        return ''
      endif
      let [start,symb,qual,unqual] = namsym
      let name  = (qual == '') ? unqual : qual.'.'.unqual
      let pname = name " ( symb ? '('.name.')' : name )
      if b:ghc_types == {}
        redraw
        echo "no type information (try :GHCReload)"
      elseif (b:my_changedtick != b:changedtick)
        redraw
        echo "type information may be out of date (try :GHCReload)"
      endif
      " silent call GHC_HaveTypes()
      if b:ghc_types != {}
        if has('balloon_multiline')
          return ( has_key(b:ghc_types,pname) ? split(b:ghc_types[pname], ' -- ') : '' )
        else
          return ( has_key(b:ghc_types,pname) ? b:ghc_types[pname] : '' )
        endif
      else
        return ''
      endif
    else
      return ''
    endif
  endfunction
endif


map <LocalLeader>si :call GHC_ShowInfo()<CR>
function! GHC_ShowInfo()
  let namsym = haskellmode#GetNameSymbol(getline('.'), col('.'), 0)
  if namsym == []
    redraw
    echo 'no name/symbol under cursor!'
    return 0
  endif
  let [_,symb,qual,unqual] = namsym
  let name = (qual == '') ? unqual : qual.'.'.unqual
  let output = GHC_Info(name)
  pclose | new
  setlocal previewwindow
  setlocal buftype=nofile
  setlocal noswapfile
  put =output
  wincmd w
  "redraw
  "echo output
endfunction


" fill/update the type map unless no changes have been made since last attempt
function! GHC_HaveTypes()
  if b:ghc_types == {} && (b:my_changedtick != b:changedtick)
    let b:my_changedtick = b:changedtick
    return GHC_BrowseAll()
  else
    return 1
  endif
endfunction

" update b:ghc_types after successful make
autocmd QuickFixCmdPost make if exists('current_compiler') && current_compiler == "ghc" && GHC_CountErrors() == 0 | silent call GHC_BrowseAll() | endif

" only count error entries in quickfix list and ignore warnings
function! GHC_CountErrors()
  let c = 0
  for e in getqflist()
    if e.type == 'E' && e.text !~ "^[ \n]*Warning:"
      let c += 1
    endif
  endfor
  return c
endfunction

command! GHCReload call GHC_BrowseAll()
function! GHC_BrowseAll()
  " let imports = haskellmode#GatherImports()
  " let modules = keys(imports[0]) + keys(imports[1])
  let b:my_changedtick = b:changedtick
  let imports = {}    " no need for them at the moment
  let current = GHC_NameCurrent()
  let module = (current == []) ? 'Main' : current[0]
  if haskellmode#GHC_VersionGE([6,8,1])
    return GHC_BrowseBangStar(module)
  else
    return GHC_BrowseMultiple( imports, ['*'.module] )
  endif
endfunction

function! GHC_NameCurrent()
  let last = line('$')
  let l = 1
  while l < last
    let ml = matchlist( getline(l), '^module\s*\([^ (]*\)' )
    if ml != []
      let [_,module;x] = ml
      return [module]
    endif
    let l += 1
  endwhile
  redraw
  echo "cannot find module header for file " . expand("%")
  return []
endfunction


function! GHC_BrowseBangStar(module)
  redraw
  echo "browsing module " a:module
  " TODO: this doesn't work if a:module is loaded compiled - we
  "       could try to give a more helpful error message, or use
  "       -fforce-recomp directly
  let command = ":browse! *" . a:module
  let orig_shellredir = &shellredir
  let &shellredir = ">"    " ignore error/warning messages, only output or lack thereof
  let output = system( g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%"), command )
  let &shellredir = orig_shellredir
  return GHC_ProcessBang(a:module, output)
endfunction

function! GHC_BrowseMultiple(imports, modules)
  redraw
  echo "browsing modules " a:modules
  let command = ":browse " . join( a:modules, " \n :browse ")
  let command = substitute( command, '\(:browse \(\S*\)\)', 'putStrLn "-- \2" \n \1', 'g' )
  let output = system( g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%"), command )
  return GHC_Process(a:imports, output)
endfunction

function! GHC_Info(what)
  " call GHC_HaveTypes()
  let output = system( g:ghc . ' ' . b:ghc_staticoptions . ' -v0 --interactive ' . expand("%"), ":info ".a:what )
  return output
endfunction


function! GHC_ProcessBang(module, output)
  let module      = a:module
  let b           = a:output
  let linePat     = '^\(.\{-}\)\n\(.*\)'
  let contPat     = '\s\+\(.\{-}\)\n\(.*\)'
  let typePat     = '^\(\)\(\S*\)\s*::\(.*\)'
  let commentPat  = '^-- \(\S*\)'
  let definedPat  = '^-- defined locally'
  let importedPat = '^-- imported via \(.*\)'
  if b !~ commentPat
    redraw
    echo s:scriptname.": GHCi reports errors (try :make?)"
    return 0
  endif
  let b:ghc_types = {}
  let ml = matchlist( b, linePat )
  while ml != []
    let [_,l,rest;x] = ml
    let mlDecl = matchlist( l, typePat )
    if mlDecl != []
      let [_,indent,id,type;x] = mlDecl
      let ml2 = matchlist( rest, '^'.indent.contPat )
      while ml2 != []
        let [_,c,rest;x] = ml2
        let type .= c
        let ml2 = matchlist( rest, '^'.indent.contPat )
      endwhile
      let id   = substitute( id, '^(\(.*\))$', '\1', '' )
      let type = substitute( type, '\s\+', " ", "g" )
      " using :browse! *<current>, we get both unqualified and qualified id's
      let qualified = (id =~ '\.') && (id =~ '[A-Z]')
      let b:ghc_types[id] = type
      if !qualified
        for qual in qualifiers
          let b:ghc_types[qual.'.'.id] = type
        endfor
      endif
    else
      let mlImported = matchlist( l, importedPat )
      let mlDefined  = matchlist( l, definedPat )
      if mlImported != []
        let [_,modules;x] = mlImported
        let qualifiers = split( modules, ', ' )
      elseif mlDefined != []
        let qualifiers = [module]
      endif
    endif
    let ml = matchlist( rest, linePat )
  endwhile
  return 1
endfunction
