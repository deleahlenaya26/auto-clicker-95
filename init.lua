local logger = {}
local log_path = 'auto_clicker.log'
local max_size = 1024 * 1024

local function rotate()
    local f = io.open(log_path, 'r')
    if f then
        f:close()
        os.rename(log_path, log_path .. '.old')
    end
end

function logger.info(msg)
    local f = io.open(log_path, 'a')
    if f then
        local size = f:seek('end')
        if size > max_size then
            f:close()
            rotate()
            f = io.open(log_path, 'a')
        end
        if f then
            f:write(os.date('%Y-%m-%d %H:%M:%S') .. ' [INFO] ' .. msg .. '\n')
            f:close()
        end
    end
end

logger.info('engine initialized, standing by for clicks')
return logger