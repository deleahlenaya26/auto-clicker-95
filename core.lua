local logger = {}

local function get_timestamp()
    return os.date('%Y-%m-%d_%H-%M-%S')
end

function logger.rotate(log_path, max_size)
    local file = io.open(log_path, 'r')
    if not file then return end
    local size = file:seek('end')
    file:close()

    if size > (max_size or 1048576) then
        os.rename(log_path, log_path .. '.' .. get_timestamp() .. '.old')
    end
end

function logger.log(message)
    local log_path = 'autoclicker.log'
    logger.rotate(log_path, 512000)

    local file = io.open(log_path, 'a')
    if file then
        file:write(string.format('[%s] %s\n', get_timestamp(), message))
        file:close()
    end
end

logger.log('system initialized: auto-clicker-95 operational')

return logger