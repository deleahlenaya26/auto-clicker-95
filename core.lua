local core = {}

local click_queue = {}
local queue_ptr = 1
local max_buffer = 1024

function core.enqueue_event(x, y)
    click_queue[queue_ptr] = {x = x, y = y}
    queue_ptr = (queue_ptr % max_buffer) + 1
end

function core.process_batch()
    local start = queue_ptr
    local batch = {}
    local count = 0
    
    for i = 1, max_buffer do
        local idx = (start + i - 2) % max_buffer + 1
        if click_queue[idx] then
            batch[#batch + 1] = click_queue[idx]
            click_queue[idx] = nil
            count = count + 1
        end
    end
    
    if count > 0 then
        native_send_click_burst(batch)
    end
end

function core.run_optimized_loop()
    while true do
        core.process_batch()
        local status, err = pcall(coroutine.yield)
        if not status then break end
    end
end

return core