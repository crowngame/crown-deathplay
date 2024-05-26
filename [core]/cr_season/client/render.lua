local screenSize = Vector2(guiGetScreenSize())

local animationTimer = nil
local animationDuration = 4000

local vignetteAlpha = 0
local vignetteTimer = nil
local vignetteDuration = 1000

local startAlpha = 0
local endAlpha = 255

local startScale = 0.5
local endScale = 1

local introText = "Crown Deathplay"
local introEnded = false
local fadingOut = false

local growing = true
local seasonText = "Sezon 5"
local path = ":cr_rank/public/images/1.png"

local musicSound
local musicLink = "https://cdn.discordapp.com/attachments/1140655220653826109/1238820066217295962/Y2meta.app_-_Rammstein_-_Sonne_SLOWED_Best_Part_128_kbps.mp3?ex=66507e97&is=664f2d17&hm=f01db81388db103ff6bd3679a7817ea17d34f76caaa55cc630bda5633882cea9&"

local volume = 1
local volumeIncrement = 0.01

local _1stPlayer, _2ndPlayer, _3rdPlayer = nil, nil, nil
local datas = {}
local maxDistance = 30

local theme = exports.cr_ui:useTheme()
local _fonts = exports.cr_ui:useFonts()
local fonts = {
    season1 = exports.cr_fonts:getFont("sf-bold", 105),
    season1_nametag = exports.cr_fonts:getFont("sf-bold", 75),
    
	season2 = dxCreateFont("public/fonts/2.ttf", 105),
    season2_nametag = dxCreateFont("public/fonts/2.ttf", 75),
    
	season3 = dxCreateFont("public/fonts/3.ttf", 105),
    season3_nametag = dxCreateFont("public/fonts/3.ttf", 75),
    
	season4 = dxCreateFont("public/fonts/4.ttf", 105),
    season4_nametag = dxCreateFont("public/fonts/4.ttf", 75),
    
	season5 = dxCreateFont("public/fonts/5.ttf", 100),
    season5_nametag = dxCreateFont("public/fonts/5.ttf", 25),
	
    season6 = dxCreateFont("public/fonts/6.ttf", 50),
    season6_nametag = dxCreateFont("public/fonts/6.ttf", 20),
}
local font = fonts.season5

local _1stPlayer = createPed(253, 2036.4870605469, -1438.2783203125, 19.455863952637)
setElementFrozen(_1stPlayer, true)
setElementRotation(_1stPlayer, 0, 0, 90)
setPedAnimation(_1stPlayer, "PARK", "Tai_Chi_Loop", -1, true, false, false)
setElementData(_1stPlayer, "datas", {
	charactername = "Engjellushe_Bukuroshe",
	kills = 16706,
	deaths = 3438
})

local _2ndPlayer = createPed(134, 2036.9870605469, -1435.8, 19.455863952637)
setElementFrozen(_2ndPlayer, true)
setElementRotation(_2ndPlayer, 0, 0, 90)
setPedAnimation(_2ndPlayer, "BSKTBALL", "BBALL_def_loop", -1, true, false, false)
setElementData(_2ndPlayer, "datas", {
	charactername = "Mulayim_El_Siirtli",
	kills = 13350,
	deaths = 4728
})

local _3rdPlayer = createPed(134, 2036.9870605469, -1440.6783203125, 19.455863952637)
setElementFrozen(_3rdPlayer, true)
setElementRotation(_3rdPlayer, 0, 0, 90)
setPedAnimation(_3rdPlayer, "SHOP", "ROB_Loop_Threat", -1, true, false, false)
setElementData(_3rdPlayer, "datas", {
	charactername = "Kaizen_Guzman",
	kills = 12107,
	deaths = 1566
})

addEvent("season.startScene", true)
addEventHandler("season.startScene", root, function(_datas)
	datas = _datas
    showChat(false)
    showCursor(false)
    fadeCamera(false)
	setElementData(localPlayer, "hud_settings", {})

    setTimer(function()
        fadeCamera(true)
        animationTimer = getTickCount()
        addEventHandler("onClientRender", root, renderTextIntro)
		addEventHandler("onClientRender", root, renderVignette)

        musicSound = playSound(musicLink)

        setElementInterior(localPlayer, 0)
        setElementDimension(localPlayer, 0)
        setCameraInterior(0)
		
        smoothMoveCamera(1904.3986816406, -1072.5187988281, 182.11769104004, 2787.6147460938, -1677.8309326172, -369.88607788086, 1688.5734863281, -1446.4100341797, 161.86068725586, 2577.6623535156, -2055.7470703125, -393.8135070800, 30000)
    end, 1000, 1)
end)

