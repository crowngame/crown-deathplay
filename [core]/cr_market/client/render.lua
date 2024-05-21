local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 900, 600
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2
local clickTick = 0

local linesGap = 48
local linesHeight = 1

local selectedTextbox = 1
local textBoxes = {
	{"", false},
	{"", false},
}

local radioButtons = {
	{1, {"Erkek", "Kadın"}},
	{1, {"VIP 1", "VIP 2", "VIP 3", "VIP 4", "VIP 5"}},
	{1, {"Bronz Şans Kutusu", "Gümüş Şans Kutusu", "Altın Şans Kutusu", "Elmas Şans Kutusu"}},
}

local selectedPage = 1
local selectedCategory = 1
local selectedProduct = {0, 0, 0}

local isProductBuying = false
local totalPrice = 0
local selectedVehicle = 1
local selectedWeapon = 1

local fonts = {
    font1 = exports.cr_fonts:getFont("sf-regular", 11),
    font2 = exports.cr_fonts:getFont("sf-regular", 10),
    font3 = exports.cr_fonts:getFont("BebasNeueBold", 25),
    font4 = exports.cr_fonts:getFont("sf-regular", 9),
	font5 = exports.cr_fonts:getFont("sf-regular", 10),
	font6 = exports.cr_fonts:getFont("sf-bold", 17),
	font7 = exports.cr_fonts:getFont("sf-regular", 14),
    font8 = exports.cr_fonts:getFont("BebasNeueRegular", 11),
    awesome1 = exports.cr_fonts:getFont("FontAwesome", 25),
    awesome2 = exports.cr_fonts:getFont("FontAwesome", 17),
    awesome3 = exports.cr_fonts:getFont("FontAwesome", 30)
}

