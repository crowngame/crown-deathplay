local joinedPlayers = {
	daily = {},
	weekly = {},
	monthly = {}
}

addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		addPlayer(player)
	end
end)

addEventHandler("onPlayerJoin", root, function()
	if not isPlayerInTable(source) then
		addPlayer(source)
	end
end)

function addPlayer(thePlayer)
	if not (thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player") then
        return false
    end
	
	local serial = getPlayerSerial(thePlayer)
	
	table.insert(joinedPlayers.daily, serial)
	table.insert(joinedPlayers.weekly, serial)
	table.insert(joinedPlayers.monthly, serial)
end

function isPlayerInTable(thePlayer)
    if not (thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player") then
        return false
    end

    local serial = getPlayerSerial(thePlayer)

    for _, timeFrame in pairs(joinedPlayers) do
        for _, serialInTable in ipairs(timeFrame) do
            if serial == serialInTable then
                return true
            end
        end
    end

    return false
end

function getStatistic(thePlayer, commandName, timeFrame)
	if exports.cr_integration:isPlayerLeaderAdmin(thePlayer) then
		if timeFrame == "daily" then
			outputChatBox(">>#FFFFFF Sunucuya bugün " .. #joinedPlayers.daily .. " oyuncu giriş sağladı.", thePlayer, 0, 255, 0, true)
		elseif timeFrame == "weekly" then
			outputChatBox(">>#FFFFFF Sunucuya bu hafta " .. #joinedPlayers.daily .. " oyuncu giriş sağladı.", thePlayer, 0, 255, 0, true)
		elseif timeFrame == "monthly" then
			outputChatBox(">>#FFFFFF Sunucuya bu ay " .. #joinedPlayers.daily .. " oyuncu giriş sağladı.", thePlayer, 0, 255, 0, true)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [daily / weekly / monthly]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("getstatistic", getStatistic, false, false)