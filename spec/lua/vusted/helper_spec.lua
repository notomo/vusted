describe("vusted.helper", function()
  it("cleanup_loaded_modules() cleanups plugin's loaded modules", function()
    package.loaded["vusted_test"] = {}
    package.loaded["vusted_test.test1"] = {}
    package.loaded["vusted_test/test2"] = {}

    require("vusted.helper").cleanup_loaded_modules("vusted_test")

    assert.is_nil(package.loaded["vusted_test"])
    assert.is_nil(package.loaded["vusted_test.test1"])
    assert.is_nil(package.loaded["vusted_test/test2"])
  end)

  it("find_plugin_root() returns plugin root", function()
    local actual = require("vusted.helper").find_plugin_root("vusted")
    assert.is_true(vim.fn.isdirectory(actual .. "/lua/vusted") == 1)
  end)
end)
