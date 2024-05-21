local fonts = {
	icon = exports.cr_fonts:getFont("FontAwesome", 25),
	main = exports.cr_fonts:getFont("UbuntuRegular", 10),
}

addEvent("robbery.renderUI", true) 
addEventHandler("robbery.renderUI", root, function(state, vehicle)
	if (state) then
        if not isTimer(renderTimer) then
			renderTimer = setTimer(function()
				if (getElementDimension(localPlayer) == 0) and (getElementInterior(localPlayer) == 0) then
					local x, y, z = getElementPosition(vehicle)
					local lx, ly, lz = getElementPosition(localPlayer)
					local distance = getDistanceBetweenPoints3D(x, y, z, lx, ly, lz)
					local sx, sy = getScreenFromWorldPosition(x, y, z + 3)
					
					if sx and sy then
						dxDrawText("", sx, sy, sx, sy - 40, exports.cr_ui:rgba("#8AE68A"), 1, fonts.icon, "center", "bottom", false, false, false, true, false)
						dxDrawText("Banka Kamyonu\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre", sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, fonts.main, "center", "bottom", false, false, false, true, false)
					end
				end
			end, 0, 0, vehicle)
		end
    else
        if isTimer(renderTimer) then
			killTimer(renderTimer)
		end
    end
end)