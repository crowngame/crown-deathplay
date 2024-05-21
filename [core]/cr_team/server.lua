local teams = {}

function teamCommand(thePlayer, commandName, process, ...)
    if process == "kur" then
        if not isPlayerInTeam(thePlayer) then
            local teamID = #teams + 1
            teams[teamID] = {}
            teams[teamID].players = {}
            teams[teamID].leader = thePlayer
            table.insert(teams[teamID].players, thePlayer)
			triggerClientEvent(root, "team.loadTeams", root, teams)
			exports.cr_pass:addMissionValue(thePlayer, 5, 1)
            
			outputChatBox("[!]#FFFFFF Takımınız kuruldu.", thePlayer, 0, 255, 0, true)
            triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
        else
            outputChatBox("[!]#FFFFFF Zaten bir takımdasınız.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "ekle" then
        if isPlayerInTeam(thePlayer) then
            if (...) then
                local teamIndex = getPlayerTeamIndex(thePlayer)
                if #teams[teamIndex].players <= 10 then
                    local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, table.concat({...}, " "))
                    if targetPlayer then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						if distance <= 10 then
							if not isPlayerInTeam(targetPlayer) then
								local teamIndex = getPlayerTeamIndex(thePlayer)
								
								table.insert(teams[teamIndex].players, targetPlayer)
								triggerClientEvent(root, "team.loadTeams", root, teams)
								
								outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuyu takımınıza eklediniz.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu sizi takıma ekledi.", targetPlayer, 0, 0, 255, true)
								
								for index, player in ipairs(teams[teamIndex].players) do 
									if player ~= thePlayer and player ~= targetPlayer then
										outputChatBox("[>]#FFFFFF " .. targetPlayerName .. " isimli oyuncu takıma katıldı.", player, 0, 255, 0, true)
									end
								end
							else
								outputChatBox("[!]#FFFFFF Hedef oyuncu zaten bir takımda bulunuyor.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncudan uzaksınız.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
                    end
                else
                    outputChatBox("[!]#FFFFFF Takıma en fazla 10 kişi ekleyebilirsiniz.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("KULLANIM: /" .. commandName .. " " .. process .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "dagit" then
        if isPlayerInTeam(thePlayer) then
            local teamIndex = getPlayerTeamIndex(thePlayer)
            
            for index, player in ipairs(teams[teamIndex].players) do 
                if player ~= thePlayer then 
                    outputChatBox("[!]#FFFFFF Takımınız " .. getPlayerName(thePlayer):gsub("_", " ") .. " tarafından dağıtıldı.", player, 255, 0, 0, true)
                end
            end
            
            teams[teamIndex] = nil
			triggerClientEvent(root, "team.loadTeams", root, teams)
            
            outputChatBox("[!]#FFFFFF Takımı dağıtdınız.", thePlayer, 0, 255, 0, true)
			triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "ayril" then
        if isPlayerInTeam(thePlayer) then
            local teamIndex = getPlayerTeamIndex(thePlayer)
            
            for index, player in ipairs(teams[teamIndex].players) do 
                if player == thePlayer then 
                    table.remove(teams[teamIndex].players, index)
                end
                
				if player ~= thePlayer then
					outputChatBox("[<]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu takımdan ayrıldı.", player, 255, 0, 0, true)
				end
            end
            
            if #teams[teamIndex].players == 0 then
                teams[teamIndex] = nil
            end
			
			triggerClientEvent(root, "team.loadTeams", root, teams)
            
            outputChatBox("[!]#FFFFFF Takımdan ayrıldınız.", thePlayer, 0, 255, 0, true)
			triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "liste" then
        if isPlayerInTeam(thePlayer) then
            local teamIndex = getPlayerTeamIndex(thePlayer)
            
            outputChatBox("[!]#FFFFFF Takımdaki oyuncular:", thePlayer, 0, 0, 255, true)
            
            for index, player in ipairs(teams[teamIndex].players) do
                if teams[teamIndex].leader == player then
                    outputChatBox(">>#FFFFFF " .. getPlayerName(player):gsub("_", " ") .. " (Lider)", thePlayer, 0, 255, 0, true)
                else
                    outputChatBox(">>#FFFFFF " .. getPlayerName(player):gsub("_", " "), thePlayer, 0, 255, 0, true)
                end
            end
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "at" then
        if isPlayerInTeam(thePlayer) then
            if (...) then
                local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, table.concat({...}, " "))
                if targetPlayer then
                    if isPlayerInTeam(targetPlayer) then
                        local playerTeam = getPlayerTeamIndex(thePlayer)
                        if teams[playerTeam].leader == thePlayer then
                            if thePlayer ~= targetPlayer then
                                local targetTeam = getPlayerTeamIndex(targetPlayer)
                                if playerTeam == targetTeam then
                                    for index, player in ipairs(teams[playerTeam].players) do
                                        if player == targetPlayer then
                                            table.remove(teams[playerTeam].players, index)
                                        end
                                        
										if player ~= thePlayer and player ~= targetPlayer then
											outputChatBox("[<]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. targetPlayerName .. " isimli oyuncuyu takımdan attı.", player, 255, 0, 0, true)
										end
									end
                                    
                                    if #teams[playerTeam].players == 0 then
                                        teams[playerTeam] = nil
                                    end
									
									triggerClientEvent(root, "team.loadTeams", root, teams)
                                    
                                    outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuyu takımdan attınız.", thePlayer, 0, 255, 0, true)
									triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
									
                                    outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu sizi takımdan attı.", targetPlayer, 0, 0, 255, true)
                                else
                                    outputChatBox("[!]#FFFFFF Bu oyuncu sizin takımınızdan değil.", thePlayer, 255, 0, 0, true)
                                    playSoundFrontEnd(thePlayer, 4)
                                end
                            else
                                outputChatBox("[!]#FFFFFF Kendinizi takımdan atamazsınız.", thePlayer, 255, 0, 0, true)
                                playSoundFrontEnd(thePlayer, 4)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Takım lideri değilsiniz.", thePlayer, 255, 0, 0, true)
                            playSoundFrontEnd(thePlayer, 4)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Hedef oyuncu herhangi bir takımda bulunmuyor.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("KULLANIM: /" .. commandName .. " " .. process .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
    elseif process == "devret" then
        if isPlayerInTeam(thePlayer) then
            if (...) then
                local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, table.concat({...}, " "))
                if targetPlayer then
                    if isPlayerInTeam(targetPlayer) then
                        local teamIndex = getPlayerTeamIndex(thePlayer)
                        if teams[teamIndex].leader == thePlayer then
                            if thePlayer ~= targetPlayer then
                                local targetTeam = getPlayerTeamIndex(targetPlayer)
                                if teamIndex == targetTeam then
                                    teams[teamIndex].leader = targetPlayer
									triggerClientEvent(root, "team.loadTeams", root, teams)
                                    
                                    outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya takım liderliğini devrettiniz.", thePlayer, 0, 255, 0, true)
									triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
									
                                    outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu takım liderliğini size devretti.", targetPlayer, 0, 0, 255, true)
                                
                                    for index, player in ipairs(teams[teamIndex].players) do
                                        if player ~= thePlayer and player ~= targetPlayer then
                                            outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. targetPlayerName .. " isimli oyuncuya takım liderliğini devretti.", player, 255, 0, 0, true)
                                        end
                                    end
                                else
                                    outputChatBox("[!]#FFFFFF Bu oyuncu sizin takımınızdan değil.", thePlayer, 255, 0, 0, true)
                                    playSoundFrontEnd(thePlayer, 4)
                                end
                            else
                                outputChatBox("[!]#FFFFFF Kendinizi takım liderliğini devredemezsiniz.", thePlayer, 255, 0, 0, true)
                                playSoundFrontEnd(thePlayer, 4)
                            end
                        else
                            outputChatBox("[!]#FFFFFF Takım lideri değilsiniz.", thePlayer, 255, 0, 0, true)
                            playSoundFrontEnd(thePlayer, 4)
                        end
                    else
                        outputChatBox("[!]#FFFFFF Hedef oyuncu herhangi bir takımda bulunmuyor.", thePlayer, 255, 0, 0, true)
                        playSoundFrontEnd(thePlayer, 4)
                    end
                end
            else
                outputChatBox("KULLANIM: /" .. commandName .. " " .. process .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
            end
        else
            outputChatBox("[!]#FFFFFF Herhangi bir takımda bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
        end
	elseif process == "takimlar" then
		if #teams ~= 0 then
			for teamID, teamData in pairs(teams) do
				outputChatBox("[!]#FFFFFF Takım " .. teamID .. ":", thePlayer, 0, 0, 255, true)
				for key, player in ipairs(teamData.players) do
					if teamData.leader == player then
						outputChatBox(">>#FFFFFF " .. getPlayerName(player):gsub("_", " ") .. " (Lider)", thePlayer, 0, 255, 0, true)
					else
						outputChatBox(">>#FFFFFF " .. getPlayerName(player):gsub("_", " "), thePlayer, 0, 255, 0, true)
					end
				end
			end
		else
			outputChatBox("[!]#FFFFFF Herhangi bir takım bulunmuyor.", thePlayer, 255, 0, 0, true)
            playSoundFrontEnd(thePlayer, 4)
		end
    else
        outputChatBox("KULLANIM: /" .. commandName .. " [kur / ekle / dagit / ayril / liste / at / devret / takimlar]", thePlayer, 255, 194, 14)
    end
end
addCommandHandler("takim", teamCommand, false, false)

addEventHandler("onPlayerQuit", root, function(reason)
    local player = source
    if isPlayerInTeam(player) then
        local teamIndex = getPlayerTeamIndex(player)
        local teamData = teams[teamIndex]
        
        if teamData.leader == player then
            for _, teammate in ipairs(teamData.players) do
                if teammate ~= player then
                    outputChatBox("[!]#FFFFFF Takım lideri " .. getPlayerName(player):gsub("_", " ") .. " sunucudan ayrıldığı için takım dağıtıldı.", teammate, 255, 0, 0, true)
                end
            end
            
            teams[teamIndex] = nil
            triggerClientEvent(root, "team.loadTeams", root, teams)
        else
            for index, teammate in ipairs(teamData.players) do
                if teammate == player then
                    table.remove(teamData.players, index)
                    break
                end
            end
            
            if #teamData.players == 0 then
                teams[teamIndex] = nil
                triggerClientEvent(root, "team.loadTeams", root, teams)
            end
        end
    end
end)

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart)
    if attacker and attacker ~= source then
        local sourceTeam = getPlayerTeamIndex(source)
        local attackerTeam = getPlayerTeamIndex(attacker)
		
        if sourceTeam and attackerTeam and sourceTeam == attackerTeam then
			outputChatBox("[!]#FFFFFF Takım arkadaşınıza hasar veremezsiniz.", attacker, 255, 0, 0, true)
			playSoundFrontEnd(attacker, 4)
        end
    end
end)

function isPlayerInTeam(thePlayer)
    for index, value in pairs(teams) do 
        for key, player in ipairs(value.players) do
            if player == thePlayer then
                return true
            end
        end
    end
    return false
end

function getPlayerTeamIndex(thePlayer)
    for index, value in pairs(teams) do 
        for key, player in ipairs(value.players) do
            if player == thePlayer then
                return index
            end
        end
    end
	return false
end

function getPlayerTeamPlayers(thePlayer)
    local teamPlayers = {}
    
    if isPlayerInTeam(thePlayer) then
        local teamIndex = getPlayerTeamIndex(thePlayer)
        
        for key, player in ipairs(teams[teamIndex].players) do
            table.insert(teamPlayers, player)
        end
    end
    
    return teamPlayers
end