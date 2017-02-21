-- 
-- display infomation of volume
--

local setmetatable = setmetatable
local os = os
local io = io
local textbox = require("wibox.widget.textbox")
local capi = { timer = timer }

local volume = { mt = {} }

function volume.new(timeout)
	local timeout = timeout or 5

    local w = textbox()
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() w:set_markup(volume.getinfo()) end)
	timer:start()
	timer:emit_signal("timeout")
    return w
end

function volume.getinfo()
    -- local handle = io.popen('amixer get Master | grep \"Front Left:\" | cut -d\\[ -f2 | cut -d\\] -f1',"r")
    local handle = io.popen('amixer get Master | grep \"Front Left:\" | cut -d\' \' -f7,8 ',"r")
    local info = handle:read("*a")
    handle:close()
	return " Vol: " .. info
end


function volume.mt:__call(...)
    return volume.new(...)
end

return setmetatable(volume, volume.mt)
    

