local config = {}

local defaults = {
    cps = 15,
    key = "F6",
    jitter = false,
    randomize = true,
    sound = "click.wav"
}

function config.load(user_path)
    local loaded = {}
    setmetatable(loaded, { __index = defaults })
    
    local file = io.open(user_path, "r")
    if file then
        for line in file:lines() do
            local k, v = line:match("^%s*(.-)%s*=%s*(.-)%s*$")
            if k and v then
                if v == "true" then v = true
                elseif v == "false" then v = false
                elseif tonumber(v) then v = tonumber(v)
                end
                loaded[k] = v
            end
        end
        file:close()
    end
    
    return loaded
end

return config