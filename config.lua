local M = {}
M.defaults = {
	interval_ms = 50,
	mouse_button = "left",
	hotkey_start = "F8",
	hotkey_stop = "F9",
	max_clicks = 0,
	randomize = false,
	randomize_amount = 10
}

local function merge(base, override)
	local result = {}
	for k, v in pairs(base) do
		result[k] = v
	end
	for k, v in pairs(override) do
		result[k] = v
	end
	return result
end

function M.load(path)
	local loaded = {}
	local file = io.open(path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local chunk = load("return " .. content, "config", "t")
		if chunk then
			local success, data = pcall(chunk)
			if success and type(data) == "table" then
				loaded = data
			end
		end
	end
	local merged = merge(M.defaults, loaded)
	local proxy = {}
	local mt = {
		__index = function(t, key)
			return merged[key]
		end,
		__newindex = function(t, key, value)
			merged[key] = value
		end,
		__pairs = function(t)
			return pairs(merged)
		end
	}
	setmetatable(proxy, mt)
	return proxy
end

function M.save(path, cfg)
	local f = io.open(path, "w")
	if not f then return false end
	f:write("{\n")
	for k, v in pairs(cfg) do
		local valstr
		if type(v) == "string" then
			valstr = string.format("%q", v)
		else
			valstr = tostring(v)
		end
		f:write("  " .. k .. " = " .. valstr .. ",\n")
	end
	f:write("}\n")
	f:close()
	return true
end

return M