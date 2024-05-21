local drum = "images/drum.png"
local druminteral = "images/cards.png"

local settings = {}
settings.drumColor = exports.cr_ui:getServerColor(1)
settings.stake = 1000 -- starting stake
settings.stakeMax = 50000 -- maximum stake
settings.stakeMin = 1000 -- minimum stake
settings.stakeStep = 1000 -- step of a stake
settings.font = "fonts/sf-regular.ttf"
settings.language = "turkish"
settings.jackpotSound = "sounds/jackpot.ogg"
settings.positionsCol = {
	-- {x, y, z, size, dimension, interior}
	{1132.8974609375, -1.6181640625, 1000.6796875, 1, 16, 12},
	{1135.017578125, 0.6103515625, 1000.6796875, 1, 16, 12},
	{1135.0634765625, -3.869140625, 1000.6796875, 1, 16, 12},
}

settings.gamesPlayed = 0 -- anticheat - games played
settings.rolling = false
settings.cardsize = 256  -- Whenever you rescale cards, change this.

local cards = {
	-- 1 5 10 25
	-- {icon name, multiplier for 2x combo, multiplier for 3x combo}, with these settings avg ~=~ 1.1
	-- bars
	{"cards/goldbar.png", 20, 75},
	{"cards/redbar.png", 10, 10},
	{"cards/greenbar.png", 1, 5},
	-- luck related
	{"cards/bell.png", 5, 10},
	{"cards/heart.png", 5, 10},
	{"cards/horseshoe.png", 5, 10},
	{"cards/goldclover.png", 10, 25},
	{"cards/greenclover.png", 5, 10},
	-- sevens
	{"cards/goldenseven.png", 20, 75},
	{"cards/redseven.png", 5, 25},
	-- gems
	{"cards/ruby.png", 10, 25},
	{"cards/emerald.png", 10, 25},
	{"cards/diamond.png", 20, 75},
	-- vegetables and fruits
	{"cards/cherry.png", 1, 5},
	{"cards/grape.png", 1, 5},
	{"cards/lemon.png", 1, 5},
	{"cards/plum.png", 1, 5},
	{"cards/watermelon.png", 1, 5},
}

local setList = { --staring cards, don't delete them
	{{0.215, 0, "cards/bell.png"}, {0.215, 0.36, "cards/goldbar.png"}}, -- left set
	{{0.422, 0, "cards/bell.png"}, {0.422, 0.36, "cards/goldbar.png"}}, -- central set
	{{0.628, 0, "cards/bell.png"}, {0.628, 0.36, "cards/goldbar.png"}}, -- right set
}

local setSettings = { --settings, don't modify these unless you know what you are doing
	{speedBasic = 0.004, count = 75, xstart = 0.215},
	{speedBasic = 0.0045, count = 100, xstart = 0.422},
	{speedBasic = 0.005, count = 133, xstart = 0.628},
}

local gui = {}
local dumpedCards = {}
local localisation = {}

localisation["english"] = {
	winenthiusastic = "Impossible! Three cards at the same time. You won %d$!",
	win = "Double hit, what a luck! You won %d$",
	lose = "No luck this time, sadly :(",
	stakeMax = "You can't bet more than %d$!",
	stakeMin = "You can't play, unless you make a bet of at least %d$!",
	notEnoughCash = "You don't have enought money to make a higher bet!",
	notEnoughCashOnRoll = "You don't have enought money to start a roll!",
	stakeInfo = "Current\nstake\n%d$",
	roll = "Play",
	leave = "Leave",
	whenRolling = "You can't do that during a roll!",
}

localisation["turkish"] = {
    winenthiusastic = "İmkansız! Aynı anda üç kart. Kazandın %d$!",
    win = "Çift vuruş, ne şans! Kazandın %d$",
    lose = "Bu sefer şans yok, maalesef :(",
    stakeMax = "Daha fazla bahis yapamazsın, maksimum %d$!",
    stakeMin = "Bahis yapmadan oynayamazsın, en az %d$ bahis yapmalısın!",
    notEnoughCash = "Daha yüksek bir bahis yapmak için yeterli paran yok!",
    notEnoughCashOnRoll = "Bir oyun başlatmak için yeterli paran yok!",
    stakeInfo = "Mevcut\nbahis\n%d$",
    roll = "Oyna",
    leave = "Çık",
    whenRolling = "Bir oyun sırasında bunu yapamazsın!",
}

