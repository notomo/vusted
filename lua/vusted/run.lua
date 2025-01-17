return function()
  -- HACK: for wipe out "$@" arg buffer
  vim.cmd("silent! %bwipeout!")

  -- for loading test target
  vim.o.runtimepath = vim.fn.getcwd() .. "," .. vim.o.runtimepath

  local argv = vim.fn.argv()
  ---@cast argv string[]

  -- NOTICE: replace global arg
  arg = argv
  vim.cmd("%argdelete")

  if vim.tbl_contains(arg, "--version") then
    local version = _VERSION:sub(5)
    local package_version = vim.fn.system("luarocks --lua-version=" .. version .. " show vusted --mversion")
    print(package_version)
    os.exit(0)
  end

  if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
  end

  local runner = require("busted.runner")
  local ok, result = pcall(runner, { standalone = false, output = "vusted.default" })

  -- NOTICE: place after calling busted.runner to use patched os.exit when using --coverage
  local exit = os.exit
  if os.getenv("VUSTED_DISABLE_EXIT") then
    exit = function() end
    require("busted.compatibility").exit = exit -- HACK
  end

  local code = 0
  if not ok then
    print(result .. "\n")
    code = 1
  end
  exit(code)
end
