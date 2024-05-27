local screenSize = Vector2(guiGetScreenSize())
local text = "%50 İNDİRİM >> discord.gg/crowndp"
local fonts = exports.cr_ui:useFonts()
local screenX, screenY = 10, screenSize.y - dxGetFontHeight(1, fonts.UbuntuRegular.caption) - 10

local r, g, b = 255, 0, 0
local step = 1
local colorChangeSpeed = 10

function updateColor()
    if r > 0 and b == 0 then
        r = r - step
        g = g + step
    end
    if g > 0 and r == 0 then
        g = g - step
        b = b + step
    end
    if b > 0 and g == 0 then
        r = r + step
        b = b - step
    end
end

setTimer(function()
    dxDrawText(text, screenX, screenY, screenX, screenY, tocolor(r, g, b, 255), 1, fonts.UbuntuRegular.caption)
    updateColor()
end, 0, 0)

setTimer(updateColor, 50 / colorChangeSpeed, 0)