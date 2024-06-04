local icon1_centerX, icon1_topY = 0.89, 0.43
local icon_width, icon_height = 24, 24
local icon_sideMargin, icon_bottomMargin = 10, 5
local label_width, label_height = 200, 20
local label_font, label_topMargin = exports.cr_fonts:getFont("sf-bold", 9), 4
local label_shadowColor = tocolor(0, 0, 0)
local rows = 5

local rows_margin = icon_height + icon_bottomMargin

local label1_leftX = screenSize.x * icon1_centerX - icon_width / 2 - icon_sideMargin - label_width
local label1_rightX = label1_leftX + label_width
local label2_leftX = label1_rightX + icon_sideMargin * 2 + icon_width
local label2_rightX = label2_leftX + label_width

local icon_leftX = label1_rightX + icon_sideMargin
local icon_topY = screenSize.y * icon1_topY

local killRow = {}

local imagePath = { 
    [0] = "public/images/icons/weapons/fist.png",
    [1] = "public/images/icons/weapons/brassKnuckles.png",
    [2] = "public/images/icons/weapons/golfClub.png",
    [3] = "public/images/icons/weapons/nightstick.png",
    [4] = "public/images/icons/weapons/knife.png",
    [5] = "public/images/icons/weapons/baseballBat.png",
    [6] = "public/images/icons/weapons/shovel.png",
    [7] = "public/images/icons/weapons/poolCue.png",
    [8] = "public/images/icons/weapons/katana.png",
    [9] = "public/images/icons/weapons/chainsaw.png",
    [10] = "public/images/icons/weapons/dildo.png",
    [11] = "public/images/icons/weapons/dildo.png",
    [12] = "public/images/icons/weapons/dildo.png",
    [13] = "public/images/icons/deathReasons/death.png", 
    [14] = "public/images/icons/weapons/flowers.png",
    [15] = "public/images/icons/weapons/cane.png",
    [16] = "public/images/icons/weapons/grenade.png",
    [17] = "public/images/icons/weapons/tearGas.png",
    [18] = "public/images/icons/weapons/molotovCocktail.png",
    [19] = "public/images/icons/weapons/rocketLauncher.png",
    [20] = "public/images/icons/weapons/hsRocketLauncher.png", 
    [21] = "public/images/icons/deathReasons/explosion.png", 
    [22] = "public/images/icons/weapons/9mm.png",
    [23] = "public/images/icons/weapons/silenced9mm.png",
    [24] = "public/images/icons/weapons/desertEagle.png",
    [25] = "public/images/icons/weapons/shotgun.png",
    [26] = "public/images/icons/weapons/sawnoffShotgun.png",
    [27] = "public/images/icons/weapons/combatShotgun.png",
    [28] = "public/images/icons/weapons/microSmg.png",
    [29] = "public/images/icons/weapons/mp5.png",
    [30] = "public/images/icons/weapons/ak47.png",
    [31] = "public/images/icons/weapons/m4.png",
    [32] = "public/images/icons/weapons/tec9.png",
    [33] = "public/images/icons/weapons/countryRifle.png",
    [34] = "public/images/icons/weapons/sniperRifle.png",
    [35] = "public/images/icons/weapons/rocketLauncher.png",
    [36] = "public/images/icons/weapons/hsRocketLauncher.png",
    [37] = "public/images/icons/weapons/flamethrower.png",
    [38] = "public/images/icons/weapons/minigun.png",
    [39] = "public/images/icons/weapons/satchelCharge.png",
    [40] = "public/images/icons/weapons/detonator.png", 
    [41] = "public/images/icons/weapons/spraycan.png",
    [42] = "public/images/icons/weapons/fireExtinguisher.png",
    [43] = "public/images/icons/deathReasons/explosion.png", 
    [44] = "public/images/icons/weapons/goggles.png", 
    [45] = "public/images/icons/weapons/goggles.png", 
    [46] = "public/images/icons/weapons/parachute.png", 

    [49] = "public/images/icons/deathReasons/rammed.png",
    [50] = "public/images/icons/deathReasons/helicopterBlades.png",
    [51] = "public/images/icons/deathReasons/explosion.png",
    [52] = "public/images/icons/deathReasons/fire.png",
    [53] = "public/images/icons/deathReasons/death.png",
    [54] = "public/images/icons/deathReasons/fall.png",
    [255] = "public/images/icons/deathReasons/death.png",
}

