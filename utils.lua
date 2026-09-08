local logger = {}

local function rotate(path, max_size)
    local file = io.open(path, 'r')
    if not file then return end
    local size = file:seek('end')
    file:close()
    if size > max_size then
        os.remove(path .. '.old')
        os.rename(path, path .. '.old')
    end
end

function logger.log(message)
    local path = 'autoclicker.log'
    rotate(path, 1024 * 100)
    local file = io.open(path, 'a')
    if file then
        local timestamp = os.date('%Y-%m-%d %H:%M:%S')
        file:write(string.format('[%s] %s\n', timestamp, message))
        file:close()
    end
end

logger.log('system initialized')

return logger