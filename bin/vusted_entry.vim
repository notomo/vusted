let s:this_path = expand('<sfile>')
let s:root_path = fnamemodify(s:this_path, ':h:h')
if isdirectory(s:root_path .. '/spec')
    " HACK: for installation by clone
    let &runtimepath = s:root_path .. ',' .. &runtimepath
endif

try
lua <<EOF
    package.path = package.path .. ';' .. vim.fn.trim(vim.fn.system('luarocks config deploy_lua_dir')) .. '/?.lua'
    require('vusted/run')()
EOF
catch
    $ put =v:throwpoint
    $ put =v:exception
    1delete _
    %print
    cquit
endtry

" NOTE: A verbose output will change as the following.
"
" - `source {file.vim}`
"   Last set from ~/path/to/vusted_entry.vim line \d
" - `lua {file.lua}`
"   Last set from --cmd argument
