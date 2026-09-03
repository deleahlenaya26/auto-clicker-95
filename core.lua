local defaults = {
  interval = 0.05,
  button = 'left',
  jitter = 0.02,
  enabled = true
}

local function deep_merge(target, source)
  for k, v in pairs(source) do
    if type(v) == 'table' then
      target[k] = target[k] or {}
      deep_merge(target[k], v)
    else
      target[k] = v
    end
  end
  return target
end

local function load_config(path)
  local cfg = {}
  local chunk, err = loadfile(path)
  if chunk then
    setfenv(chunk, cfg)
    chunk()
  end
  return deep_merge(defaults, cfg)
end

local config = load_config('settings.lua')

local function click_engine()
  if not config.enabled then return end
  local delay = math.max(0.01, config.interval + (math.random() * config.jitter))
  print('clicking ' .. config.button .. ' with delay ' .. delay)
  return delay
end

return { load = load_config, state = config, execute = click_engine }