addEvent("darkweb.sendPost", true)
addEventHandler("darkweb.sendPost", root, function(text)
	if client ~= source then return end
	if exports.cr_global:hasMoney(client, 1000) then
		if string.len(text) > 0 then
			if not getElementData(client, "adminjailed") then
				exports.cr_global:takeMoney(client, 1000)
				triggerClientEvent(client, "playSuccessfulSound", client)
				
				for _, player in pairs(getElementsByType("player")) do
					if (getElementData(player, "loggedin") == 1) then
						outputChatBox("[DarkWeb]#FFFFFF " .. text .. " @" .. getPlayerName(client):gsub("_", " "), player, 18, 18, 18, true)
					end
				end
				
				exports.cr_discord:sendMessage("darkweb-log", "[DarkWeb] " .. text .. " @" .. getPlayerName(client):gsub("_", " "))
			else
				exports.cr_infobox:addBox(client, "error", "Jailde iken gönderi atamazsınız.")
			end
		else
			exports.cr_infobox:addBox(client, "error", "İçerik boş bırakılamaz.")
		end
	else
		exports.cr_infobox:addBox(client, "error", "Gönderi atmak için yeterli paranız yok.")
	end
end)