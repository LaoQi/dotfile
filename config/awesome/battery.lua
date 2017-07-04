--
-- display infomation of battery
--

local setmetatable = setmetatable
local os = os
local io = io
local textbox = require("wibox.widget.textbox")
local capi = { timer = timer }

local battery = { mt = {} }

function battery.new(timeout)
	local timeout = timeout or 5

    local w = textbox()
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() w:set_markup(battery.getinfo()) end)
	timer:start()
	timer:emit_signal("timeout")
    return w
end

function battery.getinfo()
    local handle = io.popen("acpi","r")
    local info = handle:read("*a")
	local out = " AC "
    handle:close()
	if (info ~= "") then
		local rate = string.match(info, "[1-9]+%d*%%")
		local charged = string.match(info, "Charging")
		local remaining = string.match(info, "(%d%d:%d%d):%d%d")
		if charged then
			out = string.format(" %s %s until charged ", rate, remaining)
		elseif not remaining then
			out = string.format(" On-Line %s ", rate)
		else
			out = string.format(" Remaining %s %s ", rate, remaining)
		end
	end
		
	return out
end


function battery.mt:__call(...)
    return battery.new(...)
end

return setmetatable(battery, battery.mt)
    

