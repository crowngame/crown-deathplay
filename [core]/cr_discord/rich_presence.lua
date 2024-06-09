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
		if theKey == "loggedin" then
			setRichPresenceOptions()
		end
	end
end)

function setRichPresenceOptions()
	local loggedin = getElementData(localPlayer, "loggedin") or 0

	setDiscordRichPresenceAsset("logo", "Crown Deathplay")
	setDiscordRichPresenceSmallAsset("mtasa", "Multi Theft Auto")
	setDiscordRichPresenceDetails((loggedin == 1) and getPlayerName(localPlayer):gsub("_", " ") or "Giriş Ekranında.")
	setDiscordRichPresenceState("Oyunda: " .. #getElementsByType("player") .. "/500")
	
	setDiscordRichPresenceButton(1, "Sunucuya Bağlan", "mtasa://185.160.30.248:22003")
	setDiscordRichPresenceButton(2, "Discorda Katıl", "https://discord.gg/crowndp")
end