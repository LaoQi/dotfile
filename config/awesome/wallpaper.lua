local io = io
local os = os
local screen = screen
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local capi = { timer = timer }

local timeout = 3600 -- hours
local api_url = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
local download_url = "https://www.bing.com"
local wallpaper_dir = os.getenv("HOME") .. "/Wallpaper/"
local wallpaper = nil

local function file_exists(path)
	local f = io.open(path, "r")
	if f ~= nil then io.close(f)
		return true
	else
		return false
	end
end


local function update()
	-- naughty.notify({ title = "debug", text = "update", timeout = 0})
	-- check local file
	local name = os.date("%Y-%m-%d")
	wallpaper = string.format("%s%s.jpg", wallpaper_dir, name)
	if true ~= file_exists(wallpaper) then
		local cmd0 = string.format("curl \"%s\"", api_url)
		awful.spawn.easy_async(cmd0, function (stdout, stderr, reason, exit_code) 
			if 0 ~= exit_code then
				naughty.notify { preset = naughty.config.presets.critical, title = "Request wallpaper", text = stderr}
			else
				local url = string.match(stdout, "\"url\":\"(.-)\"")
				if nil ~= url then
					-- fix wallpaper reset
					wallpaper = string.format("%s%s.jpg", wallpaper_dir, name)
					local cmd1 = string.format("curl \"%s%s\" -o %s", download_url, url, wallpaper)
					naughty.notify { text = "Download new wallpaper " .. wallpaper}
					awful.spawn.easy_async(cmd1, function(stdout, stderr, reason, exit_code)
						if 0 ~= exit_code then
							naughty.notify { preset = naughty.config.presets.critical, title = "Download wallpaper url error", text = stderr }
						else
							screen.emit_signal("property::wallpaper")
						end
					end)
				else
					naughty.notify { preset = naughty.config.presets.critical, title = "Request wallpaper url error", text = stderr }
				end 
			end
		end)

		-- set default
		awful.spawn.with_line_callback("ls -a " .. wallpaper_dir, {
			stdout = function (line)
				if string.match(line, "%.jpg$") then
					wallpaper = wallpaper_dir .. line
				end
			end,
			output_done = function()
				if false ~= file_exists(wallpaper) then
					screen.emit_signal("property::wallpaper")
				end
			end
		})
	end
end

local function init()
	if file_exists(wallpaper_dir) ~= true then
		os.execute("mkdir " .. wallpaper_dir)
	end

	local timeout = timeout or 3600
	local timer = capi.timer { timeout = timeout }
	timer:connect_signal("timeout", function() update()  end)
	timer:start()
	timer:emit_signal("timeout")
end

local function set_wallpaper(s)
	-- check local file
	if file_exists(wallpaper) then
		gears.wallpaper.maximized(wallpaper, s, true)
	elseif beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- initialize
init()

return set_wallpaper
