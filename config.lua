local Config = {}
Config.__index = Config

local DEFAULTS = {
    cps = 12,
    jitter_ms = 15,
    button = "left",
    burst_mode = false,
    hotkey = "F9",
    win95_sound = true
}

local SANITIZERS = {
    cps = function(v) return math.max(1, math.min(250, tonumber(v) or 12)) end,
    jitter_ms = function(v) return math.max(0, math.min(100, tonumber(v) or 0)) end,
    button = function(v) return (v == "right" or v == "middle") and v or "left" end,
    burst_mode = function(v) return type(v) == "boolean" and v or false end,
    hotkey = function(v) return type(v) == "string" and v:upper() or "F9" end,
    win95_sound = function(v) return not not v end
}

function Config.new(overrides)
    local store = {}
    local proxy = setmetatable({}, {
        __index = function(_, key)
            if store[key] ~= nil then return store[key] end
            return DEFAULTS[key]
        end,
        __newindex = function(_, key, val)
            if SANITIZERS[key] then
                store[key] = SANITIZERS[key](val)
            else
                rawset(store, key, val)
            end
        end
    })

    if type(overrides) == "table" then
        for k, v in pairs(overrides) do
            proxy[k] = v
        end
    end

    return proxy, store
end

function Config.export(proxy_instance, store)
    local snapshot = {}
    for k in pairs(DEFAULTS) do
        snapshot[k] = proxy_instance[k]
    end
    return snapshot
end

function Config.purge(store)
    for k in pairs(store) do
        store[k] = nil
    end
end

return Config