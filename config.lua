local config = {}
config.settings = {click_interval_ms = 50, total_clicks = 100, button = "left"}

function config.validate()
  local errors = {}
  if type(config.settings.click_interval_ms) ~= "number" or config.settings.click_interval_ms <= 0 then
    table.insert(errors, "click_interval_ms must be positive number")
    config.settings.click_interval_ms = 50
  end
  if type(config.settings.total_clicks) ~= "number" or config.settings.total_clicks < 1 then
    table.insert(errors, "total_clicks must be positive integer")
    config.settings.total_clicks = 100
  end
  if config.settings.button ~= "left" and config.settings.button ~= "right" then
    table.insert(errors, "button must be left or right")
    config.settings.button = "left"
  end
  if #errors > 0 then
    print("Edge case errors corrected:")
    for _, e in ipairs(errors) do print(" - " .. e) end
  end
  return #errors == 0
end

function config.load(path)
  local file, err = io.open(path, "r")
  if not file then print("Warning: no config file. " .. (err or "")) return false end
  local content = file:read("*all") file:close()
  local func, load_err = load("return " .. content, "config", "t", {})
  if not func then print("Parse error: " .. (load_err or "")) return false end
  local ok, data = pcall(func)
  if not ok then print("Exec error: " .. tostring(data)) return false end
  if type(data) ~= "table" then print("Config not table") return false end
  for k, v in pairs(data) do if config.settings[k] ~= nil then config.settings[k] = v end end
  return true
end

function config.get(key)
  if config.settings[key] == nil then error("Unknown key: " .. key) end
  return config.settings[key]
end

function config.run()
  local status, interval = pcall(config.get, "click_interval_ms")
  if not status then interval = 50 end
  local status2, total = pcall(config.get, "total_clicks")
  if not status2 then total = 100 end
  local count = 0
  while count < total do
    print("Click " .. config.settings.button .. " #" .. count+1)
    local start = os.clock()
    while os.clock() - start < interval/1000 do end
    count = count + 1
  end
end

config.validate()
config.load("settings.lua")
config.run()