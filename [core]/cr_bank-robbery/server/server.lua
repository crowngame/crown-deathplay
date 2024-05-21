players = {}
collision = createColCuboid(2305.34765625, -17.6798828125, 25.7421875, 15.2, 18, 5)
isRobberyStarted = false

addEventHandler("onColShapeHit", collision, function(thePlayer, matchingDimension)
	if not isRobberyStarted then
		if getElementType(thePlayer) == "player" then
			if #players == 0 then
				local playerTeam = getPlayerTeam(thePlayer)
				if playerTeam then
					table.insert(players, thePlayer)
					triggerClientEvent(root, "robbery.updatePlayers", root, players)
				end
			else
				if #players ~= 0 and #players <= 5 then
					local lastPlayer = players[1]
					if lastPlayer and isElement(lastPlayer) then
						if getPlayerTeam(lastPlayer) == getPlayerTeam(thePlayer) then
							table.insert(players, thePlayer)
							triggerClientEvent(root, "robbery.updatePlayers", root, players)
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onColShapeLeave", collision, function(thePlayer, matchingDimension)
	if getElementType(thePlayer) == "player" then
		if not isRobberyStarted then
			for index, value in pairs(players) do
				if value == thePlayer then
					table.remove(players, index)
					triggerClientEvent(root, "robbery.updatePlayers", root, players)
				end
			end
		else
			local found = false
			for index, value in pairs(players) do
				if value == thePlayer then
					found = true
				end
			end

			if found then
				isRobberyStarted = false
				triggerClientEvent(root, "robbery.stopRobbery", root)
				
				outputChatBox("#f73f3f[HABER]#FFFFFF Banka soygunu sona erdi.", root, 255, 255, 255, true)

				outputChatBox("[!]#FFFFFF Soygun bölgesinden ayrıldınız için soygun iptal olundu.", thePlayer, 255, 0, 0, true)
				for index, value in pairs(players) do
					if value ~= thePlayer then
						outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu soygun bölgesinden ayrıldığı için soygun iptal olundu.", value, 255, 0, 0, true)
						playSoundFrontEnd(value, 4)
					end
				end

				players = {}
			end
		end
	end
end)

addEvent("robbery.startRobbery", true)
addEventHandler("robbery.startRobbery", root, function()
	if not isRobberyStarted then
		triggerClientEvent(root, "robbery.startRobbery", root)
		isRobberyStarted = true

		outputChatBox("#f73f3f[HABER]#FFFFFF Bankanın alarmları çalmaya başladı.", root, 255, 255, 255, true)

		for key, value in ipairs(players) do 
			outputChatBox("[!]#FFFFFF Soygun başladı, polislere bildirim gitti!", value, 0, 255, 0, true)
			outputChatBox(">>#FFFFFF Soygunu bitirmek için 250 saniye burada bekle ve asla dışarı çıkma.", value, 0, 0, 255, true)
		end
	end
end)

addEvent("robbery.finishRobbery", true)
addEventHandler("robbery.finishRobbery", root, function()
	if isRobberyStarted then
		isRobberyStarted = false
		triggerClientEvent(root, "robbery.stopRobbery", root)
		
		outputChatBox("#f73f3f[HABER]#FFFFFF Banka soygunu sona erdi.", root, 255, 255, 255, true)
		
		for key, value in ipairs(players) do
			exports.cr_global:giveMoney(value, robberyMoney)
			exports.cr_pass:addMissionValue(value, 7, 1)
			outputChatBox("[!]#FFFFFF Başarıyla bankayı soydunuz ve $" .. exports.cr_global:formatMoney(robberyMoney) .. " miktar para kazandınız!", value, 0, 255, 0, true)
		end

		players = {}
	end
end)

addEventHandler("onPlayerQuit", root, function(quitType)
	if isRobberyStarted then
		local found = false
		for index, value in pairs(players) do
			if value == source then
				found = true
			end
		end

		if found then
			isRobberyStarted = false
			triggerClientEvent(root, "robbery.stopRobbery", root)
			
			outputChatBox("#f73f3f[HABER]#FFFFFF Banka soygunu sona erdi.", root, 255, 255, 255, true)

			for key, value in ipairs(players) do
				outputChatBox("[!]#FFFFFF " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu sunucudan ayrıldığı için soygun iptal olundu. (" .. quitReason[quitType] .. ")", value, 255, 0, 0, true)
				playSoundFrontEnd(value, 4)
			end

			players = {}
		end
	end
end)

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	if isRobberyStarted then
		local found = false
		for index, value in pairs(players) do
			if value == source then
				found = true
			end
		end

		if found then
			isRobberyStarted = false
			triggerClientEvent(root, "robbery.stopRobbery", root)
			
			outputChatBox("#f73f3f[HABER]#FFFFFF Banka soygunu sona erdi.", root, 255, 255, 255, true)

			for key, value in ipairs(players) do
				outputChatBox("[!]#FFFFFF " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu öldüğü için soygun iptal olundu.", value, 255, 0, 0, true)
				playSoundFrontEnd(value, 4)
			end

			players = {}
		else
			if isElementWithinColShape(source, collision) then
				setElementPosition(source, 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875)
				setElementInterior(source, 0)
				setElementDimension(source, 0)
				outputChatBox("[!]#FFFFFF " .. getPlayerName(attacker):gsub("_", " ") .. " tarafından katledildiniz.", source, 255, 0, 0, true)
				triggerClientEvent(source, "playDragonSound", source)
			end
		end
	end
end)