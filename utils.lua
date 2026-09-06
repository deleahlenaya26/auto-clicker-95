local utils = {}

local MIN_INTERVAL_MS = 1
local MAX_INTERVAL_MS = 3600000
local DEFAULT_FALLBACK_MS = 100

local function sanitize_interval(ms)
    if type(ms) ~= "number" or ms ~= ms then
        return DEFAULT_FALLBACK_MS, "invalid type or NaN interval detected"
    end
    if ms < MIN_INTERVAL_MS then
        return MIN_INTERVAL_MS, "interval clamped to minimum threshold"
    end
    if ms > MAX_INTERVAL_MS then
        return MAX_INTERVAL_MS, "interval clamped to maximum cap"
    end
    return math.floor(ms + 0.5), nil
end

function utils.guarded_execute(action_fn, interval_ms, onError)
    local safe_ms, edge_warning = sanitize_interval(interval_ms)
    
    if edge_warning and type(onError) == "function" then
        pcall(onError, edge_warning, safe_ms)
    end

    if type(action_fn) ~= "function" then
        return false, "target action is not executable"
    end

    local status, err = xpcall(action_fn, function(e)
        return debug and debug.traceback and debug.traceback(e, 2) or tostring(e)
    end)

    if not status then
        local log_msg = string.format("[AutoClicker95:Fault] %s | SafeDelay: %dms", tostring(err), safe_ms)
        if type(onError) == "function" then
            pcall(onError, log_msg, safe_ms)
        end
        return false, log_msg
    end

    return true, safe_ms
end

function utils.create_safe_counter(max_clicks)
    local count = 0
    local limit = tonumber(max_clicks) or math.huge
    if limit < 0 then limit = math.huge end

    return setmetatable({}, {
        __call = function(_, step)
            local delta = tonumber(step) or 1
            if delta <= 0 then delta = 1 end
            if count >= limit then return false, "click limit reached" end
            count = count + delta
            return true, count
        end,
        __index = {
            reset = function() count = 0 end,
            get = function() return count end
        }
    })
end

return utils