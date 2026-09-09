local auto = {}

local state = { active = false, interval = 0.1 }

local function execute_click()
  if not state.active then return end
  mouse_event(0x0002) -- MOUSEEVENTF_LEFTDOWN
  mouse_event(0x0004) -- MOUSEEVENTF_LEFTUP
end

auto.toggle = function()
  state.active = not state.active
  return state.active
end

auto.run = function()
  local clock = os.clock
  local last = clock()
  
  while true do
    local now = clock()
    if state.active and (now - last) >= state.interval then
      execute_click()
      last = now
    end
    sleep(0.01)
  end
end

return auto