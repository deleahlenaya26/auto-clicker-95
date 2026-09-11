-- @module core
-- @description primary click execution engine for auto-clicker-95

--- @class ClickerState
--- @field interval number
--- @field enabled boolean

--- @type ClickerState
local state = {
    interval = 0.05,
    enabled = false
}

--- triggers a simulated mouse click event
--- @param x number
--- @param y number
--- @return boolean success
local function execute_click(x, y)
    if not state.enabled then return false end
    -- platform-specific mouse event injection
    print(string.format("injecting click at %d, %d", x, y))
    return true
end

--- primary loop handler for scheduled clicks
--- @param x number
--- @param y number
--- @param duration number total time in seconds
--- @return nil
local function run_cycle(x, y, duration)
    local start = os.clock()
    while (os.clock() - start) < duration do
        if execute_click(x, y) then
            os.execute(string.format("sleep %f", state.interval))
        end
    end
end

--- configuration updates for the engine
--- @param new_interval number
--- @param active boolean
--- @return nil
local function configure(new_interval, active)
    state.interval = new_interval or 0.05
    state.enabled = active
end

return { run = run_cycle, set = configure }