local players = {}
local font = "default-bold"
local maxDistance = 30
local timeInterval = 0
local maxIconsPerLine = 6
local iconsThisLine = 0
local iconSize = 32
local postGUI = false
local badges = {}
local masks = {}
local settings = {
    font = 1,
    type = 1,
    id = 1,
    border = 1,
    country = 1,
    icon = 1,
    placement = 1,
    rank = 1
}

local function updateFont()
    if settings.font == 1 then
        font = "default-bold"
    elseif settings.font == 2 then
        font = exports.cr_fonts:getFont("sf-regular", 10)
    elseif settings.font == 3 then
        font = exports.cr_fonts:getFont("sf-bold", 10)
    elseif settings.font == 4 then
        font = "default"
    end
end
updateFont()

--===========================================================================================================================================================

function renderNametags()
	if (getElementData(localPlayer, "loggedin") == 1) and not minimizeAfk then
		local cameraX, cameraY, cameraZ = getElementPosition(localPlayer)
		for player, cache in pairs(players) do
			if isElement(player) then
				local boneX, boneY, boneZ
				if settings.placement == 1 then
					boneX, boneY, boneZ = getPedBonePosition(player, 6)
					boneZ = boneZ + 0.14
				else
					boneX, boneY, boneZ = getElementPosition(player)
					boneZ = boneZ + 0.9
				end
				
				local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
				local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
				
				if (aimsAt(player)) or (distance <= maxDistance) and (isElementOnScreen(player)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(player) >= 200) then
					local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
					
					if screenX and screenY then
						local text = ""
						local lineY = 0
						local sectionY = 0
						
						local name = (cache["name"]):gsub("_", " ") .. " (" .. cache["playerid"] .. ")"
						if cache["tinted"] or cache["mask"] or settings.id == 2 then
							name = (cache["name"]):gsub("_", " ")
						end
						
						local r, g, b = cache["nametagColor"].r, cache["nametagColor"].g, cache["nametagColor"].b
						
						if aimsAt(player) then
							alpha = 255
						end
						
						if settings.icon == 1 then
                            local icons = cache["icons"]
							local expectedIcons = math.min(#cache["icons"], maxIconsPerLine)
							local iconW, iconH = 30, 30
							local xpos, ypos = 0, -10
							local offset = iconW * expectedIcons
							
							if #icons > expectedIcons then
								if (settings.font == 1) or (settings.font == 4) then
									lineY = lineY + 26
									sectionY = sectionY + 26
								elseif (settings.font == 2) or (settings.font == 3) then
									lineY = lineY + 27
									sectionY = sectionY + 27
								end
							end
							
							for index, value in ipairs(icons) do
								local fixY = 0
								if settings.type == 1 then
									fixY = 1
								elseif settings.type == 2 then
									fixY = 3
									if (settings.font == 2) or (settings.font == 3) then
										fixY = fixY + 1
									end
								end
								
								dxDrawImage(screenX + xpos - iconW - offset / 2 + 31, screenY + ypos + fixY - 23 - sectionY, iconW - 2, iconH - 2, "public/images/icons/" .. value .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
								
								iconsThisLine = iconsThisLine + 1
								if iconsThisLine == expectedIcons then
									expectedIcons = math.min(#icons - index, maxIconsPerLine)
									offset = iconW * expectedIcons
									iconsThisLine = 0
									xpos = 0
									ypos = ypos + iconH
								else
									xpos = xpos + iconW
								end
							end
							
							if #icons > 0 then
								lineY = lineY + 33
								
								if (settings.font == 1) or (settings.font == 4) then
									sectionY = sectionY + 33
								elseif (settings.font == 2) or (settings.font == 3) then
									sectionY = sectionY + 34
								end
							end
						end
						
						if cache["afk"] then
							text = text .. "\n#f0801d[AFK]"
						end
						
						if cache["protection"] then
							text = text .. "\n#2dda9d[Korumada]"
						end
						
						if cache["baygin"] then
							text = text .. "\n#cd403b[Baygın]"
						end
						
						if cache["adminjailed"] then
							text = text .. "\n#434343[OOC Hapisde]"
						end
						
						if cache["badge"] then
							text = text .. "\n" .. RGBToHex(r, g, b) .. cache["badge"]
						end
						
						text = text .. "\n" .. RGBToHex(r, g, b) .. name
						
						if not tinted then
							if settings.type == 1 then
								local padding = 16
								local width, height = 50, 8
								
								local screenY = screenY - padding + 3
								
								local armor = getPedArmor(player)
								if armor > 0 then
									dxDrawRectangle(screenX - width / 2, screenY - lineY, width, height, tocolor(0, 0, 0), postGUI)
									dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2), height - 2, tocolor(200, 200, 200, 50), postGUI)
									dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2) * armor / 100, height - 2, tocolor(200, 200, 200, alpha), postGUI)
									lineY = lineY + (height + 1)
									
									if (settings.font == 1) or (settings.font == 4) then
										sectionY = sectionY + 9
									elseif (settings.font == 2) or (settings.font == 3) then
										sectionY = sectionY + 10
									end
								end
								
								dxDrawRectangle(screenX - width / 2, screenY - lineY, width, height, tocolor(0, 0, 0, 230), postGUI)
								dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2), height - 2, tocolor(200, 15, 15, 100), postGUI)
								dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2) * getElementHealth(player) / 100, height - 2, tocolor(200, 15, 15, alpha), postGUI)
								
								if (settings.font == 1) or (settings.font == 4) then
									lineY = lineY + 16
								elseif (settings.font == 2) or (settings.font == 3) then
									lineY = lineY + 17
								end
							elseif settings.type == 2 then
								text = text .. "\n#FFFFFFHP: " .. getHealthColor(player) .. math.floor(getElementHealth(player)) .. "%"
								
								if getPedArmor(player) > 0 then
									text = text .. "\n#FFFFFFZırh:#999999 " .. math.floor(getPedArmor(player)) .. "%"
									
									if (settings.font == 1) or (settings.font == 4) then
										sectionY = sectionY + 15
									elseif (settings.font == 2) or (settings.font == 3) then
										sectionY = sectionY + 16
									end
								end
							elseif settings.type == 3 then
								if (settings.font == 1) or (settings.font == 4) then
									lineY = lineY + 5
								elseif (settings.font == 2) or (settings.font == 3) then
									lineY = lineY + 6
								end
								
								if (settings.font == 1) or (settings.font == 4) then
									sectionY = sectionY - 10
								elseif (settings.font == 2) or (settings.font == 3) then
									sectionY = sectionY - 11
								end
							end
						end
						
						if settings.border == 1 then
							dxDrawBorderText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), 1, font, "center", "bottom", false, true, postGUI, true)
						elseif settings.border == 2 then
							dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), screenX + 1, 1, screenX + 1, screenY - lineY + 1, tocolor(0, 0, 0, alpha), 1, font, "center", "bottom", false, true, postGUI, true)
							dxDrawText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), 1, font, "center", "bottom", false, true, postGUI, true)
						elseif settings.border == 3 then
							dxDrawText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), 1, font, "center", "bottom", false, true, postGUI, true)
						end
						
						if (settings.font == 2) or (settings.font == 3) then
							sectionY = sectionY + 1
						end
						
						local textW = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x", ""), scale, font) / 2
						local leftSectionX = 0
						
						if settings.country == 2 then
							dxDrawImage(screenX - textW - 39, screenY - sectionY - 31, 28, 13, "public/images/icons/country/" .. cache["country"] .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
							leftSectionX = leftSectionX + 38
						end
						
						if settings.rank == 2 then
							if cache["rank"] then
								dxDrawImage(screenX - textW - 38 - leftSectionX, screenY - sectionY - 39, 30, 30, ":cr_rank/public/images/" .. cache["rank"] .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
								leftSectionX = leftSectionX + 33
							end
						end
						
						if cache["donater"] > 0 then
							dxDrawImage(screenX - textW - 32 - leftSectionX, screenY - sectionY - 36, 23, 23, "public/images/icons/donater" .. cache["donater"] .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
						end
						
						if cache["writing"] then
							dxDrawImage(screenX + textW + 10, screenY - sectionY - 36, 24, 24, "public/images/icons/writing.png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
						end
						
						if cache["talking"] then
							dxDrawImage(screenX + textW + 10, screenY - sectionY - 36, 24, 24, "public/images/icons/microphone.png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
						end
					end
				end
			end
		end
	end
end
renderNametagsTimer = setTimer(renderNametags, timeInterval, 0)

--===========================================================================================================================================================

function createCache(player)
    if not isElement(player) then
        return
    end
    
	if (player:getData("loggedin") ~= 1) or (localPlayer:getData("loggedin") ~= 1) then
        return
    end

    local icons = {}
    local tinted = false
	local badge = nil
	local mask = false
    local name = player:getName()
	local r, g, b = player:getNametagColor()

    if player:getData("hiddenadmin") ~= 1 then
        if (player:getData("duty_admin") == 1) and (player:getData("admin_level") > 0) then		
            table.insert(icons, "duty/" .. player:getData("admin_level"))
        end

        if (player:getData("duty_supporter") == 1) and (player:getData("supporter_level") > 0) then		
            table.insert(icons, "duty/supporter")
        end
    end

    local vehicle = player:getOccupiedVehicle(player)
	local windowsDown = vehicle and (vehicle:getData("vehicle:windowstat") == 1)

	if vehicle and not windowsDown and vehicle ~= player:getOccupiedVehicle(localPlayer) and vehicle:getData("tinted") then
		name = "Gizli (Cam Filmi) [>" .. (player:getData("dbid")) .. "]"
		tinted = true
	end

    if not tinted then
        if getPlayerMaskState(player) then 
            name = "Gizli [>" .. (player:getData("dbid")) .. "]"
			mask = true
        end

        if player:getData("restrain") == 1 then
            table.insert(icons, "handcuffs")
        end

        if player:getData("smoking") then
            table.insert(icons, "cigarette")
        end

        if player:getData("fullfacehelmet") then
            table.insert(icons, "helmet")
        end

        if player:getData("gasmask") then
            table.insert(icons, "gasmask")
        end

        if player:getData("seatbelt") and vehicle then
            table.insert(icons, "seatbelt")
        end
    end

    if windowsDown and vehicle then
        table.insert(icons, "window")
    end

    if player:getData("vip") > 0 then
        table.insert(icons, "vip" .. player:getData("vip"))
    end

    if settings.country == 1 then
        table.insert(icons, "country/-" .. player:getData("country"))
    end

    for key, data in pairs(badges) do
        local title = player:getData(key)
        if title then
            badge = title:gsub("#%x%x%x%x%x%x", "")
			if not data[5][-1] then
				table.insert(icons, "badge")
			end
        end
    end
	
	if player:getData("tags") then
		for _, value in pairs(player:getData("tags")) do
			table.insert(icons, "tags/" .. value)
		end
	end

    if player:getData("youtuber") == 1 then
        table.insert(icons, "youtuber")
    end

    if player:getData("dm_plus") == 1 then
        table.insert(icons, "dm_plus")
    end
    
    if player:getData("pass_type") == 2 then
        table.insert(icons, "elite_pass")
    end

    if settings.rank == 1 then
        if player:getData("rank") > 0 then
            table.insert(icons, "rank/" .. (player:getData("rank") or 1))
        end
    end

    players[player] = {
        ["player"] = player,
        ["name"] = name,
		["nametagColor"] = { r = r, g = g, b = b },
        ["icons"] = icons,
        ["tinted"] = tinted,
        ["badge"] = badge,
        ["mask"] = mask,
        ["playerid"] = player:getData("playerid"),
        ["afk"] = player:getData("afk"),
        ["protection"] = player:getData("protection"),
        ["baygin"] = player:getData("baygin"),
        ["adminjailed"] = player:getData("adminjailed"),
        ["country"] = player:getData("country"),
		["rank"] = exports.cr_rank:getPlayerRankIndex(player),
        ["donater"] = player:getData("donater"),
        ["writing"] = player:getData("writing"),
		["talking"] = exports.cr_voice:getPlayerTalking(player),
    }
end

function deleteCache(player)
    if players[player] then
        players[player] = nil
    end
end

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
        setPlayerNametagShowing(player, false)
		if isElementStreamedIn(player) then
            if getElementType(player) == "player" then
                createCache(player)
            end
        end
    end
end, 250, 0)

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, newValue, oldValue)
	if theKey == "nametag_settings" then
		settings = {
			font = getElementData(localPlayer, "nametag_settings").font or 1,
			type = getElementData(localPlayer, "nametag_settings").type or 1,
			id = getElementData(localPlayer, "nametag_settings").id or 1,
			border = getElementData(localPlayer, "nametag_settings").border or 1,
			country = getElementData(localPlayer, "nametag_settings").country or 1,
			icon = getElementData(localPlayer, "nametag_settings").icon or 1,
			placement = getElementData(localPlayer, "nametag_settings").placement or 1,
			rank = getElementData(localPlayer, "nametag_settings").rank or 1
		}
		
		updateFont()
	end
end)

loadTimer = setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		for _, value in pairs(exports.cr_items:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5], value[3] }
		end
		
		for _, value in pairs(exports.cr_items:getMasks()) do
			masks[value[1]] = { value[1], value[2], value[3], value[4] }
		end
		
		killTimer(loadTimer)
	end
end, 1000, 0)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "player" then
        createCache(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "player" then
        deleteCache(source)
    end
end)