function renderTextIntro()
    local now = getTickCount()
    local elapsedTime = now - animationTimer
    local progress = elapsedTime / animationDuration

    local alpha
    if fadingOut then
        alpha = interpolateBetween(endAlpha, 0, 0, startAlpha, 0, 0, progress, "Linear")
    else
        alpha = interpolateBetween(startAlpha, 0, 0, endAlpha, 0, 0, progress, "Linear")
    end
    
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(18, 18, 20, 150))
    dxDrawText(introText, 0, 0, screenSize.x, screenSize.y, tocolor(255, 255, 255, alpha), 1, _fonts.UbuntuRegular.h0, "center", "center")
    
    if alpha == 255 and introText == "Crown Deathplay" then
		setTimer(function()
			animationTimer = getTickCount()
			now = getTickCount()
			elapsedTime = now - animationTimer
			progress = elapsedTime / animationDuration
			fadingOut = true
		end, 1000, 1)
        
		setTimer(function()
            fadingOut = false
			animationTimer = getTickCount()
            now = getTickCount()
            elapsedTime = now - animationTimer
            progress = elapsedTime / animationDuration
            
            introText = "Zirveye çıkmak zordur.\nZirvede kalmak daha zordur.\nZirvede bırakmak ise en zorudur."
        end, 6000, 1)
    end
    
    if alpha == 255 and introText == "Zirveye çıkmak zordur.\nZirvede kalmak daha zordur.\nZirvede bırakmak ise en zorudur." then
        setTimer(function()
			animationTimer = getTickCount()
			now = getTickCount()
			elapsedTime = now - animationTimer
			progress = elapsedTime / animationDuration
			fadingOut = true
		end, 1000, 1)
		
		setTimer(function()
            fadingOut = false
			animationTimer = getTickCount()
            now = getTickCount()
            elapsedTime = now - animationTimer
            progress = elapsedTime / animationDuration
            
            introText = "Malum sunucular.\nÖzenmeye devam edin, serüveniniz çok kısa sürecek..."
        end, 6000, 1)
    end
    
    if alpha == 255 and introText == "Malum sunucular.\nÖzenmeye devam edin, serüveniniz çok kısa sürecek..." and not introEnded then
        setTimer(function()
			animationTimer = getTickCount()
			now = getTickCount()
			elapsedTime = now - animationTimer
			progress = elapsedTime / animationDuration
			fadingOut = true
		end, 1000, 1)
		
		introEnded = true
		
        setTimer(function()
            fadeCamera(false)
	
            setTimer(function()
                restartVariables()
                fadeCamera(true)
                removeEventHandler("onClientRender", root, renderTextIntro)
                addEventHandler("onClientRender", root, renderSeasonIntro)
                animationTimer = getTickCount()
                playSound("public/sounds/sound.mp3")
	
                setElementInterior(localPlayer, 0)
                setElementDimension(localPlayer, 0)
                setCameraInterior(0)
                
                smoothMoveCamera(2051.1303710938, -1018.294921875, 97.041488647461, 2362.5087890625, -2658.1396484375, -527.46716308594, 1973.4168701172, -1471.9990234375, 46.231925964355, 2040.947265625, -1408.8565673828, 8.1180086135864, 6000)
            end, 1000, 1)
        end, 5000, 1)
    end
end

function renderSeasonIntro()
    local now = getTickCount()
    local elapsedTime = now - animationTimer
    local progress = elapsedTime / animationDuration

    local alpha = interpolateBetween(startAlpha, 0, 0, endAlpha, 0, 0, progress, "Linear")

    local scale
    if growing then
        scale = interpolateBetween(startScale, 0, 0, endScale, 0, 0, progress, "Linear")
    else
        scale = endScale
    end

    if seasonText == "Sezon 5" then
        dxDrawBorderedText(3, tocolor(22, 156, 196, alpha), seasonText, 0, 0, screenSize.x, screenSize.y, tocolor(50, 185, 222, alpha), scale, font, "center", "center")
    end

    if seasonText == "Sezon 6" then
        dxDrawBorderedText(3, tocolor(177, 84, 29, alpha), seasonText, 0, 0, screenSize.x, screenSize.y, tocolor(228, 134, 43, alpha), scale, font, "center", "center")
    end

    if elapsedTime >= animationDuration and alpha == endAlpha then
        if not animationTimer2 then
            animationTimer2 = getTickCount()
        end

        local waitTime = 2000
        local now2 = getTickCount()
        local elapsedTime2 = now2 - animationTimer2

        if elapsedTime2 >= waitTime then
            startAlpha, endAlpha = endAlpha, startAlpha
            animationDuration = 5000
            animationTimer = getTickCount()
            animationTimer2 = nil
            seasonText = "Sezon 6"
            font = fonts.season6

            if alpha <= 0 then
                removeEventHandler("onClientRender", root, renderSeasonIntro)
                restartVariables()
                addEventHandler("onClientRender", root, renderSeasonRank)
                path = ":cr_rank/public/images/" .. (getElementData(localPlayer, "rank") or 1) .. ".png"
            else
                growing = not growing
            end
        end
    end
