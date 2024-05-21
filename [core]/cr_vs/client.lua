local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 600, 500
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2
local clickTick = 0

local maxScroll = 11
local firstScroll = 0
local secondScroll = 0

local fonts = {
    font1 = exports.cr_fonts:getFont("sf-regular", 10),
    font2 = exports.cr_fonts:getFont("sf-bold", 25),
    font3 = exports.cr_fonts:getFont("sf-bold", 30),
}

local players = {{},{}}
local gameStarted = false
local blips = {}

addCommandHandler("vs", function()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(renderTimer) then
	        showCursor(true)
	        renderTimer = setTimer(function()
	            dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(25, 25, 25, 255))
				dxDrawText("VS Etkinliği", (screenX + sizeX / 2) - (dxGetTextWidth("VS Etkinliği", 1, fonts.font2) / 2), screenY + 15, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font2)
				
				dxDrawText("Kırmızı Takım " .. "(" .. #players[1] .. "/100)", screenX + 20, screenY + 65, nil, nil, tocolor(231, 76, 60, 255), 1, fonts.font1)
	            dxDrawRectangle(screenX + 20, screenY + 88, 250, sizeY - 158, tocolor(18, 18, 18, 255))
				
				local newFN = 0
				local newFY = 0
				for index, player in pairs(players[1]) do
					if index > firstScroll and newFN < maxScroll then
						local color = index % 2 == 0 and tocolor(20, 20, 20, 255) or tocolor(32, 32, 32, 255)
						local playerName = player == localPlayer and getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ") (Sen)" or getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ")"
						
						dxDrawRectangle(screenX + 21, screenY + 89 + newFY, 248, 30, color)
						dxDrawText(playerName, screenX + 36, screenY + 95 + newFY, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
						
						newFN = newFN + 1
						newFY = newFY + 31
					end
				end
				
				dxDrawText("Mavi Takım " .. "(" .. #players[2] .. "/100)", screenX + 579, screenY + 65, nil, nil, tocolor(116, 185, 255, 255), 1, fonts.font1, "right")
	            dxDrawRectangle(screenX + 330, screenY + 88, 250, sizeY - 158, tocolor(18, 18, 18, 255))
				
				local newSN = 0
				local newSY = 0
				for index, player in pairs(players[2]) do
					if index > secondScroll and newSN < maxScroll then
						local color = index % 2 == 0 and tocolor(20, 20, 20, 255) or tocolor(33, 33, 33, 255)
						local playerName = player == localPlayer and getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ") (Sen)" or getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ")"
						
						dxDrawRectangle(screenX + 331, screenY + 89 + newSY, 248, 30, color)
						dxDrawText(playerName, screenX + 346, screenY + 95 + newSY, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
						
						newSN = newSN + 1
						newSY = newSY + 31
					end
				end
				
				if not isPlayerInTeam(1, localPlayer) then
					dxDrawRectangle(screenX + 20, screenY + 450, 250, 30, exports.cr_ui:inArea(screenX + 20, screenY + 450, 250, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
					dxDrawText("Takıma Katıl", screenX + 140, screenY + 456, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
					
					if exports.cr_ui:inArea(screenX + 20, screenY + 450, 250, 30) and getKeyState("mouse1") and clickTick+500 < getTickCount() then
						clickTick = getTickCount()
						if not gameStarted then
							triggerServerEvent("vs.joinTeam", localPlayer, 1)
						else
							exports.cr_infobox:addBox("error", "Şuanda oyun başlamış durumda.")
						end
					end
				else
					dxDrawRectangle(screenX + 20, screenY + 450, 250, 30, exports.cr_ui:inArea(screenX + 20, screenY + 450, 250, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
					dxDrawText("Takımdan Ayrıl", screenX + 140, screenY + 456, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
					
					if exports.cr_ui:inArea(screenX + 20, screenY + 450, 250, 30) and getKeyState("mouse1") and clickTick+500 < getTickCount() then
						clickTick = getTickCount()
						if not gameStarted then
							triggerServerEvent("vs.leaveTeam", localPlayer)
						else
							exports.cr_infobox:addBox("error", "Şuanda oyun başlamış durumda.")
						end
					end
				end
				
				if not isPlayerInTeam(2, localPlayer) then
					dxDrawRectangle(screenX + 330, screenY + 450, 250, 30, exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 450, 250, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
					dxDrawText("Takıma Katıl", screenX + 455, screenY + 456, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
					
					if exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 450, 250, 30) and getKeyState("mouse1") and clickTick+500 < getTickCount() then
						clickTick = getTickCount()
						if not gameStarted then
							triggerServerEvent("vs.joinTeam", localPlayer, 2)
						else
							exports.cr_infobox:addBox("error", "Şuanda oyun başlamış durumda.")
						end
					end
				else
					dxDrawRectangle(screenX + 330, screenY + 450, 250, 30, exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 450, 250, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
					dxDrawText("Takımdan Ayrıl", screenX + 455, screenY + 456, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
					
					if exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 450, 250, 30) and getKeyState("mouse1") and clickTick+500 < getTickCount() then
						clickTick = getTickCount()
						if not gameStarted then
							triggerServerEvent("vs.leaveTeam", localPlayer)
						else
							exports.cr_infobox:addBox("error", "Şuanda oyun başlamış durumda.")
						end
					end
				end
	        end, 0, 0)
	    else
	        killTimer(renderTimer)
	        showCursor(false)
	    end
	end
end, false, false)

function renderScoreUI()
	dxDrawRectangle((screenSize.x - 160) / 2, 0, 80, 80, tocolor(116, 185, 255, 220))
	dxDrawText(#players[1], (screenSize.x - 77) / 2, 13, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font3, "center")
	
	dxDrawRectangle((screenSize.x) / 2, 0, 80, 80, tocolor(231, 76, 60, 220))
	dxDrawText(#players[2], (screenSize.x + 80) / 2, 13, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font3, "center")
end

bindKey("mouse_wheel_down", "down", function()
	if isTimer(renderTimer) then
		if exports.cr_ui:inArea(screenX + 20, screenY + 88, 250, sizeY - 158) then
			if firstScroll < #players[1] - maxScroll then
				firstScroll = firstScroll + 1
			end
		elseif exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 88, 250, sizeY - 158) then
			if secondScroll < #players[2] - maxScroll then
				secondScroll = secondScroll + 1
			end
		end
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if isTimer(renderTimer) then
		if exports.cr_ui:inArea(screenX + 20, screenY + 88, 250, sizeY - 158) then
			if firstScroll > 0 then
				firstScroll = firstScroll - 1
			end
		elseif exports.cr_ui:inArea(screenX + sizeX - 270, screenY + 88, 250, sizeY - 158) then
			if secondScroll > 0 then
				secondScroll = secondScroll - 1
			end
		end
	end
end)

addEvent("vs.assignSettings", true)
addEventHandler("vs.assignSettings", root, function(_players, _gameStarted)
	players = _players
	gameStarted = _gameStarted
end)

addEvent("vs.startGame", true)
addEventHandler("vs.startGame", root, function()
	if isTimer(renderTimer) then
		killTimer(renderTimer)
		showCursor(false)
	end
	
	blips.blue = createBlip(2214.7578125, -1431.3525390625, 23.828125, 30)
	blips.red = createBlip(2521.1845703125, -2009.7021484375, 13.546875, 20)
	addEventHandler("onClientRender", root, renderScoreUI)
end)

addEvent("vs.eliminatePlayer", true)
addEventHandler("vs.eliminatePlayer", root, function()
	if isEventHandlerAdded("onClientRender", root, renderScoreUI) then
		removeEventHandler("onClientRender", root, renderScoreUI)
	end
	
	if isElement(blips.blue) then
		destroyElement(blips.blue)
	end

	if isElement(blips.red) then
		destroyElement(blips.red)
	end
end)

addEventHandler("onClientPlayerDamage", root, function(attacker, weapon, bodypart)
	if (attacker) and (attacker ~= source) then
		if gameStarted then
			if (isPlayerInTeam(1, source) and isPlayerInTeam(1, attacker)) or (isPlayerInTeam(2, source) and isPlayerInTeam(2, attacker)) then
				cancelEvent()
			end
		end
	end
end)

function isPlayerInTeam(teamID, player)
    for _, p in ipairs(players[teamID]) do
        if p == player then
            return true
        end
    end
    return false
end

function isPlayerInGame()
	return (isPlayerInTeam(1, localPlayer) or isPlayerInTeam(2, localPlayer)) and gameStarted
end

function isEventHandlerAdded(eventName, attachedTo, handlerFunction)
    if type(eventName) == "string" and isElement(attachedTo) and type(handlerFunction) == "function" then
        local aAttachedFunctions = getEventHandlers(eventName, attachedTo)
        if type(aAttachedFunctions) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == handlerFunction then
                    return true
                end
            end
        end
    end
    return false
end