local mysql = exports.cr_mysql

local drops = {}
local dropTimers = {}
local prices = {
    -- type, name, id
	-- type 1 = lucky box
	-- type 2 = money
	-- type 3 = elite pass
	
    {1, "Bronz Şans Kutusu", 581},
    {1, "Gümüş Şans Kutusu", 582},
    {1, "Altın Şans Kutusu", 583},
    {1, "Elmas Şans Kutusu", 584},
    {2, 100000},
    {2, 250000},
    {2, 500000},
    {2, 750000},
    {2, 1000000},
    {3},
}

function createDrop(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		local x, y, z = getElementPosition(thePlayer)
		
		local index = #drops + 1
		drops[index] = {}
        drops[index].object = createObject(2903, x, y, z + 100)
        moveObject(drops[index].object, 10000, x, y, z + 6.4)
		setElementFrozen(drops[index].object, true)
        drops[index].blip = createBlip(x, y, z, 19, 0, 0, 0, 255)
		
		dropTimers[drops[index].object] = setTimer(function(object)
			setElementPosition(object, x, y, z - 0.3)
			setElementModel(object, 2919)
			setElementPosition(object, x, y, z - 0.3)
			
			setTimer(function()
				setElementPosition(object, x, y, z - 0.3)
			end, 500, 1)
		end, 10000, 1, drops[index].object)
		
		triggerClientEvent(root, "drop.startProcess", root, drops[index].object)
		
		setTimer(function()
            drops[index].colSphere = createColSphere(x, y, z, 3)
            addEventHandler("onColShapeHit", drops[index].colSphere, function(element, dimension)
				if not getPedOccupiedVehicle(element) then
					hitDrop(element, index)
				end
            end)
        end, 1000 * 130, 1)
		
		outputChatBox("[DROP]#FFFFFF Şehirin bir bölgesine drop bırakıldı, haritadaki blip'e git ve çatış!", root, 232, 113, 114, true)
		outputChatBox("[DROP]#FFFFFF Drop'u 120 saniye sonra alabilirsiniz, ilk alan ödülü kapar!", root, 232, 113, 114, true)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("createdrop", createDrop, false, false)

function hitDrop(thePlayer, index)
    if isElement(drops[index].object) then
		triggerClientEvent(root, "drop.deleteProcess", root, drops[index].object)
        destroyElement(drops[index].object)
		destroyElement(drops[index].blip)
		destroyElement(drops[index].colSphere)
		drops[index] = nil
    end

    local randomPrice = math.random(1, #prices)
	
	if prices[randomPrice][1] == 1 then
		if exports.cr_items:hasSpaceForItem(thePlayer, prices[randomPrice][3], 1) then
			exports.cr_global:giveItem(thePlayer, prices[randomPrice][3], 1)
			outputChatBox("[DROP]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu drop'u açtı ve " .. prices[randomPrice][2] .. " kazandı.", root, 232, 113, 114, true)
		else
			exports.cr_global:giveMoney(thePlayer, 500000)
			outputChatBox("[DROP]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu drop'u açtı ve $" .. exports.cr_global:formatMoney(500000) .. " kazandı.", root, 232, 113, 114, true)
		end
	elseif prices[randomPrice][1] == 2 then
		exports.cr_global:giveMoney(thePlayer, prices[randomPrice][2])
		outputChatBox("[DROP]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu drop'u açtı ve $" .. exports.cr_global:formatMoney(prices[randomPrice][2]) .. " kazandı.", root, 232, 113, 114, true)
	elseif prices[randomPrice][1] == 3 then
		local randomNumber = math.random(1, 2)
		if (randomNumber == 1) and (getElementData(thePlayer, "pass_type") ~= 2) then
			setElementData(thePlayer, "pass_type", 2)
			dbExec(mysql:getConnection(), "UPDATE characters SET pass_type = 2 WHERE id = ?", getElementData(thePlayer, "dbid"))
			outputChatBox("[DROP]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu drop'u açtı ve #FFD43BElite Pass#FFFFFF kazandı.", root, 232, 113, 114, true)
		else
			exports.cr_global:giveMoney(thePlayer, 500000)
			outputChatBox("[DROP]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu drop'u açtı ve $" .. exports.cr_global:formatMoney(500000) .. " kazandı.", root, 232, 113, 114, true)
		end
	end
	
	exports.cr_pass:addMissionValue(thePlayer, 13, 1)
end