addEventHandler("onClientPlayerQuit", root, function()
    if getElementType(source) == "player" then
        deleteCache(source)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "player" then
        deleteCache(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    settings = {
		font = getElementData(localPlayer, "nametag_settings").font or 1,
		type = getElementData(localPlayer, "nametag_settings").type or 1,
		id = getElementData(localPlayer, "nametag_settings").id or 1,
		border = getElementData(localPlayer, "nametag_settings").border or 1,
		country = getElementData(localPlayer, "nametag_settings").country or 1,
		icon = getElementData(localPlayer, "nametag_settings").icon or 1,
		placement = getElementData(localPlayer, "nametag_settings").placement or 1,
		rank = getElementData(localPlayer, "nametag_settings").rank or 1
	}
	
	updateFont()
	
	for _, player in ipairs(getElementsByType("player")) do
        setPlayerNametagShowing(player, false)
		if isElementStreamedIn(player) then
            if getElementType(player) == "player" then
                createCache(player)
            end
        end
    end
end)

--===========================================================================================================================================================

addEventHandler("onClientCursorMove", root, function(x, sectionY)
	if isCursorShowing() then
		if getElementData(localPlayer, "afk") and not isMTAWindowActive() then
			setElementData(localPlayer, "afk", false)
		end
	end
end)

addEventHandler("onClientMinimize", root, function()
	setElementData(localPlayer, "afk", true)
    minimizeAfk = true
end)

addEventHandler("onClientRestore", root, function()
	setElementData(localPlayer, "afk", false)
    minimizeAfk = false
end)

--===========================================================================================================================================================


function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and (getPedWeapon(localPlayer) == 22 or getPedWeapon(localPlayer) == 23 or getPedWeapon(localPlayer) == 24 or getPedWeapon(localPlayer) == 25 or getPedWeapon(localPlayer) == 26 or getPedWeapon(localPlayer) == 27 or getPedWeapon(localPlayer) == 28 or getPedWeapon(localPlayer) == 29 or getPedWeapon(localPlayer) == 30 or getPedWeapon(localPlayer) == 31 or getPedWeapon(localPlayer) == 32 or getPedWeapon(localPlayer) == 33 or getPedWeapon(localPlayer) == 34)
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

function getPlayerMaskState(player)
	for index, value in pairs(masks) do
		if player:getData(value[1]) then
			return true
		end
	end
	return false
end

function getHealthColor(player)
	local color = "#9c9c9c"
	
	if getElementHealth(player) <= 30 then
		color = "#ff0000"
	elseif getElementHealth(player) <= 70 then
		color = "#ffd11a"
	else
		color = "#009432"
	end
	
	return color
end

function dxDrawBorderText(message, left, top, width, height, color, size, font, alignX, alignY, clip, wordBreak, postGUI)
    color, size, font, alignX, alignY, clip, wordBreak, postGUI = color or tocolor(255, 255, 255), size or 1, font or "default", alignX or "left", alignY or "top", clip or false, wordBreak or false, postGUI or false
    borderColor = tocolor(0, 0, 0)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top + 1, width + 1, height + 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top - 1, width + 1, height - 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top + 1, width - 1, height + 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top - 1, width - 1, height - 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message, left, top, width, height, color, size, font, alignX, alignY, clip, wordBreak, postGUI, true)
end

function RGBToHex(red, green, blue, alpha)
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end

function toggleNametag(commandName)
	if isTimer(renderNametagsTimer) then
		killTimer(renderNametagsTimer)
		outputChatBox("[!]#FFFFFF Nametag başarıyla kapatıldı, açmak için tekrardan /" .. commandName .. " yazınız.", 0, 255, 0, true)
	else
		renderNametagsTimer = setTimer(renderNametags, timeInterval, 0)
		outputChatBox("[!]#FFFFFF Nametag başarıyla açıldı, kapatmak için tekrardan /" .. commandName .. " yazınız.", 0, 255, 0, true)
	end
end
addCommandHandler("togglenametag", toggleNametag, false, false)
addCommandHandler("tognametag", toggleNametag, false, false)
addCommandHandler("nametagkapat", toggleNametag, false, false)