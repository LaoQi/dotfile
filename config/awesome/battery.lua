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
    handle:close()
	if (info ~= "") then
		info = string.sub(info,12)
		if (string.find(info,"Unknown")) then
			info = string.sub(info,9)
			info = " On-Line" .. info
		end
	else
		info = " AC "
	end
		
	return info
end


function battery.mt:__call(...)
    return battery.new(...)
end

return setmetatable(battery, battery.mt)
    

