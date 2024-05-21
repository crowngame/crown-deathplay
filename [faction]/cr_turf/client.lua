local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 300, 55
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY)

local theme = exports.cr_ui:useTheme()
local fonts = exports.cr_ui:useFonts()
local announcementFont = exports.cr_fonts:getFont("sf-regular", 11),

setElementData(localPlayer, "turf", false)

setTimer(function()
	local turf = getElementData(localPlayer, "turf")
	if turf then
		exports.cr_ui:drawRoundedRectangle {
			position = {
				x = ((screenSize.x - dxGetTextWidth(turf.teamName, 1, fonts.UbuntuRegular.h3)) / 2) - 40,
				y = screenY - 60
			},
			size = {
				x = dxGetTextWidth(turf.teamName, 1, fonts.UbuntuRegular.h3) + 80,
				y = sizeY
			},

			color = theme.GRAY[900],
			alpha = 1,
			radius = 10
		}
		
		dxDrawText(turf.teamName, screenX, screenY - 47, screenX + sizeX, 0, tocolor(255, 255, 255, 255), 1, fonts.UbuntuRegular.h3, "center")
		exports.cr_ui:dxDrawFramedText("%" .. turf.occupier, screenX, screenY + 5, screenX + sizeX, 0, tocolor(255, 255, 255, 255), 1, fonts.UbuntuBold.h4, "center")
	end
end, 0, 0)

--======================================================================================================================================================================================

local animationTimer = nil
local animationDuration = 4000
local aY = 0
local alpha = 255
local colorPosition = false
local r, g, b = 10, 10, 10

local factionName = "N/A"
local playerName = "N/A"
local isBoost = false

addEvent("turf.renderUI", true)
addEventHandler("turf.renderUI", root, function(_factionName, _playerName, _isBoost)
	animationTimer = nil
	animationDuration = 4000
	aY = 0
	alpha = 255
	colorPosition = false
	r, g, b = 10, 10, 10
	factionName = _factionName or "N/A"
	playerName = _playerName or "N/A"
	isBoost = _isBoost or false
	
	animationTimer = getTickCount()
	addEventHandler("onClientRender", root, renderInformation)
	
	setTimer(function()
		removeEventHandler("onClientRender", root, renderInformation)
	end, 5000, 1)
end)

function renderInformation()
	local now = getTickCount()
	local elapsedTime = now - animationTimer
	
	if aY >= 30 then
		if elapsedTime >= animationDuration then
			if alpha ~= 0 then
				alpha = alpha - 5
			end
		end
	else
		aY = aY + 10
	end
	
	if isBoost then
		if not colorPosition then
			g = 0
			b = 255
			if (r < 255) then
				r = r + 3
				if (r > 255) then r = 255 end
			end
			if (r == 255) then colorPosition = true end
			
		else
			if (r > 0) then
				r = r - 3
				if (r < 0) then r = 0 end
			end
			if (r == 0) then colorPosition = false end
		end
		
		local text = factionName .. " isimli birlik turfu ele geçirdi ve " .. playerName:gsub("_", " ") .. " isimli oyuncu tarafından turf boostlandı."
		local textWidth = dxGetTextWidth(text, 1, announcementFont)
		
		dxDrawRectangle(((screenSize.x - textWidth) / 2) - 20, aY, textWidth + 40, 40, tocolor(r, g, b, alpha))
		dxDrawText(text, (screenSize.x / 2), 11 + aY, nil, nil, tocolor(225, 225, 225, alpha), 1, announcementFont, "center")
	else
		local text = factionName .. " isimli birlik turfu ele geçirdi."
		local textWidth = dxGetTextWidth(text, 1, announcementFont)
		
		dxDrawRectangle(((screenSize.x - textWidth) / 2) - 20, aY, textWidth + 40, 40, tocolor(10, 10, 10, alpha))
		dxDrawText(text, (screenSize.x / 2), 11 + aY, nil, nil, tocolor(225, 225, 225, alpha), 1, announcementFont, "center")
	end
end

addEvent("playTurfSound",true)
addEventHandler("playTurfSound", root, function()
	local sound = playSound("public/sounds/turf.mp3",false) 
	setSoundVolume(sound, 0.5)
end)

addEvent("playDragonSound", true)
addEventHandler("playDragonSound", root, function()
    local sound = playSound("public/sounds/dragon.mp3", false)
	setSoundVolume(sound, 0.5)
end)