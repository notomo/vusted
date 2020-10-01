local create_new_rockspec = function(version)
  local PLACE_HOLDER = "{EDIT_VERSION}"
  local ROCKSPEC_DIR = "rockspec"

  local original = ROCKSPEC_DIR .. "/vusted.rockspec"
  local new_lines = {}
  local f = io.open(original, "r")
  for line in f:lines() do
    local s = line:find(PLACE_HOLDER)
    if s ~= nil then
      local new_line = line:gsub(PLACE_HOLDER, version)
      table.insert(new_lines, new_line)
    else
      table.insert(new_lines, line)
    end
  end
  f:close()

  local file_name = ("%s/vusted-%s-1.rockspec"):format(ROCKSPEC_DIR, version)
  local new_f = io.open(file_name, "w")
  for _, line in ipairs(new_lines) do
    new_f:write(line .. "\n")
  end
  new_f:close()

  return file_name
end

local main = function()
  local version = arg[1] or ""
  local major, minor, patch = version:match("(%d+)%.(%d+)%.(%d+)")
  if major == nil or minor == nil or patch == nil then
    error("invalid version: " .. version)
  end

  local rockspec_file = create_new_rockspec(version)
  os.execute("cat " .. rockspec_file)

  os.execute("luarocks make " .. rockspec_file)

  local api_key = os.getenv("LUAROCKS_API_KEY")
  if api_key == nil or api_key == "" then
    error("`LUAROCKS_API_KEY` is not found")
  end

  local upload = ("luarocks upload %s --api-key=%s"):format(rockspec_file, api_key)
  os.execute(upload)
end

main()
