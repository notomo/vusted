return function()
  -- NOTICE: replace global arg
  arg = vim.fn.argv()

  local run = require("busted.runner")
  local ok, result = pcall(run, {standalone = false, output = "TAP"})

  local code = 0
  if not ok then
    print(result .. "\n")
    code = 1
  end
  os.exit(code)
end
