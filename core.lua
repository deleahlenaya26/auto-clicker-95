local core = {}
core.__index = core

local function create_jitter_generator(base_cps, variance)
    return function()
        local interval = 1.0 / base_cps
        local delta = (math.random() * 2 - 1) * variance
        return math.max(0.001, interval + delta)
    end
end

function core.new(config)
    local cfg = config or {}
    local self = setmetatable({}, core)
    self.cps = cfg.cps or 10
    self.jitter = cfg.jitter or 0.02
    self.active = false
    self.total_clicks = 0
    self.next_interval = create_jitter_generator(self.cps, self.jitter)
    return self
end

function core:step(click_fn)
    if not self.active then return false, 0 end
    
    self.total_clicks = self.total_clicks + 1
    if click_fn then click_fn(self.total_clicks) end
    
    return true, self.next_interval()
end

function core:toggle(state)
    if state == nil then
        self.active = not self.active
    else
        self.active = state
    end
    return self.active
end

function core:reset()
    self.total_clicks = 0
    self.active = false
    return self
end

return core