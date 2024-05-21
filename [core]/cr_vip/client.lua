local mysql = exports.cr_mysql

local specialWeapons = {
	--[weapon_id] = {true, gereken_level (default değeri 1) }
	[34] = {true, 5},
}

function antiWeapon(preSlot)
	local currentWeaponID = getPedWeapon(localPlayer)
	if specialWeapons[currentWeaponID] then
		if specialWeapons[currentWeaponID][1] then
			local vipLevel = getElementData(localPlayer, "vip") or 0
			local requiredLevel = specialWeapons[currentWeaponID][2] or 1
			if not (vipLevel >= requiredLevel) then
				setPedWeaponSlot(localPlayer, preSlot)
				outputChatBox("[!]#FFFFFF " .. getWeaponNameFromID(currentWeaponID) .. " adlı silahı kullanabilmen için VIP [" .. requiredLevel .. "] olmalısın.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, antiWeapon)