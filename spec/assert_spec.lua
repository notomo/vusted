local vassert = require("vusted.assert")
local asserts = vassert.asserts

asserts.create("line"):register_eq(function(row)
  return vim.fn.getline(row or ".")
end)

asserts.create("found"):register(function(self)
  return function(_, args)
    local pattern = args[1]
    local result = vim.fn.search(pattern, "n")
    self:set_positive(("`%s` not found"):format(pattern))
    self:set_negative(("`%s` found"):format(pattern))
    return result ~= 0
  end
end)

describe("vusted.assert", function()
  it("can register full custom assert", function()
    vim.fn.setline(1, "hoge")

    assert.found("hoge")
  end)
  it("can register custom assert for actual == expected", function()
    vim.fn.setline(1, "foo")
    vim.fn.setline(2, "bar")

    assert.line("foo")
    assert.line(2, "bar")
  end)
end)
