-- auto-clicker-95 configuration management
local json = require('json')

local ConfigManager = {
    storage_path = 'settings.dat',
    defaults = {
        cps = 10,
        toggle_key = 'f6',
        jitter_radius = 2
    }
}

function ConfigManager.load()
    local file = io.open(ConfigManager.storage_path, 'r')
    if not file then return ConfigManager.defaults end
    
    local content = file:read('*all')
    file:close()
    
    local ok, data = pcall(json.decode, content)
    return ok and data or ConfigManager.defaults
end

function ConfigManager.save(data)
    local file = io.open(ConfigManager.storage_path, 'w')
    if file then
        file:write(json.encode(data, {indent = true}))
        file:close()
    end
end

function ConfigManager.apply_patch(patch)
    local current = ConfigManager.load()
    for k, v in pairs(patch) do
        current[k] = v
    end
    ConfigManager.save(current)
end

return ConfigManager