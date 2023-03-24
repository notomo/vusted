describe("vusted.helper", function()
  describe("cleanup_loaded_modules()", function()
    it("cleanups plugin's loaded modules", function()
      package.loaded["vusted_test"] = {}
      package.loaded["vusted_test.test1"] = {}
      package.loaded["vusted_test/test2"] = {}

      require("vusted.helper").cleanup_loaded_modules("vusted_test")

      assert.is_nil(package.loaded["vusted_test"])
      assert.is_nil(package.loaded["vusted_test.test1"])
      assert.is_nil(package.loaded["vusted_test/test2"])
    end)
  end)

  describe("find_plugin_root()", function()
    it("returns plugin root", function()
      local actual = require("vusted.helper").find_plugin_root("vusted")
      assert.is_true(vim.fn.isdirectory(actual .. "/lua/vusted") == 1)
    end)
  end)

  describe("require()", function()
    it("behaviors like require()", function()
      package.loaded["vusted_test_require"] = { test = 8888 }

      local tbl = require("vusted.helper").require("vusted_test_require")

      assert.equal(8888, tbl.test)
    end)

    it("returns table to call require on every access", function()
      package.loaded["vusted_test_require"] = { test = 8888 }

      local tbl = require("vusted.helper").require("vusted_test_require")

      package.loaded["vusted_test_require"] = nil
      local ok, result = pcall(function()
        return tbl.test
      end)

      assert.is_false(ok)
      assert.matches("module 'vusted_test_require' not found:", result)
    end)
  end)

  describe("cleanup()", function()
    it("removes buffers", function()
      vim.cmd.tabedit()

      require("vusted.helper").cleanup()

      assert.equal(1, #vim.api.nvim_list_bufs())
    end)

    it("removes messages", function()
      vim.api.nvim_echo({ { "test_message" } }, true, {})

      require("vusted.helper").cleanup()

      assert.equal("", vim.api.nvim_exec("messages", true))
    end)

    it("removes abbreviations", function()
      vim.cmd.noreabbrev({ "1", "test1" })
      vim.cmd.inoreabbrev({ "2", "test2" })
      vim.cmd.cnoreabbrev({ "3", "test3" })

      require("vusted.helper").cleanup()

      assert.equal(
        [[

No abbreviation found]],
        vim.api.nvim_exec("abbreviate", true)
      )
    end)

    it("removes highlights", function()
      vim.api.nvim_set_hl(0, "VustedTestHighlight", { fg = "#ffffff" })

      require("vusted.helper").cleanup()

      local hl = vim.api.nvim_get_hl(0, { name = "VustedTestHighlight" })
      assert.is_nil(hl.fg)
    end)

    it("removes jumps", function()
      vim.cmd.tabedit()

      require("vusted.helper").cleanup()

      assert.same({}, vim.fn.getjumplist(0)[1])
    end)

    it("removes histories", function()
      vim.fn.histadd("cmd", "test1")
      vim.fn.histadd("cmd", "test2")
      vim.fn.histadd("search", "test1")
      vim.fn.histadd("expr", "test1")
      vim.fn.histadd("input", "test1")
      vim.fn.histadd("debug", "test1")

      require("vusted.helper").cleanup()

      assert.equal("", vim.fn.histget("cmd"))
      assert.equal("", vim.fn.histget("search"))
    end)

    it("removes commands", function()
      vim.api.nvim_create_user_command("VustedTestCommand", "echo", {})

      require("vusted.helper").cleanup()

      assert.same([[No user-defined commands found]], vim.api.nvim_exec("command VustedTestCommand", true))
    end)

    it("removes keymaps", function()
      vim.keymap.set("n", "F", [[echo]])
      vim.keymap.set("i", "F", [[echo]])
      vim.keymap.set("t", "F", [[echo]])
      vim.keymap.set("l", "F", [[echo]])

      require("vusted.helper").cleanup()

      assert.same({}, vim.api.nvim_get_keymap("n"))
      assert.same({}, vim.api.nvim_get_keymap("i"))
      assert.same({}, vim.api.nvim_get_keymap("t"))
      assert.same({}, vim.api.nvim_get_keymap("l"))
    end)

    it("removes autocmds", function()
      vim.api.nvim_create_augroup("vusted_test", {})

      vim.api.nvim_create_autocmd({ "BufWipeout" }, {
        group = "vusted_test",
        pattern = { "*" },
        callback = function() end,
      })
      vim.api.nvim_create_autocmd({ "BufDelete" }, {
        pattern = { "*" },
        callback = function() end,
      })

      require("vusted.helper").cleanup()

      assert.same({}, vim.api.nvim_get_autocmds({}))
    end)

    it("reset options", function()
      vim.opt.autoread = false
      vim.opt.expandtab = true
      vim.opt.cursorline = true

      require("vusted.helper").cleanup()

      assert.is_true(vim.o.autoread)
      assert.is_false(vim.o.expandtab)
      assert.is_false(vim.o.cursorline)
    end)

    it("can disable specific target", function()
      vim.keymap.set("n", "F", [[echo]])
      vim.opt.autoread = false

      require("vusted.helper").cleanup({ option = { enabled = false } })

      assert.same({}, vim.api.nvim_get_keymap("n"))
      assert.is_false(vim.o.autoread)
    end)
  end)

  describe("get_module_root", function()
    for _, c in ipairs({
      {
        module_name = "root",
        expected = "root",
      },
      {
        module_name = "root.a.b",
        expected = "root",
      },
      {
        module_name = "root/a/b",
        expected = "root",
      },
    }) do
      local name = ([[("%s") == "%s"]]):format(c.module_name, c.expected)
      it(name, function()
        local actual = require("vusted.helper").get_module_root(c.module_name)
        assert.is_same(c.expected, actual)
      end)
    end
  end)
end)
