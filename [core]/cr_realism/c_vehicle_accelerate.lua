bindKey("accelerate", "down", function()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	if theVehicle and getVehicleOccupant(theVehicle) == localPlayer then
		if isElementFrozen(theVehicle) and getVehicleEngineState(theVehicle) then
			if getVehicleType(theVehicle) == "Bike" then
				outputChatBox("[!]#FFFFFF Motorun ayaklığını indirmeniz gerekmektedir, /kickstand yazarak indirebilirsiniz.", 0, 0, 255, true)
			elseif getVehicleType(theVehicle) == "Boat" then
				outputChatBox("[!]#FFFFFF Çapanızı geri çekmeniz gerekmektedir, /anchor yazarak geri çekebilirsiniz.", 0, 0, 255, true)
			else
				outputChatBox("[!]#FFFFFF Aracınızın el freni kaldırılmış, 'G' tuşuna basarak indirebilirsiniz.", 0, 0, 255, true)
			end
		elseif not getVehicleEngineState(theVehicle) then
			outputChatBox("[!]#FFFFFF Aracınızın motoru çalışmamaktadır, 'J' tuşuna basarak motoru çalıştırınız.", 0, 0, 255, true)
		end
	end
end)