local setmetatable = setmetatable
local imagebox = require("wibox.widget.imagebox")
local io = io
local os = os
local button = require("awful.button")
local gears = require("gears")
local naughty = require("naughty")

local screensave = { mt = {} }
local images_dir = gears.filesystem.get_configuration_dir() .. '/images/'

function screensave:update(w)
	local handle = io.popen("xset -q","r")
	local info = handle:read("*a")
	handle:close()
	local timeout = string.match(info, "timeout%:%s+(%d+)")
	local image = images_dir .. "bulb-red.png"
	if (tonumber(timeout) > 0 ) then
		image = images_dir .. "bulb-grey.png"
	end
	w:set_image(image)
end

function screensave:toggle(w)
	local handle = io.popen("xset -q","r")
	local info = handle:read("*a")
	handle:close()
	local timeout = string.match(info, "timeout%:%s+(%d+)")
	-- naughty.notify({title = "test screensave",text = timeout})
	-- naughty.notify({preset = naughty.config.presets.critical,title = "test screensave",text = info})
	local image = images_dir .. "bulb-grey.png"
	if (tonumber(timeout) > 0 ) then
		image = images_dir .. "bulb-red.png"
		os.execute("xset s off;xset -dpms")
	else
		os.execute("xset s 600;xset dpms")
	end
	w:set_image(image)
end

function screensave.new()
	local w = imagebox()
	w:buttons(gears.table.join(
			button({}, 1, function() screensave:toggle(w) end)
		))
	screensave:update(w)
	return w
end

function screensave.mt:__call(...)
	return screensave.new(...)
end

return setmetatable(screensave, screensave.mt)
