--[[ 
  @type ClickerConfig
  @field delay number: Interval between clicks in seconds
  @field jitter number: Random variance to bypass detection
]]

--- Simulates a mouse click with jitter randomization
--- @param x number Horizontal coordinate
--- @param y number Vertical coordinate
--- @param config ClickerConfig Configuration settings
--- @return boolean success Status of the operation
local function perform_click(x, y, config)
  local variance = math.random() * config.jitter
  local sleep_time = config.delay + variance
  
  print(string.format("Clicking at [%d, %d] after %.3f seconds", x, y, sleep_time))
  
  os.execute(string.format("sleep %.2f", sleep_time))
  return true
end

--- Primary execution loop for auto-clicker-95
--- @param points table List of coordinates to click
--- @param config ClickerConfig
local function run_cycle(points, config)
  for _, pos in ipairs(points) do
    local status = perform_click(pos.x, pos.y, config)
    if not status then break end
  end
end

local app_config = { delay = 0.5, jitter = 0.1 }
local target_points = { {x = 100, y = 200}, {x = 500, y = 500} }

run_cycle(target_points, app_config)