addEvent("killmessage2.sendKill", true)
addEventHandler("killmessage2.sendKill", root, function(killerName, killerNameColor, deathReason, victimName, victimNameColor)
	local firstRow = killRow[1]

    for r = 1, rows - 1 do
        killRow[r] = killRow[r + 1]
    end

    if type(killerNameColor) ~= "table" then killerNameColor = { 255, 255, 255 } end
    if type(victimNameColor) ~= "table" then victimNameColor = { 255, 255, 255 } end

    if firstRow then
        killRow[rows] = firstRow

        killRow[rows]["killerName"] = unfuck(tostring(killerName))
        killRow[rows]["killerNameColor"] = tocolor(unpack(killerNameColor))
        killRow[rows]["deathReason"] = deathReason
        killRow[rows]["victimName"] = unfuck(tostring(victimName))
        killRow[rows]["victimNameColor"] = tocolor(unpack(victimNameColor))

    else
        killRow[rows] = { 
            ["killerNamePos"] = { leftX = label1_leftX, rightX = label1_rightX, topY = 0, bottomY = 0 },
            ["reasonIconPos"] = { leftX = icon_leftX, topY = 0 },
            ["victimNamePos"] = { leftX = label2_leftX, rightX = label2_rightX, topY = 0, bottomY = 0 },

            ["killerName"] = unfuck(tostring(killerName)),
            ["killerNameColor"] = tocolor(unpack(killerNameColor)),
            ["deathReason"] = deathReason,
            ["victimName"] = unfuck(tostring(victimName)),
            ["victimNameColor"] = tocolor(unpack(victimNameColor))
        }
    end

    if imagePath[killRow[rows]["deathReason"]] == nil then
        killRow[rows]["deathReason"] = 255
    end

    if killRow[rows]["killerName"] == killRow[rows]["victimName"] then
        killRow[rows]["killerName"] = ""
    end

    local y = icon_topY

    for r = 1, rows do
        if killRow[r] then
            killRow[r]["killerNamePos"]["topY"] = y + label_topMargin
            killRow[r]["killerNamePos"]["bottomY"] = y + label_height

            killRow[r]["reasonIconPos"]["topY"] = y

            killRow[r]["victimNamePos"]["topY"] = killRow[r]["killerNamePos"]["topY"]
            killRow[r]["victimNamePos"]["bottomY"] = killRow[r]["killerNamePos"]["bottomY"]
        end

        y = y + rows_margin
    end
end)

setTimer(function()
	if (getElementData(localPlayer, "loggedin") == 1) and (getElementData(localPlayer, "hud_settings").killmessage == 2) and (not exports.cr_items:isInventoryShow()) and (not exports.cr_hud:isOverlayShow()) then
        for r = 1, rows do
            if killRow[r] then
                exports.cr_ui:dxDrawFramedText(killRow[r]["killerName"], killRow[r]["killerNamePos"]["leftX"], killRow[r]["killerNamePos"]["topY"], killRow[r]["killerNamePos"]["rightX"], killRow[r]["killerNamePos"]["bottomY"], killRow[r]["killerNameColor"], 1, label_font, "right")
                dxDrawImage(killRow[r]["reasonIconPos"]["leftX"], killRow[r]["reasonIconPos"]["topY"] - 2, icon_width, icon_height, imagePath[killRow[r]["deathReason"]])
                exports.cr_ui:dxDrawFramedText(killRow[r]["victimName"], killRow[r]["victimNamePos"]["leftX"], killRow[r]["victimNamePos"]["topY"], killRow[r]["victimNamePos"]["rightX"], killRow[r]["victimNamePos"]["bottomY"], killRow[r]["victimNameColor"], 1, label_font) 
            end
        end
	end
end, 0, 0)

function unfuck(text)
	return string.gsub(text, "_", " ")
end