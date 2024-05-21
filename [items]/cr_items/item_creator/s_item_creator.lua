function spawnItem (thePlayer, targetPlayerID, itemID, itemValue)
	if client ~= source then return end
	if client ~= thePlayer then return end
	executeCommandHandler("giveitem", thePlayer, targetPlayerID .. " " .. itemID .. " " .. itemValue)
end
addEvent("itemCreator:spawnItem", true)
addEventHandler("itemCreator:spawnItem", root, spawnItem)