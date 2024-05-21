function getPlayerRankTitle(thePlayer)
	if thePlayer and isElement(thePlayer) then
		local kills = getElementData(thePlayer, "kills") or 0
		local title = "?"
		
		for i, v in ipairs(ranks) do
			if (kills >= ranks[i][1] and kills <= ranks[i][2]) then
				title = ranks[i][3]
			end
		end
		
		return title
	end
end

function getRankTitle(kills)
	local title = "?"
	
	for i, v in ipairs(ranks) do
		if (kills >= ranks[i][1] and kills <= ranks[i][2]) then
			title = ranks[i][3]
		end
	end
	
	return title
end

function getRankAim(kills)
	local aim = 0
	
	for i, v in ipairs(ranks) do
		if (kills >= ranks[i][1] and kills <= ranks[i][2]) then
			aim = ranks[i][2]
		end
	end
	
	return aim
end

function getPlayerRankIndex(thePlayer)
	if thePlayer and isElement(thePlayer) then
		local kills = getElementData(thePlayer, "kills") or 0
		local index = 1
		
		for i, v in ipairs(ranks) do
			if (kills >= ranks[i][1] and kills <= ranks[i][2]) then
				index = i
			end
		end
		
		return index
	end
end

function checkPlayerRank(thePlayer, chatbox)
	if thePlayer and isElement(thePlayer) then
		chatbox = chatbox or false
		local kills = getElementData(thePlayer, "kills") or 0
		for i, v in ipairs(ranks) do
			if (kills >= ranks[i][1] and kills <= ranks[i][2]) then
				if chatbox then
					if getElementData(thePlayer, "rank") ~= i then
						outputChatBox("[!]#FFFFFF Tebrikler, [" .. ranks[i][3] .. "] rütbesine yükseldiniz!", thePlayer, 0, 255, 0, true)
						triggerClientEvent(thePlayer, "rankUpSound", thePlayer)
					end
				end
				setElementData(thePlayer, "rank", i)
			end
		end
	end
end

addEventHandler("onResourceStart", resourceRoot, function()
	for i, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 then
			checkPlayerRank(source, false)
		end
    end
end)