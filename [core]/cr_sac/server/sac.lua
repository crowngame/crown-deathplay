local mysql = exports.cr_mysql
local protectedDatas = {
	["admin_level"] = true,
	["supporter_level"] = true,
	["vct_level"] = true,
	["mapper_level"] = true,
	["scripter_level"] = true,
	["manager"] = true,
	["money"] = true,
	["bankmoney"] = true,
	["vip"] = true,
	["balance"] = true,
	["dbid"] = true,
	["account:character:id"] = true,
	["account:id"] = true,
	["account:username"] = true,
	["account:loggedin"] = true,
	["loggedin"] = true,
	["hiddenadmin"] = true,
	["legitnamechange"] = true,
	["boxHours"] = true,
	["boxCount"] = true,
	["etiket"] = true,
	["etiket2"] = true,
	["etiket3"] = true,
	["donater"] = true,
	["youtuber"] = true,
	["dm_plus"] = true,
	["playerid"] = true,
	["itemID"] = true,
	["itemValue"] = true,
	["faction"] = true,
	["factionrank"] = true,
	["factionleader"] = true,
	["adminjailed"] = true,
	["jailtime"] = true,
	["jailtimer"] = true,
	["jailadmin"] = true,
	["jailreason"] = true,
	["minutesPlayed"] = true,
	["hoursplayed"] = true,
	["level"] = true,
	["kills"] = true,
	["deaths"] = true,
	["rank"] = true,
	["pass_type"] = true,
	["pass_level"] = true,
	["pass_xp"] = true,
	["voiceChannel"] = true,
}

local dataChangeCount = {}

local eventUsingPlayers = {}
local defaultServerEventNames = {
    onAccountDataChange = "onAccountDataChange",
    onConsole = "onConsole",
    onColShapeHit = "onColShapeHit",
    onColShapeLeave = "onColShapeLeave",
    onElementClicked = "onElementClicked",
    onElementColShapeHit = "onElementColShapeHit",
    onElementColShapeLeave = "onElementColShapeLeave",
    onElementDataChange = "onElementDataChange",
    onElementCollectionChange = "onElementDataChange",
    onElementDestroy = "onElementDestroy",
    onElementDimensionChange = "onElementDimensionChange",
    onElementInteriorChange = "onElementInteriorChange",
    onElementModelChange = "onElementModelChange",
    onElementStartSync = "onElementStartSync",
    onElementStopSync = "onElementStopSync",
    onMarkerHit = "onMarkerHit",
    onMarkerLeave = "onMarkerLeave",
    onPedDamage = "onPedDamage",
    onPedVehicleEnter = "onPedVehicleEnter",
    onPedVehicleExit = "onPedVehicleExit",
    onPedWasted = "onPedWasted",
    onPedWeaponSwitch = "onPedWeaponSwitch",
    onPickupHit = "onPickupHit",
    onPickupLeave = "onPickupLeave",
    onPickupSpawn = "onPickupSpawn",
    onPickupUse = "onPickupUse",
    onPlayerACInfo = "onPlayerACInfo",
    onPlayerBan = "onPlayerBan",
    onPlayerChangeNick = "onPlayerChangeNick",
    onPlayerChat = "onPlayerChat",
    onPlayerClick = "onPlayerClick",
    onPlayerCommand = "onPlayerCommand",
    onPlayerConnect = "onPlayerConnect",
    onPlayerContact = "onPlayerContact",
    onPlayerDamage = "onPlayerDamage",
    onPlayerJoin = "onPlayerJoin",
    onPlayerLogin = "onPlayerLogin",
    onPlayerLogout = "onPlayerLogout",
    onPlayerMarkerHit = "onPlayerMarkerHit",
    onPlayerMarkerLeave = "onPlayerMarkerLeave",
    onPlayerModInfo = "onPlayerModInfo",
    onPlayerMute = "onPlayerMute",
    onPlayerNetworkStatus = "onPlayerNetworkStatus",
    onPlayerPickupHit = "onPlayerPickupHit",
    onPlayerPickupLeave = "onPlayerPickupLeave",
    onPlayerPickupUse = "onPlayerPickupUse",
    onPlayerPrivateMessage = "onPlayerPrivateMessage",
    onPlayerQuit = "onPlayerQuit",
    onPlayerScreenShot = "onPlayerScreenShot",
    onPlayerSpawn = "onPlayerSpawn",
    onPlayerStealthKill = "onPlayerStealthKill",
    onPlayerTarget = "onPlayerTarget",
    onPlayerUnmute = "onPlayerUnmute",
    onPlayerVehicleEnter = "onPlayerVehicleEnter",
    onPlayerVehicleExit = "onPlayerVehicleExit",
    onPlayerVoiceStart = "onPlayerVoiceStart",
    onPlayerVoiceStop = "onPlayerVoiceStop",
    onPlayerWasted = "onPlayerWasted",
    onPlayerWeaponFire = "onPlayerWeaponFire",
    onPlayerWeaponSwitch = "onPlayerWeaponSwitch",
    onPlayerResourceStart = "onPlayerResourceStart",
    onResourceLoadStateChange = "onResourceLoadStateChange",
    onResourcePreStart = "onResourcePreStart",
    onResourceStart = "onResourceStart",
    onResourceStop = "onResourceStop",
    onBan = "onBan",
    onChatMessage = "onChatMessage",
    onDebugMessage = "onDebugMessage",
    onSettingChange = "onSettingChange",
    onUnban = "onUnban",
    onTrailerAttach = "onTrailerAttach",
    onTrailerDetach = "onTrailerDetach",
    onVehicleDamage = "onVehicleDamage",
    onVehicleEnter = "onVehicleEnter",
    onVehicleExit = "onVehicleExit",
    onVehicleExplode = "onVehicleExplode",
    onVehicleRespawn = "onVehicleRespawn",
    onVehicleStartEnter = "onVehicleStartEnter",
    onVehicleStartExit = "onVehicleStartExit",
    onWeaponFire = "onWeaponFire",
}

