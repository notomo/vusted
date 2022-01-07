return function(options)
  local busted = require("busted")
  local handler = require("busted.outputHandlers.TAP")(options)

  local suiteStart = function(suite)
    if suite.randomseed then
      -- NOTE: can know random seed even if neovim crashes
      io.write(("# Random seed: %s\n"):format(suite.randomseed))
    end
    return nil, true
  end
  busted.subscribe({ "suite", "start" }, suiteStart)

  return handler
end
