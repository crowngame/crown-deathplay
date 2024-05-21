local armorTimer = {}

function vipArmor(thePlayer, commandName)
	local vip = getElementData(thePlayer, "vip")
	if vip >= 4 then
		if not isTimer(armorTimer[thePlayer]) then
			if not getElementData(thePlayer, "baygin") then
				if vip == 4 then
					setPedArmor(thePlayer, 50)
				elseif vip == 5 then
					setPedArmor(thePlayer, 100)
				end
				
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
				armorTimer[thePlayer] = setTimer(function() end, 1000 * 10, 1)
			else
				outputChatBox("[!]#FFFFFF Baygın iken bu özelliği kullanamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			local timer = getTimerDetails(armorTimer[thePlayer])
			outputChatBox("[!]#FFFFFF Zırh almak için " .. math.floor(timer / 1000) .." saniye beklemeniz gerekiyor.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu özelliği kullanabilmek için VIP 4 veya 5 üyeliğine ihtiyacın var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipzirh", vipArmor)