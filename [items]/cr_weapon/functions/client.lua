function isGun(id) return getSlotFromWeapon(id) >= 2 and getSlotFromWeapon(id) <= 7 end

function clientWeaponAndAmmoCheck(player, dbid, id)
	local has_ammo, loaded_ammo, duty
	for inv_slot, item in ipairs(exports["cr_items"]:getItems(player)) do
		if item[1] == 115 and item[3] == dbid then
			local gunDetails = exports.cr_global:explode(':', item[2])
			loaded_ammo = tonumber(gunDetails[4] or 0) or 0
			local serialNumberCheck = exports.cr_global:retrieveWeaponDetails(gunDetails[2])
			duty = tonumber(serialNumberCheck[2]) == 2
		elseif item[1] == 116 and not has_ammo and not duty then
			local gunDetails = exports.cr_global:explode(':', item[2])
			local ammo, ammo_id = getAmmoForWeapon(id)
			if ammo and tonumber(gunDetails[1]) == ammo_id then
				if tonumber(gunDetails[2]) > 0 then
					has_ammo = true
				end
			end
		end

		if has_ammo and loaded_ammo then
			break
		end
	end
	return has_ammo, loaded_ammo, duty
end

function satchelCreation(creator) 
	local projectileType = getProjectileType(source)
	if projectileType == 39 then
		triggerServerEvent("weapon:removeSatchel", creator, creator, projectileType)
	end
end 
addEventHandler("onClientProjectileCreation", root, satchelCreation)

function antiChainsaw(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    local currentWeaponID = tonumber(getPedWeapon(localPlayer))
    if currentWeaponID == 9 then
        setPedWeaponSlot(localPlayer, 0)
        cancelEvent()
        outputChatBox("[!]#FFFFFF Testere politikalar gereğince artık kullanılamaz.", 255, 0, 0, true)
        outputChatBox("[!]#FFFFFF [/silahsat chainsaw] komutuyla yarı fiyatına satabilirsiniz.", 255, 0, 0, true)
		playSoundFrontEnd(4)
    end
end
addEventHandler("onClientWeaponFire", localPlayer, antiChainsaw)
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, antiChainsaw)
addEventHandler("onClientPlayerWeaponFire", localPlayer, antiChainsaw)