local setmetatable = setmetatable
local imagebox = require("wibox.widget.imagebox")
local io = io
local os = os
local button = require("awful.button")
-- local naughty = require("naughty")

local screensave = { mt = {} }

function screensave:update(w)
	local handle = io.popen("xset -q | grep \"timeout\" | cut -dc -f1 | grep -o \"[0-9]\\+\"","r")
	local info = handle:read("*a")
	local image = "~/.config/awesome/themes/zenburn/bulb-red.png"
	handle:close()
	-- naughty.notify({preset = naughty.config.presets.critical,title = "test screensave",text = info})
	if (tonumber(info) > 0 ) then
		image = "~/.config/awesome/themes/zenburn/bulb-grey.png"
	end
	w:set_image(image)
end

function screensave:toggle(w)
	local handle = io.popen("xset -q | grep \"timeout\" | cut -dc -f1 | grep -o \"[0-9]\\+\"","r")
	local info = handle:read("*a")
	local image = "~/.config/awesome/themes/zenburn/bulb-grey.png"
	handle:close()
	-- naughty.notify({preset = naughty.config.presets.critical,title = "test screensave",text = info})
	if (tonumber(info) > 0 ) then
		image = "~/.config/awesome/themes/zenburn/bulb-red.png"
		os.execute("xset s off;xset -dpms")
	else
		os.execute("xset s 300;xset dpms")
	end
	w:set_image(image)
end

function screensave.new()
	local w = imagebox()
	screensave:update(w)
	return w
end

function screensave.mt:__call(...)
	return screensave.new(...)
end

return setmetatable(screensave, screensave.mt)
