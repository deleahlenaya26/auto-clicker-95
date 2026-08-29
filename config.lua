local M = {}
M.defaults = {
    interval = 100,
    clicks = 0,
    button = "left",
    hotkey = "F8",
    random = false,
    pos_x = 0,
    pos_y = 0
}

function M.load(filename)
    local cfg = {}
    for k, v in pairs(M.defaults) do
        cfg[k] = v
    end
    local f = io.open(filename, "r")
    if f then
        for line in f:lines() do
            local key, val = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
            if key and val then
                if val == "true" then
                    val = true
                elseif val == "false" then
                    val = false
                else
                    local num = tonumber(val)
                    if num then val = num end
                end
                cfg[key] = val
            end
        end
        f:close()
    end
    return cfg
end

function M.save(cfg, filename)
    if not cfg or not filename then return false end
    local f = io.open(filename, "w")
    if not f then return false end
    for k, v in pairs(cfg) do
        if type(v) ~= "function" then
            f:write(string.format("%s = %s\n", k, tostring(v)))
        end
    end
    f:close()
    return true
end

function M.get_with_default(cfg, key)
    return cfg[key] or M.defaults[key]
end

return M