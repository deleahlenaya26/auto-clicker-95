local helpers = {}
local default_config = {click_delay = 100, burst_size = 5, use_random = true, max_duration = 60, hotkey_toggle = "F1", window_title = nil}
local function deep_merge(base, override)
    local result = {}
    for k, v in pairs(base) do
        if type(v) == "table" then result[k] = deep_merge(v, override and override[k] or {}) else result[k] = v end
    end
    if override then for k, v in pairs(override) do if type(v) == "table" and type(result[k]) == "table" then result[k] = deep_merge(result[k], v) else result[k] = v end end end
    return result
end
function helpers.load_with_defaults(filename)
    local config = {}
    local file = io.open(filename, "r")
    if file then
        local data = file:read("*a")
        file:close()
        local ok, loaded = pcall(function() local chunk = load("return " .. data, "config", "t", {}) if chunk then return chunk() end end)
        if ok and type(loaded) == "table" then config = loaded end
    end
    local merged = deep_merge(default_config, config)
    setmetatable(merged, {__index = function(_, key) return default_config[key] end})
    return merged
end
function helpers.write_defaults(filename)
    local file = io.open(filename, "w")
    if file then
        file:write("{\n")
        for key, value in pairs(default_config) do
            if type(value) == "string" then file:write(string.format("  %s = \"%s\",\n", key, value))
            elseif type(value) == "boolean" or type(value) == "number" then file:write(string.format("  %s = %s,\n", key, tostring(value))) end
        end
        file:write("}\n")
        file:close()
    end
end
return helpers