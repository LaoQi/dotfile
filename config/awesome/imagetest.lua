local setmetatable = setmetatable
local imagebox = require("wibox.widget.imagebox")

local imagetest = { mt = {} }

function imagetest.new()
	local w = imagebox()
	w:set_image("~/.config/awesome/themes/zenburn/layouts/tile.png")

	return w
end

function imagetest.mt:__call(...)
	return imagetest.new(...)
end

return setmetatable(imagetest, imagetest.mt)
