local utils = {}

function utils.throttle(func, delay)
    local last = 0
    return function(...)
        local now = os.time()
        if now - last >= delay then
            last = now
            return func(...)
        end
    end
end

function utils.random_jitter(base, range)
    math.randomseed(os.time())
    return base + math.random(-range, range)
end

function utils.pack_click(x, y, btn)
    return {pos = {x = x, y = y}, button = btn or 1, ts = os.time()}
end

function utils.serialize_session(data)
    local s = ""
    for k, v in pairs(data) do
        s = s .. tostring(k) .. "=" .. tostring(v) .. ";"
    end
    return s
end

function utils.safe_execute(task, ...)
    local status, result = pcall(task, ...)
    if not status then
        print("[CRITICAL] operation failed: " .. tostring(result))
        return nil
    end
    return result
end

return utils