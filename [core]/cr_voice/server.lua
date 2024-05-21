addEvent("voice.update", true)
addEventHandler("voice.update", root, function(broadcastList)
    if client and source == client then else return end
    setPlayerVoiceIgnoreFrom(source, nil)
    setPlayerVoiceBroadcastTo(source, broadcastList)
end)

addEvent("voice.changeChannel", true)
addEventHandler("voice.changeChannel", root, function()
	if getElementData(client, "loggedin") ~= 1 then return end
	if authorizedUsers[getElementData(client, "account:username")] then
		local voiceChannel = getElementData(client, "voiceChannel")
		
		if voiceChannel >= 1 and voiceChannel < 3 then
			voiceChannel = voiceChannel + 1
		else
			voiceChannel = 1
		end
		
		setElementData(client, "voiceChannel", voiceChannel)
		outputChatBox("[!]#FFFFFF Konuşma kanalı [" .. voiceChannel .. "] olarak değiştirildi.", client, 0, 255, 0, true)
	end
end)

if isVoiceEnabled() then
	local playerChannels = {}
	local channels = {}
	
	addEventHandler("onPlayerJoin", root, function()
		setPlayerVoiceBroadcastTo(source, getElementsByType("player"))
		setPlayerInternalChannel(source, root)
	end)

	addEventHandler("onResourceStart", resourceRoot, function()
		refreshPlayers()
		setTimer(refreshPlayers, 1000 * 60, 0)
	end)

	function refreshPlayers()
		for _, player in ipairs(getElementsByType("player")) do
			setPlayerInternalChannel(player, root)
		end
	end

	function setPlayerInternalChannel(player, element)
		if playerChannels[player] == element then
			return false
		end
		playerChannels[player] = element
		channels[element] = player
		setPlayerVoiceBroadcastTo(player, element)
		return true
	end
end

function setVoice(thePlayer, commandName, targetPlayer, channelID)
	if authorizedUsers[getElementData(thePlayer, "account:username")] then
		if targetPlayer and channelID and tonumber(channelID) then
            channelID = tonumber(channelID)
			if channelID >= 0 and channelID <= 3 then
				if targetPlayer == "all" then
					for _, player in ipairs(getElementsByType("player")) do
						setElementData(player, "voiceChannel", channelID)
					end
					outputChatBox("[!]#FFFFFF Başarıyla tüm oyuncuların konuşma kanalı [" .. math.floor(channelID) .. "] olarak ayarlandı.", thePlayer, 0, 255, 0, true)
				else
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							setElementData(targetPlayer, "voiceChannel", math.floor(channelID))
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun konuşma kanalı [" .. math.floor(channelID) .. "] olarak ayarlandı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili konuşma kanalınızı [" .. math.floor(channelID) .. "] olarak ayarladı.", targetPlayer, 0, 0, 255, true)
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bu sayıya ait bir konuşma kanalı bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-3]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setvoice", setVoice, false, false)