local clientID = "975807504518873099"

addEventHandler("onClientResourceStart", resourceRoot, function()
	if setDiscordApplicationID(clientID) then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerChangeNick", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerJoin", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientPlayerQuit", root, function()
	if isDiscordRichPresenceConnected() then
		setRichPresenceOptions()
	end
end)

addEventHandler("onClientElementDataChange", root, function(theKey, oldValue, newValue)
	if isDiscordRichPresenceConnected() then
		if theKey == "playerid" then
			setRichPresenceOptions()
		end
	end
end)

function setRichPresenceOptions()
	setDiscordRichPresenceAsset("logo", "Crown Deathplay")
	setDiscordRichPresenceSmallAsset("mtasa", "Multi Theft Auto")
	setDiscordRichPresenceDetails(getPlayerName(localPlayer):gsub("_", " ") .. " (" .. getElementData(localPlayer, "playerid") .. ")")
	setDiscordRichPresenceState("Oyunda: " .. #getElementsByType("player") .. "/500")
	
	setDiscordRichPresenceButton(1, "Sunucuya Bağlan", "mtasa://185.160.30.248:22003")
	setDiscordRichPresenceButton(2, "Discord'a Katıl", "https://discord.gg/crowndp")
end