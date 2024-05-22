screenSize = Vector2(guiGetScreenSize())

serverColor = exports.cr_ui:getServerColor(1)
eliteColor = {
	red = bitExtract(serverColor, 16, 8),
	green = bitExtract(serverColor, 8, 8),
	blue = bitExtract(serverColor, 0, 8)
}

theme = exports.cr_ui:useTheme()
fonts = exports.cr_ui:useFonts()
icons = {
	iconClose = exports.cr_fonts:getFont("FontAwesome", 17),
	iconPass = exports.cr_fonts:getFont("FontAwesome", 30),
	missionIcon = exports.cr_fonts:getFont("FontAwesome", 23),
	statusIcon = exports.cr_fonts:getFont("FontAwesome", 8),
}

function dxDrawProgressBar(startX, startY, width, height, progress, color, backgroundColor, postGUI, subPixelPositioning)
	color = color or tocolor(255, 255, 255, 255)
	backgroundColor = backgroundColor or tocolor(255, 255, 255, 255)
	postGUI = postGUI or false
	subPixelPositioning = subPixelPositioning or false
	
	dxDrawText(progress .. "/100", startX, startY - 20, startX + width, 0, tocolor(102, 102, 102), 1, fonts.UbuntuRegular.caption, "right")
	
    dxDrawRectangle(startX, startY, width, height, backgroundColor, postGUI, subPixelPositioning)
	dxDrawRectangle(startX, startY, width * (progress / 100), height, color, postGUI, subPixelPositioning)
	
	dxDrawGradient(startX, startY - 1, width, 1, 163, 247, 209, 255, false, true, postGUI)
	dxDrawGradient(startX, startY, 1, height, 163, 247, 209, 255, true, true, postGUI)
	dxDrawGradient(startX, startY + height, width, 1, 163, 247, 209, 255, false, false, postGUI)
	dxDrawGradient(startX + width, startY - 1, 1, height, 163, 247, 209, 255, true, false, postGUI)
end

function dxDrawButton(startX, startY, width, height, color, postGUI, subPixelPositioning)
	color = color or tocolor(255, 255, 255, 255)
	postGUI = postGUI or false
	subPixelPositioning = subPixelPositioning or false
	
    dxDrawRectangle(startX, startY, width, height, color, postGUI, subPixelPositioning)
	
	dxDrawGradient(startX, startY - 1, width, 1, 150, 150, 150, 255, false, true, postGUI)
	dxDrawGradient(startX, startY, 1, height, 150, 150, 150, 255, true, true, postGUI)
	
	dxDrawGradient(startX, startY + height, width, 1, 150, 150, 150, 255, false, false, postGUI)
	dxDrawGradient(startX + width, startY - 1, 1, height, 150, 150, 150, 255, true, false, postGUI)
end

function dxDrawGradient(x, y, w, h, r, g, b, a, vertical, inverce)
    if vertical then
        for i = 0, h do
            if not inverce then
                dxDrawRectangle(x, y + i, w, 1, tocolor(r, g, b, i / h * a or 255))
            else
                dxDrawRectangle(x, y + h - i, w, 1, tocolor(r, g, b, i / h * a or 255))
            end
        end
    else
        for i = 0, w do
            if not inverce then
                dxDrawRectangle(x + i, y, 1, h, tocolor(r, g, b, i / w * a or 255))
            else
                dxDrawRectangle(x + w - i, y, 1, h, tocolor(r, g, b, i / w * a or 255))
            end
        end
    end
end