local ids = {}
local specialIDs = {
	["56B4859AF5F99E75D05C601AE8BA6EA2"] = 0,
	["6BCCD7D5858EFE85B62A46551D980C54"] = -1,
	["6578C0F0AE53CC8AB00FC32511F4F5B3"] = -2,
}

addEventHandler("onPlayerJoin", root, function()
	local slot
	for i = 1, 5000 do
		if (ids[i] == nil) then
			slot = i
			break
		end
	end
	
	if specialIDs[getPlayerSerial(source)] then
		slot = specialIDs[getPlayerSerial(source)]
	end
	
	ids[slot] = source
	setElementData(source, "playerid", slot)
	exports.cr_pool:allocateElement(source, slot)
	idforname = "CDP." .. getElementData(source, "playerid")
	setPlayerName(source, idforname)
	exports.cr_discord:sendMessage("joinquit-log", "[>] " .. getPlayerName(source):gsub("_", " ") .. " sunucuya katıldı.\nIP: " .. getPlayerIP(source) .. "\nSerial: " .. getPlayerSerial(source))
end)

addEventHandler("onPlayerQuit", root, function(reason	)
	local slot = getElementData(source, "playerid")
	if (slot) then
		ids[slot] = nil
	end
	exports.cr_discord:sendMessage("joinquit-log", "[<] " .. getPlayerName(source):gsub("_", " ") .. " sunucuya katıldı. (" .. reason .. ")\nIP: " .. getPlayerIP(source) .. "\nSerial: " .. getPlayerSerial(source))
end)

for key, value in ipairs(getElementsByType("player")) do
	if specialIDs[getPlayerSerial(value)] then
		key = specialIDs[getPlayerSerial(value)]
	end
	
	ids[key] = value
	setElementData(value, "playerid", key)
	exports.cr_pool:allocateElement(value, key)
end