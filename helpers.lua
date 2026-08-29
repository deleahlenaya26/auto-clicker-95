local helpers = {}
helpers = setmetatable(helpers, {__call = function(_, data) return helpers.process(data) end})
function helpers.process(clickData)
  if not clickData or type(clickData) ~= "table" then return {error = "invalid data"} end
  local result = {}
  local totalDelay = 0
  local numClicks = 0
  for i, item in ipairs(clickData) do
    if type(item) == "table" and item.x and item.y then
      local delay = item.delay or 100
      totalDelay = totalDelay + delay
      numClicks = numClicks + 1
      result[i] = {coords = {item.x, item.y}, timing = delay, hash = (item.x * 31 + item.y) % 10000}
    end
  end
  if numClicks > 0 then result.avg = totalDelay / numClicks end
  return result
end
function helpers.batchHandle(datasets)
  local processed = {}
  for _, ds in ipairs(datasets) do
    table.insert(processed, helpers.process(ds))
  end
  return processed
end
function helpers.createBuffer(size)
  local buf = {}
  local pos = 0
  return setmetatable({}, {__index = function(t, k)
    if k == "push" then
      return function(val)
        pos = pos + 1
        if pos > size then pos = 1 end
        buf[pos] = val
      end
    elseif k == "get" then
      return function()
        local out = {}
        for i=1, size do if buf[i] then table.insert(out, buf[i]) end end
        return out
      end
    end
  end})
end
return helpers