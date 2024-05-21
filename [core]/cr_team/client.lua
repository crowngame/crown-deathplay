local teams = {}
local teamBlips = {}

addEventHandler("onClientPlayerDamage", root, function(attacker, weapon, bodypart)
    if attacker and attacker ~= source then
        local sourceTeam = getPlayerTeamIndex(source)
        local attackerTeam = getPlayerTeamIndex(attacker)
		
        if sourceTeam and attackerTeam and sourceTeam == attackerTeam then
            cancelEvent()
        end
    end
end)

addEvent("team.loadTeams", true)
addEventHandler("team.loadTeams", root, function(_teams)
    if _teams and type(_teams) == "table" then
        teams = _teams
        updateTeamBlips()
    end
end)

function updateTeamBlips()
	for player, blip in pairs(teamBlips) do
        if isElement(blip) then
            destroyElement(blip)
        end
    end
    teamBlips = {}
	
	for _, teamData in pairs(teams) do
        for _, player in ipairs(teamData.players) do
            if player ~= localPlayer then
				local localTeam = getPlayerTeamIndex(localPlayer)
				local playerTeam = getPlayerTeamIndex(player)
				if localTeam == playerTeam then
					if not teamBlips[player] then
						teamBlips[player] = createBlipAttachedTo(player, 0, 2, math.random(0, 255), math.random(0, 255), math.random(0, 255), 255, 0, 99999, player)
					end
				end
            end
        end
    end
end

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