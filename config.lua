local config = {}

local defaults = {
    cps = 15,
    hotkey = "F6",
    toggle_sound = true,
    randomization = 0.15,
    click_type = "left"
}

function config.load(user_path)
    local loaded = {}
    local file = io.open(user_path or "settings.dat", "r")
    
    if file then
        for line in file:lines() do
            local k, v = line:match("^%s*(%w+)%s*=%s*(.+)%s*$")
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
    
    setmetatable(loaded, {
        __index = function(_, key)
            return defaults[key]
        end
    })
    
    return loaded
end

return config