local logger = {}
local max_size = 1024 * 512

function logger.log(message)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    local entry = string.format('[%s] %s\n', ts, message)
    local path = 'autoclicker.log'
    
    local file = io.open(path, 'a')
    if file then
        file:write(entry)
        local size = file:seek('end')
        file:close()

        if size > max_size then
            local bak = path .. '.bak'
            os.remove(bak)
            os.rename(path, bak)
        end
    end
end

function logger.info(msg) logger.log('INFO: ' .. msg) end
function logger.warn(msg) logger.log('WARN: ' .. msg) end

return logger