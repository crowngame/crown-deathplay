local sizeX, sizeY = guiGetScreenSize()

screenSize = {
    x = sizeX,
    y = sizeY
}

initialPosition = { x = 1, y = 1 }
initialSize = { x = 1, y = 1 }
initialRadius = 4
initialPadding = 10

CurrentTheme = Theme.DARK

lastClick = getTickCount()

function dxDrawShadowText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top, width - 1, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 1, top, width + 1, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top - 1, width, height - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top + 1, width, height + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 2, top, width - 2, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 2, top, width + 2, height, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top - 2, width, height - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top + 2, width, height + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

function dxDrawFramedText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
	local alpha = bitExtract(color, 24, 8)
    dxDrawText(text, left + 1, top + 1, width + 1, height + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left + 1, top - 1, width + 1, height - 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top + 1, width - 1, height + 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left - 1, top - 1, width - 1, height - 1, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(text, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
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

function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultipler = reMap(screenSize.x, 800, 1920, 0.6, 1)

function resp(value)
    return math.ceil(value * responsiveMultipler)
end

function respc(value)
    return tonumber(string.format("%.1f", tostring(value * responsiveMultipler)))
end

function abs(size)
    return {
        x = size.x * screenSize.x,
        y = size.y * screenSize.y
    }
end

function absX(size)
    return size * screenSize.x
end

function absY(size)
    return size * screenSize.y
end

function conv(sizeValue)
    return sizeValue / screenSize.x
end

function convY(sizeValue)
    return sizeValue / screenSize.y
end

addEvent("playSuccessfulSound", true)
addEventHandler("playSuccessfulSound", root, function()
	local sound = playSound(":cr_infobox/public/sounds/success.mp3", false)
	setSoundVolume(sound, 0.5)
end)