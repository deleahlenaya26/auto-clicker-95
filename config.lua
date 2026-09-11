local default_cfg = {
    interval = 100,
    button = 1,
    toggle_key = "F6",
    mode = "random"
}

local config = {}

function config.load(path)
    local settings = setmetatable({}, { __index = default_cfg })
    local file = io.open(path, "r")
    if not file then return settings end

    local chunk = file:read("*a")
    file:close()

    local loaded = loadstring("return " .. chunk)
    if loaded then
        local user_data = loaded()
        for k, v in pairs(user_data) do
            settings[k] = v
        end
    end
    return settings
end

return config