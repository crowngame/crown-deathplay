function updateItemThings()
--	setPlayerHudComponentVisible("radar", true)
end
addEvent("item:updateclient", true)
addEventHandler("item:updateclient", root, updateItemThings)
addEventHandler("onCharacterLogin", root, updateItemThings)
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), updateItemThings)
addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), updateItemThings)