end

function renderSeasonRank()
    local animationDuration = 1000
    local now = getTickCount()
    local elapsedTime = now - animationTimer
    local progress = elapsedTime / animationDuration

    local alpha = interpolateBetween(startAlpha, 0, 0, endAlpha, 0, 0, progress, "Linear")

    dxDrawImage((screenSize.x - 256) / 2, (screenSize.y - 256) / 2, 256, 256, path, 0, 0, 0, tocolor(255, 255, 255, alpha))

    if elapsedTime >= animationDuration and alpha == endAlpha then
        if not animationTimer2 then
            animationTimer2 = getTickCount()
        end

        local waitTime = 3000
        local now2 = getTickCount()
        local elapsedTime2 = now2 - animationTimer2

        if elapsedTime2 >= 1500 and path ~= ":cr_rank/public/images/1.png" then
            playSound("public/sounds/swish.wav")
            path = ":cr_rank/public/images/1.png"
        end

        if elapsedTime2 >= waitTime then
            startAlpha, endAlpha = endAlpha, startAlpha
            animationDuration = 1000
            animationTimer = getTickCount()
            animationTimer2 = nil

            if alpha <= 0 then
                removeEventHandler("onClientRender", root, renderSeasonRank)
                smoothMoveCamera(1973.4168701172, -1471.9990234375, 46.231925964355, 2040.947265625, -1408.8565673828, 8.1180086135864, 2031.3060302734, -1438.4093017578, 20.914417266846, 4572.2915039062, -1422.8376464844, -914.06958007812, 5000)
				
				setTimer(function()
					smoothMoveCamera(2031.3060302734, -1438.4093017578, 20.914417266846, 4572.2915039062, -1422.8376464844, -914.06958007812, 2034.580078125, -1438.3293457031, 20.081535339355, 3704.8952636719, -1430.1761474609, -529.67517089844, 2000)
					setTimer(function()
						_1stPlayer = createPed(datas[1].skin, 2036.4870605469, -1438.2783203125, 19.455863952637)
						setElementFrozen(_1stPlayer, true)
						setElementRotation(_1stPlayer, 0, 0, 90)
						setPedAnimation(_1stPlayer, "PARK", "Tai_Chi_Loop", -1, true, false, false)
						setElementData(_1stPlayer, "datas", datas[1])
						playSound("public/sounds/teleport.mp3")
						
						setTimer(function()
							smoothMoveCamera(2034.580078125, -1438.3293457031, 20.081535339355, 3704.8952636719, -1430.1761474609, -529.67517089844, 2034.1589355469, -1435.7174072266, 20.129028320312, 4869.0415039062, -1467.2462158203, -751.87817382812, 2000)
							setTimer(function()
								_2ndPlayer = createPed(datas[2].skin, 2036.9870605469, -1435.8, 19.455863952637)
								setElementFrozen(_2ndPlayer, true)
								setElementRotation(_2ndPlayer, 0, 0, 90)
								setPedAnimation(_2ndPlayer, "BSKTBALL", "BBALL_def_loop", -1, true, false, false)
								setElementData(_2ndPlayer, "datas", datas[2])
								playSound("public/sounds/teleport.mp3")
								
								setTimer(function()
									smoothMoveCamera(2034.1589355469, -1435.7174072266, 20.129028320312, 4869.0415039062, -1467.2462158203, -751.87817382812, 2034.1030273438, -1440.6566162109, 20.129028320312, 4052.4497070312, -1457.0484619141, -531.66851806641, 2000)
									setTimer(function()
										_3rdPlayer = createPed(datas[3].skin, 2036.9870605469, -1440.6783203125, 19.455863952637)
										setElementFrozen(_3rdPlayer, true)
										setElementRotation(_3rdPlayer, 0, 0, 90)
										setPedAnimation(_3rdPlayer, "SHOP", "ROB_Loop_Threat", -1, true, false, false)
										setElementData(_3rdPlayer, "datas", datas[3])
										playSound("public/sounds/teleport.mp3")
										
										setTimer(function()
											smoothMoveCamera(2034.1030273438, -1440.6566162109, 20.129028320312, 4052.4497070312, -1457.0484619141, -531.66851806641, 2031.3060302734, -1438.4093017578, 20.914417266846, 4572.2915039062, -1422.8376464844, -914.06958007812, 3000)
											
											setTimer(function()
												smoothMoveCamera(2031.3060302734, -1438.4093017578, 20.914417266846, 4572.2915039062, -1422.8376464844, -914.06958007812, 1997.2531738281, -1450.6553955078, 12.894771575928, 3170.6579589844, -254.82312011719, 553.50109863281, 4000)
												
												setTimer(function()
													restartVariables()
													removeEventHandler("onClientRender", root, renderVignette)
													addEventHandler("onClientRender", root, renderLoading)
													addEventHandler("onClientRender", root, renderVignette)
													setTimer(function()
														showChat(true)
														setCameraTarget(localPlayer)
														decreaseVolume()
														clearChatBox()
														triggerEvent("hud:loadSettings", localPlayer)
														triggerServerEvent("season.finishScene", localPlayer)
														removeEventHandler("onClientRender", root, renderVignette)
														removeEventHandler("onClientRender", root, renderLoading)
													end, 30000, 1)
												end, 5000, 1)
											end, 4000, 1)
										end, 2000, 1)
									end, 2000, 1)
								end, 2000, 1)
							end, 2000, 1)
						end, 2000, 1)
					end, 2000, 1)
				end, 6000, 1)
            end
        end
    end
