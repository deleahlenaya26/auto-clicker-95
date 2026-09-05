local helpers = {}

function helpers.serialize_click_profile(profile)
    local stream = { "-- AUTOCLICKER-95 SCHEMA v1 --" }
    for k, v in pairs(profile) do
        if type(v) == "string" then
            table.insert(stream, string.format('%s = "%s"', k, v))
        else
            table.insert(stream, string.format('%s = %s', k, tostring(v)))
        end
    end
    return table.concat(stream, "\n")
end

function helpers.deserialize_click_profile(data)
    local profile = {}
    for line in data:gmatch("([^\n]+)") do
        if not line:match("^--") then
            local key, val = line:match("(%w+)%s*=%s*(.+)")
            if key then
                val = val:gsub('"', '')
                profile[key] = tonumber(val) or val
            end
        end
    end
    return profile
end

function helpers.validate_interval(ms)
    local min_latency = 10
    local max_latency = 60000
    return math.max(min_latency, math.min(ms, max_latency))
end

return helpers