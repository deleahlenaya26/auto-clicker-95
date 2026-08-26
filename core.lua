local core = {}

local function sanity_check(cfg)
    assert(type(cfg) == "table", "config must be a table entity")
    assert(type(cfg.cps) == "number" and cfg.cps > 0, "cps must be a positive integer")
    assert(type(cfg.key) == "string" and #cfg.key > 0, "key binding must be a non-empty string")
    
    cfg.interval = 1 / cfg.cps
    cfg.burst_limit = cfg.burst_limit or 100
    return true
end

function core.process_loop(raw_config, click_callback)
    local ok, err = pcall(sanity_check, raw_config)
    if not ok then
        io.stderr:write("[AUTO-95 FATAL] input validation failed: ", tostring(err), "\n")
        return false, err
    end

    local active = true
    local iterations = 0

    while active and iterations < raw_config.burst_limit do
        local start_time = os.clock()
        
        click_callback(raw_config.key)
        iterations = iterations + 1
        
        local elapsed = os.clock() - start_time
        local deficit = raw_config.interval - elapsed
        
        if deficit > 0 then
            -- Yield execution precisely to respect CPS limits
            os.execute("sleep " .. tonumber(string.format("%.4f", deficit)))
        end
        
        if iterations >= 1000000 then
            active = false
        end
    end

    return true, iterations
end

return core