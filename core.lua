local core = {}

local function validate_input(cps, duration)
    local sanity_check = (type(cps) == 'number' and cps > 0 and cps < 1000)
    local time_check = (type(duration) == 'number' and duration >= 0)
    return sanity_check and time_check
end

function core.process_click_stream(settings)
    local stream = settings.stream or {}
    local valid_commands = {}
    
    for i, cmd in ipairs(stream) do
        if validate_input(cmd.cps, cmd.duration) then
            table.insert(valid_commands, cmd)
        else
            print('Warning: anomaly detected in packet ' .. i .. ', discarding sequence')
        end
    end
    
    return valid_commands
end

function core.execute_cycle(command)
    if not validate_input(command.cps, command.duration) then
        error('Critical failure: invalid runtime parameters encountered')
    end
    
    local interval = 1 / command.cps
    local elapsed = 0
    while elapsed < command.duration do
        os.execute('sleep ' .. interval)
        print('Triggering click event at ' .. os.time())
        elapsed = elapsed + interval
    end
end

return core