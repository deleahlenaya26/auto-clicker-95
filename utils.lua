local utils = {}

local function exponential_backoff(attempt)
  return math.pow(2, attempt) + (math.random() * 0.5)
end

function utils.retry_network_op(func, max_attempts)
  local last_error
  for attempt = 0, max_attempts or 3 do
    local success, result = pcall(func)
    if success then
      return result
    end
    
    last_error = result
    if attempt < (max_attempts or 3) then
      local delay = exponential_backoff(attempt)
      local start = os.clock()
      while os.clock() - start < delay do end
    end
  end
  
  error("network operation failed after retries: " .. tostring(last_error))
end

function utils.safe_fetch(url, callback)
  return utils.retry_network_op(function()
    local response = http.request(url)
    if not response then error("connection timeout") end
    return callback(response)
  end, 5)
end

return utils