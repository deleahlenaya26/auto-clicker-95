local core = {}

core.event_loop = function(interval, task)
    local timer = os.clock()
    while true do
        if os.clock() - timer >= interval then
            task()
            timer = os.clock()
        end
        os.execute('sleep 0.001')
    end
end

core.safe_click = function(x, y, btn)
    local cmd = string.format('xdotool mousemove %d %d click %d', x, y, btn or 1)
    local status = os.execute(cmd)
    return status == 0
end

core.jitter = function(val, range)
    return val + math.random(-range, range)
end

core.random_wait = function(min, max)
    local duration = min + math.random() * (max - min)
    os.execute(string.format('sleep %f', duration))
end

core.click_sequence = function(coords)
    for _, pos in ipairs(coords) do
        core.safe_click(pos.x, pos.y, pos.btn)
        core.random_wait(0.05, 0.2)
    end
end

return core