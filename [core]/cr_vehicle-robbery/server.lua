local robberyVehicle = createVehicle(428, 1024.267578125, -981.365234375, 42.645942687988)
setElementRotation(robberyVehicle, 0, 0, 270)
setVehicleColor(robberyVehicle, 0, 0, 0)
setVehicleDamageProof(robberyVehicle, true)
setElementFrozen(robberyVehicle, true)
setVehiclePlateText(robberyVehicle, "CROWN")
setElementData(robberyVehicle, "robberyVehicle", true)
setElementData(robberyVehicle, "robberyVehicleBlock", false)
robberyVehicleBlip = createBlipAttachedTo(robberyVehicle, 52)

addEventHandler("onVehicleStartEnter", root, function(thePlayer, seat)
    if source == robberyVehicle then
        if isTimer(timer) then
			killTimer(timer)
        end
		
        if seat ~= 0 then
            cancelEvent()
        end
		
		if getElementData(source, "robberyVehicleBlock") then
			outputChatBox("[!]#FFFFFF Burayı 10 dakika sonra soyabilirsin.", thePlayer, 255, 0, 0, true) 
			cancelEvent() 
			return
		end
    end
end)

addEventHandler("onVehicleEnter", root, function(thePlayer)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle == robberyVehicle then 
		setVehicleEngineState(robberyVehicle, true)
		setElementFrozen(robberyVehicle, false)
		setVehicleDamageProof(robberyVehicle, false)
		
		if getElementData(thePlayer, "faction") == 1 then 
			outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, bankaya götürülmek üzere " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli LSPD Üyesi tarafından teslim alındı.", root, 255, 255, 255, true)
			outputChatBox(">>#FFFFFF Kamyonu radarda gösterilen Kırmızı Bölgeye götürün.", thePlayer, 0, 255, 0, true)
			markerLegal = createMarker(1600.224609375, -1609.796875, 12.465431213379, "cylinder", 10, 255, 0, 0, 175)
			blipLegal = createBlip(1600.224609375, -1609.796875, 13.465431213379, 41, 2, 255, 0, 0, 255)
		else
			outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli Terör Örgütü üyesi tarafından kaçırıldı.", root, 255, 255, 255, true) 
			outputChatBox(">>#FFFFFF Kamyonu radarda gösterilen Kırmızı Bölgeye götürün.", thePlayer, 0, 255, 0, true)
			markerIllegal = createMarker(2224.6640625, -1167.0244140625, 24.7265625, "cylinder", 10, 255, 0, 0, 175)
			blipIllegal = createBlip(2224.6640625, -1167.0244140625, 25.7265625, 41, 2, 255, 0, 0, 255)
		end

		triggerClientEvent(root, "robbery.renderUI", root, true, robberyVehicle)
	end
end)

addEventHandler("onVehicleStartExit", root, function(thePlayer) 
	if source == robberyVehicle then
		if getElementData(thePlayer, "faction") == 1 then 
			if isElement(markerLegal) and isElement(blipLegal) then 
				destroyElement(markerLegal)
				destroyElement(blipLegal)
			end
		else
			if isElement(markerIllegal) and isElement(blipIllegal) then 
				destroyElement(markerIllegal)
				destroyElement(blipIllegal)
			end
		end
	end
end)

