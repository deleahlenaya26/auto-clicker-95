local utils = {}

function utils.setup_logger(filepath, max_size_bytes)
    max_size_bytes = max_size_bytes or 1024 * 1024
    
    local function get_size(path)
        local file = io.open(path, "r")
        if not file then return 0 end
        local size = file:seek("end")
        file:close()
        return size
    end

    local function rotate()
        os.remove(filepath .. ".old")
        os.rename(filepath, filepath .. ".old")
    end

    return function(level, message)
        if get_size(filepath) >= max_size_bytes then
            rotate()
        end
        
        local log_file = io.open(filepath, "a")
        if log_file then
            local timestamp = os.date("%Y-%m-%d %H:%M:%S")
            log_file:write(string.format("[%s] [%s] %s\n", timestamp, level, message))
            log_file:close()
        end
    end
end

return utils