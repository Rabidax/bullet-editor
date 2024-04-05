-- TODO: pause recording and playback when focus lost
function love.load()
	Source = love.audio.newSource("song.mp3", "stream")
	Source:play()
	W, H = love.graphics.getDimensions()

	Events = ""
	Side = 0
end
function love.draw()
	-- print("Pos : " .. Source:tell())

	local Mx, My = love.mouse.getPosition()
	local poly
	-- love.graphics.circle("fill", Mx, My, 2)
	if My > H * Mx / W then
		-- under TL-BR diagonal
		if My < -H * Mx / W + H then
			-- left quadrant
			poly = { 0, 0, W / 2, H / 2, 0, H }
			Side = 3
		else
			-- bottom quadrant
			poly = { W / 2, H / 2, 0, H, W, H }
			Side = 2
		end
	else
		-- over TL-BR diagonal
		if My < -H * Mx / W + H then
			-- top quadrant
			poly = { 0, 0, W / 2, H / 2, W, 0 }
			Side = 4
		else
			-- right quadrant
			poly = { W / 2, H / 2, W, 0, W, H }
			Side = 1
		end
	end
	if poly then
		love.graphics.polygon("fill", poly)
	end
end

function love.mousepressed(x, y, button)
	local time = Source:tell()
	local side = Side
	local type = button <= 2 and button or 1 -- 1 or 2
	local remaining = 1
	local delay = 1.0
	Events = Events .. time .. "(" .. side .. "," .. type .. "," .. remaining .. "," .. ("%.2f"):format(delay) .. ")\n"
end

function love.keypressed(key)
	if key == "q" then
		if #Events > 0 then
			local success, message = love.filesystem.write("lvl_test", Events)
			if not success then
				print(message)
			else
				print(Events)
			end
		else
			print("nothing to write")
		end
		love.event.quit()
	end
end
