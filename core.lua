local core = {}
core.logger = { file = "auto-clicker-95.log", max_size = 1024*1024, rotations = 4 }
function core.logger.get_size()
  local file = io.open(core.logger.file, "rb")
  if file == nil then
    return 0
  end
  local size = file:seek("end")
  file:close()
  return size or 0
end
function core.logger.rotate()
  local base = core.logger.file
  local max = core.logger.rotations
  for i = max - 1, 1, -1 do
    local src = base .. "." .. i
    local dst = base .. "." .. (i + 1)
    pcall(function() os.rename(src, dst) end)
  end
  pcall(function() os.rename(base, base .. ".1") end)
end
function core.logger.log(msg)
  if core.logger.get_size() > core.logger.max_size then
    core.logger.rotate()
  end
  local file = io.open(core.logger.file, "a")
  if file then
    file:write(os.date("%Y-%m-%d %H:%M:%S") .. ": " .. tostring(msg) .. "\n")
    file:close()
  end
end
function core.logger.setup(options)
  options = options or {}
  core.logger.file = options.file or core.logger.file
  core.logger.max_size = options.max_size or core.logger.max_size
  core.logger.rotations = options.rotations or core.logger.rotations
  local f = io.open(core.logger.file, "a")
  if f ~= nil then
    f:close()
  end
end
_G.log = core.logger.log
core.logger.setup()
log("Logger initialized with rotation")