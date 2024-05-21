local sizeX, sizeY = 260, 90
local screenX, screenY = (screenSize.x - sizeX) - 15, 20

local fonts = {
    font1 = exports.cr_fonts:getFont("sf-regular", 10),
    font2 = exports.cr_fonts:getFont("sf-regular", 9),
    awesome = exports.cr_fonts:getFont("FontAwesome", 13),
}

setTimer(function()
    if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").hud == 3 then
	        dxDrawRectangle(screenX, screenY, sizeX, sizeY, exports.cr_ui:rgba(theme.GRAY[900], 0.9))
	        
			local weapon = getPedWeapon(localPlayer)
		    dxDrawImage(screenX + 10, screenY + 5, 80, 80, "public/images/weapon/" .. weapon .. ".png")
	        
			if bulletWeapons[weapon] then
				local ammo1 = getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer))
				local ammo2 = getPedTotalAmmo(localPlayer)  -  getPedAmmoInClip(localPlayer)
				
				exports.cr_ui:dxDrawFramedText(ammo1 .. "/" .. ammo2, screenX, screenY + 68, sizeX + screenX - 170, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font2, "right")
			end
			
			dxDrawText("", screenX + 112, screenY + 18, nil, nil, exports.cr_ui:getServerColor(1), 1, fonts.awesome, "center")
	        dxDrawText(exports.cr_global:formatMoney(exports.cr_global:getMoney(localPlayer)) .. "$", screenX + 132, screenY + 20, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
	        
			dxDrawText("", screenX + 112, screenY + 49, nil, nil, exports.cr_ui:getServerColor(1), 1, fonts.awesome, "center")
	        dxDrawText(exports.cr_global:formatMoney((getElementData(localPlayer, "kills") or 0)), screenX + 130, screenY + 52, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1)
		end
	end
end, 0, 0)