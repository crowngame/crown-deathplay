local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 600, 500
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2

local clickTick = 0
local isLoaded = false
local datas = {}
local selectedCategory = 1

local maxScroll = 10
local scroll = 0

local theme = exports.cr_ui:useTheme()
local fonts = {
    awesome1 = exports.cr_fonts:getFont("FontAwesome", 22),
	awesome2 = exports.cr_fonts:getFont("FontAwesome", 16),
    font1 = exports.cr_fonts:getFont("sf-bold", 16),
    font2 = exports.cr_fonts:getFont("sf-regular", 11),
    font3 = exports.cr_fonts:getFont("sf-bold", 10),
    font4 = exports.cr_fonts:getFont("Bankgothic", 13),
    font5 = exports.cr_fonts:getFont("sf-regular", 10),
    font6 = exports.cr_fonts:getFont("sf-regular", 7),
}

local categories = {
	{"Öldürme"},
	{"Ekonomi"},
	{"Turf Öldürme"},
	{"Aktiflik"},
	{"Crown Pass"},
	{"Bakiye"},
}

bindKey("f4", "down", function()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(renderTimer) then
			isLoaded = false
			scroll = 0
			selectedCategory = 1
			triggerServerEvent("leaderboard.loadDatas", localPlayer, selectedCategory)
	        showCursor(true)
	        renderTimer = setTimer(function()
	            exports.cr_ui:drawRoundedRectangle {
					position = {
						x = screenX,
						y = screenY
					},
					size = {
						x = sizeX,
						y = sizeY
					},

					color = theme.GRAY[900],
					alpha = 1,
					radius = 10
				}
				
				dxDrawText("", screenX + 25, screenY + 20, 30, 30, tocolor(255, 255, 255, 250), 1, fonts.awesome1)
	            dxDrawText("liderler sıralaması", screenX + 83, screenY + 16, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font1)
	            dxDrawText("buradan sıralamada olanları görebilirsiniz", screenX + 83, screenY + 43, sizeX, sizeY, tocolor(255, 255, 255, 150), 1, fonts.font2)
				
				dxDrawText("", screenX + sizeX - 40, screenY + 20, nil, nil, exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, fonts.awesome2)
				if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
					clickTick = getTickCount()
					killTimer(renderTimer)
					showCursor(false)
				end
				
				local newCX = 0
				for key, value in pairs(categories) do
                    local isSelected = selectedCategory == key
                    dxDrawRectangle(screenX + 20 + newCX, screenY + 70, dxGetTextWidth(value[1], 1, fonts.font5) + 20, 30, (exports.cr_ui:inArea(screenX + 20 + newCX, screenY + 70, dxGetTextWidth(value[1], 1, fonts.font5) + 20, 30) or isSelected) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
                    dxDrawText(value[1], screenX + 30 + newCX, screenY + 76, 0, 0, tocolor(255, 255, 255, 235), 1, fonts.font5)
                    
                    if exports.cr_ui:inArea(screenX + 20 + newCX, screenY + 70, dxGetTextWidth(value[1], 1, fonts.font5) + 20, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() and selectedCategory ~= key then
                        clickTick = getTickCount()
						selectedCategory = key
						isLoaded = false
						scroll = 0
						triggerServerEvent("leaderboard.loadDatas", localPlayer, selectedCategory)
                    end
                    newCX = newCX + ((dxGetTextWidth(value[1], 1, fonts.font5) + 20) + 5)
                end
				
				if not isLoaded then
					exports.cr_ui:drawSpinner({
						position = {
							x = (screenSize.x - 128) / 2,
							y = ((screenSize.y - 128) / 2) + 25
						},
						size = 128,
						speed = 2,
						variant = "solid",
						color = "white"
					})
				else
					if selectedCategory == 1 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("karakter adı", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("rütbe", screenX + 265, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("öldürme", screenX + 395, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("ölme", screenX + 490, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								local name = value.charactername:gsub("_", " ")
								
								if getElementData(localPlayer, "dbid") == value.id then
									name = name .. " (Sen)"
								end
								
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 180, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 265, screenY + 135 + newY, 125, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 395, screenY + 135 + newY, 90, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 490, screenY + 135 + newY, 90, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(exports.cr_rank:getRankTitle(value.kills), screenX + 275, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(value.kills, screenX + 405, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(value.deaths, screenX + 500, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
						
						local currentTime = getTickCount()
						local targetTime = os.time({ year = 2024, month = 6, day = 30, hour = 23, min = 59, sec = 59 })
						local difference = targetTime - os.time()

						local days = math.floor(difference / (24 * 60 * 60))
						local hours = math.floor((difference % (24 * 60 * 60)) / (60 * 60))
						local minutes = math.floor((difference % (60 * 60)) / 60)
						local seconds = difference % 60

						local text = "Sezon 7'ye " .. days .. " gün, " .. hours .. " saat, " .. minutes .. " dakika, " .. seconds .. " saniye kaldı."
						dxDrawText(text, screenX - 15, screenY + sizeY - 17, screenX + sizeX, sizeY, tocolor(150, 150, 150, 250), 1, fonts.font6, "center")
					elseif selectedCategory == 2 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("karakter adı", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("para", screenX + 250, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								local name = value.charactername:gsub("_", " ")
								
								if getElementData(localPlayer, "dbid") == value.id then
									name = name .. " (Sen)"
								end
								
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 165, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 250, screenY + 135 + newY, 330, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText("$" .. exports.cr_global:formatMoney(value.money + value.bankmoney), screenX + 260, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
					elseif selectedCategory == 3 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("birlik", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("öldürme", screenX + 350, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 265, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 350, screenY + 135 + newY, 230, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(value.name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(value.turf_kills, screenX + 360, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
					elseif selectedCategory == 4 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("karakter adı", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("aktiflik", screenX + 250, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								local name = value.charactername:gsub("_", " ")
								
								if getElementData(localPlayer, "dbid") == value.id then
									name = name .. " (Sen)"
								end
								
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 165, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 250, screenY + 135 + newY, 330, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(value.hoursplayed .. " saat " .. value.minutesPlayed .. " dakika", screenX + 260, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
					elseif selectedCategory == 5 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("karakter adı", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("seviye", screenX + 250, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								local name = value.charactername:gsub("_", " ")
								
								if getElementData(localPlayer, "dbid") == value.id then
									name = name .. " (Sen)"
								end
								
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 165, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 250, screenY + 135 + newY, 330, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(value.pass_level, screenX + 260, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
					elseif selectedCategory == 6 then
						local newY = 0
						local rowIndex = 0
						local color = theme.GRAY[800]
					
						dxDrawText("sıra", screenX + 20, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("kullanıcı adı", screenX + 80, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						dxDrawText("bakiye", screenX + 250, screenY + 112, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font3)
						
						for index, value in ipairs(datas) do
							if index > scroll and rowIndex < maxScroll then
								local name = value.username
								
								if getElementData(localPlayer, "account:id") == value.id then
									name = name .. " (Sen)"
								end
								
								if index == 1 then
									color = "#D2AA00"
								elseif index == 2 then
									color = "#969696"
								elseif index == 3 then
									color = "#6E5A28"
								else
									color = theme.GRAY[800]
								end
								
								dxDrawRectangle(screenX + 20, screenY + 135 + newY, 55, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 80, screenY + 135 + newY, 165, 30, exports.cr_ui:rgba(color))
								dxDrawRectangle(screenX + 250, screenY + 135 + newY, 330, 30, exports.cr_ui:rgba(color))
								
								dxDrawText(index, screenX + 47, screenY + 139 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font4, "center")
								dxDrawText(name, screenX + 90, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								dxDrawText(exports.cr_global:formatMoney(value.balance) .. " TL", screenX + 260, screenY + 141 + newY, nil, nil, tocolor(255, 255, 255, 250), 1, fonts.font5)
								
								rowIndex = rowIndex + 1
								newY = newY + 35
							end
						end
					end
				end
	        end, 0, 0)
	    else
	        killTimer(renderTimer)
	        showCursor(false)
	    end
	end
end)

addEvent("leaderboard.loadDatas", true)
addEventHandler("leaderboard.loadDatas", root, function(_datas)
	if _datas and type(_datas) == "table" then
		datas = _datas
		isLoaded = true
	end
end)

bindKey("mouse_wheel_down", "down", function()
	if isTimer(renderTimer) then
	    if scroll < #datas - maxScroll then
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