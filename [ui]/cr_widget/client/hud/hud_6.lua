local sizeX, sizeY = 300, 100
local screenX, screenY = (screenSize.x - sizeX), 40

local fonts = {
	ammo = exports.cr_fonts:getFont("sf-bold", 10),
	main = exports.cr_fonts:getFont("sf-regular", 11),
	icon = exports.cr_fonts:getFont("FontAwesome", 12),
}

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").hud == 6 then
			dxDrawGradient(screenX, screenY, sizeX, sizeY, 0, 0, 0, 255, false, false)
			
			local weapon = getPedWeapon(localPlayer)
			dxDrawImage(screenX, screenY + 6, 90, 90, "public/images/weapon/" .. weapon .. ".png")
			
			if bulletWeapons[weapon] then
				local ammo1 = getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer))
				local ammo2 = getPedTotalAmmo(localPlayer) - getPedAmmoInClip(localPlayer)
				
				exports.cr_ui:dxDrawFramedText(ammo1 .. "/" .. ammo2, screenX, screenY + 77, screenX + 93, 0, tocolor(255, 255, 255, 255), 1, fonts.ammo, "center")
			end
			
			dxDrawRectangle(screenX + 110, screenY + 10, 2, sizeY - 20, tocolor(150, 150, 150, 150))
			
			dxDrawText(exports.cr_global:formatMoney(exports.cr_global:getMoney(localPlayer)), screenX, screenY + 30, screenX + sizeX - 15, 0, tocolor(85, 152, 78, 255), 1, fonts.main, "right")
			dxDrawText("", screenX, screenY + 29, screenX + sizeX - 20 - dxGetTextWidth(exports.cr_global:formatMoney(exports.cr_global:getMoney(localPlayer)), 1, fonts.main), 0, tocolor(85, 152, 78, 255), 1, fonts.icon, "right")
			
			dxDrawText(exports.cr_global:formatMoney(getElementData(localPlayer, "bankmoney")), screenX, screenY + sizeY - 50, screenX + sizeX - 15, 0, tocolor(217, 217, 217, 255), 1, fonts.main, "right")
			dxDrawText("", screenX, screenY + sizeY - 51, screenX + sizeX - 20 - dxGetTextWidth(exports.cr_global:formatMoney(getElementData(localPlayer, "bankmoney")), 1, fonts.main), 0, tocolor(217, 217, 217, 255), 1, fonts.icon, "right")
			
			dxDrawGradient(screenX + 200, screenY + sizeY + 15, 100, 40, 0, 0, 0, 255, false, false)
			dxDrawText(math.floor(getElementHealth(localPlayer)), screenX, screenY + sizeY + 26, screenX + sizeX - 15, 0, tocolor(234, 83, 83, 255), 1, fonts.main, "right")
			dxDrawText("", screenX, screenY + sizeY + 25, screenX + sizeX - 20 - dxGetTextWidth(math.floor(getElementHealth(localPlayer)), 1, fonts.main), 0, tocolor(234, 83, 83, 255), 1, fonts.icon, "right")
			
			dxDrawGradient(screenX + 200, screenY + sizeY + 65, 100, 40, 0, 0, 0, 255, false, false)
			dxDrawText(math.floor(getPedArmor(localPlayer)), screenX, screenY + sizeY + 76, screenX + sizeX - 15, 0, tocolor(217, 217, 217, 255), 1, fonts.main, "right")
			dxDrawText("", screenX, screenY + sizeY + 75, screenX + sizeX - 20 - dxGetTextWidth(math.floor(getPedArmor(localPlayer)), 1, fonts.main), 0, tocolor(217, 217, 217, 255), 1, fonts.icon, "right")
		end
	end
end, 0, 0)