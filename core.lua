--[[ 
  @module core
  @description high-frequency simulation engine for auto-clicker-95
]]

---@class ClickEngine
---@field interval number The delay between clicks in seconds
---@field running boolean State of the simulation loop
local ClickEngine = {}

---@type ClickEngine
local instance = {interval = 0.01, running = false}

---@param delay number
---@return boolean success
function instance:set_speed(delay)
  if delay < 0.001 then return false end
  self.interval = delay
  return true
end

---@param duration number
---@return nil
function instance:execute_burst(duration)
  local stop_time = os.clock() + duration
  self.running = true
  
  while self.running and os.clock() < stop_time do
    -- Simulated system event: mouse_event(MOUSEEVENTF_LEFTDOWN)
    os.execute("sleep " .. self.interval)
  end
  
  self.running = false
end

return instance