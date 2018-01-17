" Vim syntax plugin
" Language:    "Keychain" files listing login info for my accounts
" Maintainer:  Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/myvim
" Last Change: 2017 Aug 3
" ======================================================================================

if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpoptions
set cpo&vim

syntax match keychainURL
