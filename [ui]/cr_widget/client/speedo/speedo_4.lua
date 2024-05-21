local screenX, screenY = (screenSize.x / 1920) + 0.02, screenSize.y / 1080

local font = dxCreateFont("public/fonts/GothamProBoldItalic.ttf", 25)
local font1 = dxCreateFont("public/fonts/GothamPro.ttf", 15)
local font2 = dxCreateFont("public/fonts/GothamPro.ttf", 10)

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").speedo == 4 then
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			if theVehicle then
				local speed = getElementSpeed(theVehicle, "kmh")
				local fuel = getElementData(theVehicle, "fuel") or 100

				dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/main.png", 0, 0, 0, tocolor(255, 255, 255, 255))
				dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speed.png", 0, 0, 0, tocolor(0, 0, 0, 125))
				dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speedline.png", 0, 0, 0, tocolor(0, 0, 0, 125))

				if getElementData(theVehicle, "turn_right") then
					if (getTickCount() % 1400 >= 600) then
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speedline.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					end
				end

				if getElementData(theVehicle, "turn_left") then
					if (getTickCount() % 1400 >= 600) then
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speed.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					end
				end

				if getElementData(theVehicle, "emergency_light") then
					if (getTickCount() % 1400 >= 600) then
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speed.png", 0, 0, 0, tocolor(255, 255, 255, 255))
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/speedline.png", 0, 0, 0, tocolor(255, 255, 255, 255))
					end
				end

				dxDrawText(speed, 1495 * screenX, 1310 * screenY, 1880 * screenX, 367 * screenY, tocolor(255, 255, 255, 255), 1, font, "center", "center")
				dxDrawText("km/h", 1495 * screenX, 1370 * screenY, 1880 * screenX, 367 * screenY, tocolor(255, 255, 255, 255), 1, font1, "center", "center")

				dxDrawSpeedIndicator(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, -140, tocolor(230, 105, 25, 255), 360, 300 / 300 * speed, 40)

				dxDrawImageSection(1583 * screenX, 984 * screenY, 205 * screenX * (fuel) / 100, 53 * screenX, 0, 0, 205 * (fuel) / 100, 53, "public/images/fuelmask.png", 0, 0, 0, tocolor(255, 255, 255, 255))

				if getVehicleEngineState(theVehicle) then
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/engine_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/engine_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end

				if isVehicleLocked(theVehicle) then
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/door_lock.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/door_unlock.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end

				if getVehicleOverrideLights(theVehicle) == 2 then
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/light_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				elseif getVehicleOverrideLights(theVehicle) == 1 then
					dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/light_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				else
					local hours, minutes = getTime()
					if hours >= 7 and hours <= 21 then
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/light_off.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
					else
						dxDrawImage(1500 * screenX, 700 * screenY, 367 * screenX, 367 * screenY, "public/images/light_on.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
					end
				end
			end
		end
	end
end, 0, 0)