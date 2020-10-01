let s:this_path = expand('<sfile>')
let s:root_path = fnamemodify(s:this_path, ':h:h')
if isdirectory(s:root_path .. '/spec')
    " HACK: for installation by clone
    let &runtimepath = s:root_path .. ',' .. &runtimepath
endif

lua require('vusted/run')()

" NOTE: A verbose output will change as the following.
"
" - `source {file.vim}`
"   Last set from ~/path/to/entry.vim line \d
" - `lua {file.lua}`
"   Last set from --cmd argument
