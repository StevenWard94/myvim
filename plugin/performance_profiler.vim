" Vim plugin to enable profiling at startup
" Language:    n/a
" Maintainer:  Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/myvim
" Last Change: 2017 Jan 14
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:InitProfile() abort
  let l:when = strftime("%Y %b %d :: %T")
  let l:bufdict = {}
  for bufnr in range(0, bufnr('$'))
    if buflisted(bufnr)
      let l:bufdict[(bufnr > 9 ? '' : '0').string(bufnr)] = fnamemodify(bufname(bufnr), ":p")
    endif
    unlet bufnr
  endfor
  map(l:bufdict, "substitute(v:val, '^\/home\/[A-Za-z0-9_+.-]*', '~', '')")
  let l:buflist = []
  for [_,val] in items(l:bufdict)
    call add(l:buflist, val)
  endfor
  unlet l:bufdict

  let l:logd = expand("~/.log/vim-profile.log")
  let l:logf_prefix = 'profile.log_'
  let l:new_file = l:logd . '/' . l:logf_prefix . strftime("%Y%b%d")

  let l:index = logd.'/.index'
  if filereadable(l:index) && match(readfile(l:index), '.*') != -1
    let l:div = '-'
    for _ in range(0,5)
      let l:div = l:div . l:div
    endfor
    execute '!echo "'.l:div.'" >> '.l:index
  endif
  execute '!echo "' . (has('gui_running') ? 'VIM-GUI' : 'VIM') . ' session:  ' . l:when . '" >> ' . l:index
  execute '!echo "Initial Files: ' . join(l:buflist, ', ') . '" >> ' . l:index

  if !isdirectory(l:logd)
    silent call system('mkdir -p ' . shellescape(logd))
  else
    let shell_fpat = '^'.escape(l:logf_prefix, '.') . '[0-9]{4}(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[0-9]{2}$'
    let grep_out = system("ls -A ".l:logd." | grep -Eim1 '".shell_fpat."'")
    if !empty(grep_out)
      let existing = l:logd.'/'.grep_out
      if !isdirectory(l:logd.'/.history')
        silent call system('mkdir -p '.l:logd.'/.history')
      endif
      silent call system('mv -t '.l:logd.'/.history '.l:logd.'/'.grep_out)
    endif
  endif

  if !isdirectory(logd)
    return
  endif

  execute 'profile start ' . l:new_file
  profile func *
  profile file *
endfunction

function! s:StopProfile() abort
  if !exists('v:profiling') || v:profiling == 0
    return
  endif
  silent! profile pause
endfunction

if exists('g:profile_on') && g:profile_on != 0
  augroup profile_start_stop
    autocmd!
    autocmd VimEnter * :call <SID>InitProfile()
    autocmd VimLeavePre * :call <SID>StopProfile()
  augroup END
endif
