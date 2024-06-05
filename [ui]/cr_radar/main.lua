radarSettings = {
	["mapTexture"] = "images/map.jpg",
	["mapVignette"] = "images/vignette.png",
	["mapTextureSize"] = 3072,
	["mapWaterColor"] = {110, 158, 204},
	["alpha"] = 250,
	["showStats"] = true
}

local blips = {
    {2130.015625, -2156.2685546875, 14.689163208008, 55, "Ekonomik Galeri"},
	{2128.302734375, -1130.6826171875, 25.550813674927, 55, "Orta Galeri"},
	{550.9482421875, -1285.0009765625, 21.089172363281, 55, "Lüks Galeri"},
	{2312.9345703125, -8.390625, 26.7421875, 52, "Banka Soygunu"}
}

local blipElements = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	for _, blip in ipairs(blips) do 
        blipElements[blip] = createBlip(blip[1], blip[2], blip[3], blip[4], 2, 255, 255, 255, 255, 0)
        setElementData(blipElements[blip], "name", blip[5])
    end
end)