
function! s:main() abort
    lua require 'vusted/run'{}
endfunction

" HACK: for wipe out "$@" arg buffer
silent! %bwipeout!

let &runtimepath = getcwd() .. ',' .. &runtimepath
let &runtimepath = expand('<sfile>:h') .. ',' .. &runtimepath
runtime! plugin/**/*.vim

call s:main()
