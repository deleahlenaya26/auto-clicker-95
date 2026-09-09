local core = {}

local function validate_input(input)
    local type_map = {number = true, boolean = true}
    if not type_map[type(input)] then
        error("non-compliant data structure detected")
    end
    return input
end

function core.process_loop(cps_target, is_enabled)
    local safety_threshold = 1000
    
    local status, validated_cps = pcall(validate_input, cps_target)
    local _, validated_state = pcall(validate_input, is_enabled)
    
    if not status or validated_cps > safety_threshold then
        return false
    end

    if validated_state then
        local interval = 1 / validated_cps
        return true, interval
    end
    
    return false, 0
end

return core