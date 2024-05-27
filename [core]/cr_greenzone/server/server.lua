local positions = {
	{x = 255.3427734375, y = -2074.486328125, width = 50, depth = 50}, -- AFK Bölgesi
	{x = 1997.2783203125, y = -1451.0146484375, width = 60, depth = 60}, -- Hastane Bölgesi
	{x = 513.517578125, y = -1330.0185546875, width = 65, depth = 75}, -- Zengin Galeri
	{x = 2111.4921875, y = -1163.078125, width = 50, depth = 50}, -- Orta Galeri
	{x = 1509.718359375, y = -1481.3271484375, width = 50, depth = 50}, -- Crown Galeri
	-- {x = 163.2236328125, y = -1886.603515625, width = 100, depth = 100}, -- O Ses Crown
}
local greenzones = {}
local lastPositions = {}

addEventHandler("onResourceStart", resourceRoot, function()
	if positions and #positions ~= 0 then
		for _, value in ipairs(positions) do
			if value then
				if value.x and value.y and value.width and value.depth then
					local colCuboid = createColCuboid(value.x, value.y, -50, value.width, value.depth, 10000)
					local radarArea = createRadarArea(value.x, value.y, value.width, value.depth, 0, 255, 0, 150)
					setElementParent(radarArea, colCuboid)
					if colCuboid then
						greenzones[colCuboid] = true
						
						for _, player in ipairs(getElementsWithinColShape(colCuboid, "player")) do
							setElementData(player, "greenzone", true)
						end
						
						addEventHandler("onElementDestroy", colCuboid, function()
							if greenzones[source] then
								greenzones[source] = nil
							end
						end)
						
						addEventHandler("onColShapeHit", colCuboid, function(element, dimension)
							if element and dimension and isElement(element) and getElementType(element) == "player" then
								setElementData(element, "greenzone", true)
							end
						end)
						
						addEventHandler("onColShapeLeave", colCuboid, function(element, dimension)
							if element and dimension and isElement(element) and getElementType(element) == "player" then
								removeElementData(element, "greenzone")
							end
						end)
						
						for _, player in ipairs(getElementsByType("player")) do
							local x, y, z = getElementPosition(player)
							lastPositions[player] = {x, y, z}
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		if isElement(player) then
			removeElementData(player, "greenzone")
		end
	end
end)

addEventHandler("onPlayerJoin", root, function()
	local x, y, z = getElementPosition(source)
	lastPositions[source] = {x, y, z}
end)

addEventHandler("onPlayerQuit", root, function()
	if lastPositions[source] then
		lastPositions[source] = nil
	end
end)

function interiorAndDimensionChange()
	if getElementType(source) == "player" then
		removeElementData(source, "greenzone")
		
		for colCuboid, _ in pairs(greenzones) do
			for _, player in ipairs(getElementsWithinColShape(colCuboid, "player")) do
				setElementData(player, "greenzone", true)
			end
		end
	end
end
addEventHandler("onElementInteriorChange", root, interiorAndDimensionChange)
addEventHandler("onElementDimensionChange", root, interiorAndDimensionChange)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		local x, y, z = getElementPosition(player)
		if x ~= lastPositions[player][1] or y ~= lastPositions[player][2] or z ~= lastPositions[player][3] then
			lastPositions[player] = {x, y, z}
			
			removeElementData(player, "greenzone")
			for colCuboid, _ in pairs(greenzones) do
				if isElementWithinColShape(player, colCuboid) then
					setElementData(player, "greenzone", true)
				end
			end
		end
	end
end, 1000, 0)