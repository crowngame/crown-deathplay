local players = {{}, {}}
local gameStarted = false
local armorTimer = {}

function vsBasla(thePlayer, commandName)
	if authorizedUsers[getElementData(thePlayer, "account:username")] then
		if not gameStarted then
			gameStarted = true
			
			for index, player in pairs(players[1]) do
				local randomPosition = math.random(1, #positions[1])
				local randomSkin = math.random(1, #skins[1])
				if isPedInVehicle(player) then removePedFromVehicle(player) end
				setElementPosition(player, positions[1][randomPosition][1] + math.random(1, 3), positions[1][randomPosition][2] + math.random(1, 3), positions[1][randomPosition][3])
				setElementInterior(player, 0)
				setElementDimension(player, 1)
				setElementModel(player, skins[1][randomSkin])
				setElementHealth(player, 100)
                setPedArmor(player, 100)
				setElementFrozen(player, false)
				removeElementData(player, "greenzone")
				triggerClientEvent(player, "vs.startGame", player)
			end
			
			for index, player in pairs(players[2]) do
				local randomPosition = math.random(1, #positions[2])
				local randomSkin = math.random(1, #skins[2])
				if isPedInVehicle(player) then removePedFromVehicle(player) end
				setElementPosition(player, positions[2][randomPosition][1] + math.random(1, 3), positions[2][randomPosition][2] + math.random(1, 3), positions[2][randomPosition][3])
				setElementInterior(player, 0)
				setElementDimension(player, 1)
				setElementModel(player, skins[2][randomSkin])
				setElementHealth(player, 100)
                setPedArmor(player, 100)
				setElementFrozen(player, false)
				removeElementData(player, "greenzone")
				triggerClientEvent(player, "vs.startGame", player)
			end
			
			triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
		else
			outputChatBox("[!]#FFFFFF Şuanda VS etkinliği başlamış durumda.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vsbasla", vsBasla, false, false)

function vsBitir(thePlayer, commandName)
	if authorizedUsers[getElementData(thePlayer, "account:username")] then
		if gameStarted then
			for index, player in pairs(players[1]) do
				if isPedInVehicle(player) then removePedFromVehicle(player) end
				setElementPosition(player, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
				setElementInterior(player, 0)
				setElementDimension(player, 0)
				triggerClientEvent(player, "vs.eliminatePlayer", player)
			end
			
			for index, player in pairs(players[2]) do
				if isPedInVehicle(player) then removePedFromVehicle(player) end
				setElementPosition(player, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
				setElementInterior(player, 0)
				setElementDimension(player, 0)
				triggerClientEvent(player, "vs.eliminatePlayer", player)
			end
			
			players = {{}, {}}
			gameStarted = false
			triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
		else
			outputChatBox("[!]#FFFFFF Şuanda VS etkinliği başlamamış durumda.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vsbitir", vsBitir, false, false)

addEvent("vs.joinTeam", true)
addEventHandler("vs.joinTeam", root, function(teamID)
    if client ~= source then return end
	if #players[teamID] <= 100 then
		if (not isPlayerInTeam(1, source)) and (not isPlayerInTeam(2, source)) then
			table.insert(players[teamID], source)
			triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
		end
	end
end)

addEvent("vs.leaveTeam", true)
addEventHandler("vs.leaveTeam", root, function()
    if client ~= source then return end
	for teamID = 1, 2 do
		for index, player in pairs(players[teamID]) do
			if player == source then
				table.remove(players[teamID], index)
				triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
			end
		end
    end
end)

addEventHandler("onPlayerQuit", root, function()
	for teamID = 1, 2 do
		for index, player in pairs(players[teamID]) do
			if player == source then
				table.remove(players[teamID], index)
				triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
			end
		end
    end
end)

addEventHandler("onPlayerWasted", root, function(ammo, killer, killerweapon, bodypart)
	if (killer) and (killer ~= source) and (gameStarted) then
		for teamID = 1, 2 do
			for index, player in pairs(players[teamID]) do
				if player == source then
					setElementPosition(player, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
					setElementInterior(player, 0)
					setElementDimension(player, 0)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(killer):gsub("_", " ") .. " tarafından katledildiniz.", player, 255, 0, 0, true)
					triggerClientEvent(player, "playDragonSound", player)
					
					table.remove(players[teamID], index)
					triggerClientEvent(root, "vs.assignSettings", root, players, gameStarted)
					triggerClientEvent(player, "vs.eliminatePlayer", player)
				end
			end
		end
	end
end)

function isPlayerInGame(thePlayer)
	return (isPlayerInTeam(1, thePlayer) or isPlayerInTeam(2, thePlayer)) and gameStarted
end

function isPlayerInTeam(teamID, player)
    for _, p in ipairs(players[teamID]) do
        if p == player then
            return true
        end
    end
    return false
end