local function outputOnScreen(str, r, g, b)
	local labels = {{},{},{}}
	labels[1] = {str, r, g, b}
	labels[2] = {guiGetText(gui.labelList1), guiLabelGetColor(gui.labelList1)}
	labels[3] = {guiGetText(gui.labelList2), guiLabelGetColor(gui.labelList2)}
	for k, v in ipairs(labels) do
		guiLabelSetColor(gui["labelList" .. k], v[2], v[3], v[4])
		guiSetText(gui["labelList" .. k], v[1])
	end
end

local function copyTable() end -- recursive copyTable function
copyTable = function(t1)
	local newTable = {}
	for k, v in ipairs(t1) do
		if type(v) ~= "table" then
			newTable[k] = v
		else
			newTable[k] = copyTable(v)
		end
	end
	return newTable
end

local function getFontSizeFromResolution(w, h, base)
	local w = w/base
	local h = h/base
	local result = math.floor(math.sqrt(h*w))
	return result
end

local sw, sh = guiGetScreenSize()
local function drawImage(x, y, card) --pretty complicated function, generally draws only cards that one can see.
	local topy = y - 0.23
	local bottomy = 0.75 - y
	if topy < 0 then
		local hrr = (0.25+topy)/0.25
		dxDrawImageSection(x*sw, (y-topy)*sh, 0.15*sw, (0.25+topy)*sh, 0, (1-hrr)*settings.cardsize, settings.cardsize, hrr*settings.cardsize, card)
	elseif bottomy > 0 and bottomy < 0.25 then
		dxDrawImageSection(x*sw, y*sh, 0.15*sw, bottomy*sh, 0, 0, settings.cardsize, (bottomy/0.25)*settings.cardsize, card)
	else
		dxDrawImageSection(x*sw, y*sh, 0.15*sw, 0.25*sh, 0, 0, settings.cardsize, settings.cardsize, card)
	end
end

