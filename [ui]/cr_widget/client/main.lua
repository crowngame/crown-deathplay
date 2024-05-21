screenSize = Vector2(guiGetScreenSize())

theme = exports.cr_ui:useTheme()

categories = {
	{"Hud Görünüşü"},
	{"Speedo Görünüşü"},
	{"Radar Görünüşü"},
	{"Kill-Message Görünüşü"},
}

huds = {
	{"Definitive Hud"},
	{"GTA Hud"},
	{"Dikdörtgen Hud"},
	{"Rectangle Hud"},
	{"Crown Hud"},
	{"Gradient Hud"},
	{"Gizle"},
}

speedos = {
	{"SA:MP Speedo"},
	{"Klasik Speedo"},
	{"Modern Speedo"},
	{"FiveM Speedo"},
	{"Gizle"},
}

radars = {
	{"Modern Radar"},
	{"GTA Radar"},
	{"Gizle"},
}

killmessages = {
	{"Modern Kill-Message"},
	{"SA:MP Kill-Message"},
	{"Gizle"},
}

moneySuff = {"K", "M", "B", "T", "Q"}

bulletWeapons = {
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[16] = true,
	[17] = true,
	[18] = true,
	[39] = true,
	[41] = true,
	[42] = true,
	[43] = true,
}

local circleShader = dxCreateShader("public/shaders/hou_circle.fx")
local pos_start = {}
local pos_stop = {}
local sx, sy = guiGetScreenSize()
local px, py = sx / 1920, sy / 1080
local maskShader = dxCreateShader("public/shaders/hud_mask.fx")
local circle = dxCreateTexture("public/images/speedmask.png")
local renders = dxCreateRenderTarget(300 * px, 300 * px, true)

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%." .. decimals .. "f"):format(number)) end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "#aaaaaa00#ffffff" .. unit
    elseif unit < 100 then
        unit = "#aaaaaa0#ffffff" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end

function convertMoney(cMoney)
	didConvert = 0
	if not cMoney then
		return "?"
	end
	while cMoney / 1000 >= 1 do
		cMoney = cMoney / 1000
		didConvert = didConvert + 1
	end
	if didConvert > 0 then
		return "$" .. string.format("%.2f", cMoney) .. moneySuff[didConvert]
	else
		return "$" .. cMoney
	end
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

function dxDrawSpeedIndicator(x, y, width, height, rot, color, angleStart, angleSweep, borderWidth)
	height = height or width
	color = color or tocolor(255,255,255)
	borderWidth = borderWidth or 1e9
	angleStart = angleStart or 0
	angleSweep = math.floor(angleSweep)
	angleSweep = angleSweep or 360 - angleStart
	if (angleSweep < 360) then
		angleEnd = math.fmod(angleStart + angleSweep, 360) + 0
	else
		angleStart = 0
		angleEnd = 360
	end
	dxSetShaderValue(circleShader, "sCircleWidthInPixel", width)
	dxSetShaderValue(circleShader, "sCircleHeightInPixel", height)
	dxSetShaderValue(circleShader, "sBorderWidthInPixel", borderWidth)
	dxSetShaderValue(circleShader, "sAngleStart", math.rad(angleStart) - math.pi)
	dxSetShaderValue(circleShader, "sAngleEnd", math.rad(angleSweep) - math.pi)
	dxSetRenderTarget (renders, true)
	dxDrawImage(0, 0, 300 * px, 300 * px, circleShader, rot)
	dxSetRenderTarget()
	dxSetShaderValue(maskShader, "sMaskTexture", circle)
	dxSetShaderValue(maskShader, "sPicTexture", renders)
	dxDrawImage(x, y, width, height, maskShader, 0, 0, 0, color)
end

setTimer(function()
	if isElementInWater(localPlayer) then
        local oxygen = screenSize.x * getPedOxygenLevel(localPlayer) / 1000
        dxDrawRectangle(0, 0, screenSize.x, 2, tocolor(155, 155, 155, 155))
        dxDrawRectangle(0, 0, oxygen, 2, tocolor(245, 245, 245))
    end
end, 0, 0)