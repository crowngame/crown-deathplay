local mysql = exports.cr_mysql

addEventHandler("onPlayerWasted", root, function(ammo, killer, killerweapon, bodypart)
	if (killer) and (killer ~= source) and (getElementType(killer) == "player" and getElementType(source) == "player") then
		if not getElementData(source, "adminjailed") then
			local money = math.random(3000, 5000)
			
			if getElementData(killer, "vip") == 1 then
				money = money + 500
			elseif getElementData(killer, "vip") == 2 then
				money = money + 1000
			elseif getElementData(killer, "vip") == 3 then
				money = money + 1500
			elseif getElementData(killer, "vip") == 4 then
				money = money + 2000
			elseif getElementData(killer, "vip") == 5 then
				money = money + 2500
			end
			
			if exports.cr_team:isPlayerInTeam(killer) then
				local teamPlayers = exports.cr_team:getPlayerTeamPlayers(killer)
				local teamSize = #teamPlayers
				
				if teamSize > 1 then
					local moneyPerPlayer = math.floor(money / teamSize)
					
					for _, teamPlayer in ipairs(teamPlayers) do
						exports.cr_global:giveMoney(teamPlayer, moneyPerPlayer)
						
						if teamPlayer == killer then
							outputChatBox("[!]#FFFFFF " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncuyu öldürerek $" .. exports.cr_global:formatMoney(moneyPerPlayer) .. " kendine ve takımınıza kazandırdınız!", teamPlayer, 0, 255, 0, true)
						else
							outputChatBox("[!]#FFFFFF " .. getPlayerName(killer):gsub("_", " ") .. " isimli takım arkadaşın " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncuyu öldürerek takıma $" .. exports.cr_global:formatMoney(moneyPerPlayer) .. " kazandırdı!", teamPlayer, 0, 255, 0, true)
						end
					end
				else
					exports.cr_global:giveMoney(killer, money)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncuyu öldürerek $" .. exports.cr_global:formatMoney(money) .. " kazandınız!", killer, 0, 255, 0, true)
				end
				
				exports.cr_pass:addMissionValue(killer, 2, 1)
			else
				exports.cr_global:giveMoney(killer, money)
				outputChatBox("[!]#FFFFFF " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncuyu öldürerek $" .. exports.cr_global:formatMoney(money) .. " kazandınız!", killer, 0, 255, 0, true)
			end
			
			setElementData(killer, "kills", getElementData(killer, "kills") + 1)
			exports.cr_rank:checkPlayerRank(killer, true)
			setElementHealth(killer, 100)
			
			setElementData(source, "deaths", getElementData(source, "deaths") + 1)
			
			dbExec(mysql:getConnection(), "UPDATE characters SET kills = ? WHERE id = ?", mysql:escape_string(getElementData(killer, "kills")), mysql:escape_string(getElementData(killer, "dbid")))
			dbExec(mysql:getConnection(), "UPDATE characters SET deaths = ? WHERE id = ?", mysql:escape_string(getElementData(source, "deaths")), mysql:escape_string(getElementData(source, "dbid")))
			
			exports.cr_pass:addMissionValue(killer, 1, 1)
			
			if killerweapon == 30 then
				exports.cr_pass:addMissionValue(killer, 3, 1)
			end
			
			if bodypart == 9 then
				exports.cr_pass:addMissionValue(killer, 4, 1)
			end
			
			exports.cr_pass:setMissionValue(killer, 11, getElementData(killer, "kills"))
			exports.cr_pass:setMissionValue(killer, 12, getElementData(killer, "kills"))
		end
	end
end)

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
	if bodypart == 9 then
		if getElementInterior(source) == 3 and getElementDimension(source) == 313 then
			killPed(source, attacker, weapon, bodypart)
		end
	end
end)

function oldurmeVer(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "kills", getElementData(targetPlayer, "kills") + amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET kills = ? WHERE id = ?", getElementData(targetPlayer, "kills"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] öldürme verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. amount .. "] öldürme verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLDÜRME-VER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] öldürme verdi.")
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
addCommandHandler("oldurmever", oldurmeVer, false, false)

function oldurmeAl(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "kills", getElementData(targetPlayer, "kills") - amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET kills = ? WHERE id = ?", getElementData(targetPlayer, "kills"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] öldürme alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden [" .. amount .. "] öldürme aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLDÜRME-AL] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] öldürme aldı.")
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
addCommandHandler("oldurmeal", oldurmeAl, false, false)

function setOldurme(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "kills", amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET kills = ? WHERE id = ?", getElementData(targetPlayer, "kills"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun öldürmesi [" .. amount .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili öldürmenizi [" .. amount .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLDÜRME-AYARLA] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun öldürmesi [" .. amount .. "] olarak değiştirdi.")
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
addCommandHandler("setoldurme", setOldurme, false, false)

function olmeVer(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "deaths", getElementData(targetPlayer, "deaths") + amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET deaths = ? WHERE id = ?", getElementData(targetPlayer, "deaths"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] ölme verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. amount .. "] ölme verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLME-VER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncuya [" .. amount .. "] ölme verdi.")
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
addCommandHandler("olmever", olmeVer, false, false)

function olmeAl(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "deaths", getElementData(targetPlayer, "deaths") - amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET deaths = ? WHERE id = ?", getElementData(targetPlayer, "deaths"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] ölme alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizden [" .. amount .. "] ölme aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLME-AL] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncudan [" .. amount .. "] ölme aldı.")
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
addCommandHandler("olmeal", olmeAl, false, false)

function setOlme(thePlayer, commandName, targetPlayer, amount)
	if exports.cr_integration:isPlayerGeneralAdmin(thePlayer) then
		if targetPlayer then
			amount = tonumber(amount)
			if amount then
				targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						setElementData(targetPlayer, "deaths", amount)
						dbExec(mysql:getConnection(), "UPDATE characters SET deaths = ? WHERE id = ?", getElementData(targetPlayer, "deaths"), getElementData(targetPlayer, "dbid"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun ölmesini [" .. amount .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili ölmenizi [" .. amount .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("kill-log", "[ÖLME-AYARLA] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun ölmesini [" .. amount .. "] olarak değiştirdi.")
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
addCommandHandler("setolme", setOlme, false, false)