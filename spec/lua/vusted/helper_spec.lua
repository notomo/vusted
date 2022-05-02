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
end)
