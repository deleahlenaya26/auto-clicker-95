local fs = require('fs')

local defaults = {
  click_interval = 0.05,
  hotkey = 'F8',
  mode = 'toggle',
  randomize = true
}

local function load_config(path)
  local config = {}
  for k, v in pairs(defaults) do
    config[k] = v
  end

  local ok, data = pcall(fs.read_file, path)
  if not ok then return config end

  for line in data:gmatch('[^\r\n]+') do
    local key, val = line:match('^([^=]+)=(.+)$')
    if key and val then
      key = key:gsub('%s+', ''):lower()
      val = val:gsub('%s+', '')
      
      if tonumber(val) then
        config[key] = tonumber(val)
      elseif val == 'true' or val == 'false' then
        config[key] = (val == 'true')
      else
        config[key] = val
      end
    end
  end
  return config
end

return { load = load_config }