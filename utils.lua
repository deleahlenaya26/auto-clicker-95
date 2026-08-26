---@class AutoClickerUtils
local utils = {}

---Clamps a number between a minimum and maximum boundary.
---@param val number The value to clamp
---@param min number The lower bound
---@param max number The upper bound
---@return number clamped_value The resulting clamped number
function utils.clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

---Formats milliseconds into a human-readable click interval string.
---@param ms number The milliseconds to format
---@return string formatted_time The formatted time representation
function utils.format_interval(ms)
    if ms < 1000 then
        return string.format("%dms", ms)
    else
        return string.format("%.2fs", ms / 1000)
    end
end

---Generates a pseudo-random jitter offset for click timing.
---@param base_cps number Base clicks per second
---@param variance number Maximum deviation percentage
---@return number jittered_delay Calculated delay in milliseconds
function utils.calculate_jitter(base_cps, variance)
    local base_delay = 1000 / math.max(base_cps, 0.1)
    local jitter_range = base_delay * (variance or 0.05)
    local random_offset = (math.random() * 2 - 1) * jitter_range
    return utils.clamp(base_delay + random_offset, 1, 60000)
end

return utils