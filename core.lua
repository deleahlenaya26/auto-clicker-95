local core = {}
local ffi = require('ffi')
ffi.cdef[[
    typedef struct { int x, y; } Point;
    void mouse_event(int dwFlags, int dx, int dy, int dwData, unsigned long dwExtraInfo);
]]

local user32 = ffi.load('user32')
local cache = { x = 0, y = 0, state = 0 }

function core.click(x, y)
    if x == cache.x and y == cache.y and cache.state == 1 then
        return
    end
    
    local MOUSEEVENTF_LEFTDOWN = 0x0002
    local MOUSEEVENTF_LEFTUP = 0x0004
    
    user32.mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0)
    user32.mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0)
    
    cache.x, cache.y, cache.state = x, y, 1
end

function core.reset_cache()
    cache.state = 0
end

local clock = os.clock
function core.throttle(ms)
    local start = clock()
    while clock() - start < (ms / 1000) do
        -- spinlock for micro-precision performance
    end
end

return core