_1stPlayer = createPed(253, 2036.4870605469, -1438.2783203125, 19.455863952637)
setElementFrozen(_1stPlayer, true)
setElementRotation(_1stPlayer, 0, 0, 90)
setPedAnimation(_1stPlayer, "PARK", "Tai_Chi_Loop", -1, true, false, false)
setElementData(_1stPlayer, "datas", {
	charactername = "Engjellushe_Bukuroshe",
	kills = 16706,
	deaths = 3438
})

_2ndPlayer = createPed(134, 2036.9870605469, -1435.8, 19.455863952637)
setElementFrozen(_2ndPlayer, true)
setElementRotation(_2ndPlayer, 0, 0, 90)
setPedAnimation(_2ndPlayer, "BSKTBALL", "BBALL_def_loop", -1, true, false, false)
setElementData(_2ndPlayer, "datas", {
	charactername = "Mulayim_El_Siirtli",
	kills = 13350,
	deaths = 4728
})

_3rdPlayer = createPed(134, 2036.9870605469, -1440.6783203125, 19.455863952637)
setElementFrozen(_3rdPlayer, true)
setElementRotation(_3rdPlayer, 0, 0, 90)
setPedAnimation(_3rdPlayer, "SHOP", "ROB_Loop_Threat", -1, true, false, false)
setElementData(_3rdPlayer, "datas", {
	charactername = "Kaizen_Guzman",
	kills = 12107,
	deaths = 1566
})

datas = {}

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
					
					if (distance <= 30) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							dxDrawBorderedText(2, tocolor(22, 156, 196, alpha), index, screenX, 0, screenX, screenY, tocolor(50, 185, 222, alpha), 1, seasonFonts.season5_nametag, "center", "bottom", false, true, false, true)
						end
					end
				end
				
				if isElement(ped) then
					local boneX, boneY, boneZ = getPedBonePosition(ped, 2)
					boneZ = boneZ - 0.1
					
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (distance <= 30) and (isElementOnScreen(ped)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(ped) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							local datas = getElementData(ped, "datas")
							if datas then
								dxDrawText((datas.charactername):gsub("_", " ") .. "\nÖldürme: " .. datas.kills .. "\nÖlme: " .. datas.deaths, screenX, 0, screenX, screenY, exports.cr_ui:rgba(theme.GRAY[100], alpha / 255), 1, fonts.UbuntuRegular.caption, "center", "bottom", false, true, false, true)
							end
						end
					end
				end
			end
		end
	end
end, 5, 0)