local function generateSets()
	for i = 1, #setList do
		for i2 = 1, setSettings[i].count do
			local newcard = {0, 0, "str"}
			newcard[1] = setSettings[i].xstart
			newcard[2] = 0.4*i2+0.25
			newcard[3] = cards[math.random(1, #cards)][1]
			table.insert(setList[i], newcard)
		end
		setSettings[i].speed = setSettings[i].speedBasic * 40
	end
	if math.sqrt(settings.gamesPlayed) > math.random(22, 50) and math.random(1,2)%2==0 then --anticheat, if he leaves game with autoclicker he will lose all of his cash, because if he plays too much he will get bad cards sets (at least ends of them :))
		setList[1][setSettings[1].count - 1][3] = cards[math.random(1,4)][1]
		setList[2][setSettings[2].count - 1][3] = cards[math.random(5,8)][1]
		setList[3][setSettings[3].count - 1][3] = cards[math.random(9,12)][1]
	end
	collectgarbage("collect")
end

local function calculateRewards()
	local multiplier = {name, multiplier = 0, columns = 0}
	multiplier.columns = multiplier.columns + ((setList[1][2][3] == setList[2][2][3] and setList[1][2][3] == setList[3][2][3] and 3)  or (setList[1][2][3] == setList[2][2][3] and 2) or (setList[2][2][3] == setList[3][2][3] and 2) or (setList[1][2][3] == setList[3][2][3] and 2) or 0)
	
	multiplier.name = (setList[1][2][3] == setList[2][2][3] and setList[1][2][3] == setList[3][2][3] and setList[1][2][3]) or (setList[1][2][3] == setList[2][2][3] and setList[1][2][3]) or (setList[2][2][3] == setList[3][2][3] and setList[2][2][3]) or (setList[1][2][3] == setList[3][2][3] and setList[3][2][3])
	if multiplier.columns ~= 0 then
		for k, v in ipairs(cards) do
			if v[1] == multiplier.name then
				multiplier.multiplier = v[multiplier.columns]
			end
		end
	end
	
	dumpedCards = {}  --dumps all cards
	collectgarbage("collect") --collects garbage at the end, so game doesn't get lagged
	
	if multiplier.columns == 3 then
		outputOnScreen(string.format(localisation[settings.language].winenthiusastic, settings.stake*multiplier.multiplier), 255, 255, 0)
		triggerServerEvent("slot:giveMoney", localPlayer, settings.stake*multiplier.multiplier)
		guiSetText(gui.labelMoney, exports.cr_global:formatMoney(getElementData(localPlayer, "money")) .. "$")
		playSound(settings.jackpotSound)
	elseif multiplier.columns == 2 then
		outputOnScreen(string.format(localisation[settings.language].win, settings.stake*multiplier.multiplier), 220, 220, 0)
		triggerServerEvent("slot:giveMoney", localPlayer, settings.stake*multiplier.multiplier)
		guiSetText(gui.labelMoney, exports.cr_global:formatMoney(getElementData(localPlayer, "money")) .. "$")
		playSound(settings.jackpotSound)
	else
		outputOnScreen(localisation[settings.language].lose, 250, 168, 0)
	end
	settings.gamesPlayed = settings.gamesPlayed + 1
end	


local delta = getTickCount()
local function main()
	delta = (getTickCount() - delta)  --calculates delta time diffrence between last 2 frames
	delta = delta < 34 and delta or 34  -- if he has less than 30 fps his game will run slower, but it will prevent any drum related drawing problems(at least those major ones)
	dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0 ,150)) --grey background
	dxDrawImage(0.15*sw, 0.2*sh, 0.7*sw, 0.6*sh, druminteral)  --draws drum internal part
	for key, set in ipairs (setList) do
		if #set == 2 and key == #setList then --stops when there are only 2 cards left in the right set and ends roll.
			if settings.rolling then
				calculateRewards()  --calculates prize
				settings.rolling = false --allows to roll again
			end
		end
		for index, card in ipairs(set) do
			if settings.rolling then -- if we roll
				if #set < 40 then
					setSettings[key].speed = setSettings[key].speedBasic * #set --used to slowdown drums near end of roll
				end
				if #set ~= 2 then  -- drum works till there are more than 2 cards in a set
					card[2] = card[2] - setSettings[key].speed * delta/17 --change position of card
				end
			end
			if card[2] < 0.75 and card[2] >= 0 then -- draw cards only when picture can is seeable
				drawImage(card[1], card[2], card[3]) --draws image
			elseif card[2] < -0.42 then --if the card is over the top of the screen
				table.insert(dumpedCards, table.remove(set, index)) -- remove useless cards from set and move it to dumpedCards
			end
		end
	end
	dxDrawImage(0.1*sw, 0.2*sh, 0.8*sw, 0.6*sh, drum, 0, 0, 0, settings.drumColor) --draws drum external part
	delta = getTickCount()
end

local prizesPanel = {}
prizesPanel.labels = {}
prizesPanel.images = {}

local function generatePrizesPanel()
	local offsetx = 0
	local offsety = 0
	local icons = copyTable(cards)
	
	-- 2x in columns
	table.sort(icons, function (a,b) return a[2] < b[2] end)
	
	for k, v in ipairs(icons) do
		if icons[k-1] and v[2] ~= icons[k-1][2] then
			local label = guiCreateLabel(0.145 + offsetx, 0.006 + offsety, 0.03, sw/sh*0.03, icons[k-1][2] .. "x", true)
			table.insert(prizesPanel.labels, label)
			offsety = offsety + 0.046
			offsetx = 0
		end
		local img = guiCreateStaticImage(0.15 + offsetx, 0.01 + offsety, 0.03, sw/sh*0.026, v[1], true)
		table.insert(prizesPanel.images, img)
		offsetx = offsetx + 0.04
		if k == #icons then
			local label = guiCreateLabel(0.145 + offsetx, 0.006 + offsety, 0.03, sw/sh*0.03, v[2] .. "x", true)
			table.insert(prizesPanel.labels, label)
		end
	end 
	
	for k, v in ipairs(prizesPanel.labels) do
		guiLabelSetColor(v, 255, 50, 50)
	end
	local count = #prizesPanel.labels
	
	
	table.sort(icons, function (a,b) return a[3] > b[3] end)
	offsetx = 0
	offsety = 0
	for k, v in ipairs(icons) do
		if icons[k-1] and v[3] ~= icons[k-1][3] then
			local label = guiCreateLabel(0.815 - offsetx, 0.006 + offsety, 0.04, sw/sh*0.03, icons[k-1][3] .. "x", true)
			table.insert(prizesPanel.labels, label)
			offsety = offsety + 0.046
			offsetx = 0
		end
		local img = guiCreateStaticImage(0.815 - offsetx, 0.01 + offsety, 0.03, sw/sh*0.026, v[1], true)
		table.insert(prizesPanel.images, img)
		offsetx = offsetx + 0.04
		if k == #icons then
			local label = guiCreateLabel(0.815 - offsetx, 0.006 + offsety, 0.04, sw/sh*0.03, v[3] .. "x", true)
			table.insert(prizesPanel.labels, label)
		end
	end 
	
	local font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 70))
	for k, v in ipairs(prizesPanel.labels) do
		guiSetFont(v, font)
		if count < k then 
			guiLabelSetColor(v, 255, 255, 50)
		end
	end
	
	local label1 = guiCreateLabel(0.32, 0.145, 0.12, 0.05, "İKİLİ!", true)
	local label2 = guiCreateLabel(0.56, 0.015, 0.12, 0.05, "ÜÇLÜ!", true)
	
	font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 50))
	
	guiSetFont(label1, font)
	guiSetFont(label2, font)
	
	guiLabelSetColor(label1, 255, 50, 50)
	guiLabelSetColor(label2, 255, 255, 50)
	
	table.insert(prizesPanel.labels, label1)
	table.insert(prizesPanel.labels, label2)
	
	for k, v in ipairs(prizesPanel.labels) do
		guiLabelSetHorizontalAlign(v, "center") 
		guiLabelSetVerticalAlign(v, "center")
	end

	for k, v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, false)
	end
	
	for k, v in ipairs(prizesPanel.images) do
		guiSetVisible(v, false)
	end
	
	collectgarbage("collect")
