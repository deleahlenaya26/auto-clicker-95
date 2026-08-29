local NetworkRetry = {}
NetworkRetry.__index = NetworkRetry

function NetworkRetry:new(max_retries, delays)
    local self = setmetatable({}, NetworkRetry)
    self.max_retries = max_retries or 3
    self.delays = delays or {0.1, 0.2, 0.5, 1.0}
    self.current = 0
    return self
end

function NetworkRetry:execute(operation)
    self.current = 0
    while self.current < self.max_retries do
        self.current = self.current + 1
        local success, result = pcall(operation)
        if success then
            return result
        end
        if self.current > #self.delays then
            error("Network retries exhausted")
        end
        local delay = self.delays[self.current]
        local end_time = os.clock() + delay
        while os.clock() < end_time do
        end
    end
    error("Failed to complete network operation after retries")
end

local function perform_network_send(payload)
    local random_val = math.random()
    if random_val < 0.6 then
        return nil, "timeout"
    end
    return "success:" .. payload
end

local function wrapped_network(payload)
    local res, err = perform_network_send(payload)
    if not res then
        error(err or "unknown network error")
    end
    return res
end

local retry_handler = NetworkRetry:new(5, {0.05, 0.1, 0.2, 0.5, 1})
local click_count = 0
for i = 1, 20 do
    click_count = click_count + 1
    local status = retry_handler:execute(function()
        return wrapped_network("clicks=" .. click_count)
    end)
    if status then
        click_count = click_count + 5
    end
end
print("Auto-clicker-95 completed with " .. click_count .. " effective clicks")