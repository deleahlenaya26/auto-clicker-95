local helpers = {}

function helpers.gaussian_jitter(base_ms, dev)
    local u1, u2 = math.random(), math.random()
    if u1 < 1e-6 then u1 = 1e-6 end
    local z0 = math.sqrt(-2.0 * math.log(u1)) * math.cos(2.0 * math.pi * u2)
    local result = base_ms + (z0 * dev)
    return math.max(1, math.floor(result + 0.5))
end

function helpers.drift_stream(base_delay, max_drift)
    local current = base_delay
    return function()
        local shift = (math.random() - 0.48) * max_drift
        current = math.max(10, math.min(base_delay * 3, current + shift))
        return math.floor(current)
    end
end

function helpers.bezier_path(p0, p1, p2, steps)
    local path = {}
    steps = math.max(2, steps or 10)
    for i = 0, steps do
        local t = i / steps
        local inv = 1 - t
        local x = inv * inv * p0.x + 2 * inv * t * p1.x + t * t * p2.x
        local y = inv * inv * p0.y + 2 * inv * t * p1.y + t * t * p2.y
        path[#path + 1] = { x = math.floor(x + 0.5), y = math.floor(y + 0.5) }
    end
    return path
end

function helpers.screen_clamp(pt, bounds)
    bounds = bounds or { min_x = 0, min_y = 0, max_x = 1920, max_y = 1080 }
    return {
        x = math.max(bounds.min_x, math.min(bounds.max_x, pt.x)),
        y = math.max(bounds.min_y, math.min(bounds.max_y, pt.y))
    }
end

return helpers