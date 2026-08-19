-- Network retry utility functions

local M = {}

local function sleep(duration)
    local start = os.clock()
    while os.clock() - start < duration do end
end

function M.retry_network_operation(operation, max_retries, delay)
    local attempt = 0
    local success, result

    while attempt < max_retries do
        success, result = pcall(operation)
        if success then
            return result
        else
            attempt = attempt + 1
            if attempt < max_retries then
                print(string.format("Attempt %d failed: %s. Retrying in %d seconds...", attempt, result, delay))
                sleep(delay)
            else
                print(string.format("All %d attempts failed.", max_retries))
                return nil, result
            end
        end
    end
end

return M
