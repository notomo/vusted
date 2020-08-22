function! vusted#run() abort
    " HACK: for wipe out "$@" arg buffer
    silent! %bwipeout!

    runtime! plugin/**/*.vim

    lua require('vusted/run')()
endfunction
