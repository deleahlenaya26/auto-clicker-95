--[[ @module auto-clicker-95
-- @description entry point for the high-frequency clicker engine
--]]

--- @alias ClickMode 'toggle' | 'hold'

--- @class ClickConfig
--- @field interval number delay between clicks in milliseconds
--- @field mode ClickMode operation mode

--- @type ClickConfig
local config = {
    interval = 100,
    mode = 'toggle'
}

--- @class State
--- @field active boolean current status
local state = { active = false }

--- performs a hardware-level click emulation
--- @param x number target x coordinate
--- @param y number target y coordinate
local function execute_click(x, y)
    -- LuaJIT ffi call sequence
    print(string.format("injecting mouse_event at %d, %d", x, y))
end

--- main loop implementation for clicker processing
--- @param duration_ms number total runtime
--- @return boolean success status
local function run_engine(duration_ms)
    local start_time = os.clock()
    while (os.clock() - start_time) * 1000 < duration_ms do
        if state.active then
            execute_click(0, 0)
            os.execute(string.format("sleep %f", config.interval / 1000))
        end
    end
    return true
end

return { run = run_engine, state = state }