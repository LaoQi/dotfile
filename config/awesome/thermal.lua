-- 
-- display infomation of thermal
--

local setmetatable = setmetatable
local os = os
local io = io
local textbox = require("wibox.widget.textbox")
local capi = { timer = timer }

local thermal = { mt = {} }

function thermal.new(timeout)
	local timeout = timeout or 5

    local w = textbox()
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() w:set_markup(thermal.getinfo()) end)
	timer:start()
	timer:emit_signal("timeout")
    return w
end

function thermal.getinfo()
    -- local handle = io.popen('sensors | grep "temp1" | cut -d+ -f2 | head -n 1',"r")
    -- local info = handle:read("*a")
    -- handle:close()
	local f = io.open('/proc/acpi/ibm/thermal')
	if not f then return nil end
	local res = f:read("*a")
	f:close()
	if not res then return nil end
	local t = string.match(res, "%d+")
	return " " .. t .. "℃ "
end


function thermal.mt:__call(...)
    return thermal.new(...)
end

return setmetatable(thermal, thermal.mt)
    

