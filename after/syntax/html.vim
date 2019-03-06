" Vim syntax file
" Language:     HTML (version 5)
" Maintainer:   Rodrigo Machado <rcmachado@gmail.com>
" URL:          https://gist.github.com/256840
" Last Change:  2010 Aug 26
" License:      Creative Commons CCO 1.0 Universal (CC-0)
"
" Description:  This file adds syntax items for the new HTML5 tags
"               and IS NOT intended to replace the default html
"               syntax file that ships with Vim.

" HTML5 Tags
syntax keyword htmlTagName contained article aside audio bb canvas command datagrid
syntax keyword htmlTagName contained datalist details dialog embed figure footer
syntax keyword htmlTagName contained header hgroup keygen mark meter nav output
syntax keyword htmlTagName contained progress time ruby rt rp section time video
syntax keyword htmlTagName contained source figcaption

"HTML5 Arguments
syntax keyword htmlArg contained autofocus autocomplete placeholder min max step
syntax keyword htmlArg contained contenteditable contextmenu draggable hidden item
syntax keyword htmlArg contained itemprop list sandbox subject spellcheck
syntax keyword htmlArg contained novalidate seamless pattern formtarget manifest
syntax keyword htmlArg contained formaction formenctype formmethod formnovalidate
syntax keyword htmlArg contained sizes scoped async reversed sandbox srcdoc
syntax keyword htmlArg contained hidden role
syntax match   htmlArg "\<\(aria-[\-a-zA-Z0-9_]\+\)=" contained
syntax match   htmlArg contained "\s*data-[-a-zA-Z0-9_]\+"
