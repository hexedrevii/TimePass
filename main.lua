local FileSystem = require "modules.fs"
local Time = require "modules.time"
local Parser = require "lib.argparse"
local Json = require "lib.json"

if not jit then
  io.stderr:write("Application cannot run on non JIT interpreter.\n")
  os.exit(1)
end


local data = {}

local config, cache = FileSystem.mkConfig()

local dataPath = FileSystem.getCache(cache)
local dataFile = io.open(dataPath, "r")
if dataFile then
  data = Json.decode(dataFile:read("*a"))
  dataFile:close()
end

--#region Args
local args = Parser("TimePass", "Track stuff!")

local list = args:command("list")
list:flag("-a --all", "List every entry")
list:option("-i --id", "List entry by ID")

local remove = args:command("remove")
remove:option("-n --name", "Remove by name")
remove:option("-i --id", "Remove by ID")

local add = args:command("add")
add:option("-d --date", "The date (dd/mm/yyyy)"):args(1)
add:option("-n --name", "The name"):args(1)
--#endregion Args

local result = args:parse(arg)

if result.add then
  if not result.name or not result.date then
    args:error("Missing argument for add.\n")
  end

  local item = {
    id = #data + 1,
    name = result.name,
    date = result.date
  }

  table.insert(data, item)
  local file = io.open(dataPath, "w")
  if file then
    local json = Json.encode(data)
    file:write(json)

    print("Successfully added entry " .. result.name .. ".")
    file:close()
  else
    args:error("Could not open file " .. dataPath)
  end
end

if result.remove then
  if result.name then
    for i, model in ipairs(data) do
      if result.name == model.name then
        table.remove(data, i)
        local file = io.open(dataPath, "w")
        if file then
          local json = Json.encode(data)
          file:write(json)

          print("Successfully removed entry " .. result.name .. ".")
          file:close()
        else
          args:error("Could not open file " .. dataPath)
        end

        break
      end
    end
  elseif result.id then
    for i, model in ipairs(data) do
      if tonumber(result.id) == model.id then
        table.remove(data, i)
        local file = io.open(dataPath, "w")
        if file then
          local json = Json.encode(data)
          file:write(json)

          print("Successfully removed entry with id " .. result.id .. ".")
          file:close()
        else
          args:error("Could not open file " .. dataPath)
        end

        break
      end
    end
  end
end

if result.list then
  if result.all then
    local now = os.time()
    for i, model in ipairs(data) do
      local time_string = Time.formatTime(model, now)
      print(model.name .. " " .. model.date .. " [" .. model.id .. "]\n - " .. time_string)

      if i ~= #data then
        print()
      end
    end
  elseif result.id then
    local now = os.time()
    for _, model in ipairs(data) do
      if tonumber(result.id) == model.id then
        local time_string = Time.formatTime(model, now)
        print(model.name .. " " .. model.date .. "\n - " .. time_string)
      end
    end
  end
end
