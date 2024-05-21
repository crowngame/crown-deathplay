local counterSizes = {
	x = 250,
	y = 70 
}

local counterPosition = {
	x = (screenSize.x - counterSizes.x) / 2,
	y = (screenSize.y - counterSizes.y) / 1.05,
}

function drawCounter()
	if isRobberyStarted then
		local found = false
		for index, value in pairs(players) do
			if value == localPlayer then
				found = true
			end
		end

		if found then
			local timer = getTimerDetails(counter) or 0
			local text = math.floor(timer / 1000) .. " saniye"
			
			exports.cr_ui:drawRoundedRectangle {
				position = counterPosition,
				size = counterSizes,
				color = theme.GRAY[900],
				alpha = 1,
				radius = 10
			}

			dxDrawText(text, counterPosition.x, counterPosition.y + 17, counterPosition.x + counterSizes.x, counterSizes.y, tocolor(255, 255, 255, 255), 1, fonts[1], "center")

			if math.floor(timer / 1000) == 0 then
				isRobberyStarted = false
				triggerServerEvent("robbery.finishRobbery", localPlayer)
			end
		end
	end
end

function drawInformation()
    if getElementDimension(localPlayer) == 0 and getElementInterior(localPlayer) == 0 then
		local x, y, z = 2312.9345703125, -8.390625, 26.7421875
		local distance = getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(localPlayer)))
		local sx, sy = getScreenFromWorldPosition(x, y, z + 3)
		if (sx) and (sy) then
			local timer = getTimerDetails(counter) or 0
			local text = math.floor(timer / 1000)
			
			dxDrawImage(sx - 25, sy - 80, 50, 50, "public/images/icon.png", 0, 0, -120)
			dxDrawText("Banka Soygunu\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre\n#8AE68A" .. text .. " #FFFFFFsaniye", sx + 2, sy + 2, sx, sy, tocolor(255, 255, 255, 255), 1, fonts[2], "center", "center", false, false, false, true, false)
		end
	end
end