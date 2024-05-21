local mysql = exports.cr_mysql

function banList(thePlayer, commandName)
	if exports.cr_integration:isPlayerLeaderAdmin(thePlayer) then
        local bans = {}
        local clientBans = {}
        local accountBans = {}
		
		for _, ban in ipairs(getBans()) do
        	table.insert(bans, { getBanNick(ban), getBanAdmin(ban), getBanReason(ban), getBanIP(ban), getBanSerial(ban) })
        end
		
		local query = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM bans"), -1)
		if (query) then
			for _, data in ipairs(query) do
            	table.insert(clientBans, { data["id"], data["serial"], data["admin"], data["reason"], data["date"] })
            end
        end
		
		local query = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM accounts WHERE banned = 1"), -1)
		if (query) then
			for _, data in ipairs(query) do
            	table.insert(accountBans, { data["id"], data["username"] })
            end
        end

        triggerClientEvent(thePlayer, "bans.openWindow", thePlayer, bans, clientBans, accountBans)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bans", banList, false, false)

addEvent("bans.removeBan", true)
addEventHandler("bans.removeBan", root, function(type, data)
	if client ~= source then return end
	if exports.cr_integration:isPlayerLeaderAdmin(client) then
		if type == 1 then
			removeBanFromSerial(data)
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] numaralı serialin banını kaldırıldı.", client, 0, 255, 0, true)
			exports.cr_global:sendMessageToAdmins("[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] serialin banını kaldırdı.")
			exports.cr_discord:sendMessage("ban-log", "[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] serialin banını kaldırdı.")
		elseif type == 2 then
			dbExec(mysql:getConnection(), "DELETE FROM bans WHERE id = ?", data)
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] ID'li ban kaldırıldı.", client, 0, 255, 0, true)
			exports.cr_global:sendMessageToAdmins("[UNCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] ID'li banını kaldırdı.")
			exports.cr_discord:sendMessage("ban-log", "[UNCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data .. "] ID'li banını kaldırdı.")
		elseif type == 3 then
			dbExec(mysql:getConnection(), "UPDATE accounts SET banned = 0 WHERE id = ?", data[1])
			outputChatBox("[!]#FFFFFF Başarıyla [" .. data[2] .. "] isimli hesabın banı kaldırıldı.", client, 0, 255, 0, true)
			exports.cr_global:sendMessageToAdmins("[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data[2] .. "] isimli hesabın banını kaldırdı.")
			exports.cr_discord:sendMessage("ban-log", "[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(client) .. " isimli yetkili [" .. data[2] .. "] isimli hesabın banını kaldırdı.")
		end
	end
end)

function removeBanFromSerial(serial)
	for _, ban in ipairs(getBans()) do
		if serial == getBanSerial(ban) then
			removeBan(ban)
		end
    end
end