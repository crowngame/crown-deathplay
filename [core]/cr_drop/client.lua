local dropSeconds = {}
local counterTimers = {}
local renderTimers = {}

local fonts = {
    icon = exports.cr_fonts:getFont("FontAwesome", 25),
    main = exports.cr_fonts:getFont("UbuntuRegular", 10),
}

addEvent("drop.startProcess", true)
addEventHandler("drop.startProcess", root, function(object)
    dropSeconds[object] = 120
    
    renderTimers[object] = setTimer(function()
        if (getElementDimension(localPlayer) == 0) and (getElementInterior(localPlayer) == 0) then
            local x, y, z = getElementPosition(object)
            local lx, ly, lz = getElementPosition(localPlayer)
            local distance = getDistanceBetweenPoints3D(x, y, z, lx, ly, lz)
            local sx, sy = getScreenFromWorldPosition(x, y, z + 1)
            
            if sx and sy then
                dxDrawText("", sx, sy, sx, sy - 55, tocolor(232, 113, 114), 1, fonts.icon, "center", "bottom", false, false, false, true, false)
                dxDrawText("Drop\n" .. ((dropSeconds[object] == -1) and "Alınabilir" or ("#8AE68A" .. dropSeconds[object] .. " #FFFFFFsaniye")) .. "\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre", sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, fonts.main, "center", "bottom", false, false, false, true, false)
            end
        end
    end, 0, 0)
	
	setTimer(function()
		counterTimers[object] = setTimer(function()
			if dropSeconds[object] == 0 then
				killTimer(counterTimers[object])
				counterTimers[object] = nil
			end
			dropSeconds[object] = dropSeconds[object] - 1
		end, 1000, 0)
	end, 10000, 1)
end)

addEvent("drop.deleteProcess", true)
addEventHandler("drop.deleteProcess", root, function(object)
	if isTimer(counterTimers[object]) then
		killTimer(counterTimers[object])
		counterTimers[object] = nil
	end
	
	if isTimer(renderTimers[object]) then
		killTimer(renderTimers[object])
		renderTimers[object] = nil
	end
	
	if dropSeconds[object] then
		dropSeconds[object] = nil
	end
end)