local utils = {}
utils.retry_queue = {}

function utils.enqueue_retry(task_fn, on_success, on_failure, max_attempts)
    local item = {
        task = task_fn,
        on_success = on_success,
        on_failure = on_failure,
        max_attempts = max_attempts or 5,
        attempt = 0,
        next_run = 0,
        fib_prev = 0,
        fib_curr = 1
    }
    table.insert(utils.retry_queue, item)
end

function utils.update_retries(current_time)
    for i = #utils.retry_queue, 1, -1 do
        local item = utils.retry_queue[i]
        if current_time >= item.next_run then
            item.attempt = item.attempt + 1
            local ok, success, result = pcall(item.task)
            if ok and success then
                if item.on_success then item.on_success(result) end
                table.remove(utils.retry_queue, i)
            else
                local err = result or "network operation failed"
                if item.attempt >= item.max_attempts then
                    if item.on_failure then item.on_failure(err) end
                    table.remove(utils.retry_queue, i)
                else
                    local next_wait = item.fib_prev + item.fib_curr
                    item.fib_prev = item.fib_curr
                    item.fib_curr = next_wait
                    local jitter = (math.random() * 200) / 1000
                    item.next_run = current_time + next_wait + jitter
                end
            end
        end
    end
end

return utils