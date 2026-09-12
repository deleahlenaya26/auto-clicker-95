local ffi = require('ffi')
local bit = require('bit')

ffi.cdef[[
    void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);
]]

local M = {}

local MOUSEEVENTF_LEFTDOWN = 0x0002
local MOUSEEVENTF_LEFTUP = 0x0004

local function fast_click()
    ffi.C.mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    ffi.C.mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
end

function M.execute_sequence(count, interval)
    local start_time = os.clock()
    local delta = interval / 1000
    
    local i = 0
    while i < count do
        fast_click()
        
        local elapsed = os.clock() - start_time
        local target = (i + 1) * delta
        
        if elapsed < target then
            local pause = (target - elapsed) * 0.95
            if pause > 0.001 then
                os.execute('timeout ' .. tostring(pause) .. ' > NUL 2>&1')
            end
        end
        i = i + 1
    end
end

return M