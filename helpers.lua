local helpers = {}

local function validate_input(value, min, max, name)
    if type(value) ~= 'number' then
        error(string.format('input %s must be number, got %s', name, type(value)), 2)
    end
    if value < min or value > max then
        return math.max(min, math.min(max, value))
    end
    return value
end

function helpers.safe_click_interval(ms)
    local status, result = pcall(validate_input, ms, 10, 60000, 'click_interval')
    if not status then
        print('[!] invalid interval, defaulting to 100ms: ' .. result)
        return 100
    end
    return result
end

function helpers.execute_safely(fn, ...)
    local success, err = pcall(fn, ...)
    if not success then
        local log = io.open('crash.log', 'a')
        if log then
            log:write(os.date('%c') .. ' | Error: ' .. tostring(err) .. '\n')
            log:close()
        end
        return nil, err
    end
    return true, err
end

return helpers