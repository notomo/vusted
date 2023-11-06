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
    print(result .. "\n")
    code = 1
  end
  os.exit(code)
end
