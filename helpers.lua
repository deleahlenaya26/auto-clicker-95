local ffi = require('ffi')
ffi.cdef[[
    typedef struct { long x; long y; } point_t;
    void SetCursorPos(int x, int y);
    void mouse_event(int flags, int dx, int dy, int data, unsigned long extra);
]]

local user32 = ffi.load('user32')
local MOUSEEVENTF_LEFTDOWN = 0x0002
local MOUSEEVENTF_LEFTUP = 0x0004

local helpers = {}

function helpers.optimized_click(x, y)
    user32.SetCursorPos(x, y)
    user32.mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    user32.mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
end

local click_cache = {}
function helpers.memoized_coords(x, y)
    local key = string.format('%d:%d', x, y)
    if not click_cache[key] then
        click_cache[key] = {x = x, y = y}
    end
    return click_cache[key]
end

function helpers.clear_cache()
    click_cache = {}
end

return helpers