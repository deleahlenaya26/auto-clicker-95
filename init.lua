---@class ClickConfig
---@field cps number Clicks per second target
---@field jitter number Random timing variance in milliseconds
---@field button "left" | "right" | "middle" Mouse button to trigger

---@class AutoClicker95
---@field private active boolean Engine pulse status
---@field private config ClickConfig Target parameters
---@field private click_count integer Total clicks registered
local AutoClicker95 = {}
AutoClicker95.__index = AutoClicker95

--- Creates a retro clicker pulse engine with anti-pattern jitter.
---@param config? table Optional initial configuration overrides
---@return AutoClicker95
function AutoClicker95.new(config)
    local self = setmetatable({}, AutoClicker95)
    self.active = false
    self.click_count = 0
    self.config = {
        cps = (config and config.cps) or 10,
        jitter = (config and config.jitter) or 15,
        button = (config and config.button) or "left"
    }
    return self
end

--- Calculates next delay using pseudo-random Gaussian approximation.
---@return number delay_seconds Time to wait before next impulse
function AutoClicker95:calc_delay()
    local base_delay = 1.0 / math.max(1, self.config.cps)
    local variance = (math.random() - 0.5) * (self.config.jitter / 1000.0)
    return math.max(0.001, base_delay + variance)
end

--- Toggles active status of the automated pulse loop.
---@param state? boolean Explicit state override
---@return boolean new_state Current active state
function AutoClicker95:toggle(state)
    if state ~= nil then
        self.active = state
    else
        self.active = not self.active
    end
    return self.active
end

--- Executes one discrete click event impulse.
---@return integer total_clicks Updated total click tally
function AutoClicker95:pulse()
    if not self.active then return self.click_count end
    self.click_count = self.click_count + 1
    return self.click_count
end

--- Returns engine status metrics.
---@return table Snapshot of current state and stats
function AutoClicker95:stats()
    return {
        active = self.active,
        clicks = self.click_count,
        target_cps = self.config.cps
    }
end

return AutoClicker95