end

function renderVignette()
    local now = getTickCount()
    if not vignetteTimer then
        vignetteTimer = now
    end
    local vignetteElapsedTime = now - vignetteTimer
    vignetteAlpha = interpolateBetween(0, 0, 0, 200, 0, 0, vignetteElapsedTime / vignetteDuration, "Linear")

    dxDrawImage(0, 0, screenSize.x, screenSize.y, ":cr_ui/public/images/vignette.png", 0, 0, 0, tocolor(255, 255, 255, vignetteAlpha))
end

function renderLoading()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(18, 18, 20, 150))
    exports.cr_ui:drawSpinner({
        position = {
            x = (screenSize.x - 128) / 2,
            y = (screenSize.y - 128) / 2
        },
        size = 128,
        speed = 2,
        variant = "solid",
        color = "white",
        label = "Yeni sezona hoşgeldiniz!\nLütfen bekleyiniz, sezon sıfırlanıyor...",
    })
end

setTimer(function()
	if (getElementData(localPlayer, "loggedin") == 1) then
		if _1stPlayer or _2ndPlayer or _3rdPlayer then
			local cameraX, cameraY, cameraZ = getCameraMatrix(localPlayer)
			for index, ped in pairs({ _1stPlayer, _2ndPlayer, _3rdPlayer }) do
				if isElement(ped) then
					local boneX, boneY, boneZ = getPedBonePosition(ped, 6)
					boneZ = boneZ + 0.15
					
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (distance <= maxDistance) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							dxDrawBorderedText(2, tocolor(22, 156, 196, alpha), index, screenX, 0, screenX, screenY, tocolor(50, 185, 222, alpha), 1, fonts.season5_nametag, "center", "bottom", false, true, false, true)
						end
					end
				end
				
				if isElement(ped) then
					local boneX, boneY, boneZ = getPedBonePosition(ped, 2)
					boneZ = boneZ - 0.3
					
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (distance <= maxDistance) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							local datas = getElementData(ped, "datas")
							if datas then
								dxDrawText((datas.charactername):gsub("_", " ") .. "\nÖldürme: " .. exports.cr_global:formatMoney(datas.kills) .. "\nÖlme: " .. exports.cr_global:formatMoney(datas.deaths) .. "\nK/D: " .. (string.format("%.2f", datas.kills / datas.deaths) or 0), screenX, 0, screenX, screenY, exports.cr_ui:rgba(theme.GRAY[100], alpha / 255), 1, _fonts.UbuntuRegular.caption, "center", "bottom", false, true, false, true)
							end
						end
					end
				end
			end
		end
	end
end, 5, 0)

function restartVariables(fullRestart)
    animationTimer = getTickCount()
    animationDuration = 4000
    startAlpha = 0
    endAlpha = 255
    startScale = 0.5
    endScale = 1
    growing = true
    seasonText = "Sezon 5"
    font = fonts.season5
    path = ":cr_rank/public/images/1.png"
    volume = 1
    volumeIncrement = 0.01

    if fullRestart then
        vignetteAlpha = 0
        vignetteTimer = nil
        vignetteDuration = 1000
    end
end

function decreaseVolume()
    volume = volume - volumeIncrement
    if volume < 0 then
        stopSound(musicSound)
    else
        setSoundVolume(musicSound, volume)
        if volume > 0 then
            setTimer(decreaseVolume, 10, 1)
        end
    end
end

function dxDrawBorderedText(outline, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, outlineColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end