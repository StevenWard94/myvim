" Vim plugin
" Maintainer:  Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/myvim
" Last Change: 2017 Jan 1
" Description: Generates and executes scripts to test the color names available to (g)vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" To test available colors:
"     ':VimColorTest [output file] [fg range] [bg range]'     (for vim running in a terminal)
"     ':GvimColorTest [output file]'                          (for vim running in a GUI)

function! VimColorTest(outfile, fgend, bgend)
  let l:result = []
  for fg in range(a:fgend)
    for bg in range(a:bgend)
      let l:kw = printf('%-7s', printf('c_%d', fg, bg))
      let l:h  = printf('highlight %s ctermfg=%d ctermbg=%d', l:kw, fg, bg)
      let l:s  = printf('syntax keyword %s %s', l:kw, l:kw)
      unlet l:kw
      call add(l:result, printf('%-32s | %s', l:h, l:s))
      unlet l:h l:s bg
    endfor
    unlet fg
  endfor
  call writefile(l:result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! -nargs=* VimColorTest call ParseArgs('VimColorTest', <f-args>) 


function! GVimColorTest(outfile)
  let l:result = []
  for red in range(0, 255, 16)
    for green in range(0, 255, 16)
      for blue in range(0, 255, 16)
        let l:kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
        let l:fg = printf('#%02x%02x%02x', red, green, blue)
        let l:bg = '#fafafa'
        let l:h  = printf('highlight %s guifg=%s guibg=%s', l:kw, l:fg, l:bg)
        unlet l:fg l:bg
        let l:s  = printf('syntax keyword %s %s', l:kw, l:kw)
        unlet l:kw
        call add(l:result, printf('%s | %s', l:h, l:s))
        unlet blue l:h l:s
      endfor
      unlet green
    endfor
    unlet red
  endfor
  call writefile(l:result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! -nargs=* GvimColorTest call ParseArgs('GvimColorTest', <f-args>)


function! ParseArgs(fn, ...)
  let ColorTest = function(a:fn)
  let l:args = []

  if ColorTest == function('GvimColorTest')
    call add( l:args, (a:0 ? a:1 : 'gvim-color-test.tmp') )

  elseif ColorTest == function('VimColorTest')
    let l:defaults = ['vim-color-test.tmp', &t_Co, &t_Co]
    if a:0 >= 3
      let l:args = deepcopy(a:000[:2])
    elseif a:0 == 0
      let l:args = deepcopy(l:defaults)
    else
      let i = 0
      while i < 3
        call add( l:args, (i < a:0 ? a:000[i] : l:defaults[i]) )
      endwhile
      if get(a:000, 1) && !get(a:000, 2)
        let l:args[2] = a:000[1]
      endif
    endif
  endif

  if getftype(l:args[0])
    call rename(l:args[0], 'old'.(l:args[0][0] == '.' ? '' : '.').l:args[0])
  endif
  call call(ColorTest, l:args)
endfunction
    

