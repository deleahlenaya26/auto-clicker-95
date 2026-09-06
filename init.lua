local fs = require('fs')
local os = require('os')

local log_config = {
  path = 'autoclicker.log',
  max_size = 1024 * 512, -- 512KB
  backup_suffix = '.old'
}

local function rotate_logs()
  local info = fs.stat(log_config.path)
  if info and info.size > log_config.max_size then
    fs.rename(log_config.path, log_config.path .. log_config.backup_suffix)
  end
end

local function logger(level, message)
  rotate_logs()
  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local entry = string.format('[%s] [%s] %s\n', timestamp, level, message)
  
  local file, err = io.open(log_config.path, 'a')
  if file then
    file:write(entry)
    file:close()
  else
    io.stderr:write('Log access failure: ' .. tostring(err) .. '\n')
  end
end

-- Exporting the logger utility
return {
  info = function(msg) logger('INFO', msg) end,
  error = function(msg) logger('ERROR', msg) end
}