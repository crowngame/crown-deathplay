local colision = createColSphere(275.6669921875, -2051.6669921875, 3085.5180664062, 40)
local timers = {}

addEventHandler("onColShapeHit", colision, function(thePlayer, matchingDimension)
	if getElementType(thePlayer) == "player" then
		local money = 3000
		if getElementData(thePlayer, "vip") == 1 then
			money = 3500
		elseif getElementData(thePlayer, "vip") == 2 then
			money = 4000
		elseif getElementData(thePlayer, "vip") == 3 then
			money = 4500
		elseif getElementData(thePlayer, "vip") == 4 then
			money = 5000
		elseif getElementData(thePlayer, "vip") == 5 then
			money = 5500
		end
		
		-- 2x para
		-- money = money * 2
		
		outputChatBox("[!]#FFFFFF AFK bölgesine giriş yaptınız, her 1 dakikada " .. exports.cr_global:formatMoney(money) .. "$ kazanacaksınız.", thePlayer, 0, 255, 0, true)
		
		timers[thePlayer] = setTimer(function()
			exports.cr_global:giveMoney(thePlayer, money)
			outputChatBox("[!]#FFFFFF AFK bölgesinde 1 dakika durdunuz ve " .. exports.cr_global:formatMoney(money) .. "$ kazandınız!", thePlayer, 0, 255, 0, true)
		end, 60 * 1000, 0)
	end
end)

addEventHandler("onColShapeLeave", colision, function(thePlayer, matchingDimension)
	if getElementType(thePlayer) == "player" then
		outputChatBox("[!]#FFFFFF AFK bölgesinden çıkış yaptınız.", thePlayer, 255, 0, 0, true)
		if timers[thePlayer] then
			killTimer(timers[thePlayer])
			timers[thePlayer] = nil
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	if timers[source] then 
		killTimer(timers[source])
		timers[source] = nil
	end
end)