local config = {}
config.logger = {
    file = "auto-clicker-95.log",
    max_size = 1024 * 1024,
    max_backups = 5,
    level = "INFO"
}

local log_levels = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4 }

function config.logger:should_log(level)
    return log_levels[level] >= log_levels[self.level]
end

function config.logger:rotate()
    for i = self.max_backups, 2, -1 do
        local src = self.file .. "." .. (i - 1)
        local dst = self.file .. "." .. i
        local handle = io.open(src, "r")
        if handle then
            handle:close()
            pcall(os.remove, dst)
            os.rename(src, dst)
        end
    end
    local handle = io.open(self.file, "r")
    if handle then
        handle:close()
        pcall(os.remove, self.file .. "." .. (self.max_backups + 1))
        os.rename(self.file, self.file .. ".1")
    end
end

function config.logger:write_log(level, msg)
    if not self:should_log(level) then return end
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local log_entry = string.format("%s [%s] %s\n", timestamp, level, msg)
    local handle = io.open(self.file, "a")
    if handle then
        handle:write(log_entry)
        handle:close()
    end
    handle = io.open(self.file, "r")
    if handle then
        local size = handle:seek("end")
        handle:close()
        if size > self.max_size then
            self:rotate()
        end
    end
end

local proxy = {}
setmetatable(proxy, {
    __index = function(t, level)
        return function(msg)
            config.logger:write_log(level, msg)
        end
    end
})

config.log = proxy

function config.setup_logger(settings)
    if settings then
        for k, v in pairs(settings) do
            if config.logger[k] ~= nil then
                config.logger[k] = v
            end
        end
    end
    local h = io.open(config.logger.file, "a")
    if h then h:close() end
end

return config