local dimensionChangeTimers = {}

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if protectedDatas[theKey] then
		if getElementType(source) == "player" then
			if client and client == source then
				cancelEvent(true)
				setElementData(client, theKey, oldValue)
				
				sendMessage("[SAC #1] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage(">> IP: " .. getPlayerIP(client))
				sendMessage(">> Serial: " .. getPlayerSerial(client))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1")
			elseif client and client ~= source then
				cancelEvent(true)
				setElementData(source, theKey, oldValue)
				
				sendMessage("[SAC #1.1] " .. getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage(">> IP: " .. getPlayerIP(source))
				sendMessage(">> Serial: " .. getPlayerSerial(source))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1.1")
			end
		elseif client and (getElementType(source) == "object") then
			cancelEvent(true)
			setElementData(source, theKey, oldValue)
			
			sendMessage("[SAC #1.2] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan objeye geçersiz veri değişikliği algılandı, derhal kontrol edin.")
			sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
			sendMessage(">> IP: " .. getPlayerIP(client))
			sendMessage(">> Serial: " .. getPlayerSerial(client))
			
			kickPlayer(client, "Shine Anti-Cheat", "SAC #1.2")
		end
	end
	
	if (type(tonumber(theKey)) == "number") and (tonumber(theKey) >= 1 and tonumber(theKey) <= 100000) and client then
		cancelEvent(true)
		
		sendMessage("[SAC #1.3] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
		sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
		sendMessage(">> IP: " .. getPlayerIP(client))
		sendMessage(">> Serial: " .. getPlayerSerial(client))
		
		kickPlayer(client, "Shine Anti-Cheat", "SAC #1.3")
	end
end)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		if isPedWearingJetpack(player) then
			sendMessage("[SAC #2] " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ") isimli oyuncu Jetpack kullandığı için sunucudan yasaklandı.")
			sendMessage(">> IP: " .. getPlayerIP(player))
			sendMessage(">> Serial: " .. getPlayerSerial(player))
	
			banPlayer(player, true, false, true, "Shine Anti-Cheat", "SAC #2")
		end
	end
end, 1000, 0)

addEventHandler("onPlayerACInfo", root, function(detectedACList)
	for _, acCode in ipairs(detectedACList) do
		if acCode == 14 then
			banPlayer(source, true, false, true, "Shine Anti-Cheat", "SAC #3")
		end
	end
end)

addEvent("sac.sendPlayer", true)
addEventHandler("sac.sendPlayer", root, function(sacCode, isBan, reason, ...)
	if client ~= source then return end
	if sacCode and reason then
		local args = { ... }
		
		sendMessage("[SAC #" .. sacCode .. "] " .. getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "playerid") .. ") isimli oyuncu " .. reason .. " sebebiyle sunucudan " .. (isBan and "yasaklandı" or "atıldı") .. ".")
		sendMessage(">> IP: " .. getPlayerIP(source))
		sendMessage(">> Serial: " .. getPlayerSerial(source))
		
		if sacCode == 4 then
			sendMessage(">> Kelime: `" .. tostring(args[1]) .. "`")
		elseif sacCode == 9 then
			sendMessage(">> Script: " .. tostring(args[1]))
		elseif sacCode == 12 then
			sendMessage(">> Kod:\n```" .. tostring(args[1]) .. "```")
			sendMessage(">> Kelime: `" .. tostring(args[2]) .. "`")
		elseif sacCode == 13 then
			sendMessage(">> Mesaj: `" .. tostring(args[1]) .. "`")
		elseif sacCode == 14 then
			sendMessage(">> Limit: " .. tostring(args[1]))
		elseif (sacCode == 16) or (sacCode == 16.1) then
			sendMessage(">> Eski Serial: " .. tostring(args[1]))
		elseif sacCode == 17 then
			sendMessage(">> Mesaj: `" .. tostring(args[1]) .. "`")
		end
		
		if isBan then
			local accountID = getElementData(source, "account:id")
			
			banPlayer(source, true, false, true, "Shine Anti-Cheat", "SAC #" .. sacCode)
			
			if accountID > 0 then
				dbExec(mysql:getConnection(), "UPDATE accounts SET banned = 1 WHERE id = ?", accountID)
			end
		else
			kickPlayer(source, "Shine Anti-Cheat", "SAC #" .. sacCode)
		end
	end
end)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if client then
		local player = client
		
		if not dataChangeCount[player] then
            dataChangeCount[player] = {
                count = 1,
                timer = setTimer(function()
                    dataChangeCount[player] = nil
                end, 1000, 1)
            }
        else
            dataChangeCount[player].count = dataChangeCount[player].count + 1

            if dataChangeCount[player].count >= 500 then
				sendMessage("[SAC #8] " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı ve sunucudan atıldı.")
				sendMessage(">> IP: " .. getPlayerIP(player))
				sendMessage(">> Serial: " .. getPlayerSerial(player))
				
				kickPlayer(player, "Shine Anti-Cheat", "SAC #8")

                dataChangeCount[player].count = 0
                if isTimer(dataChangeCount[player].timer) then
                    killTimer(dataChangeCount[player].timer)
                end
            end
        end
	end
end)

