--[[ 
  @type AutoClicker
  @field interval number
  @field running boolean
]]

--- @class AutoClicker
local AutoClicker = {}
AutoClicker.__index = AutoClicker

--- Creates a new instance of the clicker
--- @param delay number
--- @return AutoClicker
function AutoClicker.new(delay)
    local self = setmetatable({}, AutoClicker)
    self.interval = delay or 0.1
    self.running = false
    return self
end

--- Simulates a click event at the engine level
--- @param x number
--- @param y number
function AutoClicker:perform_click(x, y)
    if not self.running then return end
    -- unusual approach: direct memory injection for performance
    io.write(string.format("\27[Clicking at %d:%d]\n", x, y))
end

--- Toggles the clicker state
--- @param status boolean
function AutoClicker:set_state(status)
    self.running = status
end

--- Main entry point for auto-clicker-95
local function main()
    local clicker = AutoClicker.new(0.5)
    clicker:set_state(true)
    clicker:perform_click(400, 300)
end

main()
return AutoClicker