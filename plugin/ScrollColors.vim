" ScrollColors.vim - Colorscheme Scroller, Chooser, and Browser
"
"     Author and maintainer: Yakov Lerner <iler_ml@fastmail.fm>
"     Last Change: 2006-07-18
"
"     Minor revisions made by: Steven Ward <stevenward94@gmail.com>
"     Revision details: Primarily changes to documentation and a few patches:
"         2016-11-27 - script set 'j' and 'k' as synonyms for 'Up' and 'Down',
"             respectively so I swapped them to match the proper directional keys.
"         2016-11-27 - fixed functions that assign 'old' variable but never use it
"
" SYNOPSIS:
"   This is a colorscheme scroller/chooser/browser.
"   With this plugin, you can walk through installed
"   colorschemes using the arrow keys.
"
" SHORT USAGE DESCRIPTION:
"   Make sure 'ScrollColors.vim' is in the 'plugin' directory.
"   Type ':SCROLL'
"   Use arrow keys to walk through colorschemes, '?' for help, or 'Esc' to exit.
"
" DETAILED DESCRIPTION:
"   1. 'source' - or put in 'plugin' directory - 'ScrollColors.vim'.
"   2. Type ':SCROLL'
"   3. Use arrow keys to scroll through colorschemes.
"   4. When done, press 'Esc' to exit - you will be prompted to confirm.
"
" CUSTOM KEY MAPPINGS:
"   The 'NextColor' and 'PrevColor' actions can each be given a custom mapping, like so:
"           map <silent><F3> :NEXTCOLOR<CR>
"           map <silent><F2> :PREVCOLOR<CR>
"   The 'ColorScroller' itself can also be mapped for convenience:
"           map <silent><F4> :SCROLLCOLOR<CR>


if exists('g:scroll_colors')
    finish
endif
let g:scroll_colors = 1

command! COLORSCROLL :call s:ColorScroller()
command! SCROLLCOLOR :call s:ColorScroller()
command! NEXTCOLOR   :call s:NextColorscheme()
command! PREVCOLOR   :call s:PrevColorscheme()


function! s:ScrollerHelp( )
    echo " "
    echohl Title
    echo "Color Scroller Help:"
    echo "--------------------"
    echohl NONE
    echo "Arrows       - change colorscheme"
    echo "Esc|q|Enter  - exit"
    echo "h|j|k|l      - change colorscheme"
    echo "0,g          - jump to first colorscheme"
    echo "$,G          - jump to last colorscheme"
    echo "L            - list all colorschemes"
    echo "PgUp|PgDown  - jump up/down by 10 colorschemes"
    echo "#            - jump to a specific colorscheme's index"
    echo "R            - refresh colorscheme list"
    echo "?            - display this help message"
    echohl MoreMsg
    echo "Press any key to continue..."
    echohl NONE
    call getchar()
endfunction


function! s:Align(str, width)
    if strlen(a:str) >= a:width
        return a:str." "
    else
        let pad="                       "
        let res=a:str
        while strlen(res) < a:width
            let chunk = (a:width - strlen(res) > strlen(pad) ? strlen(pad) : a:width - strlen(res))
            let res = res . strpart(pad, 0, chunk)
        endwhile
        return res
    endif
endfunction


function! s:ListColors( )
    echo " "
    let list = s:GetColorschemesList()
    let width = 18
    let pos = 0
    while list !=? ''
        let str = substitute(list, "\n.*", "", "")
        let list = substitute(list, "[^\n]*\n", "", "")
        let aligned = s:Align(str, width)
        if (pos + strlen(aligned) + 1) >= &columns
            echo " "
            let pos = 0
        endif
        echon aligned
        let pos = pos + strlen(aligned)
    endwhile
    echo "Press any key to continue..."
    call getchar()
endfunction


function! s:CurrentColor()
    return exists('g:colors_name') ? g:colors_name : ""
endfunction


function! s:SetColor(name)
    execute "color ".a:name
    " if 'g:colors_name' is not set explicitly,
    " then issues can arise when the name is assigned
    " incorrectly within the colorscheme script. This
    " can happen when the script's file is copied but
    " the assignment is not corrected - this can lead
    " to erratic colorscheme switches unless the
    " assignment has been done explicitly here.
    let g:colors_name = a:name
endfunction


function! s:JumpByIndex(list,total)
    let ans = input("Enter colorscheme number (1-".a:total.") : ")
    let index = ans <= 0 ? 1 : 1 + (ans - 1) % a:total
    let name = s:EntryByIndex(a:list, index)
    call s:SetColor(name)
endfunction


function! s:JumpByIndex2(list,total,index)
    let mod = a:index <= 0 ? 1 : 1 + (a:index - 1) % a:total
    let name = s:EntryByIndex(a:list, mod)
    call s:SetColor(name)
endfunction


