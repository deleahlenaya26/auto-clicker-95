local helpers = {}
function helpers.sleep(seconds)
  local start_time = os.clock()
  while os.clock() - start_time < seconds do
  end
end
function helpers.fibonacci(n)
  if n < 2 then
    return n
  end
  return helpers.fibonacci(n - 1) + helpers.fibonacci(n - 2)
end
function helpers.retry_network_operation(operation, max_retries, initial_delay)
  max_retries = max_retries or 5
  initial_delay = initial_delay or 0.5
  local attempt = 0
  local last_error
  while attempt < max_retries do
    attempt = attempt + 1
    local success, result = pcall(operation)
    if success then
      return result
    end
    last_error = result
    if attempt < max_retries then
      local fib_delay = helpers.fibonacci(attempt)
      local wait_time = initial_delay * fib_delay
      local jitter = math.random() * 0.2
      wait_time = wait_time + jitter
      helpers.sleep(wait_time)
    end
  end
  error("Network operation failed after " .. max_retries .. " retries. Last error: " .. tostring(last_error))
end
function helpers.create_network_helper(base_url)
  return function(endpoint)
    local function network_call()
      if math.random() < 0.3 then
        error("simulated network timeout")
      end
      return "success from " .. base_url .. endpoint
    end
    return helpers.retry_network_operation(network_call, 3, 0.1)
  end
end
return helpers