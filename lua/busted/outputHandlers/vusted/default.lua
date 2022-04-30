return function(options)
  local busted = require("busted")
  local handler = require("busted.outputHandlers.TAP")(options)

  local suite_start = function(suite)
    if suite.randomseed then
      -- NOTE: can know random seed even if neovim crashes
      io.write(("# Random seed: %s\n"):format(suite.randomseed))
    end
    return nil, true
  end
  busted.subscribe({ "suite", "start" }, suite_start)

  local test_path = function(t)
    local trace = t.element.trace
    if not trace then
      return ""
    end
    local source = trace.source:gsub("^@", "")
    return ("%s:%d : %s"):format(source, trace.currentline, t.name)
  end

  local show_test_paths = function(tests)
    for _, test in ipairs(tests) do
      io.write(("#   %s\n"):format(test_path(test)))
    end
  end

  local suite_end = function()
    io.write("\n\n")

    io.write(("# Success: %d\n"):format(#handler.successes))

    if #handler.failures > 0 then
      io.write(("# Failure: %d\n"):format(#handler.failures))
      show_test_paths(handler.failures)
    end

    if #handler.pendings > 0 then
      io.write(("# Pending: %d\n"):format(#handler.pendings))
      show_test_paths(handler.pendings)
    end

    if #handler.errors > 0 then
      io.write(("# Error: %d\n"):format(#handler.errors))
      show_test_paths(handler.errors)
    end

    return nil, true
  end
  busted.subscribe({ "suite", "end" }, suite_end)

  return handler
end
