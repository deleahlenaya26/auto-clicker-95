local core = {}

local function build_optimized_trigger(config)
    local delay = math.floor(1000 / (config.cps or 10))
    local down_flag = config.button == "right" and 0x0008 or 0x0002
    local up_flag = config.button == "right" and 0x0010 or 0x0004
    
    local batch_size = config.turbo and 4 or 1
    local jitter_range = config.jitter or 0
    
    return function(native_click, native_sleep, state)
        while state.active do
            for _ = 1, batch_size do
                native_click(down_flag)
                native_click(up_flag)
            end
            
            local current_delay = delay
            if jitter_range > 0 then
                current_delay = current_delay + math.random(-jitter_range, jitter_range)
            end
            
            if current_delay > 0 then
                native_sleep(current_delay)
            end
        end
    end
end

function core.create_engine(driver)
    local engine = {
        driver = driver or { click = function() end, sleep = function() end },
        state = { active = false }
    }
    
    function engine:prepare(config)
        self.runner = build_optimized_trigger(config)
    end
    
    function engine:start()
        if not self.runner then error("engine not prepared") end
        self.state.active = true
        self.runner(self.driver.click, self.driver.sleep, self.state)
    end
    
    function engine:stop()
        self.state.active = false
    end
    
    return engine
end

return core