local controls = {
	"fire",
	"aim_weapon",
	"next_weapon",
	"previous_weapon",
	"vehicle_fire",
	"vehicle_secondary_fire",
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	setTimer(checkGreenzone, 500, 0, localPlayer)
	setTimer(removeGreenzone, 500, 0, localPlayer)
end)

addEventHandler("onClientPlayerDamage", localPlayer, function()
	if getElementData(source, "greenzone") then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function()
	if getElementData(source, "greenzone") then
		setPedWeaponSlot(localPlayer, 0)
	end
end)

addEventHandler("onClientPlayerStealthKill", localPlayer, function(element)
	if getElementData(element, "greenzone") then
		cancelEvent()
	end
end)

function checkGreenzone(thePlayer)
	if getElementData(thePlayer, "greenzone") then
		setPedWeaponSlot(thePlayer, 0)
	end
end

function removeGreenzone(thePlayer)
	if getElementData(thePlayer, "greenzone") then
		for _, control in pairs(controls) do 
			toggleControl(control, false) 
		end
	else 
		for _, control in pairs(controls) do 
			toggleControl(control, true) 
		end
	end
end