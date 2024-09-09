local asserts = require("vusted.assert").asserts

asserts.create("line"):register_eq(function(row)
  return vim.fn.getline(row or ".")
end)

asserts.create("position"):register_same(function()
  return vim.fn.getpos(".")
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

local assert = assert
---@cast assert +{found:fun(want), line:fun(row,want), position:fun(want)}

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

  it("can register custom assert for deep_equal", function()
    local pos = vim.fn.getpos(".")
    assert.position(pos)
  end)
end)