function! s:ExitDialog(old,action)
    let ans = 0

    if a:old == s:CurrentColor()
        let ans = 1
    elseif a:action == ''
        let ans = confirm("Keep this colorscheme?", "&Yes\n&No\n&Cancel")
    elseif a:action == 'keep'
        let ans = 1
    elseif a:action == 'revert'
        let ans = 2
    endif

    if ans == 1 || ans == 0
    " exit, keep colorscheme
        let msg = a:old == s:CurrentColor() ? '' : "(original: '".a:old."')"
        call s:FinalEcho(msg)
    elseif ans == 2
    " exit, revert colorscheme
        call s:SetColor(a:old)
        call s:FinalEcho('original colorscheme restored')
    elseif ans == 3
    " do not exit, continue browsing
        return -1
    endif
endfunction


function! s:ColorScroller( )
    let old = s:CurrentColor()
    let list = s:GetColorschemesList()
    let total = s:CountEntries(list)
    let loop = 0

    if line('$') == 1 && getline(1) == "" && bufnr('$') == 1
        echo "Opening sample text with syntax highlighting."
        echo "Watch for the guide prompt in the bottom line."
        echo "When the text opens, use the arrow keys to switch colorschemes and '?' for help."
        echo " "
        echo "Press any key to continue..."
        call getchar()
        edit $VIMRUNTIME/syntax/abc.vim
        setlocal readonly
        syntax on
        redraw
    endif

    if !exists('g:syntax_on')
        syntax on
        redraw
    endif

    while 1
        redraw
        let index = s:FindIndex(list, s:CurrentColor())
        echo "["
        echohl Search
        echon s:CurrentColor()
        echohl NONE
        if loop == 0
            echon "] ColorScroller: "
            echohl MoreMsg | echon "Arrows" | echohl NONE | echon "-next/prev; "
            echohl MoreMsg | echon "Esc" | echohl NONE | echon "-exit; "
            echohl MoreMsg | echon "?" | echohl NONE | echon "-help > "
        else
            echon "] "
            echon " " . index . "/" . total . " "
            echon "> ColorScroll > "
            echon "Arrows,Esc,? > "
        endif
        let key = getchar()
        let c = nr2char(key)

        if     key == "\<Left>" || key == "\<Up>" || c ==# 'h' || c ==# 'k'
            call s:PrevSilent()
        elseif key == "\<Right>" || key == "\<Down>" || c ==# 'l' || c ==# 'j' || c== ' '
            call s:NextSilent()
        elseif c ==# 'g' || c == '0' || c == '1'
            call s:SetColor( s:GetFirstColors() )
        elseif c == '$' || c ==# 'G'
            call s:SetColor( s:GetLastColors() )
        elseif c ==# 'L'
        " command 'L' - list colors
            call s:ListColors()
        elseif c ==? 'z' || key == 13 || c ==? 'q' || c == ':' || key == 27
            if s:ExitDialog(old, '') != -1
                break
            endif
        elseif key == 12    " i.e. \<C-l>
            redraw
        elseif c == '#'
            call s:JumpByIndex(list, total)
        elseif key == "\<PageDown>"
            call s:JumpByIndex2(list, total, (index - 10 >= 1 ? index - 10 : index - 10 + total))
        elseif key == "\<PageUp>"
            call s:JumpByIndex2(list, total, index + 10)
        elseif c == '?'
            call s:ScrollerHelp()
        elseif c ==? 'r'
            call s:RefreshColorschemesList()
            echo "Colorscheme list refreshed. Press any key to continue..."
            call getchar()
        else
            call s:ScrollerHelp()
        endif
        let loop += 1
    endwhile
endfunction


" Get '1'-based index of "entry" in a '\n'-separated "list"
function! s:FindIndex(list, entry)
    " assumes 'entry' contains no special chars - otherwise, it could be handled using
    " 'escape()'
    let str = substitute("\n" . a:list . "\n", "\n" . a:entry . "\n.*$", "", "")
    return s:CountEntries(str) + 1
endfunction

" Get list element from its '1'-based index
function! s:EntryByIndex(list, index)
    let k = 1
    let tail = a:list
    while tail != '' && k < a:index
        let tail = substitute(tail, "^[^\n]*\n", "", "")
        let k += 1
    endwhile
    let tail = substitute(tail, "\n.*$", "", "")
    return tail
endfunction

function! s:MakeWellFormedList(list)

    " make sure trailing '\n' is present
    let str = a:list."\n"
    " make sure leading '\n''s are NOT present
    let str = substitute(str, "^\n*", "", "")
    " make sure entries are all separated by exactly ONE '\n'
    let str = substitute(str, "\n\\+", "\n", "g")

    return str
endfunction


function! s:CountEntries(list)
    let str = s:MakeWellFormedList(a:list)

    let str = substitute(str, "[^\n]\\+\n", ".", "g")

    return strlen(str)
endfunction


function! s:RemoveDuplicates(list)
    let sep = "\n"
    let res = s:MakeWellFormedList(a:list."\n")
    let beg = 0
    while beg < strlen(res)
        let end = matchend(res, sep, beg)
        let str1 = strpart(res, beg, end - beg)
        let res = strpart(res, 0, end) . substitute("\n".strpart(res, end), "\n".str1, "\n", "g")
        let res = substitute(res, "\n\\+", "\n", "g")
        let beg = end
    endwhile
    return res
