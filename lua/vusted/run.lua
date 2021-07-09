return function()
  -- HACK: for wipe out "$@" arg buffer
  vim.cmd("silent! %bwipeout!")

  -- for loading test target
  vim.o.runtimepath = vim.fn.getcwd() .. "," .. vim.o.runtimepath
  vim.cmd("runtime! plugin/*.vim")

  -- NOTICE: replace global arg
  arg = vim.fn.argv() -- luacheck: ignore

  local runner = require("busted.runner")
  local ok, result = pcall(runner, {standalone = false, output = arg.output or "vusted.default"})

  local code = 0
  if not ok then
    print(result .. "\n")
    code = 1
  end
  os.exit(code)
end

