-- Auto Clicker 95

local function setupClicker(clickInterval)
    return function()
        while true do
            os.execute("xdotool click 1")  -- Simulating a left click
            os.execute(string.format("sleep %f", clickInterval))
        end
    end
end

local function startClicking()
    local clickInterval = 0.1  -- default interval in seconds
    local clicker = setupClicker(clickInterval)
    clicker()
end

local function main()
    print("Starting Auto Clicker 95...")
    startClicking()
end

main()