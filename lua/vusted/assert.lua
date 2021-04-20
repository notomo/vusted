local assert = require("luassert")
local say = require("say")

local M = {}

local Assert = {}
Assert.__index = Assert
M.asserts = Assert

function Assert.create(name)
  vim.validate({name = {name, "string"}})
  local tbl = {
    name = name,
    positive = ("assertion.%s.positive"):format(name),
    negative = ("assertion.%s.negative"):format(name),
  }
  return setmetatable(tbl, Assert)
end

function Assert.set_positive(self, msg)
  say:set(self.positive, msg)
end

function Assert.set_negative(self, msg)
  say:set(self.negative, msg)
end

function Assert.register(self, fn)
  assert:register("assertion", self.name, fn(self), self.positive, self.negative)
end

function Assert.register_eq(self, get_actual)
  local fn = function(_, args)
    local expected = args[#args]
    local actual = get_actual(unpack(args, 1, #args - 1))

    local positive_msg = ("%s should be %s, but actual: %s"):format(self.name, expected, actual)
    self:set_positive(positive_msg)
    local negative_msg = ("%s should not be %s, but actual: %s"):format(self.name, expected, actual)
    self:set_negative(negative_msg)

    return actual == expected
  end
  self:register(function(_)
    return fn
  end)
end

function Assert.register_same(self, get_actual)
  local fn = function(_, args)
    local expected = vim.inspect(args[#args])
    local actual = vim.inspect(get_actual(unpack(args, 1, #args - 1)))

    local positive_msg = ("%s should be %s, but actual: %s"):format(self.name, expected, actual)
    self:set_positive(positive_msg)
    local negative_msg = ("%s should not be %s, but actual: %s"):format(self.name, expected, actual)
    self:set_negative(negative_msg)

    return vim.deep_equal(actual, expected)
  end
  self:register(function(_)
    return fn
  end)
end

return M
