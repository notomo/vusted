
function! s:main() abort
    lua require 'vusted/run'{}
endfunction

let &runtimepath = getcwd() .. ',' .. &runtimepath
let &runtimepath = expand('<sfile>:h') .. ',' .. &runtimepath
runtime! plugin/**/*.vim

call s:main()
