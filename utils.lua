local utils = {}
local max_size = 1024 * 50

function utils.get_file_size(path)
    local file = io.open(path, "r")
    if not file then return 0 end
    local size = file:seek("end")
    file:close()
    return size
end

function utils.rotate_logs(base_path)
    if utils.get_file_size(base_path) < max_size then return end
    local old_path = base_path .. ".old"
    os.remove(old_path)
    os.rename(base_path, old_path)
end

function utils.setup_logger(filename)
    local path = filename or "clicker.log"
    return {
        log = function(self, level, msg)
            utils.rotate_logs(path)
            local file = io.open(path, "a")
            if file then
                local entry = string.format("[%s] [%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), level, msg)
                file:write(entry)
                file:close()
            end
        end
    }
end

return utils