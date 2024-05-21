local players = {}
local timers = {}
local blockTime = 1000

function onCommand(commandName)
	if not getElementData(source, "command_block") then
		players[source] = tonumber(players[source] or 0) + 1
		if players[source] >= 5 then
			outputChatBox("[!]#FFFFFF Bu kadar sık komut kullanmayınız.", source, 255, 0, 0, true)
			setElementData(source, "command_block", true)
			cancelEvent()
		end
	
		if isTimer(timers[source]) then
			killTimer(timers[source])
		end
	
		timers[source] = setTimer(function(source)
			players[source] = 0
			if isElement(source) and getElementData(source, "command_block") then
				setElementData(source, "command_block", false)
			end
		end, blockTime, 1, source)
	else
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand", root, onCommand)