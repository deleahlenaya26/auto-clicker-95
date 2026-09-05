local logger = {}
local max_size = 1024 * 512
local log_path = 'clicker.log'

function logger.rotate()
    local f = io.open(log_path, 'r')
    if f then
        local content = f:read('*a')
        f:close()
        local backup = io.open(log_path .. '.old', 'w')
        if backup then
            backup:write(content)
            backup:close()
        end
        os.remove(log_path)
    end
end

function logger.log(message)
    local f = io.open(log_path, 'a')
    if f then
        local pos = f:seek('end')
        if pos > max_size then
            f:close()
            logger.rotate()
            f = io.open(log_path, 'a')
        end
        local timestamp = os.date('%Y-%m-%d %H:%M:%S')
        f:write(string.format('[%s] %s\n', timestamp, message))
        f:close()
    end
end

logger.log('auto-clicker-95 session initialized')
return logger