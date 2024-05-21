local fixTimer = {}

function tamirMain(thePlayer, commandName)
	if not isTimer(fixTimer[thePlayer]) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			if exports.cr_global:hasMoney(thePlayer, 10000) then
				exports.cr_global:takeMoney(thePlayer, 10000)
				fixVehicle(theVehicle)
				setVehicleDamageProof(theVehicle, false)
				setVehicleEngineState(theVehicle, true)
				toggleControl(thePlayer, "brake_reverse", true)
				setElementData(theVehicle, "enginebroke", 0)
				setElementData(theVehicle, "engine", 1)
				setElementData(theVehicle, "vehicle:radio", tonumber(getElementData(theVehicle, "vehicle:radio:old")))
				setElementData(theVehicle, "lastused", exports.cr_datetime:now())
				exports.cr_pass:addMissionValue(thePlayer, 9, 1)
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
				fixTimer[thePlayer] = setTimer(function() end, 1000 * 10, 1)
			else
				outputChatBox("[!]#FFFFFF Yeterli paranız bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("[!]#FFFFFF Bir araçta olmalısın.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		local timer = getTimerDetails(fixTimer[thePlayer])
		outputChatBox("[!]#FFFFFF Aracı tamir etmek için " .. math.floor(timer / 1000)  .. " saniye beklemeniz gerekiyor.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("tamir", tamirMain, false, false)