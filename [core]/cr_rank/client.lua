addEvent("rankUpSound", true)
addEventHandler("rankUpSound", root, function()
	local sound = playSound("public/sounds/rank_up.mp3", false)
	setSoundVolume(sound, 0.5)
end)

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