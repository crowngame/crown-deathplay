addEvent("twitter.sendTweet", true)
addEventHandler("twitter.sendTweet", root, function(text)
	if client ~= source then return end
	if exports.cr_global:hasMoney(client, 1000) then
		if string.len(text) > 0 then
			if not getElementData(client, "adminjailed") then
				exports.cr_global:takeMoney(client, 1000)
				triggerClientEvent(client, "playSuccessfulSound", client)
				
				for _, player in pairs(getElementsByType("player")) do
					if (getElementData(player, "loggedin") == 1) then
						outputChatBox("[Twitter] " .. text .. " @" .. getPlayerName(client):gsub("_", " "), player, 0, 178, 238)
					end
				end
				
				exports.cr_discord:sendMessage("twitter-log", "[Twitter] " .. text .. " @" .. getPlayerName(client):gsub("_", " "))
			else
				exports.cr_infobox:addBox(client, "error", "Jailde iken tweet atamazsınız.")
			end
		else
			exports.cr_infobox:addBox(client, "error", "İçerik boş bırakılamaz.")
		end
	else
		exports.cr_infobox:addBox(client, "error", "Tweet göndermek için yeterli paranız yok.")
	end
end)