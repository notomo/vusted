local M = {}

--- Cleanup lua package.loaded for plugin.
--- This does nothing If VUSTED_DISABLE_CLEANUP environment variable exists.
--- @param plugin_name string: lua module name (`lua/{plugin_name}/*.lua`)
function M.cleanup_loaded_modules(plugin_name)
  if os.getenv("VUSTED_DISABLE_CLEANUP") then
    return
  end

  vim.validate({ plugin_name = { plugin_name, "string" } })

  local dir = plugin_name:gsub("/", ".") .. "."
  for key in pairs(package.loaded) do
    if vim.startswith(key:gsub("/", "."), dir) or key == plugin_name then
      package.loaded[key] = nil
    end
  end
end

local clears = {
  buffer = function()
    vim.cmd("tabedit")
    vim.cmd("tabonly!")
    vim.cmd("silent! %bwipeout!")
  end,
  message = function()
    vim.cmd("messages clear")
  end,
  abbreviation = function()
    vim.cmd("abclear")
  end,
  highlight = function()
    vim.cmd("highlight clear")
  end,
  jump = function()
    vim.cmd("clearjumps")
  end,
  history = function()
    vim.fn.histdel("cmd")
    vim.fn.histdel("search")
    vim.fn.histdel("expr")
    vim.fn.histdel("input")
    vim.fn.histdel("debug")
  end,
  command = function()
    vim.cmd("comclear")
  end,
  keymap = function()
    vim.cmd("mapclear")
    vim.cmd("mapclear!")
    vim.cmd("tmapclear")
    vim.cmd("lmapclear")
  end,
  autocmd = function()
    local exec = function(cmd)
      if vim.api.nvim_exec2 then
        return vim.api.nvim_exec2(cmd, { output = true }).output
      end
      return vim.api.nvim_exec(cmd, true)
    end
    local groups = vim.split(exec("augroup"), "%s+", { trimempty = true })
    for _, group in ipairs(groups) do
      vim.api.nvim_del_augroup_by_name(group)
    end
    vim.api.nvim_clear_autocmds({})
  end,
  option = function(opts)
    local options = vim.tbl_filter(function(o)
      return o.was_set and not vim.tbl_contains(opts.exclude, o.name)
    end, vim.api.nvim_get_all_options_info())
    for _, opt in ipairs(options) do
      vim.opt[opt.name] = opt.default
    end
  end,
  arglist = function()
    vim.cmd("%argdelete")
  end,
}

local default_targets = {
  buffer = { enabled = true },
  message = { enabled = true },
  abbreviation = { enabled = true },
  highlight = { enabled = true },
  jump = { enabled = true },
  history = { enabled = true },
  command = { enabled = true },
  keymap = { enabled = true },
  autocmd = { enabled = true },
  option = {
    enabled = true,
    opts = {
      exclude = { "runtimepath" },
    },
  },
  arglist = { enabled = true },
}

--- Cleanup the following state. (best effort)
---   - buffer
---   - message
---   - abbreviation
---   - highlight
---   - jump
---   - history
---   - command (NOTICE: include |nvim-defaults|)
---   - keymap (NOTICE: include |default-mappings|)
---   - autocmd, augroup (NOTICE: include |default-autocmds|)
---   - option (exclude 'runtimepath')
---   - arglist
--- Not supported:
---   - user defined function
---   - `:filetype on`
---   - `:syntax on`
---   - variable (g:, v:)
---   - register
--- This does nothing If VUSTED_DISABLE_CLEANUP environment variable exists.
--- @param targets table|nil: see above `default_targets`
---   - For example if disable 'autocmd' cleanup: `helper.cleanup({autocmd = {enabled = false}})`
function M.cleanup(targets)
  if os.getenv("VUSTED_DISABLE_CLEANUP") then
    return
  end

  targets = vim.tbl_deep_extend("force", default_targets, targets or {})
  for _, name in ipairs({
    "buffer",
    "message",
    "abbreviation",
    "highlight",
    "jump",
    "history",
    "command",
    "keymap",
    "autocmd",
    "option",
    "arglist",
  }) do
    local target = targets[name]
    if target.enabled then
      clears[name](target.opts)
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
--- @return string # plugin root directory full path
function M.find_plugin_root(plugin_name)
  vim.validate({ plugin_name = { plugin_name, "string" } })

  local root_pattern = ("lua/%s/*.lua"):format(plugin_name)
  local file = vim.api.nvim_get_runtime_file(root_pattern, false)[1]
  if file == nil then
    error("plugin root is not found by pattern: " .. root_pattern)
  end
  return vim.split(_adjust_sep(file), "/lua/", { plain = true })[1]
end

--- Returns table to call require on every access.
--- For example, `mod.execute()` equivalents to `require("mod").execute()`.
--- @param name string: lua module name
--- @return any # to access the module.
function M.require(name)
  vim.validate({ name = { name, "string" } })
  return setmetatable({}, {
    __index = function(_, k)
      return require(name)[k]
    end,
  })
end

--- Returns root module name.
--- For example, `get_required_root("plugin_name.module1")` returns `plugin_name`.
--- @param module_name string: lua module name
--- @return string # root module name
function M.get_module_root(module_name)
  vim.validate({ module_name = { module_name, "string" } })
  return vim.split(module_name:gsub("%.", "/"), "/", { plain = true })[1]
end

return M
