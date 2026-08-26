local helpers = {}

function helpers.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end

function helpers.serialize(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("%q", k) or tostring(k)
        local valStr
        if type(v) == "table" then
            valStr = helpers.serialize(v)
        elseif type(v) == "string" then
            valStr = string.format("%q", v)
        else
            valStr = tostring(v)
        end
        table.insert(result, "[" .. key .. "] = " .. valStr)
    end
    return "{ " .. table.concat(result, ", ") .. " }"
end

function helpers.deserialize(str)
    local f, err = load("return " .. str)
    if not f then return nil, err end
    local success, res = pcall(f)
    if not success then return nil, res end
    return res
end

function helpers.jitter(base, variance)
    local factor = 1 + ((math.random() * 2 - 1) * variance)
    return math.floor(base * factor)
end

return helpers