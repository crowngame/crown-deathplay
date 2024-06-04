local mysql = exports.cr_mysql

function givePassLevel(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_level", getElementData(targetPlayer, "pass_level") + amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_level = ? WHERE id = ?", getElementData(targetPlayer, "pass_level"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] Crown Pass seviyesi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. amount .. "] Crown Pass seviyesi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] Crown Pass seviyesi verdi.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("givepasslevel", givePassLevel, false, false)

function takePassLevel(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_level", getElementData(targetPlayer, "pass_level") - amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_level = ? WHERE id = ?", getElementData(targetPlayer, "pass_level"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] Crown Pass seviyesi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden [" .. amount .. "] Crown Pass seviyesi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] Crown Pass seviyesi aldı.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takepasslevel", takePassLevel, false, false)

function setPassLevel(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_level", amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_level = ? WHERE id = ?", getElementData(targetPlayer, "pass_level"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass seviyesini [" .. amount .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili Crown Pass seviyenizi [" .. amount .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass seviyesini [" .. amount .. "] olarak değiştirdi.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setpasslevel", setPassLevel, false, false)

function givePassXP(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_xp", getElementData(targetPlayer, "pass_xp") + amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_xp = ? WHERE id = ?", getElementData(targetPlayer, "pass_xp"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] Crown Pass XP'si verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. amount .. "] Crown Pass XP'si verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] Crown Pass XP'si verdi.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("givepassxp", givePassXP, false, false)

function takePassXP(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_xp", getElementData(targetPlayer, "pass_xp") - amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_xp = ? WHERE id = ?", getElementData(targetPlayer, "pass_xp"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] Crown Pass XP'si alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden [" .. amount .. "] Crown Pass XP'si aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] Crown Pass XP'si aldı.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("takepassxp", takePassXP, false, false)

function setPassXP(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "pass_xp", amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET pass_xp = ? WHERE id = ?", getElementData(targetPlayer, "pass_xp"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass XP'sini [" .. amount .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili Crown Pass XP'nizi [" .. amount .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass XP'sini [" .. amount .. "] olarak değiştirdi.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Miktar]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setpassxp", setPassXP, false, false)

function setPassType(thePlayer, commandName, targetPlayer, type)
	if exports.cr_integration:isPlayerServerManager(thePlayer) then
		if targetPlayer then
			type = tonumber(type)
			if type then
				if (type == 1) or (type == 2) then
					targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							setElementData(targetPlayer, "pass_type", type)
							dbExec(mysql:getConnection(), "UPDATE characters SET pass_type = ? WHERE id = ?", getElementData(targetPlayer, "pass_type"), getElementData(targetPlayer, "dbid"))
							outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass'ini [" .. type .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili Crown Pass'inizi [" .. type .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
							exports.cr_discord:sendMessage("pass-log", "[ADM-PASS] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun Crown Pass'ini [" .. type .. "] olarak değiştirdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [1 = Free Pass / 2 = Elite Pass]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [1 = Free Pass / 2 = Elite Pass]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [1 = Free Pass / 2 = Elite Pass]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setpasstype", setPassType, false, false)

function resetPass(thePlayer, commandName)
	if getElementData(thePlayer, "account:username") == "Farid" then
		for _, player in ipairs(getElementsByType("player")) do
			if (getElementData(player, "loggedin") == 1) then
				setElementData(player, "pass_type", 1)
				setElementData(player, "pass_level", 1)
				setElementData(player, "pass_xp", 0)
			end
		end
		
		dbExec(mysql:getConnection(), "UPDATE characters SET pass_type = ?, pass_level = ?, pass_xp = ?", 1, 1, 0)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("resetpass", resetPass, false, false)

function resetPassMissions(thePlayer, commandName)
	if getElementData(thePlayer, "account:username") == "Farid" then
		dbExec(mysql:getConnection(), "DELETE FROM pass_rewards WHERE reward_type = 3")
		dbExec(mysql:getConnection(), "DELETE FROM pass_missions")
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("resetpassmissions", resetPassMissions, false, false)