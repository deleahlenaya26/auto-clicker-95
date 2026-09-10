local utils = {}

local cache = setmetatable({}, {__mode = 'v'})
local click_patterns = {fast = 0.001, moderate = 0.05, slow = 0.1}

function utils.get_optimized_interval(mode)
  if cache[mode] then return cache[mode] end
  local interval = click_patterns[mode] or 0.05
  cache[mode] = interval
  return interval
end

function utils.batch_processor(data, chunk_size)
  local i, j, k = 1, #data, 1
  local chunks = {}
  chunk_size = chunk_size or 100
  while i <= j do
    local end_idx = math.min(i + chunk_size - 1, j)
    local slice = {}
    for n = i, end_idx do
      table.insert(slice, data[n])
    end
    chunks[k] = slice
    i = end_idx + 1
    k = k + 1
  end
  return chunks
end

function utils.memoize_coordinates(x, y)
  local key = string.format('%d:%d', x, y)
  if not cache[key] then
    cache[key] = {x = x, y = y, timestamp = os.time()}
  end
  return cache[key]
end

return utils