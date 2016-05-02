" vim: nowrap:fo=cr1jb:sw=2:sts=2:ts=8:

function! s:setf( filetype ) abort
  if &filetype !=# a:filetype
    let &filetype = a:filetype
  endif
endfunction

" Ruby
autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec           :call s:setf( 'ruby' )

" Ruby on Rails
autocmd BufNewFile,BufRead *.builder,*.rxml,*.rjs,*.ruby  :call s:setf( 'ruby' )

" Rakefile
autocmd BufNewFile,BufRead [rR]akefile,*.rake             :call s:setf( 'ruby' )

" Rantfile
autocmd BufNewFile,BufRead [rR]antfile,*.rant             :call s:setf( 'ruby' )

" IRB config
autocmd BufNewFile,BufRead .irbrc,irbrc                   :call s:setf( 'ruby' )

" Pry config
autocmd BufNewFile,BufRead .pryrc                         :call s:setf( 'ruby' )

" Rackup
autocmd BufNewFile,BufRead *.ru                           :call s:setf( 'ruby' )

" Capistrano
autocmd BufNewFile,BufRead Capfile,*.cap                  :call s:setf( 'ruby' )

" Bundler
autocmd BufNewFile,BufRead Gemfile                        :call s:setf( 'ruby' )

" Guard
autocmd BufNewFile,BufRead Guardfile,.Guardfile           :call s:setf( 'ruby' )

" Chef
autocmd BufNewFile,BufRead Cheffile                       :call s:setf( 'ruby' )
autocmd BufNewFile,BufRead Berksfile                      :call s:setf( 'ruby' )

" Vagrant
autocmd BufNewFile,BufRead [vV]agrantfile                 :call s:setf( 'ruby' )

" Autotest
autocmd BufNewFile,BufRead .autotest                      :call s:setf( 'ruby' )

" eRuby
autocmd BufNewFile,BufRead *.erb,*.rhtml                  :call s:setf( 'eruby' )

" Thor
autocmd BufNewFile,BufRead [tT]horfile,*.thor             :call s:setf( 'ruby' )

" Rabl
autocmd BufNewFile,BufRead *.rabl                         :call s:setf( 'ruby' )

" Jbuilder
autocmd BufNewFile,BufRead *.jbuilder                     :call s:setf( 'ruby' )

" Puppet librarian
autocmd BufNewFile,BufRead Puppetfile                     :call s:setf( 'ruby' )

" Buildr Buildfile
autocmd BufNewFile,BufRead [Bb]uildfile                   :call s:setf( 'ruby' )

" Appraisal
autocmd BufNewFile,BufRead Appraisals                     :call s:setf( 'ruby' )

" CocoaPods
autocmd BufNewFile,BufRead Podfile,*.podspec              :call s:setf( 'ruby' )

" Routefile
autocmd BufNewFile,BufRead [rR]outefile                   :call s:setf( 'ruby' )

" SimpleCov
autocmd BufNewFile,BufRead .simplecov                     :set filetype=ruby
