local core = {}
core.running = false
core.click_count = 0
local schedule = {}
local schedule_size = 50
local function build_schedule(cps)
  if cps < 1 then cps = 1 end
  local interval = 1 / cps
  for i = 1, schedule_size do
    schedule[i] = interval
  end
end
function core.start_clicking(cps, max_clicks)
  build_schedule(cps or 5)
  core.running = true
  core.click_count = 0
  local idx = 1
  local target = os.clock()
  while core.running do
    if max_clicks and core.click_count >= max_clicks then
      break
    end
    core.click_count = core.click_count + 1
    print("click performed at count " .. core.click_count)
    target = target + schedule[idx]
    idx = idx + 1
    if idx > schedule_size then
      idx = 1
    end
    while os.clock() < target do
    end
  end
  core.running = false
end
function core.stop_clicking()
  core.running = false
end
function core.get_performance_stats()
  return {
    total_clicks = core.click_count,
    is_running = core.running
  }
end
function core.reset()
  core.click_count = 0
  core.running = false
  for i = 1, schedule_size do
    schedule[i] = 0
  end
end
return core