addDebugHook("preEvent", function(sourceResource, eventName, eventSource, eventClient, luaFilename, luaLineNumber, ...)
	local thePlayer = eventSource or eventClient
	if thePlayer and getElementType(thePlayer) == "player" then
		if defaultServerEventNames[eventName] then
			return
		end
		
		if not eventUsingPlayers[thePlayer] then
			eventUsingPlayers[thePlayer] = 0
		end
		
		eventUsingPlayers[thePlayer] = eventUsingPlayers[thePlayer] + 1
		
		if eventUsingPlayers[thePlayer] >= 400 then
			sendMessage("[SAC #19] " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "playerid") .. ") isimli oyuncu Event Spam sebebiyle sunucudan atıldı.")
			sendMessage(">> IP: " .. getPlayerIP(thePlayer))
			sendMessage(">> Serial: " .. getPlayerSerial(thePlayer))
			sendMessage(">> Event: " .. tostring(eventName))
			sendMessage(">> Limit: " .. tostring(eventUsingPlayers[thePlayer]))
	
			kickPlayer(thePlayer, "Shine Anti-Cheat", "SAC #19")
		end
	end
end)

setTimer(function()
	for player, count in pairs(eventUsingPlayers) do
		if eventUsingPlayers[player] > 0 then
			eventUsingPlayers[player] = eventUsingPlayers[player] - 1
		end
	end
end, 150, 0)

addEventHandler("onPlayerQuit", root, function()
	if eventUsingPlayers[source] then
		eventUsingPlayers[source] = nil
	end
end)

addEventHandler("onDebugMessage", root, function(msg)
    if msg:find("but event is not added serverside") then
        local playerName = msg:match("Client %((.-)%) triggered")
        local eventName = msg:match("serverside event (.+), but event is not added serverside")
        local thePlayer = getPlayerFromName(playerName)
		
        if thePlayer then
            sendMessage("[SAC #20] " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. getElementData(thePlayer, "playerid") .. ") isimli oyuncu Non-Event sebebiyle sunucudan yasaklandı.")
            sendMessage(">> IP: " .. getPlayerIP(thePlayer))
            sendMessage(">> Serial: " .. getPlayerSerial(thePlayer))
            sendMessage(">> Event: " .. eventName)
    
            banPlayer(thePlayer, true, false, true, "Shine Anti-Cheat", "SAC #20")
        end
    end
end)

addEventHandler("onElementDimensionChange", root, function(oldDimension, newDimension)
	if getElementType(source) == "player" then
		if newDimension == 33333 then
			dimensionChangeTimers[source] = setTimer(function(source)
				setElementDimension(source, oldDimension)
				outputChatBox("[!]#FFFFFF Bu dünyaya ışınlanamazsınız.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			end, 1000, 1, source)
		end
	end
end)

function sendMessage(message)
    exports.cr_global:sendMessageToAdmins(message:gsub("`", ""), true)
    exports.cr_discord:sendMessage("sac-log", message)
end