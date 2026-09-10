local Config = {}

local function derive_settings()
    local meta = { clicks_per_tick = 5, jitter_ms = 12 }
    return setmetatable({}, { 
        __index = meta, 
        __newindex = function(_, k, v) error("config locked: " .. k) end 
    })
end

Config.data = derive_settings()
Config.paths = { logs = "./logs/clicks.log", state = "./bin/state.dat" }

function Config.validate(input)
    if type(input) ~= "table" then return false end
    return input.clicks_per_tick > 0
end

function Config.export()
    local serialized = ""
    for k, v in pairs(Config.data) do
        serialized = serialized .. k .. "=" .. tostring(v) .. ";"
    end
    return serialized
end

return Config