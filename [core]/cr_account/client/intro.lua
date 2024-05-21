local screenWidth, screenHeight = guiGetScreenSize()
local startTime = nil
local waitDuration = 1800
local animationDuration = 1000
local displayDuration = 2000
local fadeDuration = 1000
local font = dxCreateFont(":cr_ui/public/fonts/EsBuild.ttf", 100)
local fadeStartTime = nil

local color1 = {249, 190, 78}
local color2 = {255, 212, 59}
local currentColor = {color1[1], color1[2], color1[3]}
local colorProgress = 0
local colorDirection = 1

local isRendered = false

function updateColor()
    colorProgress = colorProgress + 0.01 * colorDirection
    if colorProgress > 1 then
        colorProgress = 1
        colorDirection = -1
    elseif colorProgress < 0 then
        colorProgress = 0
        colorDirection = 1
    end

    currentColor[1] = interpolateBetween(color1[1], 0, 0, color2[1], 0, 0, colorProgress, "Linear")
    currentColor[2] = interpolateBetween(color1[2], 0, 0, color2[2], 0, 0, colorProgress, "Linear")
    currentColor[3] = interpolateBetween(color1[3], 0, 0, color2[3], 0, 0, colorProgress, "Linear")
end

function drawShineAntiCheat()
    if not startTime then
        startTime = getTickCount()
    end

    local elapsedTime = getTickCount() - startTime
    local progress = 0
    local alpha = 255

    if elapsedTime > waitDuration then
        progress = (elapsedTime - waitDuration) / animationDuration
    end

    if progress > 1 then
        progress = 1
    end

    local shiStartX, shiStartY = screenWidth / 2 - 400, screenHeight / 2 - 60
    local shiEndX, shiEndY = screenWidth / 2 - 400, screenHeight / 2

    local neStartX, neStartY = screenWidth / 2 - 230, screenHeight / 2 + 60
    local neEndX, neEndY = screenWidth / 2 - 230, screenHeight / 2

    local antiStartX, antiStartY = screenWidth / 2 + 20, screenHeight / 2 - 60
    local antiEndX, antiEndY = screenWidth / 2 + 20, screenHeight / 2

    local cheatStartX, cheatStartY = screenWidth / 2 + 350, screenHeight / 2 + 60
    local cheatEndX, cheatEndY = screenWidth / 2 + 350, screenHeight / 2

    local shiCurrentX = interpolateBetween(shiStartX, 0, 0, shiEndX, 0, 0, progress, "OutQuad")
    local shiCurrentY = interpolateBetween(shiStartY, 0, 0, shiEndY, 0, 0, progress, "OutQuad")

    local neCurrentX = interpolateBetween(neStartX, 0, 0, neEndX, 0, 0, progress, "OutQuad")
    local neCurrentY = interpolateBetween(neStartY, 0, 0, neEndY, 0, 0, progress, "OutQuad")

    local antiCurrentX = interpolateBetween(antiStartX, 0, 0, antiEndX, 0, 0, progress, "OutQuad")
    local antiCurrentY = interpolateBetween(antiStartY, 0, 0, antiEndY, 0, 0, progress, "OutQuad")

    local cheatCurrentX = interpolateBetween(cheatStartX, 0, 0, cheatEndX, 0, 0, progress, "OutQuad")
    local cheatCurrentY = interpolateBetween(cheatStartY, 0, 0, cheatEndY, 0, 0, progress, "OutQuad")

    if progress == 1 and not fadeStartTime then
        fadeStartTime = getTickCount() + displayDuration
    end

    if fadeStartTime and getTickCount() > fadeStartTime then
        local fadeElapsed = getTickCount() - fadeStartTime
        local fadeProgress = fadeElapsed / fadeDuration

        if fadeProgress > 1 then
            fadeProgress = 1
        end

        alpha = 255 * (1 - fadeProgress)

        if fadeProgress == 1 then
			music.timer = setTimer(playMusic, 0, 0)
			triggerServerEvent("account.requestPlayerInfo", localPlayer)
            removeEventHandler("onClientRender", root, drawShineAntiCheat)
			passedIntro = true
        end
    end

    updateColor()

    dxDrawText("SHI", shiCurrentX, shiCurrentY, shiCurrentX, shiCurrentY, tocolor(currentColor[1], currentColor[2], currentColor[3], alpha), 1, font, "center", "center")
    dxDrawText("NE", neCurrentX, neCurrentY, neCurrentX, neCurrentY, tocolor(currentColor[1], currentColor[2], currentColor[3], alpha), 1, font, "center", "center")
    dxDrawText("ANTI", antiCurrentX, antiCurrentY, antiCurrentX, antiCurrentY, tocolor(currentColor[1], currentColor[2], currentColor[3], alpha), 1, font, "center", "center")
    dxDrawText("CHEAT", cheatCurrentX, cheatCurrentY, cheatCurrentX, cheatCurrentY, tocolor(currentColor[1], currentColor[2], currentColor[3], alpha), 1, font, "center", "center")
end

function renderIntro()
	if not passedIntro then
		addEventHandler("onClientRender", root, drawShineAntiCheat)
	end
end