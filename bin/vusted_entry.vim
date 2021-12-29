let s:this_path = expand('<sfile>')
let s:root_path = fnamemodify(s:this_path, ':h:h')
if isdirectory(s:root_path .. '/spec')
    " HACK: for installation by clone
    let &runtimepath = s:root_path .. ',' .. &runtimepath
endif

try
lua <<EOF
    local version = _VERSION.sub(5)
    local deploy_lua_dir = vim.fn.trim(vim.fn.system('luarocks --lua-version=' .. version .. ' config deploy_lua_dir'))
    local deploy_lib_dir = vim.fn.trim(vim.fn.system('luarocks --lua-version=' .. version .. ' config deploy_lib_dir'))
    package.path = package.path .. ';' .. deploy_lua_dir .. '/?.lua;' .. deploy_lua_dir .. '/?/init.lua'
    package.cpath = package.cpath .. ';' .. deploy_lib_dir .. '/?.so;' .. deploy_lib_dir .. '/?/init.so'
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
