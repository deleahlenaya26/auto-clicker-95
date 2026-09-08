local Helpers = {}

local function get_timestamp()
  return os.date('%H:%M:%S')
end

Helpers.log = function(message, level)
  level = level or 'INFO'
  print(string.format('[%s][%s] %s', get_timestamp(), level, message))
end

Helpers.clamp = function(val, min, max)
  return math.max(min, math.min(max, val))
end

Helpers.format_delay = function(ms)
  local seconds = ms / 1000
  return string.format('%.2fs', seconds)
end

Helpers.serialize_config = function(tbl)
  local s = '{ '
  for k, v in pairs(tbl) do
    s = s .. tostring(k) .. ' = ' .. tostring(v) .. ', '
  end
  return s .. '}'
end

Helpers.safe_execute = function(func, ...)
  local status, err = pcall(func, ...)
  if not status then
    Helpers.log('Execution failure: ' .. tostring(err), 'ERROR')
  end
  return status
end

return Helpers