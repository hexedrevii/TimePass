local FileSystem = require "modules.fs"
local Parser = require "lib.argparse"
local Json = require "lib.json"

if not jit then
  io.stderr:write("Application cannot run on non JIT interpreter.\n")
  os.exit(1)
end

local config, cache = FileSystem.mkConfig()

local dataPath = FileSystem.getCache(cache)
if FileSystem.exists(dataPath) then
  -- TODO: load data
end