addEventHandler("onPlayerVehicleExit", root, function(theVehicle)
	if theVehicle == robberyVehicle then
		if getElementData(source, "faction") == 1 then 
			if isElement(markerLegal) and isElement(blipLegal) then
				destroyElement(markerLegal)
				destroyElement(blipLegal)
			end
		else
			if isElement(markerIllegal) and isElement(blipIllegal) then 
				destroyElement(markerIllegal)
				destroyElement(blipIllegal)
			end
		end
		
		if theVehicle == robberyVehicle then
			timer = setTimer(function()
				triggerClientEvent(root, "robbery.renderUI", root, false, robberyVehicle)
				outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, devlet görevlileri tarafından teslim alındı.", root, 255, 255, 255, true)
				
				if robberyVehicle and isElement(robberyVehicle) then
					setElementPosition(robberyVehicle, 1024.267578125, -981.365234375, 42.645942687988)
					setElementRotation(robberyVehicle, 0, 0, 270)
					setVehicleColor(robberyVehicle, 0, 0, 0)
					setVehicleDamageProof(robberyVehicle, true)
					setElementFrozen(robberyVehicle, true)
					setVehiclePlateText(robberyVehicle, "CROWN")
					setElementData(robberyVehicle, "robberyVehicle", true)
					setElementData(robberyVehicle, "robberyVehicleBlock", true)
					
					setTimer(function()
						setElementData(robberyVehicle, "robberyVehicleBlock", false)
						outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, bankaya parayı yüklemek için geri döndü.", root, 255, 255, 255, true)
					end, 1000 * 60 * 10, 1)
					
					if robberyVehicleBlip then
						destroyElement(robberyVehicleBlip)
					end
					
					robberyVehicleBlip = createBlipAttachedTo(robberyVehicle, 52)
				end
			end, 10000, 1)
		end
	end
end)

addEventHandler("onPlayerMarkerHit", root, function(marker)
	local theVehicle = getPedOccupiedVehicle(source)
	if theVehicle == robberyVehicle then
		if getElementData(source, "faction") == 1 and marker == markerLegal then
			local randomMoney = math.random(200000, 300000)
			exports.cr_global:giveMoney(source, randomMoney)
			exports.cr_pass:addMissionValue(source, 6, 1)
			
			outputChatBox("#f73f3f[HABER]#FFFFFF Bankamıza ait para yüklü kamyon güvenli bölgeye getirildi.",root, 255, 255, 255, true)
			outputChatBox(">>#FFFFFF Başarıyla görev tamamlandı ve " .. exports.cr_global:formatMoney(randomMoney) .. "$ kazandınız!", source, 0, 255, 0, true)
			
			destroyElement(markerLegal)
			destroyElement(blipLegal)
			
			setElementPosition(robberyVehicle, 1024.267578125, -981.365234375, 42.645942687988)
			fixVehicle(robberyVehicle)
			setVehicleEngineState(robberyVehicle, false)
			setElementFrozen(robberyVehicle, true)
			removePedFromVehicle(source)
			setVehicleColor(robberyVehicle, 0, 0, 0)
			setVehiclePlateText(robberyVehicle, "CROWN")
			setElementRotation(robberyVehicle, 0, 0, 270)
			setElementData(robberyVehicle, "robberyVehicleBlock", true)
			triggerClientEvent(root, "robbery.renderUI", root, false, robberyVehicle)
			
			setTimer(function()
				setElementData(robberyVehicle, "robberyVehicleBlock", false)
				outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, bankaya parayı yüklemek için geri döndü.", root, 255, 255, 255, true)
			end, 1000 * 60 * 10, 1)
			
			if isTimer(timer) then 
				killTimer(timer)
			end
			
			setVehicleDamageProof(robberyVehicle, true)
		else
			outputChatBox("[!]#FFFFFF Burası sizin bölgeniz değil, lütfen kamyonu diğer Kırmızı Bölgeye götürün.", source, 255, 0, 0, true)
			playSoundFrontEnd(source, 4)
		end
		
		if getElementData(source, "faction") ~= 1 and marker == markerIllegal then 
			local randomMoney = math.random(200000, 300000)
			exports.cr_global:giveMoney(source, randomMoney)
			exports.cr_pass:addMissionValue(source, 6, 1)
			
			outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyon, Terör Örgütü tarafından el konuldu.", root, 255, 255, 255, true)
			outputChatBox(">>#FFFFFF Başarıyla görev tamamlandı ve " .. exports.cr_global:formatMoney(randomMoney) .. "$ kazandınız!", source, 0, 255, 0, true)
			
			destroyElement(markerIllegal)
			destroyElement(blipIllegal)
			
			setElementPosition(robberyVehicle, 1024.267578125, -981.365234375, 42.645942687988)
			fixVehicle(robberyVehicle)
			setVehicleEngineState(robberyVehicle, false)
			setElementFrozen(robberyVehicle, true)
			removePedFromVehicle(source)
			setVehicleColor(robberyVehicle, 0, 0, 0)
			setVehiclePlateText(robberyVehicle, "CROWN")
			setElementRotation(robberyVehicle, 0, 0, 270)
			setElementData(robberyVehicle, "robberyVehicleBlock", true)
			triggerClientEvent(root, "robbery.renderUI", root, false, robberyVehicle)
			
			setTimer(function()
				setElementData(robberyVehicle, "robberyVehicleBlock", false)
				outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, kasabadaki bankaya parayı yüklemek için geri döndü.", root, 255, 255, 255, true)
			end, 1000 * 60 * 10, 1)
			
			if isTimer(timer) then 
				killTimer(timer)
			end
			
			setVehicleDamageProof(robberyVehicle, true)
		else
			outputChatBox("[!]#FFFFFF Burası sizin bölgeniz değil, lütfen kamyonu diğer Kırmızı Bölgeye götürün.", source, 255, 0, 0, true)
			playSoundFrontEnd(source, 4)
		end
	end
end)

