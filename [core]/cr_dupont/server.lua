local mysql = exports.cr_mysql
local usedSkins = {}

function dupontVer(thePlayer, commandName, targetPlayer, skin, url)
    if exports.cr_integration:isPlayerManager(thePlayer) then
        if targetPlayer then
            skin = tonumber(skin)
            if skin then
                if url then
					local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							dbExec(mysql:getConnection(), "INSERT INTO clothing (cid, skin, url) VALUES (?, ?, ?)", getElementData(targetPlayer, "dbid"), skin, url)
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya dupont verildi.", thePlayer, 0, 255, 0, true)
							exports.cr_global:sendMessageToAdmins("[DUPONT] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya dupont verdi.", true)
							exports.cr_discord:sendMessage("dupontver-log", "**[DUPONT]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya dupont verdi.")
							exports.cr_discord:sendMessage("dupontver-log", "**[DUPONT]** **Skin:** " .. skin)
							exports.cr_discord:sendMessage("dupontver-log", "**[DUPONT]** **URL:** " .. url)
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
                else
                    outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Skin ID] [URL]", thePlayer, 255, 194, 14)
                end
            else
                outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Skin ID] [URL]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Skin ID] [URL]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("dupontver", dupontVer, false, false)

function dupontSkin(thePlayer, commandName, dupontID)
	dupontID = tonumber(dupontID)
	if dupontID then
		dbQuery(function(queryHandler)
			local result, rows, err = dbPoll(queryHandler, 0)
			if rows > 0 and result[dupontID] then
				setPedSkin(thePlayer, result[dupontID].skin)
				usedSkins[thePlayer] = result[dupontID]
				fetchRemote(result[dupontID].url, function(data, err, element)
					if err == 0 then
						triggerClientEvent(root, "dupont.requestDupont", root, element, data)
					end
				end, "", false, thePlayer)

				outputChatBox("[!]#FFFFFF Başarıyla [" .. dupontID .. "] ID'li dupont kuşanıldı.", thePlayer, 0, 255, 0, true)
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
			else
				outputChatBox("[!]#FFFFFF Böyle bir dupont bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end, mysql:getConnection(), "SELECT * FROM clothing WHERE cid = ?", getElementData(thePlayer, "dbid"))
	else
        outputChatBox("KULLANIM: /" .. commandName .. " [Dupont ID]", thePlayer, 255, 194, 14)
    end
end
addCommandHandler("dupont", dupontSkin, false, false)