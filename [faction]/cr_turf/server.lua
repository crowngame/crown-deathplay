local mysql = exports.cr_mysql
local turfs = {}
local positions = {
	-- { x, y, w, h, money },
	{ 1862.2216796875, -1450.5419921875, 115, 100, 100000 },
	{ 2777.6484375, 834.67578125, 150, 200, 100000 },
	{ 2496.06640625, 2666.9658203125, 225, 200, 100000 },
	{ 1103.638671875, -2080.6396484375, 110, 88, 100000 },
	{ -587.72290, -194.92352, 159, 159, 100000 },
	{ -622.76953125, -562.345703125, 157, 94, 100000 },
}

addEventHandler("onResourceStart", resourceRoot, function()
	for i, v in ipairs(positions) do
		local colRectangle = createColRectangle(v[1], v[2], v[3], v[4])
		local teamName = "Boş"
		
		turfs[colRectangle] = { 
			radar = createRadarArea(v[1], v[2], v[3], v[4], 255, 255, 255, 180), 
			teamName = teamName,
			occupier = 100,
			money = v[5],
		}
	end 
end)

function getColPlayerTeam(col, team)
	for i, player in pairs(getElementsWithinColShape(col, "player")) do
		if getPlayerTeam(player) and getPlayerTeam(player) ~= getTeamFromName("Citizen") and getTeamName(getPlayerTeam(player)) == getTeamName(team) and ((getElementData(player, "duty_admin") ~= 1) and (getElementData(player, "duty_supporter") ~= 1)) then
			return true
		else
			return false
		end
	end
	return false
end

function getTeamTurfs(team)
	local turf = {}
	for col, v in pairs(turfs) do
		if v.teamName == getTeamName(team) then
			table.insert(turf, col)
		end
	end
	return turf
end

addEventHandler("onColShapeHit", root, function(player)
	local radar = turfs[source]
	if (radar) then
		setElementData(player, "turf", radar)
	end
end)

addEventHandler("onColShapeLeave", root, function(player)
	setElementData(player, "turf", false)
end)

setTimer(function()
	for col, v in pairs(turfs) do
		for _, player in pairs(getElementsWithinColShape(col, "player")) do
			local team = getPlayerTeam(player)
			if team and getColPlayerTeam(col, team) then
				if getTeamName(team) ~= turfs[col].teamName then
					if turfs[col].occupier > 1 then
						turfs[col].occupier = turfs[col].occupier - 1
						setRadarAreaFlashing(turfs[col].radar, true)
					elseif turfs[col].occupier == 1 then
						local r, g, b = 255, 0, 0
						setRadarAreaFlashing(turfs[col].radar, false)
						setRadarAreaColor(turfs[col].radar, r, g, b, 150)
						turfs[col].teamName = getTeamName(team)
						turfs[col].occupier = 100
						
						local foundBooster = nil
						
						for _, player in ipairs(getPlayersInTeam(team)) do
							triggerClientEvent(player, "playTurfSound", player)
							if getElementData(player, "vip") == 5 and isElementWithinColShape(player, col) then
								foundBooster = player
							end
						end
						
						if foundBooster ~= nil then
							triggerClientEvent(root, "turf.renderUI", root, turfs[col].teamName, getPlayerName(foundBooster), true)
							exports.cr_discord:sendMessage("turf", "**" .. turfs[col].teamName .. "** isimli birlik turfu ele geçirdi ve **" .. getPlayerName(foundBooster):gsub("_", " ") .. "** isimli oyuncu tarafından turf boostlandı.")
							for _, player in ipairs(getPlayersInTeam(team)) do
								local money = turfs[col].money + 250000
								exports.cr_global:giveMoney(player, money)
							end
						else
							triggerClientEvent(root, "turf.renderUI", root, turfs[col].teamName)
							exports.cr_discord:sendMessage("turf", "**" .. turfs[col].teamName .. "** isimli birlik turfu ele geçirdi.")
							for _, player in ipairs(getPlayersInTeam(team)) do
								local money = turfs[col].money
								exports.cr_global:giveMoney(player, money)
							end
						end
						
						exports.cr_pass:addMissionValue(player, 10, 1)
					end
				else
					if turfs[col].occupier < 99 then
						turfs[col].occupier = turfs[col].occupier + 1 
					elseif turfs[col].occupier == 99 then
						local r, g, b = 255, 0, 0
						setRadarAreaFlashing(turfs[col].radar, false)
						setRadarAreaColor(turfs[col].radar, r, g, b, 150)
						turfs[col].teamName = getTeamName(team)
						turfs[col].occupier = 100
					end
				end
			end
			setElementData(player, "turf", turfs[col])
		end
	end
end, 5000, 0)

addEventHandler("onPlayerWasted", root, function(ammo, killer, weapon, bodypart)
	if (killer) and (killer ~= source) and (getElementType(killer) == "player" and getElementType(source) == "player") then
		for col, v in pairs(turfs) do
			if isElementWithinColShape(source, col) then
				setElementPosition(source, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
				setElementInterior(source, 0)
				setElementDimension(source, 0)
				outputChatBox("[!]#FFFFFF " .. getPlayerName(killer):gsub("_", " ") .. " tarafından katledildiniz.", source, 255, 0, 0, true)
				triggerClientEvent(source, "playDragonSound", source)
				
				local faction = getElementData(killer, "faction") or 0
				if faction > 0 then
					local playerTeam = exports.cr_pool:getElement("team", faction)
					local turfKills = getElementData(playerTeam, "turf_kills") or 0
					setElementData(playerTeam, "turf_kills", turfKills + 1)
					dbExec(mysql:getConnection(), "UPDATE factions SET turf_kills = ? WHERE id = ?", turfKills, faction)
				end
			end
		end
	end
end)