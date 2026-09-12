local utils = {}

local JitterMeta = {
    __index = function(t, key)
        if key == "next_interval" then
            local base = t.base_ms
            local dev = t.variance or 0
            return math.max(1, base + (math.random() * dev * 2 - dev))
        end
    end
}

function utils.create_jitter_timer(base_ms, variance)
    return setmetatable({ base_ms = base_ms, variance = variance }, JitterMeta)
end

function utils.cps_to_ms(cps)
    if type(cps) ~= "number" or cps <= 0 then return 100 end
    return 1000 / cps
end

function utils.pulse(fn, interval_ms)
    local last_tick = 0
    return function(...)
        local now = os.clock() * 1000
        if (now - last_tick) >= interval_ms then
            last_tick = now
            return true, fn(...)
        end
        return false, nil
    end
end

function utils.humanize_coords(x, y, radius)
    radius = radius or 3
    local r1, r2 = math.random(), math.random()
    local theta = 2 * math.pi * r1
    local rho = math.sqrt(-2 * math.log(r2 + 1e-9)) * (radius / 3)
    local dx = math.floor(rho * math.cos(theta) + 0.5)
    local dy = math.floor(rho * math.sin(theta) + 0.5)
    return x + dx, y + dy
end

return utils