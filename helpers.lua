local helpers = {}

--- Creates a clicker helper object using metatable.
--- @param base_interval number base time between clicks
--- @param humanize boolean whether to add randomness
--- @return table
function helpers.create_clicker(base_interval, humanize)
    local obj = {interval = base_interval or 50, humanize = humanize or false, clicks = 0, active = false}
    local mt = {__index = function(t, k)
        if k == "start" then return function() t.active = true end
        elseif k == "stop" then return function() t.active = false end
        elseif k == "do_click" then return function()
            if t.active then
                t.clicks = t.clicks + 1
                local delay = t.interval
                if t.humanize then delay = delay + (math.random(-10, 10)) end
                return delay
            end
            return 0
        end end
        return rawget(t, k)
    end}
    setmetatable(obj, mt)
    return obj
end

--- Computes the effective click rate.
--- @param interval_ms number
--- @return number
function helpers.interval_to_rate(interval_ms)
    if interval_ms <= 0 then return 0 end
    return 1000 / interval_ms
end

--- Validates configuration table.
--- @param config table
--- @return boolean, string?
function helpers.validate_config(config)
    if type(config) ~= "table" then return false, "config must be table" end
    if type(config.interval) ~= "number" or config.interval < 1 then return false, "invalid interval" end
    if config.button and config.button ~= "left" and config.button ~= "right" then return false, "invalid button" end
    return true
end

--- Generates click positions in a spiral pattern.
--- @param x number starting x
--- @param y number starting y
--- @param turns number number of turns
--- @param points_per_turn number
--- @return table
function helpers.spiral_pattern(x, y, turns, points_per_turn)
    local positions = {}
    local r = 5
    local angle = 0
    local dr = 2
    local dangle = 2 * math.pi / points_per_turn
    for i = 1, turns * points_per_turn do
        local px = x + r * math.cos(angle)
        local py = y + r * math.sin(angle)
        table.insert(positions, {math.floor(px), math.floor(py)})
        angle = angle + dangle
        r = r + dr / points_per_turn
    end
    return positions
end

return helpers