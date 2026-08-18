local json = require("dkjson")

local defaultConfig = {
    clickRate = 0.1,
    duration = 60,
    enabled = true,
}

local function loadConfig(filePath)
    local file = io.open(filePath, "r")
    if not file then
        return defaultConfig
    end
    local content = file:read("*a")
    file:close()

    local config, pos, err = json.decode(content, 1, nil)
    if err then
        print("Error loading config: " .. err)
        return defaultConfig
    end

    return setmetatable(config or {}, { __index = defaultConfig })
end

return {
    loadConfig = loadConfig,
    defaultConfig = defaultConfig,
}