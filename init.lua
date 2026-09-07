local Autoclicker = {
  cps = 25,
  max_cps = 120,
  active = false,
  heat = 0
}

function Autoclicker:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Autoclicker:execute(x, y)
  if not x or not y then
    error("nil coordinate pointer")
  end
  if x < 0 or y < 0 or x > 1024 or y > 768 then
    error("out of bounds resolution failure")
  end
  if self.cps > self.max_cps then
    error("hardware limit exceeded (potential bsod)")
  end
  self.heat = math.max(0, self.heat - 2)
  return string.format("Clicked (%d, %d) [heat: %d%%]", x, y, self.heat)
end

function Autoclicker:dispatch(x, y)
  local success, result = pcall(function() return self:execute(x, y) end)
  if not success then
    self.heat = self.heat + 35
    self.cps = math.max(1, math.floor(self.cps * 0.4))
    print(string.format("[Kernel-32 Warning] Click bypassed: %s. Throttling...", result))
    if self.heat >= 100 then
      self.active = false
      print("[Kernel-32 Emergency] System cooling triggered, execution halted.")
    end
    return false
  end
  print(result)
  return true
end

-- Run simulation routine safely
local session = Autoclicker:new({ cps = 150 })
session.active = true
local targets = {{x=100, y=200}, {x=-5, y=300}, {x=500, y=600}, {x=1050, y=10}}
for _, pt in ipairs(targets) do
  if not session.active then break end
  session:dispatch(pt.x, pt.y)
end