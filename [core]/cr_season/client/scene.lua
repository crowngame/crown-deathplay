local introTexts = {
    "Merhabalar!",
    "Artık bir şeyleri değiştirmenin zamanı geldi.",
    "Öyleyse başlayalım!",
    "Yeni lobimiz artık burası!"
}
local currentTextIndex = 1

addEvent("season.startScene", true)
addEventHandler("season.startScene", root, function(_datas)
    if _datas and type(_datas) == "table" then
        datas = _datas
        showChat(false)
        showCursor(false)
        fadeCamera(false)
        setElementData(localPlayer, "hud_settings", {})

        setTimer(function()
            fadeCamera(true)
            lastTick = getTickCount()

            setElementInterior(localPlayer, 0)
            setElementDimension(localPlayer, 0)
            setCameraInterior(0)
			smoothMoveCamera(1636.9836425781, -1571.6375732422, 109.45010375977, 1559.0754394531, -1621.1650390625, 71.013763427734, 1970.1391601562, -1476.2312011719, 53.020889282227, 2035.1127929688, -1413.4678955078, 10.134928703308, (#introTexts - 1) * 5900)
            
            musicSound = playSound("public/sounds/music.mp3")
            addEventHandler("onClientRender", root, renderVignette)
            addEventHandler("onClientRender", root, renderTextIntro)
        end, 1000, 1)
    end
end)

function renderTextIntro()
    local nowTick = getTickCount()
    local elapsedTime = nowTick - lastTick
    local progress = elapsedTime / 5900

    if progress > 1 then
        if currentTextIndex == #introTexts then
			removeEventHandler("onClientRender", root, renderTextIntro)
			return
		end
		
		lastTick = nowTick
        currentTextIndex = currentTextIndex + 1
        if currentTextIndex > (#introTexts - 1) then
            currentTextIndex = 1
            removeEventHandler("onClientRender", root, renderTextIntro)
            smoothMoveCamera(1970.1391601562, -1476.2312011719, 53.020889282227, 2035.1127929688, -1413.4678955078, 10.134928703308, 2455.7299804688, 1767.5771484375, 74.021011352539, 2541.029296875, 1800.6848144531, 33.673652648926, 10000)
            setTimer(function()
                lastTick = getTickCount()
                currentTextIndex = #introTexts
                addEventHandler("onClientRender", root, renderTextIntro)
            end, 10000, 1)
            return
        end
        progress = 0
    end

    local text = introTexts[currentTextIndex]
    local alpha = math.sin(progress * math.pi) * 255

    dxDrawText(text, 0, 0, screenSize.x + 2, screenSize.y + 2, tocolor(0, 0, 0, alpha), 1, fonts.UbuntuBold.h0, "center", "center")
    dxDrawText(text, 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255, alpha), 1, fonts.UbuntuBold.h0, "center", "center")
end

function renderVignette()
    dxDrawImage(0, 0, screenSize.x, screenSize.y, ":cr_ui/public/images/vignette.png", 0, 0, 0, tocolor(255, 255, 255, 255))
end