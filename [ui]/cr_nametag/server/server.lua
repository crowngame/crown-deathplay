local mysql = exports.cr_mysql

function etiketVer(thePlayer, commandName, targetPlayer, level)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer and level then
            level = tonumber(level)
			if level >= 1 and level <= 107 then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						local tags = getElementData(targetPlayer, "tags") or {}
						local foundIndex = false
						
						for index, value in pairs(tags) do
							if value == level then
								foundIndex = index
							end
						end
						
						if foundIndex then
							table.remove(tags, foundIndex)
							setElementData(targetPlayer, "tags", tags)
							dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
							
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun [" .. level .. "] ID'li etiketi alındı.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin [" .. level .. "] ID'li etiketizi aldı.", targetPlayer, 0, 0, 255, true)
							exports.cr_discord:sendMessage("etiket-log", "[ETIKET-VER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun [" .. level .. "] ID'li etiketini aldı.")
						else
							if #tags >= 0 and #tags < 5 then
								table.insert(tags, level)
								setElementData(targetPlayer, "tags", tags)
								dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
								
								outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li etiket verildi.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. level .. "] ID'li etiket verdi.", targetPlayer, 0, 0, 255, true)
								exports.cr_discord:sendMessage("etiket-log", "[ETIKET-VER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li etiketi verdi.")
							else
								outputChatBox("[!]#FFFFFF Maksimum 5 tane etiket verebilirsiniz.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						end
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("[!]#FFFFFF Bu sayıya ait bir etiket bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Etiket ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketver", etiketVer, false, false)

function etiketAl(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					setElementData(targetPlayer, "tags", {})
					dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON({}), getElementData(targetPlayer, "dbid"))
					outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun etiketleri alındı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili etiketlerinizi aldı.", targetPlayer, 0, 0, 255, true)
					exports.cr_discord:sendMessage("etiket-log", "[ETIKET-AL] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun etiketlerini aldı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketal", etiketAl, false, false)

function donaterVer(thePlayer, commandName, targetPlayer, level)
	if getElementData(thePlayer, "account:username") == "Farid" or getElementData(thePlayer, "account:username") == "biax" then
		if targetPlayer then
            level = tonumber(level)
			if level then
				if level >= 0 and level <= 5 then
					targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							setElementData(targetPlayer, "donater", level)
							dbExec(mysql:getConnection(), "UPDATE accounts SET donater = ? WHERE id = ?", level, getElementData(targetPlayer, "account:id"))
							
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li donater etiketi verildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. level .. "] ID'li donater etiketi verdi.", targetPlayer, 0, 0, 255, true)
							exports.cr_discord:sendMessage("etiket-log", "[DONATER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. level .. "] ID'li donater etiketi verdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıya ait bir donater etiketi bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("donaterver", donaterVer, false, false)

function youtuberVer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "youtuber") == 1 then
						setElementData(targetPlayer, "youtuber", 0)
						dbExec(mysql:getConnection(), "UPDATE accounts SET youtuber = ? WHERE id = ?", 0, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin YouTuber etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[YOUTUBER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketini aldı.")
					else
						setElementData(targetPlayer, "youtuber", 1)
						dbExec(mysql:getConnection(), "UPDATE accounts SET youtuber = ? WHERE id = ?", 1, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size YouTuber etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[YOUTUBER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verdi.")
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ytver", youtuberVer, false, false)
addCommandHandler("youtuberver", youtuberVer, false, false)

function dmPlusVer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "dm_plus") == 1 then
						setElementData(targetPlayer, "dm_plus", 0)
						dbExec(mysql:getConnection(), "UPDATE accounts SET dm_plus = ? WHERE id = ?", 0, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun DM+ etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin DM+ etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[DM+] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun DM+ etiketini aldı.")
					else
						setElementData(targetPlayer, "dm_plus", 1)
						dbExec(mysql:getConnection(), "UPDATE accounts SET dm_plus = ? WHERE id = ?", 1, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya DM+ etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size DM+ etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[DM+] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya DM+ etiketi verdi.")
					end
					
					exports.cr_global:updateNametagColor(targetPlayer)
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("dmver", dmPlusVer, false, false)
addCommandHandler("dmplusver", dmPlusVer, false, false)