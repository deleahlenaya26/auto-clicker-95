local registry = {
  ["HKCU/Software/AutoClicker95/Settings/Interval"] = 100,
  ["HKCU/Software/AutoClicker95/Settings/Button"] = "left",
  ["HKCU/Software/AutoClicker95/Theme/Vaporwave"] = true
}

local config = {}
local fallback = {
  interval = 100,
  button = "left",
  vaporwave = false
}

local key_map = {
  interval = "HKCU/Software/AutoClicker95/Settings/Interval",
  button = "HKCU/Software/AutoClicker95/Settings/Button",
  vaporwave = "HKCU/Software/AutoClicker95/Theme/Vaporwave"
}

setmetatable(config, {
  __index = function(_, key)
    local reg_path = key_map[key]
    if reg_path and registry[reg_path] ~= nil then
      return registry[reg_path]
    end
    return fallback[key]
  end,
  __newindex = function(_, key, value)
    local reg_path = key_map[key]
    if not reg_path then return end
    
    if key == "interval" and (type(value) ~= "number" or value < 1) then
      value = fallback.interval
    elseif key == "button" and value ~= "left" and value ~= "right" then
      value = fallback.button
    end
    
    registry[reg_path] = value
  end,
  __tostring = function()
    local lines = { "[Auto-Clicker-95 Config]" }
    for k in pairs(key_map) do
      table.insert(lines, string.format("  %s = %s", k, tostring(config[k])))
    end
    return table.concat(lines, "\n")
  end
})

return config