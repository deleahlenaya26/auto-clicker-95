local Core = {}

local clock = os.clock
local pcall = pcall

-- Zero-allocation click pool preventing garbage collector spikes
local pool = {}
for i = 1, 128 do
    pool[i] = { x = 0, y = 0, timestamp = 0 }
end
local index = 1

local function get_event(x, y, t)
    local ev = pool[index]
    ev.x = x
    ev.y = y
    ev.timestamp = t
    index = (index % 128) + 1
    return ev
end

Core.cps = 10
Core.active = false
Core.last_trigger = 0

function Core.setup(config)
    Core.cps = config.cps or 10
    Core.click_fn = config.click_fn or function() end
    Core.active = false
end

-- Fast-path tick loop with cached state mapping
function Core.tick(current_x, current_y)
    if not Core.active then return false end
    
    local now = clock()
    local delay = 1.0 / Core.cps
    
    if now - Core.last_trigger >= delay then
        local ev = get_event(current_x, current_y, now)
        local ok, err = pcall(Core.click_fn, ev)
        Core.last_trigger = now
        return ok, err
    end
    
    return false
end

function Core.toggle(state)
    if state == nil then
        Core.active = not Core.active
    else
        Core.active = not not state
    end
    Core.last_trigger = clock()
end

return Core