addEventHandler("onVehicleExplode", root, function()
	if source == robberyVehicle then
		outputChatBox("#f73f3f[HABER]#FFFFFF Para yüklü banka kamyonu, devlet görevlileri tarafından teslim alındı.", root, 255, 255, 255, true)
		triggerClientEvent(root, "robbery.renderUI", root, false, robberyVehicle)
		
		if isElement(robberyVehicle) then
			destroyElement(robberyVehicle)
		end
		
		robberyVehicle = createVehicle(428, 1024.267578125, -981.365234375, 42.645942687988)
		setElementRotation(robberyVehicle, 0, 0, 270)
		setVehicleColor(robberyVehicle, 0, 0, 0)
		setVehicleDamageProof(robberyVehicle, true)
		setElementFrozen(robberyVehicle, true)
		setVehiclePlateText(robberyVehicle, "CROWN")
		setElementData(robberyVehicle, "robberyVehicle", true)
		setElementData(robberyVehicle, "robberyVehicleBlock", false)
		
		if robberyVehicleBlip then
			destroyElement(robberyVehicleBlip)
		end
		
		robberyVehicleBlip = createBlipAttachedTo(robberyVehicle, 52)
	end
end)

addEventHandler("onVehicleDamage", root, function(attacker, weapon, loss)
	if source == robberyVehicle then
		setVehicleDamageProof(robberyVehicle, true)
        cancelEvent(true)
    end
end)

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	local theVehicle = getPedOccupiedVehicle(source)
	if theVehicle and theVehicle == robberyVehicle then
		if getElementData(thePlayer, "faction") == 1 then 
			if isElement(markerLegal) and isElement(blipLegal) then 
				destroyElement(markerLegal)
				destroyElement(blipLegal)
			end
		else
			if isElement(markerIllegal) and isElement(blipIllegal) then 
				destroyElement(markerIllegal)
				destroyElement(blipIllegal)
			end
		end
	end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	setVehicleHandling(robberyVehicle, "maxVelocity", 120)
	setVehicleHandling(robberyVehicle, "engineAcceleration", 10)
	setVehicleHandling(robberyVehicle, "engineInertia", 10)
	setVehicleHandling(robberyVehicle, "suspensionLowerLimit", -0.05)
	setVehicleHandling(robberyVehicle, "suspensionFrontRearBias", 0.5)
	setVehicleHandling(robberyVehicle, "suspensionForceLevel", 1.4)
	setVehicleHandling(robberyVehicle, "suspensionDamping", 0.1)
	setVehicleHandling(robberyVehicle, "steeringLock", 40)
	setVehicleHandling(robberyVehicle, "driveType", "awd")
	setVehicleHandling(robberyVehicle, "mass", 10000)
	setVehicleHandling(robberyVehicle, "centerOfMass", {0, 0.1, -0.5})
	setVehicleHandling(robberyVehicle, "dragCoeff", 2)
	setVehicleHandling(robberyVehicle, "brakeDeceleration", 15)
	setVehicleHandling(robberyVehicle, "brakeBias", 0.9)
	setVehicleHandling(robberyVehicle, "tractionMultiplier", 1.5)
	setVehicleHandling(robberyVehicle, "tractionBias", 0.5)
end)