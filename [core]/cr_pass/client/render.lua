local sizeX, sizeY = 820, 450
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2
local clickTick = 0

local datas = {}
local loaded = false
local loading = false

local maxScroll = 7
local scroll = 0

local selectedPage = 1

addCommandHandler("crownpass", function()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if exports.cr_network:getNetworkStatus() then
            outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
			playSoundFrontEnd(4)
            return
        end
		
		if not isTimer(renderTimer) then
			loaded = false
			maxScroll = 7
			scroll = 0
			selectedPage = 1
			triggerServerEvent("pass.loadDatas", localPlayer, localPlayer)
	        showCursor(true)
	        renderTimer = setTimer(function()
				dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(25, 25, 25, 255))

				dxDrawText("CROWN PASS " .. currentSeason .. ". SEZON", screenX + 1, screenY - 45 + 1, 0, 0, tocolor(0, 0, 0, 255), 1, fonts.BebasNeueBold.h0, "left", "top", false, false, false, true)
				dxDrawText("CROWN PASS " .. exports.cr_ui:getServerColor(2) .. currentSeason .. ". SEZON", screenX, screenY - 45, 0, 0, tocolor(255, 255, 255, 255), 1, fonts.BebasNeueBold.h0, "left", "top", false, false, false, true)
				
				dxDrawText("", screenX + sizeX - 20 + 1, screenY - 35 + 1, 0, 0, tocolor(0, 0, 0, 255), 1, icons.iconClose)
				dxDrawText("", screenX + sizeX - 20, screenY - 35, 0, 0, exports.cr_ui:inArea(screenX + sizeX - 20, screenY - 35, dxGetTextWidth("", 1, icons.iconClose), dxGetFontHeight(1, icons.iconClose)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, icons.iconClose)
				if exports.cr_ui:inArea(screenX + sizeX - 20, screenY - 35, dxGetTextWidth("", 1, icons.iconClose), dxGetFontHeight(1, icons.iconClose)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
					clickTick = getTickCount()
					killTimer(renderTimer)
					showCursor(false)
				end
				
				if not loaded then
					exports.cr_ui:drawSpinner({
						position = {
							x = screenX + (sizeX - 128) / 2,
							y = screenY + (sizeY - 128) / 2
						},
						size = 128,

						speed = 2,

						variant = "soft",
						color = "gray"
					})
				else
					if developerMode then
						if not exports.cr_integration:isPlayerDeveloper(localPlayer) then
							dxDrawText("Crown Pass şuanda geliştirilme aşamasındadır.", 0, 0, screenSize.x, screenSize.y, exports.cr_ui:rgba(theme.RED[500]), 1, fonts.UbuntuRegular.h4, "center", "center")
							return
						end
					end
					
					dxDrawRectangle(screenX, screenY, sizeX, 100, tocolor(32, 32, 32, 255))
					dxDrawText(getElementData(localPlayer, "pass_level") .. " seviye", screenX + 20, screenY + 20, 0, 0, tocolor(255, 255, 255), 1, fonts.BebasNeueBold.h1)
					dxDrawProgressBar(screenX + 20, screenY + 60, sizeX - 150, 20, getElementData(localPlayer, "pass_xp"), tocolor(45, 218, 157, 255), tocolor(50, 50, 50, 255))
					
					dxDrawButton(screenX + sizeX - 110, screenY + 20, 90, 25, exports.cr_ui:inArea(screenX + sizeX - 110, screenY + 20, 90, 25) and tocolor(50, 50, 50, 255) or tocolor(40, 40, 40, 255))
					dxDrawText("Ana Sayfa", screenX + sizeX - 35, screenY + 25, screenX + sizeX - 95, 0, tocolor(150, 150, 150), 1, fonts.UbuntuRegular.caption, "center")
					
					if exports.cr_ui:inArea(screenX + sizeX - 110, screenY + 20, 90, 25) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
						clickTick = getTickCount()
						maxScroll = 7
						scroll = 0
						selectedPage = 1
					end
					
					dxDrawButton(screenX + sizeX - 110, screenY + 55, 90, 25, exports.cr_ui:inArea(screenX + sizeX - 110, screenY + 55, 90, 25) and tocolor(50, 50, 50, 255) or tocolor(40, 40, 40, 255))
					dxDrawText("Görevler", screenX + sizeX - 35, screenY + 60, screenX + sizeX - 95, 0, tocolor(150, 150, 150), 1, fonts.UbuntuRegular.caption, "center")
					
					if exports.cr_ui:inArea(screenX + sizeX - 110, screenY + 55, 90, 25) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
						clickTick = getTickCount()
						maxScroll = 4
						scroll = 0
						selectedPage = 2
					end
					
					local scrollbarX = screenX + sizeX - 30
					local scrollbarY = screenY + 120
					local scrollbarWidth = 10
					local scrollbarHeight = sizeY - 140
					local scrollHeight = scrollbarHeight * (maxScroll / ((selectedPage == 1 and 50) or (#passMissions)))
					
					dxDrawRectangle(scrollbarX, scrollbarY, scrollbarWidth, scrollbarHeight, tocolor(40, 40, 40, 255))
					dxDrawRectangle(scrollbarX, scrollbarY + ((scroll / ((selectedPage == 1 and 50) or (#passMissions))) * scrollbarHeight), scrollbarWidth, scrollHeight, tocolor(100, 100, 100, 255))
					
					if selectedPage == 1 then
						local passInfoWritten = false
						local marginX = 0
						local scrollIndex = 0
						
						for index, value in ipairs(passRewards[1]) do
							if index > scroll and scrollIndex < maxScroll then
								if not passInfoWritten and index == 1 then
									dxDrawRectangle(screenX + 20, screenY + 120, 100, 150, tocolor(32, 32, 32, 255))
									dxDrawText("", screenX + 42, screenY + 160, 0, 0, tocolor(189, 189, 189), 1, icons.iconPass)
									dxDrawText("FREE", screenX + 140, screenY + 205, screenX, 0, tocolor(189, 189, 189), 1, fonts.BebasNeueBold.h3, "center")
									
									scrollIndex = scrollIndex + 1
									marginX = marginX + 110
									passInfoWritten = true
								end
								
								dxDrawRectangle(screenX + 20 + marginX, screenY + 120, 100, 150, exports.cr_ui:inArea(screenX + 20 + marginX, screenY + 120, 100, 150) and tocolor(40, 40, 40, 255) or tocolor(32, 32, 32, 255))
								dxDrawRectangle(screenX + 20 + marginX, screenY + 269, 100, 1, exports.cr_ui:rgba(rarityLevels[value[4]][2], 0.8))
								dxDrawText(index, screenX + 30 + marginX, screenY + 125, 0, 0, tocolor(189, 189, 189), 1, fonts.BebasNeueBold.h5)

								if value[1] == 1 then
									dxDrawImage(screenX + 33 + marginX, screenY + 160, 70, 70, ":cr_items/images/134.png")
									dxDrawText("$" .. exports.cr_global:formatMoney(value[3]), screenX + 138 + marginX, screenY + 220, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 2 then
									dxDrawImage(screenX + 30 + marginX, screenY + 155, 80, 80, ":cr_items/images/-" .. value[3] .. ".png")
									dxDrawText(value[2], screenX + 140 + marginX, screenY + 230, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 3 then
									dxDrawImage(screenX + 30 + marginX, screenY + 150, 80, 80, ":cr_items/images/" .. value[3] .. ".png")
									dxDrawText(value[2], screenX + 140 + marginX, screenY + 230, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 4 then
									dxDrawText("", screenX + 55 + marginX, screenY + 165, 0, 0, tocolor(100, 100, 100), 1, icons.iconPass)
									dxDrawText(value[3] .. " TL Bakiye", screenX + 140 + marginX, screenY + 225, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								else
									dxDrawText("", screenX + 44 + marginX, screenY + 170, 0, 0, tocolor(100, 100, 100), 1, icons.iconPass)
								end
								
								if #passRewards[1][index] ~= 0 then
									if getElementData(localPlayer, "pass_level") >= index and not isRewardReceived(1, index) then
										dxDrawGradient(screenX + 20 + marginX, screenY + 120 - 1, 100, 1, 189, 189, 189, 200, false, true)
										dxDrawGradient(screenX + 20 + marginX, screenY + 120, 1, 150, 189, 189, 189, 200, true, true)
										dxDrawGradient(screenX + 20 + marginX, screenY + 120 + 150, 100, 1, 189, 189, 189, 200, false, false)
										dxDrawGradient(screenX + 20 + marginX + 100, screenY + 120 - 1, 1, 150, 189, 189, 189, 200, true, false)
										
										if exports.cr_ui:inArea(screenX + 20 + marginX, screenY + 120, 100, 150) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
											clickTick = getTickCount()
											
											if exports.cr_network:getNetworkStatus() then
												outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
												playSoundFrontEnd(4)
												return
											end
											
											triggerServerEvent("pass.getReward", localPlayer, 1, index)
											loading = true
										end
									else
										dxDrawText(not (getElementData(localPlayer, "pass_level") >= index) and not isRewardReceived(1, index) and "" or "", screenX + 119 + marginX, screenY + 116, screenX + 119 + marginX, 0, tocolor(100, 100, 100), 1, icons.statusIcon, "center")
									end
								end
								
								scrollIndex = scrollIndex + 1
								marginX = marginX + 110
							end
						end
						
						passInfoWritten = false
						marginX = 0
						scrollIndex = 0
						
						for index, value in ipairs(passRewards[2]) do
							if index > scroll and scrollIndex < maxScroll then
								if not passInfoWritten and index == 1 then
									dxDrawRectangle(screenX + 20, screenY + 280, 100, 150, tocolor(32, 32, 32, 255))
									dxDrawText("", screenX + 42, screenY + 320, 0, 0, tocolor(eliteColor.red, eliteColor.green, eliteColor.blue, 200), 1, icons.iconPass)
									dxDrawText("ELITE", screenX + 140, screenY + 365, screenX, 0, tocolor(eliteColor.red, eliteColor.green, eliteColor.blue, 200), 1, fonts.BebasNeueBold.h3, "center")
									
									dxDrawGradient(screenX + 20, screenY + 280 - 1, 100, 1, eliteColor.red, eliteColor.green, eliteColor.blue, 200, false, true)
									dxDrawGradient(screenX + 20, screenY + 280, 1, 150, eliteColor.red, eliteColor.green, eliteColor.blue, 200, true, true)
									
									dxDrawGradient(screenX + 20, screenY + 280 + 150, 100, 1, eliteColor.red, eliteColor.green, eliteColor.blue, 200, false, false)
									dxDrawGradient(screenX + 20 + 100, screenY + 280 - 1, 1, 150, eliteColor.red, eliteColor.green, eliteColor.blue, 200, true, false)
									
									passInfoWritten = true
									scrollIndex = scrollIndex + 1
									marginX = marginX + 110
								end
								
								dxDrawRectangle(screenX + 20 + marginX, screenY + 280, 100, 150, exports.cr_ui:inArea(screenX + 20 + marginX, screenY + 280, 100, 150) and tocolor(40, 40, 40, 255) or tocolor(32, 32, 32, 255))
								dxDrawRectangle(screenX + 20 + marginX, screenY + 429, 100, 1, exports.cr_ui:rgba(rarityLevels[value[4]][2], 0.8))
								dxDrawText(index, screenX + 30 + marginX, screenY + 285, 0, 0, tocolor(eliteColor.red, eliteColor.green, eliteColor.blue, 200), 1, fonts.BebasNeueBold.h5)
								
								if value[1] == 1 then
									dxDrawImage(screenX + 33 + marginX, screenY + 320, 70, 70, ":cr_items/images/134.png")
									dxDrawText("$" .. exports.cr_global:formatMoney(value[3]), screenX + 138 + marginX, screenY + 380, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 2 then
									dxDrawImage(screenX + 30 + marginX, screenY + 315, 80, 80, ":cr_items/images/-" .. value[3] .. ".png")
									dxDrawText(value[2], screenX + 140 + marginX, screenY + 390, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 3 then
									dxDrawImage(screenX + 30 + marginX, screenY + 310, 80, 80, ":cr_items/images/" .. value[3] .. ".png")
									dxDrawText(value[2], screenX + 140 + marginX, screenY + 390, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								elseif value[1] == 4 then
									dxDrawText("", screenX + 55 + marginX, screenY + 325, 0, 0, tocolor(100, 100, 100), 1, icons.iconPass)
									dxDrawText(value[3] .. " TL Bakiye", screenX + 140 + marginX, screenY + 385, screenX + marginX, 0, tocolor(189, 189, 189), 1, fonts.UbuntuRegular.body, "center")
								else
									dxDrawText("", screenX + 44 + marginX, screenY + 330, 0, 0, tocolor(100, 100, 100), 1, icons.iconPass)
								end
								
								if #passRewards[2][index] ~= 0 then
									if getElementData(localPlayer, "pass_type") == 2 then
										if getElementData(localPlayer, "pass_level") >= index and not isRewardReceived(2, index) then
											dxDrawGradient(screenX + 20 + marginX, screenY + 280 - 1, 100, 1, eliteColor.red, eliteColor.green, eliteColor.blue, 200, false, true)
											dxDrawGradient(screenX + 20 + marginX, screenY + 280, 1, 150, eliteColor.red, eliteColor.green, eliteColor.blue, 200, true, true)
											dxDrawGradient(screenX + 20 + marginX, screenY + 280 + 150, 100, 1, eliteColor.red, eliteColor.green, eliteColor.blue, 200, false, false)
											dxDrawGradient(screenX + 20 + marginX + 100, screenY + 280 - 1, 1, 150, eliteColor.red, eliteColor.green, eliteColor.blue, 200, true, false)
											
											if exports.cr_ui:inArea(screenX + 20 + marginX, screenY + 280, 100, 150) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not loading then
												clickTick = getTickCount()
												
												if exports.cr_network:getNetworkStatus() then
													outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
													playSoundFrontEnd(4)
													return
												end
												
												triggerServerEvent("pass.getReward", localPlayer, 2, index)
												loading = true
											end
										else
											dxDrawText((not (getElementData(localPlayer, "pass_level") >= index)) and "" or "", screenX + 119 + marginX, screenY + 276, screenX + 119 + marginX, 0, tocolor(100, 100, 100), 1, icons.statusIcon, "center")
										end
									else
										dxDrawText("", screenX + 119 + marginX, screenY + 276, screenX + 119 + marginX, 0, tocolor(100, 100, 100), 1, icons.statusIcon, "center")
									end
								end
								
								scrollIndex = scrollIndex + 1
								marginX = marginX + 110
							end
						end
					elseif selectedPage == 2 then
						local marginY = 0
						local scrollIndex = 0
						
						for index, value in ipairs(passMissions) do
							if index > scroll and scrollIndex < maxScroll then
								dxDrawRectangle(screenX + 20, screenY + 120 + marginY, sizeX - 60, 70, tocolor(32, 32, 32, 255))
								dxDrawRectangle(screenX + 20, screenY + 120 + marginY, 70, 70, tocolor(40, 40, 40, 255))
								
								if exports.cr_ui:inArea(screenX + 20, screenY + 120 + marginY, sizeX - 60, 70) then
									dxDrawRectangle(screenX + 20, screenY + 120 + marginY, sizeX - 60, 70, tocolor(50, 50, 50, 100))
									if getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
										clickTick = getTickCount()
										
										if exports.cr_network:getNetworkStatus() then
											outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
											playSoundFrontEnd(4)
											return
										end
										
										if getMissionValueById(index) >= value[2] and not isRewardReceived(3, index) and not loading then
											triggerServerEvent("pass.getReward", localPlayer, 3, index)
											loading = true
										end
									end
								end
								
								dxDrawText("", screenX + 36, screenY + 136 + marginY, 0, 0, tocolor(200, 200, 200), 1, icons.missionIcon)
								dxDrawText(value[3], 0, screenY + 174 + marginY, screenX + 87, 0, tocolor(200, 200, 200), 1, fonts.UbuntuRegular.caption, "right")
								dxDrawText(value[1], screenX + 105, screenY + 147 + marginY, 0, 0, tocolor(200, 200, 200), 1, fonts.UbuntuRegular.h5)
								dxDrawText((getMissionValueById(index) or 0) .. "/" .. value[2], 0, screenY + 147 + marginY, screenX + sizeX - 55, 0, tocolor(200, 200, 200), 1, fonts.UbuntuRegular.h5, "right")
								
								if getMissionValueById(index) >= value[2] and not isRewardReceived(3, index) then
									dxDrawGradient(screenX + 20, screenY + 120 + marginY - 1, sizeX - 60, 1, 150, 150, 150, 255, false, true)
									dxDrawGradient(screenX + 20, screenY + 120 + marginY, 1, 70, 150, 150, 150, 255, true, true)
									dxDrawGradient(screenX + 20, screenY + 120 + marginY + 70, sizeX - 60, 1, 150, 150, 150, 255, false, false)
									dxDrawGradient(screenX + 20 + sizeX - 60, screenY + 120 + marginY - 1, 1, 70, 150, 150, 150, 255, true, false)
								else
									dxDrawText(isRewardReceived(3, index) and "" or "", screenX + sizeX - 82, screenY + 116 + marginY, screenX + sizeX, 0, tocolor(100, 100, 100), 1, icons.statusIcon, "center")
								end
								
								scrollIndex = scrollIndex + 1
								marginY = marginY + 80
							end
						end
					end
					
					if loading then
						dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(25, 25, 25, 100))
						exports.cr_ui:drawSpinner({
							position = {
								x = screenX + (sizeX - 128) / 2,
								y = screenY + (sizeY - 128) / 2
							},
							size = 128,

							speed = 2,

							variant = "soft",
							color = "gray"
						})
					end
				end
			end, 0, 0)
		else
			killTimer(renderTimer)
	        showCursor(false)
		end
	end
end, false, false)

addEvent("pass.loadDatas", true)
addEventHandler("pass.loadDatas", root, function(_datas)
	if _datas and type(_datas) == "table" then
		datas = _datas
		loaded = true
	end
end)

addEvent("pass.removeLoading", true)
addEventHandler("pass.removeLoading", root, function()
	loading = false
end)

bindKey("mouse_wheel_down", "down", function()
	if isTimer(renderTimer) then
	    local maxScrollEx = 0
		if selectedPage == 1 then
			maxScrollEx = 50
		elseif selectedPage == 2 then
			maxScrollEx = #passMissions
		end
		
		if scroll < maxScrollEx - maxScroll then
			scroll = scroll + 1
		end
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if isTimer(renderTimer) then
		if scroll > 0 then
			scroll = scroll - 1
		end
	end
end)

function getMissionValueById(missionID)
	if datas[1] then
		for index, value in ipairs(datas[1]) do
			if value.mission_id == missionID then
				return value.mission_value 
			end
		end
	end
	return 0
end

function isRewardReceived(rewardType, rewardID)
	if datas[2] then
		for index, value in ipairs(datas[2]) do
			if (value.reward_type == rewardType) and (value.reward_id == rewardID) then
				return true
			end
		end
	end
	return false
end