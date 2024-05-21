local screenSize = Vector2(guiGetScreenSize())
local theme = exports.cr_ui:useTheme()
local fonts = {
	icon = exports.cr_fonts:getFont("FontAwesome", 12),
	main = exports.cr_fonts:getFont("UbuntuRegular", 10),
}

setTimer(function()
    if getElementData(localPlayer, "greenzone") then
        local text = "Güvenli bölgedesiniz, burada silah çekemezsiniz."
		local sizeX, sizeY = dxGetTextWidth(text, 1, fonts.main), 35
		local screenX, screenY = ((screenSize.x - sizeX) / 2) + 20, (screenSize.y - sizeY) - 20
		
		dxDrawRectangle(screenX - 45, screenY, sizeX + 55, sizeY, exports.cr_ui:rgba(theme.GRAY[800]))
		dxDrawRectangle(screenX - 45, screenY, sizeY, sizeY, exports.cr_ui:rgba(theme.GRAY[900]))
        dxDrawText("", screenX - 37, screenY + 7, sizeX, sizeY, exports.cr_ui:rgba(theme.BLUE[400]), 1, fonts.icon)
        dxDrawText(text, screenX, screenY + 9, screenX + sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.main, "center")
    end
end, 0, 0)