end
generatePrizesPanel()

local function onPlayerStartRoll()
	if settings.rolling then -- we can't allow a new roll when there is one currently ongoing.
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	
	if settings.stake > getElementData(localPlayer, "money") then
		outputOnScreen(localisation[settings.language].notEnoughCashOnRoll, 255, 50, 50)
		return
	end
	
	if exports.cr_network:getNetworkStatus() then
        outputChatBox("[!]#FFFFFF Internet bağlantınızı kontrol edin.", 255, 0, 0, true)
        return false
    end
	
	settings.rolling = true --starts a roll
	triggerServerEvent("slot:takeMoney", localPlayer, settings.stake)
	guiSetText(gui.labelMoney, exports.cr_global:formatMoney(getElementData(localPlayer, "money")) .. "$")
	
	setList = { --uses two rows of card from last roll
		{setList[1][2]}, -- left set
		{setList[2][2]}, -- central set
		{setList[3][2]}, -- right set
	}	
	
	generateSets() --generate sets
end

local function onPlayerLeave()
	if settings.rolling then -- we can't allow a new roll when there is one currently ongoing.
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	
	for k, v in pairs(gui) do
		guiSetVisible(v, false)
	end
	
	showCursor(false, false)
	removeEventHandler("onClientRender", root, main)
	setElementFrozen(localPlayer, false)
	showChat(true)
	
	for k, v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, false)
	end
	
	for k, v in ipairs(prizesPanel.images) do
		guiSetVisible(v, false)
	end
end

local function stakeUp()
	if settings.rolling then
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	
	local potencialStake = settings.stake + settings.stakeStep
	if potencialStake > getElementData(localPlayer, "money") then
		outputOnScreen(localisation[settings.language].notEnoughCash, 250, 50, 50)
		return
	elseif potencialStake > settings.stakeMax then
		outputOnScreen(string.format(localisation[settings.language].stakeMax, settings.stakeMax), 255, 168, 0)
		return
	end
	
	settings.stake = potencialStake
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
end

local function stakeDown()
	if settings.rolling then
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	
	local potencialStake = settings.stake - settings.stakeStep
	if potencialStake < settings.stakeMin then
		outputOnScreen(string.format(localisation[settings.language].stakeMin, settings.stakeMin), 255, 168, 0)
		return
	end
	
	settings.stake = potencialStake
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
end

