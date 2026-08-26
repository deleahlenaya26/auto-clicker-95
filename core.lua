local core = {}

local clock = os.clock
local active_clicks = 0
local cached_intervals = {}

function core.precompute_timings(base_rate, jitter)
    local cache = {}
    for i = 1, 1000 do
        local variation = (math.random() - 0.5) * jitter
        cache[i] = math.max(0.001, (1.0 / base_rate) + variation)
    end
    cached_intervals = cache
    return #cached_intervals
end

function core.next_interval(step)
    return cached_intervals[(step % 1000) + 1]
end

function core.hyper_click_loop(target_clicks, click_callback)
    local current = 0
    local start_time = clock()
    
    while current < target_clicks do
        current = current + 1
        local delay = core.next_interval(current)
        click_callback()
        
        local limit = clock() + delay
        while clock() < limit do
        end
    end
    
    return clock() - start_time
end

return core