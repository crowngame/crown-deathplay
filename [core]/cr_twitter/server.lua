addEvent("twitter.sendTweet", true)
addEventHandler("twitter.sendTweet", root, function(text)
	if client ~= source then return end
	if exports.cr_global:hasMoney(client, 1000) then
		exports.cr_global:takeMoney(client, 1000)
		triggerClientEvent(client, "playSuccessfulSound", client)
		
		for _, player in pairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) then
				outputChatBox("[Twitter] " .. text .. " @" .. getPlayerName(client):gsub("_", " "), player, 0, 178, 238)
			end
		end
		
		exports.cr_discord:sendMessage("twitter-log", "[Twitter] " .. text .. " @" .. getPlayerName(client):gsub("_", " "))
	else
		outputChatBox("[!]#FFFFFF Tweet göndermek için yeterli paranız yok.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
	end
end)