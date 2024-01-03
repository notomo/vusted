package = "vusted"
version = "x.x.x-1"
source = {
  url = "git+https://github.com/notomo/vusted.git",
  tag = "vx.x.x",
}
description = {
  summary = "`busted` wrapper for testing neovim plugin",
  detailed = "",
  homepage = "https://github.com/notomo/vusted",
  license = "MIT <http://opensource.org/licenses/MIT>",
}
dependencies = {
  "luasystem = 0.2.1", -- Workaround for https://github.com/notomo/vusted/issues/17
  "busted >= 2.2.0",
}
build = {
  type = "builtin",
  modules = {
    ["busted.outputHandlers.vusted.default"] = "lua/busted/outputHandlers/vusted/default.lua",
    ["vusted.assert"] = "lua/vusted/assert.lua",
    ["vusted.helper"] = "lua/vusted/helper.lua",
    ["vusted.run"] = "lua/vusted/run.lua",
  },
  install = {
    bin = {
      "bin/vusted_entry.vim",
      "bin/vusted",
      "bin/vusted.bat",
    },
  },
}
