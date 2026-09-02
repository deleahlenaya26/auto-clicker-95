local core = {}
local click_positions = {{x=100, y=100}, {x=200, y=200}}
local pos_index = 1
local stats_buffer = {}
local buffer_size = 64
for i = 1, buffer_size do
  stats_buffer[i] = {time=0, count=0}
end
local buffer_index = 1
local total_clicks = 0
local function get_next_position()
  local pos = click_positions[pos_index]
  pos_index = pos_index % #click_positions + 1
  return pos.x, pos.y
end
local function record_stat(click_time)
  local entry = stats_buffer[buffer_index]
  entry.time = click_time
  entry.count = total_clicks
  buffer_index = buffer_index % buffer_size + 1
end
function core.perform_clicks(clicks_per_second, duration_seconds)
  local interval = 1.0 / clicks_per_second
  local end_time = os.clock() + duration_seconds
  local next_click = os.clock()
  local clicks_done = 0
  while os.clock() < end_time do
    local now = os.clock()
    if now >= next_click then
      local x, y = get_next_position()
      total_clicks = total_clicks + 1
      clicks_done = clicks_done + 1
      record_stat(now)
      next_click = next_click + interval
    end
  end
  return clicks_done
end
function core.get_average_click_rate()
  local sum = 0
  local count = 0
  for i=1, buffer_size do
    if stats_buffer[i].time > 0 then
      sum = sum + stats_buffer[i].time
      count = count + 1
    end
  end
  if count > 1 then
    local first = stats_buffer[1].time
    local last_idx = buffer_index - 1
    if last_idx < 1 then last_idx = buffer_size end
    local last = stats_buffer[last_idx].time
    return (count - 1) / (last - first)
  end
  return 0
end
function core.reset_stats()
  total_clicks = 0
  buffer_index = 1
  for i=1, buffer_size do
    stats_buffer[i].time = 0
    stats_buffer[i].count = 0
  end
end
return core