function marketRender()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(renderTimer) then
			selectedPage = 1
			selectedCategory = 1
			restartVariables()
			addEventHandler("onClientCharacter", root, eventWrite)
			addEventHandler("onClientKey", root, removeCharacter)
			addEventHandler("onClientPaste", root, pasteClipboardText)
	        showCursor(true)
			
			previewVehicle = createVehicle(privateVehicles[selectedVehicle][2], 0, 0, 0)
			setVehicleColor(previewVehicle, 255, 255, 255, 255, 255, 255)
			setElementCollisionsEnabled(previewVehicle, false)
			setElementDimension(previewVehicle, localPlayer.dimension)
			setElementInterior(previewVehicle, localPlayer.interior)
			
			renderTimer = setTimer(function()
				exports.cr_3dview:processObjectPreview(
                    privateWeapons[selectedWeapon][2],
                    screenX + 150,
					screenY - 140,
					900,
					900
				)
				exports.cr_3dview:setObjectPositionOffsets(0.1, 0, 0)
				
				if not exports.cr_3dview:getVehicleElement() then
					if isElement(previewVehicle) then
						exports.cr_3dview:processVehiclePreview()
						destroyElement(previewVehicle)
					end
					
					exports.cr_3dview:processVehiclePreview(previewVehicle,
						screenX,
						screenY,
						100,
						100
					)
					
					exports.cr_3dview:setVehicleFov(80)
					exports.cr_3dview:setVehiclePositionOffsets(0.5, 0, 0)
				end
			
	            dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(25, 25, 25, 255))

				dxDrawText("", screenX + sizeX - 20 + 1, screenY - 35 + 1, 2, 2, tocolor(0, 0, 0, 255), 1, fonts.awesome2)
				dxDrawText("", screenX + sizeX - 20, screenY - 35, nil, nil, exports.cr_ui:inArea(screenX + sizeX - 20, screenY - 35, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, fonts.awesome2)
				if exports.cr_ui:inArea(screenX + sizeX - 20, screenY - 35, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
					clickTick = getTickCount()
					restartVariables()
					exports.cr_3dview:removeProcesses()
					removeEventHandler("onClientCharacter", root, eventWrite)
					removeEventHandler("onClientKey", root, removeCharacter)
					removeEventHandler("onClientPaste", root, pasteClipboardText)
					killTimer(renderTimer)
					showCursor(false)
				end
				
				dxDrawText(exports.cr_global:formatMoney(getElementData(localPlayer, "balance")) .. " ₺", screenX + 1, screenY - 48 + 1, screenX + sizeX - dxGetTextWidth("", 1, fonts.awesome2) - 15 + 1, 2, tocolor(0, 0, 0, 255), 1, fonts.font3, "right")
				dxDrawText(exports.cr_global:formatMoney(getElementData(localPlayer, "balance")) .. " ₺", screenX, screenY - 48, screenX + sizeX - dxGetTextWidth("", 1, fonts.awesome2) - 15, nil, tocolor(255, 255, 255, 255), 1, fonts.font3, "right")
				
				dxDrawRectangle(screenX, screenY, sizeX, 45, tocolor(32, 32, 32, 255))
				
				dxDrawRectangle(screenX, screenY, sizeX, 35, (exports.cr_ui:inArea(screenX, screenY, sizeX, 35) or selectedPage == 1) and tocolor(20, 20, 20, 255) or tocolor(32, 32, 32, 255))
                dxDrawText("Mağaza", screenX + sizeX, screenY + 8, screenX, 0, selectedPage == 1 and tocolor(255, 255, 255, 235) or tocolor(255, 255, 255, 135), 1, fonts.font1, "center")
                
                if exports.cr_ui:inArea(screenX, screenY, sizeX, 35) and getKeyState("mouse1") and clickTick + 250 < getTickCount()  then
                    if not isProductBuying then
						clickTick = getTickCount()
						selectedPage = 1
					end
                end
				
				if selectedPage == 1 then
					dxDrawRectangle(screenX, screenY + 45, 220, sizeY - 45, tocolor(30, 30, 30, 255))
				
					local cY = 0
					for index, value in pairs(categories) do
						local isSelected = selectedCategory == index
						dxDrawRectangle(screenX, screenY + 45 + cY, 220, 30, (exports.cr_ui:inArea(screenX, screenY + 45 + cY, 220, 30) or isSelected) and tocolor(20, 20, 20, 255) or tocolor(32, 32, 32, 255))
						dxDrawText(value[1], screenX + 220, screenY + 52 + cY, screenX, 0, isSelected and tocolor(255, 255, 255, 235) or tocolor(255, 255, 255, 135), 1, fonts.font2, "center")
						
						if exports.cr_ui:inArea(screenX, screenY + 45 + cY, 220, 30) and getKeyState("mouse1") and clickTick + 250 < getTickCount()  then
							if not isProductBuying then
								clickTick = getTickCount()
								selectedCategory = index
								
								if selectedCategory == 3 then
									exports.cr_3dview:setVehicleAlpha(255)
									exports.cr_3dview:setObjectAlpha(0)
								elseif selectedCategory == 4 then
									exports.cr_3dview:setObjectAlpha(255)
									exports.cr_3dview:setVehicleAlpha(0)
								else
									exports.cr_3dview:setVehicleAlpha(0)
									exports.cr_3dview:setObjectAlpha(0)
								end
							end
						end
						cY = cY + 30
					end
					
					if selectedCategory == 1 then
						local newX = 0
						local newY = 0
						local column = 0
						
						for index, value in pairs(personalFeatures) do
							if column >= 5 then
								newX = 0
								newY = 130
								column = 0
							end
							
							dxDrawRectangle(screenX + 240 + newX, screenY + 60 + newY, 120, 120, exports.cr_ui:inArea(screenX + 240 + newX, screenY + 60 + newY, 120, 120) and tocolor(32, 32, 32, 255) or tocolor(20, 20, 20, 255))
							dxDrawText(value[1], screenX + 299 + newX, screenY + 95 + newY, nil, nil, tocolor(value[3][1], value[3][2], value[3][3], 255), 1, fonts.awesome1, "center")
							dxDrawText(value[2], screenX + 300 + newX, screenY + 155 + newY, nil, nil, tocolor(value[3][1], value[3][2], value[3][3], 255), 1, fonts.font4, "center")
							dxDrawText(value[4] .. " ₺", screenX + 350 + newX, screenY + 65 + newY, nil, nil, tocolor(value[3][1], value[3][2], value[3][3], 255), 1, fonts.font8, "right")
							
							if exports.cr_ui:inArea(screenX + 240 + newX, screenY + 60 + newY, 120, 120) and getKeyState("mouse1") and clickTick + 500 < getTickCount()  then
								if not isProductBuying then
									clickTick = getTickCount()
									if getElementData(localPlayer, "balance") >= value[4] then
										if tonumber(value[5]) then
											selectedProduct = {1, value[5], index}
											isProductBuying = true
										else
											if value[6] == 1 then
												triggerServerEvent(value[5], localPlayer, value[4])
											elseif value[6] == 2 then
												clickTick = getTickCount()
												restartVariables()
												removeEventHandler("onClientCharacter", root, eventWrite)
												removeEventHandler("onClientKey", root, removeCharacter)
												removeEventHandler("onClientPaste", root, pasteClipboardText)
												killTimer(renderTimer)
												showCursor(false)
												triggerEvent(value[5], localPlayer)
											end
										end
									else
										exports.cr_infobox:addBox("error", "Yeterli bakiyeniz yok.")
									end
								end
							end
							
							newX = newX + 130
							column = column + 1
						end
						
						if selectedProduct[1] == 1 then
							dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(0, 0, 0, 200))
							
							if selectedProduct[2] == 1 then
								local pageSizeX, pageSizeY = 350, 200
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Ad Soyad", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								local newRBY = 0
								for index, value in pairs(radioButtons[1][2]) do
									dxDrawRectangle(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20, tocolor(20, 20, 20, 255))
									dxDrawText(radioButtons[1][2][index], pageScreenX + 47, pageScreenY + 61 + newRBY, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font5)
									if radioButtons[1][1] == index then
										dxDrawRectangle(pageScreenX + 20 + 5, pageScreenY + 60 + 5 + newRBY, 10, 10, tocolor(255, 255, 255, 255))
									end
									
									if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
										clickTick = getTickCount()
										radioButtons[1][1] = index
									end
									
									newRBY = newRBY + 30
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 120, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 120, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 128, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 120, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									triggerServerEvent("market.buyCharacterNameChange", localPlayer, textBoxes[1][1], personalFeatures[selectedProduct[3]][4])
									restartVariables()
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 155, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 155, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 163, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 155, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 2 then
								local pageSizeX, pageSizeY = 350, 140
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Kullanıcı Adı", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 68, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									triggerServerEvent("market.buyAccountNameChange", localPlayer, textBoxes[1][1], personalFeatures[selectedProduct[3]][4])
									restartVariables()
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 103, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 3 then
								local pageSizeX, pageSizeY = 350, 295
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Gün", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								local newRBY = 0
								for index, value in pairs(radioButtons[2][2]) do
									dxDrawRectangle(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20, tocolor(20, 20, 20, 255))
									dxDrawText(radioButtons[2][2][index], pageScreenX + 47, pageScreenY + 61 + newRBY, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font5)
									if radioButtons[2][1] == index then
										dxDrawRectangle(pageScreenX + 20 + 5, pageScreenY + 60 + 5 + newRBY, 10, 10, tocolor(255, 255, 255, 255))
									end
									
									if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
										clickTick = getTickCount()
										radioButtons[2][1] = index
										
										if tonumber(textBoxes[1][1]) then
											totalPrice = textBoxes[1][1] * vips[radioButtons[2][1]]
										end
									end
									
									newRBY = newRBY + 30
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 215, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 215, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla (" .. totalPrice .. " TL)", pageScreenX + 175, pageScreenY + 223, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 215, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									if tonumber(textBoxes[1][1]) then
										if tonumber(textBoxes[1][1]) >= 7 then
											triggerServerEvent("market.buyVIP", localPlayer, radioButtons[2][1], tonumber(math.floor(textBoxes[1][1])), totalPrice)
											restartVariables()
										else
											exports.cr_infobox:addBox("error", "Minimum 7 günlük VIP üyeliği satın alabilirsiniz.")
										end
									else
										exports.cr_infobox:addBox("error", "Lütfen geçerli bir gün girin.")
									end
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 250, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 250, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 258, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 250, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 4 then
								local pageSizeX, pageSizeY = 350, 265
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Miktar", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								local newRBY = 0
								for index, value in pairs(radioButtons[3][2]) do
									dxDrawRectangle(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20, tocolor(20, 20, 20, 255))
									dxDrawText(radioButtons[3][2][index], pageScreenX + 47, pageScreenY + 61 + newRBY, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font5)
									if radioButtons[3][1] == index then
										dxDrawRectangle(pageScreenX + 20 + 5, pageScreenY + 60 + 5 + newRBY, 10, 10, tocolor(255, 255, 255, 255))
									end
									
									if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60 + newRBY, 20, 20) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
										clickTick = getTickCount()
										radioButtons[3][1] = index
										
										if tonumber(textBoxes[1][1]) then
											totalPrice = textBoxes[1][1] * luckBoxes[radioButtons[3][1]][3]
										end
									end
									
									newRBY = newRBY + 30
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 185, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 185, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla (" .. totalPrice .. " TL)", pageScreenX + 175, pageScreenY + 193, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 185, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									if tonumber(textBoxes[1][1]) then
										if tonumber(textBoxes[1][1]) >= 1 then
											triggerServerEvent("market.buyLuckBox", localPlayer, radioButtons[3][1], math.floor(textBoxes[1][1]), totalPrice)
											restartVariables()
										else
											exports.cr_infobox:addBox("error", "Minimum 1 adet şans kutusu satın alabilirsiniz.")
										end
									else
										exports.cr_infobox:addBox("error", "Lütfen geçerli bir miktar girin.")
									end
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 220, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 220, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 228, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 220, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 5 then
								local pageSizeX, pageSizeY = 350, 140
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Rozet", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 68, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									triggerServerEvent("market.buyPrivateBadge", localPlayer, textBoxes[1][1], personalFeatures[selectedProduct[3]][4])
									restartVariables()
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 103, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							else
								exports.cr_infobox:addBox("error", "Bu özellik şu-anda devre dışı.")
								restartVariables()
							end
						end
					elseif selectedCategory == 2 then
						local newX = 0
						local newY = 0
						local column = 0
						
						for index, value in pairs(vehicleFeatures) do
							if column >= 5 then
								newX = 0
								newY = 130
								column = 0
							end
							
							dxDrawRectangle(screenX + 240 + newX, screenY + 60 + newY, 120, 120, exports.cr_ui:inArea(screenX + 240 + newX, screenY + 60 + newY, 120, 120) and tocolor(32, 32, 32, 255) or tocolor(20, 20, 20, 255))
							dxDrawText(value[1], screenX + 299 + newX, screenY + 95 + newY, nil, nil, tocolor(102, 102, 102, 255), 1, fonts.awesome1, "center")
							dxDrawText(value[2], screenX + 300 + newX, screenY + 155 + newY, nil, nil, tocolor(102, 102, 102, 255), 1, fonts.font4, "center")
							dxDrawText(value[4] .. " ₺", screenX + 350 + newX, screenY + 65 + newY, nil, nil, tocolor(value[3][1], value[3][2], value[3][3], 255), 1, fonts.font8, "right")
							
							if exports.cr_ui:inArea(screenX + 240 + newX, screenY + 60 + newY, 120, 120) and getKeyState("mouse1") and clickTick + 500 < getTickCount()  then
								if not isProductBuying then
									clickTick = getTickCount()
									if getElementData(localPlayer, "balance") >= value[4] then
										if tonumber(value[5]) then
											selectedProduct = {2, value[5], index}
											isProductBuying = true
										else
											if value[6] == 1 then
												triggerServerEvent(value[5], localPlayer, value[4])
											elseif value[6] == 2 then
												clickTick = getTickCount()
												restartVariables()
												removeEventHandler("onClientCharacter", root, eventWrite)
												removeEventHandler("onClientKey", root, removeCharacter)
												removeEventHandler("onClientPaste", root, pasteClipboardText)
												killTimer(renderTimer)
												showCursor(false)
												triggerEvent(value[5], localPlayer)
											end
										end
									else
										exports.cr_infobox:addBox("error", "Yeterli bakiyeniz yok.")
									end
								end
							end
							
							newX = newX + 130
							column = column + 1
						end
						
						if selectedProduct[1] == 2 then
							dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(0, 0, 0, 200))

							if selectedProduct[2] == 1 then
								local pageSizeX, pageSizeY = 350, 180
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Araç ID", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[2][2] and textBoxes[2][1] or "Plaka", pageScreenX + 30, pageScreenY + 66, nil, nil, textBoxes[2][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 2
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 100, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 100, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 108, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 100, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									if tonumber(textBoxes[1][1]) then
										triggerServerEvent("market.buyVehiclePlate", localPlayer, math.floor(textBoxes[1][1]), textBoxes[2][1], vehicleFeatures[selectedProduct[3]][4])
										restartVariables()
									else
										exports.cr_infobox:addBox("error", "Lütfen geçerli bir Araç ID girin.")
									end
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 135, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 135, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 143, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 135, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 2 then
								local pageSizeX, pageSizeY = 350, 140
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Araç ID", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 68, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									triggerServerEvent("market.buyVehicleTintWindows", localPlayer, textBoxes[1][1], vehicleFeatures[selectedProduct[3]][4])
									restartVariables()
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 103, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							elseif selectedProduct[2] == 3 then
								exports.cr_infobox:addBox("error", "Bu özellik şu-anda devre dışı.")
								restartVariables()
							elseif selectedProduct[2] == 4 then
								local pageSizeX, pageSizeY = 350, 140
								local pageScreenX, pageScreenY = (screenSize.x - pageSizeX) / 2, (screenSize.y - pageSizeY) / 2
								
								dxDrawRectangle(pageScreenX, pageScreenY, pageSizeX, pageSizeY, tocolor(25, 25, 25, 255))
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30, tocolor(20, 20, 20, 255))
								dxDrawText(textBoxes[1][2] and textBoxes[1][1] or "Araç ID", pageScreenX + 30, pageScreenY + 26, nil, nil, textBoxes[1][2] and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.font5)
				
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 20, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									selectedTextbox = 1
									textBoxes[selectedTextbox][1] = ""
									textBoxes[selectedTextbox][2] = true
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
								dxDrawText("Onayla", pageScreenX + 175, pageScreenY + 68, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 60, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									triggerServerEvent("market.buyVehicleButterflyDoor", localPlayer, textBoxes[1][1], vehicleFeatures[selectedProduct[3]][4])
									restartVariables()
								end
								
								dxDrawRectangle(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30, exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and tocolor(232, 113, 114, 255) or tocolor(232, 113, 114, 200))
								dxDrawText("Arayüzü Kapat", pageScreenX + 175, pageScreenY + 103, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
								
								if exports.cr_ui:inArea(pageScreenX + 20, pageScreenY + 95, pageSizeX - 40, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
									clickTick = getTickCount()
									restartVariables()
								end
							else
								exports.cr_infobox:addBox("error", "Bu özellik şu-anda devre dışı.")
								restartVariables()
							end
						end
					elseif selectedCategory == 3 then
						drawLinesBackground({ x = screenX + 220, y = screenY + 45 }, { x = 680, y = 555 })
						
						exports.cr_3dview:setVehicleProjection(
							screenX + 150,
							screenY - 140,
							900,
							900
						)
						
						dxDrawText("", screenX + 240, screenY + 260, nil, nil, exports.cr_ui:inArea(screenX + 240, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.awesome3)
						
						if exports.cr_ui:inArea(screenX + 240, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							if selectedVehicle ~= 1 then
								selectedVehicle = selectedVehicle - 1
								previewVehicle:setModel(privateVehicles[selectedVehicle][2])
								exports.cr_3dview:setPreviewVehicleModel(privateVehicles[selectedVehicle][2])
							end
						end
						
						dxDrawText("", screenX + sizeX - 55, screenY + 260, nil, nil, exports.cr_ui:inArea(screenX + sizeX - 55, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.awesome3)
						
						if exports.cr_ui:inArea(screenX + sizeX - 55, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							if selectedVehicle < #privateVehicles then
								selectedVehicle = selectedVehicle + 1
								previewVehicle:setModel(privateVehicles[selectedVehicle][2])
								exports.cr_3dview:setPreviewVehicleModel(privateVehicles[selectedVehicle][2])
							end
						end
						
						dxDrawText(privateVehicles[selectedVehicle][1], screenX + 240, screenY + sizeY - 73, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font6)
						dxDrawText(exports.cr_global:formatMoney(privateVehicles[selectedVehicle][4]) .. " TL", screenX + 240, screenY + sizeY - 40, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font7)
						
						dxDrawRectangle(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30, exports.cr_ui:inArea(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
						dxDrawText("Satın Al", screenX + sizeX - 95, screenY + sizeY - 42, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
						
						if exports.cr_ui:inArea(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							triggerServerEvent("market.buyPrivateVehicle", localPlayer, privateVehicles[selectedVehicle][2], privateVehicles[selectedVehicle][3], privateVehicles[selectedVehicle][1], privateVehicles[selectedVehicle][4])
						end
					elseif selectedCategory == 4 then
						drawLinesBackground({ x = screenX + 220, y = screenY + 45 }, { x = 680, y = 555 })
						
						exports.cr_3dview:setObjectProjection(
							screenX + 150,
							screenY - 140,
							900,
							900
						)
						
						dxDrawText("", screenX + 240, screenY + 260, nil, nil, exports.cr_ui:inArea(screenX + 240, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.awesome3)
						
						if exports.cr_ui:inArea(screenX + 240, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							if selectedWeapon ~= 1 then
								selectedWeapon = selectedWeapon - 1
								exports.cr_3dview:processObjectPreview()
							end
						end
						
						dxDrawText("", screenX + sizeX - 55, screenY + 260, nil, nil, exports.cr_ui:inArea(screenX + sizeX - 55, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and tocolor(255, 255, 255, 255) or tocolor(255, 255, 255, 200), 1, fonts.awesome3)
						
						if exports.cr_ui:inArea(screenX + sizeX - 55, screenY + 260, dxGetTextWidth("", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							if selectedWeapon < #privateWeapons then
								selectedWeapon = selectedWeapon + 1
								exports.cr_3dview:processObjectPreview()
							end
						end
						
						dxDrawText(privateWeapons[selectedWeapon][1], screenX + 240, screenY + sizeY - 73, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font6)
						dxDrawText(exports.cr_global:formatMoney(privateWeapons[selectedWeapon][4]) .. " TL", screenX + 240, screenY + sizeY - 40, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font7)
						
						dxDrawRectangle(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30, exports.cr_ui:inArea(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30) and tocolor(45, 218, 157, 255) or tocolor(45, 218, 157, 200))
						dxDrawText("Satın Al", screenX + sizeX - 95, screenY + sizeY - 42, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font4, "center")
						
						if exports.cr_ui:inArea(screenX + sizeX - 170, screenY + sizeY - 50, 150, 30) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
							clickTick = getTickCount()
							triggerServerEvent("market.buyPrivateWeapon", localPlayer, privateWeapons[selectedWeapon][3], privateWeapons[selectedWeapon][4])
						end
					end
				end
	        end, 0, 0)
	    else
			restartVariables()
			exports.cr_3dview:removeProcesses()
			removeEventHandler("onClientCharacter", root, eventWrite)
			removeEventHandler("onClientKey", root, removeCharacter)
			removeEventHandler("onClientPaste", root, pasteClipboardText)
	        killTimer(renderTimer)
	        showCursor(false)
	    end
	end
end
addCommandHandler("market", marketRender, false, false)

function eventWrite(...)
    write(...)
end

function write(char)
	if textBoxes[selectedTextbox][2] then
		local text = textBoxes[selectedTextbox][1]
		if #text <= 30 then
			textBoxes[selectedTextbox][1] = textBoxes[selectedTextbox][1] .. char
			playSound(":cr_ui/public/sounds/key.mp3")
			
			if (selectedProduct[1] == 1 and selectedProduct[2] == 3) and tonumber(textBoxes[selectedTextbox][1]) then
				totalPrice = textBoxes[selectedTextbox][1] * vips[radioButtons[2][1]]
			elseif (selectedProduct[1] == 1 and selectedProduct[2] == 4) and tonumber(textBoxes[selectedTextbox][1]) then
				totalPrice = textBoxes[selectedTextbox][1] * luckBoxes[radioButtons[3][1]][3]
			end
		end
	end
end

function removeCharacter(key, state)
    if key == "backspace" and state then
        if textBoxes[selectedTextbox][2] then
			local text = textBoxes[selectedTextbox][1]
			if #text > 0 then
				textBoxes[selectedTextbox][1] = string.sub(text, 1, #text - 1)
				playSound(":cr_ui/public/sounds/key.mp3")
				
				if (selectedProduct[1] == 1 and selectedProduct[2] == 3) and tonumber(textBoxes[selectedTextbox][1]) then
					totalPrice = textBoxes[selectedTextbox][1] * vips[radioButtons[2][1]]
				elseif (selectedProduct[1] == 1 and selectedProduct[2] == 5) and tonumber(textBoxes[selectedTextbox][1]) then
					totalPrice = textBoxes[selectedTextbox][1] * luckBoxes[radioButtons[3][1]][3]
				end
			end
        end
    end
end

function pasteClipboardText(clipboardText)
	if clipboardText then
		if textBoxes[selectedTextbox][2] then
			local text = textBoxes[selectedTextbox][1]
			if #text <= 30 then
				textBoxes[selectedTextbox][1] = textBoxes[selectedTextbox][1] .. clipboardText
				playSound(":cr_ui/public/sounds/key.mp3")
				
				if (selectedProduct[1] == 1 and selectedProduct[2] == 3) and tonumber(textBoxes[selectedTextbox][1]) then
					totalPrice = textBoxes[selectedTextbox][1] * vips[radioButtons[2][1]]
				elseif (selectedProduct[1] == 1 and selectedProduct[2] == 4) and tonumber(textBoxes[selectedTextbox][1]) then
					totalPrice = textBoxes[selectedTextbox][1] * luckBoxes[radioButtons[3][1]][3]
				end
			end
		end
	end
end

function restartVariables()
	for index, value in pairs(textBoxes) do
		textBoxes[index][1] = ""
		textBoxes[index][2] = false
	end
	
	for index, value in pairs(radioButtons) do
		radioButtons[index][1] = 1
	end
	
	selectedProduct = {0, 0, 0}
	selectedTextbox = 1
	isProductBuying = false
	totalPrice = 0
	selectedVehicle = 1
	selectedWeapon = 1
end

function drawLinesBackground(position, size)
    local linesCount = math.floor(size.y / (linesHeight + linesGap))
    local linesCountX = math.floor(size.x / (linesHeight + linesGap))

    for i = 1, linesCount do
        local y = position.y + (i - 1) * (linesHeight + linesGap)
        dxDrawRectangle(position.x, y, size.x, linesHeight, exports.cr_ui:rgba("#29292e", 1))
    end

    for i = 1, linesCountX do
        local x = position.x + (i - 1) * (linesHeight + linesGap)
        dxDrawRectangle(x, position.y, linesHeight, size.y, exports.cr_ui:rgba("#29292e", 1))
    end
end