local FileSystem = {}

---Check if a file exists on the filesystem.
---@param path string
---@return boolean
function FileSystem.exists(path)
  local f = io.open(path, "r")
  if f then
    io.close(f)
    return true
  end

  return false
end

---Get data path for saving
---@param cache string
---@return string
function FileSystem.getCache(cache)
  local osname = jit.os

  if osname == "Windows" then
    return cache .. "\\data.json"
  end

  return cache .. "/data.json"
end

---Get lua config file path
---@param config string
---@return string
function FileSystem.getConfig(config)
  local osname = jit.os

  if osname == "Windows" then
    return config .. "\\config.lua"
  end

  return config .. "/config.lua"
end

---Ensure config path exists.
---@return string config base config path
---@return string cache cache path
function FileSystem.mkConfig()
  local osname = jit.os

  if osname == "Windows" then
    local appdata = os.getenv("LOCALAPPDATA")
    if not appdata then
      io.stderr:write("Missing AppData folder.\n")
      os.exit(1)
    end

    local path = appdata .. "\\TimePass"
    local cache = appdata .. "\\TimePass\\Cache"

    os.execute('mkdir "' .. cache .. '" >nul 2>&1')

    return path, cache
  else -- Literally every other OS works the same ASIDE windows.
    local home = os.getenv("HOME")
    if not home then
      io.stderr:write("Missing HOME folder. (what?)\n")
      os.exit(1)
    end

    local path = home .. "/.config/TimePass"
    local cache = home .. "/.config/TimePass/Cache"

    if not FileSystem.exists(cache) then
      os.execute('mkdir -p "' .. cache .. '"')
    end

    return path, cache
  end
end

return FileSystem
