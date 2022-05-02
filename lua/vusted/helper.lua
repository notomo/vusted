local M = {}

--- Cleanup lua package.loaded for plugin.
--- @param plugin_name string: lua module name (`lua/{plugin_name}/*.lua`)
function M.cleanup_loaded_modules(plugin_name)
  vim.validate({ plugin_name = { plugin_name, "string" } })

  local dir = plugin_name:gsub("/", ".") .. "."
  for key in pairs(package.loaded) do
    if vim.startswith(key:gsub("/", "."), dir) or key == plugin_name then
      package.loaded[key] = nil
    end
  end
end

local _adjust_sep
if vim.fn.has("win32") == 1 then
  _adjust_sep = function(path)
    return path:gsub("\\", "/")
  end
else
  _adjust_sep = function(path)
    return path
  end
end

--- Returns plugin root directory full path.
--- @param plugin_name string: lua module name (`lua/{plugin_name}/*.lua`)
--- @return string: plugin root directory full path
function M.find_plugin_root(plugin_name)
  vim.validate({ plugin_name = { plugin_name, "string" } })

  local root_pattern = ("lua/%s/*.lua"):format(plugin_name)
  local file = vim.api.nvim_get_runtime_file(root_pattern, false)[1]
  if file == nil then
    error("plugin root is not found by pattern: " .. root_pattern)
  end
  return vim.split(_adjust_sep(file), "/lua/", true)[1], nil
end

--- Returns table to call require on every access.
--- For example, `mod.execute()` equivalents to `require("mod").execute()`.
--- @param name string: lua module name
--- @return table: to access the module.
function M.require(name)
  vim.validate({ name = { name, "string" } })
  return setmetatable({}, {
    __index = function(_, k)
      return require(name)[k]
    end,
  })
end

return M
