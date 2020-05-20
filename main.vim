
let s:root = expand('<sfile>:h')

function! s:main() abort
    let &runtimepath = s:root .. ',' .. &runtimepath
    lua require 'vusted/run'{}
endfunction

call s:main()
