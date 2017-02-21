local setmetatable = setmetatable
local imagebox = require("wibox.widget.imagebox")
local io = io
local os = os
-- local button = require("awful.button")
-- local naughty = require("naughty")
local capi = { timer = timer }
-- ## MAX < -45  1 < -65 2 < -85 3 > -85

local network = { mt = {} }

function network:update(w)
	local handle = io.popen("iwconfig wlp1s0 | grep \"Signal level\" | cut -d- -f2 | grep -o \"[0-9]\\+\"","r")
	local info = handle:read("*a")
	handle:close()
	-- naughty.notify({preset = naughty.config.presets.critical,title = "test network",text = info})
	local image = "~/.config/awesome/themes/zenburn/wifi-0.png"
	local signalNum = tonumber(info)
	if ( signalNum ~= nil ) then
		if (signalNum > 35) then
			image = "~/.config/awesome/themes/zenburn/wifi-1.png"
		elseif (signalNum > 55) then
			image = "~/.config/awesome/themes/zenburn/wifi-2.png"
		elseif (signalNum > 75) then 
			image = "~/.config/awesome/themes/zenburn/wifi-3.png"
		end
	else 
		image = "~/.config/awesome/themes/zenburn/wifi-none.png"
	end
	w:set_image(image)
end

function network.new()
	local timeout = timeout or 8
	local w = imagebox()
	
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() network:update(w)  end)
	timer:start()
	timer:emit_signal("timeout")
	return w
end

function network.mt:__call(...)
	return network.new(...)
end

return setmetatable(network, network.mt)
