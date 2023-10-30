return function()
  -- HACK: for wipe out "$@" arg buffer
  vim.cmd("silent! %bwipeout!")

  -- for loading test target
  vim.o.runtimepath = vim.fn.getcwd() .. "," .. vim.o.runtimepath

  -- NOTICE: replace global arg
  arg = vim.fn.argv() -- luacheck: ignore

  if vim.tbl_contains(arg, "--version") then
    local version = _VERSION:sub(5)
    local package_version = vim.fn.system("luarocks --lua-version=" .. version .. " show vusted --mversion")
    print(package_version)
    os.exit(0)
  end

  local runner = require("busted.runner")
  local ok, result = pcall(runner, { standalone = false, output = "vusted.default" })

  local code = 0
  if not ok then
    -- workaround: unitl next busted release
    local normalized = result:gsub([[\]], [[/]])
    if
      normalized:find([[busted/outputHandlers/TAP.lua]])
      and normalized:find([[attempt to concatenate field 'currentline' %(a nil value%)]])
    then
      print([[
# Failure message: Cannot find file or directory: spec
not ok 2 - 
# Failure message: No test files found matching Lua pattern: _spec
1..2

# Success: 0
# Error: 2
]])
    else
      print(result .. "\n")
    end

    code = 1
  end
  os.exit(code)
end