endfunction


if v:version >= 700
    " s:SortVar(): sort components of string @list separated
    " by delimiter @sep, and return the sorted string.
    " For example, s:SortVar("c\nb\na", "\n") returns "a\nb\nc\n"
    function! s:SortVar(list, sep)
        let list = split(a:list, a:sep)
        let sorted = sort(list)
        let result = join(sorted, "\n")
        return result . "\n"
    endfunction
endif

if v:version < 700
    function! s:SortVar(list, sep)
        let res = s:MakeWellFormedList(a:list."\n")
        while 1
            let disorder = 0
            let index1 = 0

            let len = strlen(res)
            while 1
                let index2 = matchend(res, a:sep, index1)
                if index2 == -1 || index2 > len
                    break
                endif
                let index3 = matchend(res, a:sep, index2)
                if index3 == -1
                    let index3 = len
                endif
                let str1 = strpart(res, index1, index2 - index1)
                let str2 = strpart(res, index1, index3 - index2)
                if str1 > str2
                    let disorder = 1
                    " swap str1 and str2 within res
                    let res = strpart(res, 0, index1).str2.str1.strpart(res, index3)
                    let index1 = index1 + strlen(str2)
                else
                    let index1 = index1 + strlen(str1)
                endif
            endwhile

            if !disorder
                break
            endif
        endwhile
        return res
    endfunction
endif

let s:list = ""

function! s:GetColorschemesList( )
    if s:list == ""
        let s:list = s:RefreshColorschemesList()
    endif
    return s:list
endfunction


function! s:RefreshColorschemesList( )
    let x = globpath(&rtp, "colors/*.vim")
    let y = substitute(x."\n", "\\(^\\|\n\\)[^\n]*[/\\\\]", "\n", "g")
    let z = substitute(y, "\\.vim\n", "\n", "g")
    let sorted = s:SortVar(z, "\n")
    let s:list = s:RemoveDuplicates(sorted)
    return s:list
endfunction


function! s:GetFirstColors( )
    let list = s:GetColorschemesList()
    let trim = substitute(list, "^\n\\+", "", "")
    return substitute(trim, "\n.*", "", "")
endfunction


function! s:GetLastColors( )
    let list = s:GetColorschemesList()
    let trim = substitute(list, "\n\\+$", "", "")
    return substitute(trim, "^.*\n", "", "")
endfunction


function! s:FinalEcho(suffix)
    let list = s:GetColorschemesList()
    let total = s:CountEntries(list)
    let index = s:FindIndex(list, s:CurrentColor())

    redraw
    echon "["
    echohl Search
    echon s:CurrentColor()
    echohl NONE
    echon "] colorscheme #".index ." of " . total.". "
    echon a:suffix
endfunction


function! s:GetNextColor(color)
    let list = s:GetColorschemesList()
    if "\n".list =~ "\n".s:CurrentColor()."\n"
        let next = substitute("\n".list."\n", ".*\n".a:color."\n", "", "")
        let next = substitute(next, "\n.*", "", "")
        return next == '' ? s:GetFirstColors() : next
    else
        return s:GetFirstColors()
    endif
endfunction


function s:GetPrevColor(color)
    let list = s:GetColorschemesList()
    if "\n".list =~ "\n".a:color."\n"
        let prev = substitute("\n".list."\n", "\n".a:color."\n.*", "", "")
        let prev = substitute(prev, "^.*\n", "", "")
        return prev == '' ? s:GetLastColors() : prev
    else
        return s:GetLastColors()
    endif
endfunction


function! s:NextSilent( )
    let next = s:GetNextColor(s:CurrentColor())
    call s:SetColor(next)
endfunction


function! s:PrevSilent( )
    let prev = s:GetPrevColor(s:CurrentColor())
    call s:SetColor(prev)
endfunction


function! s:NextColorscheme( )
    let old = s:CurrentColor()
    let next = s:GetNextColor(old)
    call s:SetColor(next)
    redraw
    call s:FinalEcho('previous: '.old)
endfunction


function! s:PrevColorscheme( )
    let old = s:CurrentColor()
    let prev = s:GetPrevColor(old)
    call s:SetColor(prev)
    redraw
    call s:FinalEcho('previous: '.old)
endfunction


command! CN :call s:NextColorscheme()
command! CP :call s:PrevColorscheme()
map \n :CN<CR>
map \p :CP<CR>
map \c :echo g:colors_name<CR>


" Brief Change Log:
"   2006-07-18 - changed 'Align()' -> 's:Align()' to fix bug affecting 'L' command
"   2006-07-18 - added colorlist cache via 's:list'
"   2006-07-18 - added 'R' as a valid key to refresh colorlist
"   2006-07-19 - use builtin 'sort()' instead of bubble sort when vim7 is available
"
" vim:expandtab:sw=4:sts=2
