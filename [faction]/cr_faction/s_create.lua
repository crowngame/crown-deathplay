mysql = exports.cr_mysql

function birlikKur(thePlayer, commandName)
	local playerTeam = getElementData(thePlayer, "faction")
	
	if playerTeam ~= -1 then
		outputChatBox("[!]#FFFFFF Zaten bir birliğiniz var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return
	end
	
	triggerClientEvent(thePlayer, "birlikKurGUI", thePlayer)
end
addCommandHandler("birlikkur", birlikKur, false, false)

addEvent("birlikKur", true)
addEventHandler("birlikKur", root, function(birlikName, birlikType)
	if client ~= source then return end
	
	if string.len(birlikName) < 4 then
		outputChatBox("[!]#FFFFFF Birlik ismi en az 4 karakterden oluşmalıdır.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return false
	elseif string.len(birlikName) > 36 then
		outputChatBox("[!]#FFFFFF Birlik ismi en fazla 36 karakterden oluşmalıdır.", client, 255, 0, 0, true)
		playSoundFrontEnd(client, 4)
		return false
	end
	
	if exports.cr_global:hasMoney(client, 500000) then
		factionName = birlikName
		factionType = tonumber(birlikType)
		local getrow = mysql:query("SELECT * FROM factions WHERE name='" .. factionName .. "'")
		local numrows = mysql:num_rows(getrow)
		if numrows > 0 then
			outputChatBox("[!]#FFFFFF Maalesef, bu birlik ismi kullanımda.", client, 255, 0, 0, true)
			return false
		end
		
		local theTeam = createTeam(tostring(factionName))
		if theTeam then
			if mysql:query_free("INSERT INTO factions SET name='" .. mysql:escape_string(factionName) .. "', bankbalance='0', type='" .. mysql:escape_string(factionType) .. "'") then
				local id = mysql:insert_id()
				exports.cr_pool:allocateElement(theTeam, id)
				
				dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='Dinamik Rütbe #1', rank_2='Dinamik Rütbe #2', rank_3='Dinamik Rütbe #3', rank_4='Dinamik Rütbe #4', rank_5='Dinamik Rütbe #5', rank_6='Dinamik Rütbe #6', rank_7='Dinamik Rütbe #7', rank_8='Dinamik Rütbe #8', rank_9='Dinamik Rütbe #9', rank_10='Dinamik Rütbe #10', rank_11='Dinamik Rütbe #11', rank_12='Dinamik Rütbe #12', rank_13='Dinamik Rütbe #13', rank_14='Dinamik Rütbe #14', rank_15='Dinamik Rütbe #15', rank_16='Dinamik Rütbe #16', rank_17='Dinamik Rütbe #17', rank_18='Dinamik Rütbe #18', rank_19='Dinamik Rütbe #19', rank_20='Dinamik Rütbe #20',  motd='Welcome to the faction.', note = '' WHERE id='" .. id .. "'")
				outputChatBox("[!]#FFFFFF Başarıyla " .. factionName .. " (" .. id .. ") isimli birlik kuruldu.", client, 0, 255, 0, true)
				setElementData(theTeam, "type", tonumber(factionType))
				setElementData(theTeam, "id", tonumber(id))
				setElementData(theTeam, "money", 0)
				
				local factionRanks = {}
				local factionWages = {}
				for i = 1, 20 do
					factionRanks[i] = "Dinamik Rütbe #" .. i
					factionWages[i] = 100
				end
				setElementData(theTeam, "ranks", factionRanks, false)
				setElementData(theTeam, "wages", factionWages, false)
				setElementData(theTeam, "motd", "Birliğe hoş geldiniz.", false)
				setElementData(theTeam, "note", "", false)
				
				dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(id) .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(client, "dbid"))
				setPlayerTeam(client, theTeam)
				setElementData(client, "faction", id, true)
				setElementData(client, "factionrank", 1, true)
				setElementData(client, "factionleader", 1, true)
				setElementData(client, "factionphone", nil, true)
				triggerEvent("duty:offduty", client)
				triggerEvent("onPlayerJoinFaction", client, theTeam)
				
				exports.cr_logs:dbLog(client, 4, theTeam, "MAKE FACTION")
				exports.cr_global:takeMoney(client, 500000)
				exports.cr_global:sendMessageToAdmins("[BIRLIK-KUR] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. factionName .. " [" .. id .. "] isimli yeni birlik oluşturdu.")
			else
				destroyElement(theTeam)
				outputChatBox("[!]#FFFFFF Bir sorun oluştu.", client, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Böyle bir birlik bulunuyor.", client, 255, 0, 0, true)
		end
	else
		outputChatBox("[!]#FFFFFF Maalesef, birlik kuracak paranız yok.", client, 255, 0, 0, true)
	end
end)