local function createGUI()
	gui.buttonRoll = guiCreateButton(0.6, 0.792, 0.23, 0.1, localisation[settings.language].roll, true) --start roll
	gui.buttonLeave = guiCreateButton(0.37, 0.792, 0.23, 0.1, localisation[settings.language].leave, true) --leave
	gui.buttonStakeUp = guiCreateButton(0.32, 0.792, 0.05, 0.1, ">", true)
	gui.buttonStakeDown = guiCreateButton(0.17, 0.792, 0.05, 0.1, "<", true)

	gui.labelStake = guiCreateLabel(0.22, 0.792, 0.10, 0.1, string.format(localisation[settings.language].stakeInfo, settings.stake), true) --current stake
	guiLabelSetHorizontalAlign(gui.labelStake, "center") 
	guiLabelSetVerticalAlign(gui.labelStake, "center")
	gui.labelMoney = guiCreateLabel(0.79, 0.01, 0.2, 0.2, exports.cr_global:formatMoney(getElementData(localPlayer, "money")) .. "$", true)
	guiLabelSetHorizontalAlign(gui.labelMoney, "right") 
	guiLabelSetVerticalAlign(gui.labelMoney, "top")
	guiLabelSetColor(gui.labelMoney, 133, 187, 101)

	gui.labelList1 = guiCreateLabel(0, 0.9, 1, 0.03, "", true)
	gui.labelList2 = guiCreateLabel(0, 0.93, 1, 0.03, "", true)
	gui.labelList3 = guiCreateLabel(0, 0.96, 1, 0.03, "", true)
	
	for i = 1, 3 do
		guiLabelSetHorizontalAlign(gui["labelList" .. i], "center") 
		guiLabelSetVerticalAlign(gui["labelList" .. i], "center")
	end
	
	local font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 90))
	for k, v in pairs(gui) do
		guiSetFont(v, font)
	end
	
	guiSetFont(gui.labelMoney, guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 50)))
	
	addEventHandler("onClientGUIMouseUp", gui.buttonRoll, onPlayerStartRoll)
	addEventHandler("onClientGUIMouseUp", gui.buttonLeave, onPlayerLeave)
	addEventHandler("onClientGUIMouseUp", gui.buttonStakeUp, stakeUp)
	addEventHandler("onClientGUIMouseUp", gui.buttonStakeDown, stakeDown)
	
	for k, v in pairs(gui) do
		guiSetVisible(v, false)
	end
end

if getElementData(localPlayer, "loggedin") == 1 then
	createGUI()
end

local function setGUIlanguage(language)
	settings.language = language
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
	guiSetText(gui.buttonRoll, localisation[settings.language].roll)
	guiSetText(gui.buttonLeave, localisation[settings.language].leave)
end

local function showGUI(el, md)
	if not md or getElementType(el) ~= "player" or el ~= localPlayer then
		return
	end
	
	if not (#gui > 0) then
		createGUI()
	end
	
	for k, v in pairs(gui) do
		guiSetVisible(v, true)
	end
	
	showCursor(true, true)
	addEventHandler("onClientRender", root, main)
	setElementFrozen(localPlayer, true)
	showChat(false)
	guiSetText(gui.labelMoney, exports.cr_global:formatMoney(getElementData(localPlayer, "money")) .. "$")
	
	for k, v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, true)
	end
	
	for k, v in ipairs(prizesPanel.images) do
		guiSetVisible(v, true)
	end
end

local function setup()
	for k, v in ipairs(settings.positionsCol) do
		local col = createColSphere(v[1], v[2], v[3], v[4])
		local marker = createMarker(v[1], v[2], v[3] - 1, "cylinder", v[4], 255, 212, 59, 170)
		setElementDimension(col, v[5])
		setElementDimension(marker, v[5])
		setElementInterior(col, v[6])
		setElementInterior(marker, v[6])
		addEventHandler("onClientColShapeHit", col, showGUI)
	end
end

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prevSlot, curSlot)
    if (getElementInterior(localPlayer) == 12 and getElementDimension(localPlayer) == 16) or (getElementInterior(localPlayer) == 10 and getElementDimension(localPlayer) == 358) then
		setPedWeaponSlot(localPlayer, 0)
	end
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if (getElementInterior(localPlayer) == 12 and getElementDimension(localPlayer) == 16) or (getElementInterior(localPlayer) == 10 and getElementDimension(localPlayer) == 358) then
		setPedWeaponSlot(localPlayer, 0)
	end
end)

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart)
	if (getElementInterior(localPlayer) == 12 and getElementDimension(localPlayer) == 16) or (getElementInterior(localPlayer) == 10 and getElementDimension(localPlayer) == 358) then
		cancelEvent()
	end
end)

setup()