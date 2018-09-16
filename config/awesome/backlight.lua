-- 
-- display infomation of backlight
--

local setmetatable = setmetatable
local os = os
local io = io
local naughty = require("naughty")

local backlight = { mt = {} }

local steps = 5

local notifyid = nil

function popen(cmd)
    local handle = io.popen(cmd,"r")
    local info = handle:read("*a")
    handle:close()
	return info
end

function notice(vol)
	local barlen = 40
	local notification = nil
	if notifyid then
		notification = naughty.getById(notifyid)
	end
	if not notification then
		notification = naughty.notify({
			title = 'Backlight ' .. vol,
			text = string.rep("|", barlen),
			timeout = 3,
		})
		notifyid = notification.id
	end

	local n = tonumber(vol)
	local s = math.floor(n/100*barlen)
	local e = barlen - s
	local bar = string.rep("|", s) .. string.rep("-", e)

	local title = 'Backlight ' .. math.floor(n) .. '%'
	naughty.replace_text(notification, title, bar)
	naughty.reset_timeout(notification, 3)
end

function backlight.dec()
	local info = popen('xbacklight -dec ' .. steps .. ' && xbacklight')
	notice(info)
end

function backlight.inc()
	local info = popen('xbacklight -inc ' .. steps .. ' && xbacklight')
	notice(info)
end

return backlight   

