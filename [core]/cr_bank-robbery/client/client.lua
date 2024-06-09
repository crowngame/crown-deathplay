players = {}
robberyStarted = false

alarmSound = nil
counter = nil
openingTimer = nil

bankPed = createPed(240, 2306.6591796875, -1.4609375, 26.7421875, -90)
setElementData(bankPed, "nametag", true)
setElementData(bankPed, "name", "Marcus Williams")
setElementFrozen(bankPed, true)

setTimer(function()
	if not robberyStarted then
		if isElement(bankPed) then
		    if aimsAt(bankPed) then
		    	if not openingTimer then
			    	if #players >= 2 then
				    	local policeCount = 0
			    		for _, player in ipairs(getElementsByType("player")) do 
							if getElementData(player, "faction") == 1 then
								policeCount = policeCount + 1
							end
						end
						
						if policeCount >= 3 then
							local foundPlayer = false
							for _, player in pairs(players) do
								if player == localPlayer then
									foundPlayer = true
								end
							end

							if foundPlayer then
								triggerServerEvent("robbery.startRobbery", localPlayer)
							end
						else
							outputChatBox("[!]#FFFFFF Bankayı soymak için sunucuda minimum 3 kişi LSPD üyesi olması lazım.", 255, 0, 0, true)
							playSoundFrontEnd(4)
						end
				    else
						outputChatBox("[!]#FFFFFF Bankayı soymak için minimum 2 kişi olmanız lazım.", 255, 0, 0, true)
						playSoundFrontEnd(4)
					end
				else
					outputChatBox("[!]#FFFFFF Burası daha yeni soyulmuş, lütfen " .. (math.floor((getTimerDetails(openingTimer) or 0) / 1000)) .. " saniye sonra tekrar deneyin.", 255, 0, 0, true)
					playSoundFrontEnd(4)
				end
		    end
		end
	end
end, 100, 0)

function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and (getPedWeapon(localPlayer) == 22 or getPedWeapon(localPlayer) == 23 or getPedWeapon(localPlayer) == 24 or getPedWeapon(localPlayer) == 25 or getPedWeapon(localPlayer) == 26 or getPedWeapon(localPlayer) == 27 or getPedWeapon(localPlayer) == 28 or getPedWeapon(localPlayer) == 29 or getPedWeapon(localPlayer) == 30 or getPedWeapon(localPlayer) == 31 or getPedWeapon(localPlayer) == 32 or getPedWeapon(localPlayer) == 33 or getPedWeapon(localPlayer) == 34)
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

addEvent("robbery.startRobbery", true)
addEventHandler("robbery.startRobbery", root, function()
	if not robberyStarted then
		setPedAnimation(bankPed, "ped", "handsup", -1, false, true, false)
		robberyStarted = true

		alarmSound = playSound3D("public/sounds/alarm.wav", 2312.9345703125, -8.390625, 26.7421875, true)
		setSoundMaxDistance(alarmSound, 150)
		setSoundVolume(alarmSound, 5)

		drawCounterTimer = setTimer(drawCounter, 0, 0)
		drawInformationTimer = setTimer(drawInformation, 0, 0)
		counter = setTimer(function() end, 200 * 1000, 1)
	end
end)

addEvent("robbery.updatePlayers", true)
addEventHandler("robbery.updatePlayers", root, function(_players)
	players = _players
end)

addEvent("robbery.stopRobbery", true)
addEventHandler("robbery.stopRobbery", root, function()
	if robberyStarted then
		robberyStarted = false
		setPedAnimation(bankPed)
		destroyElement(alarmSound)
		
		if isTimer(drawCounterTimer) then killTimer(drawCounterTimer) end
		if isTimer(drawInformationTimer) then killTimer(drawInformationTimer) end
		
		players = {}
		openingTimer = setTimer(function() end, 30 * 60 * 1000, 1)
	end
end)