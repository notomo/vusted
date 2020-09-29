let s:this_path = expand('<sfile>')
let &runtimepath = fnamemodify(s:this_path, ':h:h') .. ',' .. &runtimepath

lua require('vusted/run')()

" NOTE: A verbose output will change as the following.
"
" - `source {file.vim}`
"   Last set from ~/path/to/entry.vim line \d
" - `lua {file.lua}`
"   Last set from --cmd argument
