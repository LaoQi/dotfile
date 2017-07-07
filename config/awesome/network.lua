local setmetatable = setmetatable
local imagebox = require("wibox.widget.imagebox")
local gfs = require("gears.filesystem")
local naughty = require("naughty")
local io = io
local os = os
-- local button = require("awful.button")
-- local naughty = require("naughty")
local capi = { timer = timer }
-- ## MAX < -45  1 < -65 2 < -85 3 > -85

local network = { mt = {} }

local images_dir = gfs.get_configuration_dir()..'/images/'

function network:update(w)
	local handle = io.popen("iwconfig", "r")
	local info = handle:read("*a")
	handle:close()
	local signalstr = string.match(info, "Signal% level%=%-(%d+)% dBm")
	local image = "wifi-0.png"
	local signalNum = tonumber(signalstr)
	if ( signalNum ~= nil ) then
		if (signalNum > 35) then
			image = "wifi-1.png"
		elseif (signalNum > 55) then
			image = "wifi-2.png"
		elseif (signalNum > 75) then 
			image = "wifi-3.png"
		end
	else 
		image = "wifi-none.png"
	end
	w:set_image(images_dir .. image)
end

function network.new()
	local timeout = timeout or 5
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
