-- 
-- display infomation of volume
--

local setmetatable = setmetatable
local os = os
local io = io
local textbox = require("wibox.widget.textbox")
local capi = { timer = timer }
local naughty = require("naughty")

local volume = { mt = {} }

local w = textbox()
local notifyid = nil

function popen(cmd)
    local handle = io.popen(cmd,"r")
    local info = handle:read("*a")
    handle:close()
	return info
end

function notice(info)
	local vol = string.match(info,  "%[(%d+)%%%]")
	local stat = string.match(info, "%[on%]")
	local mute = stat == nil
	local statusbar = "[" .. vol .. "% ON]"
	if mute then
		statusbar = "[" .. vol .. "% OFF]"
	end
	w:set_markup(statusbar)

	local barlen = 40
	local notification = nil
	if notifyid then
		notification = naughty.getById(notifyid)
	end
	if not notification then
		notification = naughty.notify({
			title = vol,
			text = string.rep("|", barlen),
			timeout = 3,
		})
		notifyid = notification.id
	end

	local n = tonumber(vol)
	local s = math.floor(n/100*barlen)
	local e = barlen - s
	local bar = string.rep("|", s) .. string.rep("-", e)

	local title = vol .. "% ON"
	if mute then
		title = vol .. "% OFF" 
	end
	naughty.replace_text(notification, title, bar)
	naughty.reset_timeout(notification, 3)
end

function volume.new(timeout)
	local timeout = timeout or 7
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() volume.update() end)
	timer:start()
	timer:emit_signal("timeout")
    return w
end

function volume.update()
	local info = popen('amixer sget Master')
	local vol = string.match(info,  "%[(%d+)%%%]")
	local stat = string.match(info, "%[on%]")
	local mute = stat == nil
	local statusbar = "[" .. vol .. "% ON]"
	if mute then
		statusbar = "[" .. vol .. "% OFF]"
	end
	w:set_markup(statusbar)
end

function volume.lower()
	local info = popen('amixer sset Master 3%-')
	notice(info)
end

function volume.raise()
	local info = popen('amixer sset Master 3%+')
	notice(info)
end

function volume.toggle()
	local info = popen('amixer sset Master toggle')
	notice(info)
end

function volume.mt:__call(...)
    return volume.new(...)
end

return setmetatable(volume, volume.mt)
    

