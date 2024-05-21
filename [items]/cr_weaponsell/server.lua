local weapons = {
	["colt 45"] = 0,
	["deagle"] = 10000,
	["uzi"] = 150000,
	["tec-9"] = 150000,
	["mp5"] = 0,
	["shotgun"] = 500000,	
	["ak-47"] = 5000000,
	["m4"] = 7000000,
	["combat shotgun"] = 10000000,		
	["rifle"] = 10000000,
	["chainsaw"] = 15000000,
}

function silahSat(thePlayer, commandName, ...)
	if (...) then
		local weaponName = table.concat({...}, " ")
		if weapons[weaponName] then
			local foundWeapon = false
			for _, value in ipairs(exports.cr_items:getItems(thePlayer)) do
				if weaponName == string.lower(tostring(explode(":", value[2])[3])) then
					foundWeapon = value
					break
				end
			end
			
			if foundWeapon then
				if weapons[weaponName] ~= 0 then
					exports.cr_items:takeItem(thePlayer, 115, foundWeapon[2])
					exports.cr_global:giveMoney(thePlayer, math.floor(weapons[weaponName] / 2))
					
					outputChatBox("[!]#FFFFFF Başarıyla [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahınızı satarak $" .. exports.cr_global:formatMoney(math.floor(weapons[weaponName] / 2)) .. " kazandınız!", thePlayer, 0, 255, 0, true)
					triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					
					exports.cr_global:sendMessageToAdmins("[SILAHSAT] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahını satarak $" .. exports.cr_global:formatMoney(math.floor(weapons[weaponName] / 2)) .. " kazandı.")
					exports.cr_discord:sendMessage("silahsat-log", "[SILAHSAT] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahını satarak $" .. exports.cr_global:formatMoney(math.floor(weapons[weaponName] / 2)) .. " kazandı.")
				else
					exports.cr_items:takeItem(thePlayer, 115, foundWeapon[2])
					
					outputChatBox("[!]#FFFFFF Başarıyla [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahınızı satarak $0 kazandınız!", thePlayer, 0, 255, 0, true)
					triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
					
					exports.cr_global:sendMessageToAdmins("[SILAHSAT] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahını satarak $0 kazandı.")
					exports.cr_discord:sendMessage("silahsat-log", "[SILAHSAT] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu [" .. tostring(explode(":", foundWeapon[2])[3]) .. "] markalı silahını satarak $0 kazandı.")
				end
			else
				outputChatBox("[!]#FFFFFF Üzerinizde [" .. weaponName .. "] markalı silah bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Silah İsmi]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Silah İsmi]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("silahsat", silahSat, false, false)

function explode(div,str)
	if (div=='') then return false end
	local pos,arr = 0,{}
	for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1))
	pos = sp + 1
	end
	table.insert(arr,string.sub(str,pos))
	return arr
end