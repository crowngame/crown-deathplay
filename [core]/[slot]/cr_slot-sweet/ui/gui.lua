sx, sy = guiGetScreenSize()
psx, psy = (sx / 1920), (sy / 1080)
ui = {icons = {}, screen = {}, fonts = {}}
loading = false

function loadTextures()
    ui.icons = {
        ["apple"] = dxCreateTexture("assets/candys/apple.png"),
        ["banana"] = dxCreateTexture("assets/candys/banana.png"),
        ["blue"] = dxCreateTexture("assets/candys/blue.png"),
        ["candy"] = dxCreateTexture("assets/candys/candy.png"),
        ["grape"] = dxCreateTexture("assets/candys/grape.png"),
        ["green"] = dxCreateTexture("assets/candys/green.png"),
        ["heart"] = dxCreateTexture("assets/candys/heart.png"),
        ["plum"] = dxCreateTexture("assets/candys/plum.png"),
        ["purple"] = dxCreateTexture("assets/candys/purple.png"),
        ["watermelon"] = dxCreateTexture("assets/candys/watermelon.png"),
        ["explode"] = dxCreateTexture("assets/multipliers/explode.png"),
        ["high"] = dxCreateTexture("assets/multipliers/high.png"),
        ["medium"] = dxCreateTexture("assets/multipliers/medium.png"),
        ["low"] = dxCreateTexture("assets/multipliers/low.png"),
    }
    ui.screen = {
        ["background"] = dxCreateTexture("assets/screen/background.png"),
        ["slot"] = dxCreateTexture("assets/screen/slot-bg.png"),
        ["slotborder"] = dxCreateTexture("assets/screen/slot-border.png"),
        ["title"] = dxCreateTexture("assets/screen/title.png"),
        ["volume"] = dxCreateTexture("assets/screen/volume.png"),
        ["settings"] = dxCreateTexture("assets/screen/settings.png"),
        ["info"] = dxCreateTexture("assets/screen/info.png"),
        ["farmbutton"] = dxCreateTexture("assets/screen/farmbutton.png"),
        ["farmbuttonarrow"] = dxCreateTexture("assets/screen/farmbuttonarrow.png"),
        ["addbet"] = dxCreateTexture("assets/screen/addbet.png"),
        ["removebet"] = dxCreateTexture("assets/screen/removebet.png"),
        ["freespinbuy"] = dxCreateTexture("assets/screen/freespinbutton.png"),
        ["freespinbuyhover"] = dxCreateTexture("assets/screen/freespinbuttonhover.png"),
        ["bordercake"] = dxCreateTexture("assets/screen/bordercake.png"),
        ["winscreen"] = dxCreateTexture("assets/screen/winscreen.png"),
        ["wintype"] = dxCreateTexture("assets/screen/wintype.png"),
        ["spinwin"] = dxCreateTexture("assets/screen/spinwin.png"),
    }
    ui.explode = {
        [1] = dxCreateTexture("assets/explode/1.png"),
        [2] = dxCreateTexture("assets/explode/2.png"),
        [3] = dxCreateTexture("assets/explode/3.png"),
        [4] = dxCreateTexture("assets/explode/4.png"),
        [5] = dxCreateTexture("assets/explode/5.png"),
        [6] = dxCreateTexture("assets/explode/6.png"),
        [7] = dxCreateTexture("assets/explode/7.png"),
        [8] = dxCreateTexture("assets/explode/8.png"),
        [9] = dxCreateTexture("assets/explode/9.png"),
    }
end

function loadFonts()
    ui.fonts = {
        ["bottom_1"] = dxCreateFont("assets/fonts/font_bottom.ttf", 18 * psy),
        ["bottom_2"] = dxCreateFont("assets/fonts/font_bottom.ttf", 35 * psy),
        ["top_1"] = dxCreateFont("assets/fonts/font_top.ttf", 11 * psy),
        ["top_2"] = dxCreateFont("assets/fonts/font_top.ttf", 16 * psy),
        ["top_2.5"] = dxCreateFont("assets/fonts/font_top.ttf", 18 * psy),
        ["top_2.75"] = dxCreateFont("assets/fonts/font_top.ttf", 22 * psy),
        ["top_2.95"] = dxCreateFont("assets/fonts/font_top.ttf", 30 * psy),
        ["top_3"] = dxCreateFont("assets/fonts/font_top.ttf", 40 * psy),
    }
end
loadFonts()
loadTextures()
local csx, csy = 1480 * psx, 840 * psy
local cx, cy = (sx - csx) / 2, (sy - csy) / 2

function drawWinScreen(amount, type, clicktype, start)
    local x, y, w, h = (sx - (875 * psx)) / 2, (sy - (687.5 * psy)) / 2, (996 * psx), (650 * psy)
    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - start) / 125, "Linear")
    dxDrawImage(x, y, w, h, ui.screen["winscreen"], 0, 0, 0, tocolor(255, 255, 255, alpha), true)
    dxDrawOutlineText("TEBRİKLER!", x, y * 1.5, x + w, nil, tocolor(255, 215, 36, alpha), 1, ui.fonts["top_3"], "center", "center", true, false, tocolor(0, 0, 0, alpha))
    dxDrawOutlineText("KAZANDINIZ", x, y * 2, x + w, nil, tocolor(0, 207, 190, alpha), 1, ui.fonts["top_3"], "center", "center", true, false, tocolor(0, 0, 0, alpha))
    if true then
        local _w, _h = 800 * psx, 175 * psy
        local x, y = ((x + (x + w)) - _w) / 2, ((y + (y + h)) - _h) / 2
        local y = y * 1.025
        dxDrawImage(x, y, _w, _h, ui.screen["wintype"], 0, 0, 0, tocolor(255, 255, 255, alpha), true)
        dxDrawOutlineText(amount, x, y, x + _w, y + _h, tocolor(255, 215, 36, alpha), 1, ui.fonts["top_3"], "center", "center", true, false, tocolor(0, 0, 0, alpha))
    end
    --10 #00cfbeFREESPINLER
    dxDrawOutlineText(type, x, y * 3.35, x + w, nil, tocolor(255, 255, 255, alpha), 1, ui.fonts["top_3"], "center", "center", true, true)
    dxDrawBorderedText(1, tocolor(0, 0, 0, alpha), 'DEVAM ETMEK İÇİN HERHANGİ BİR YERE BASIN', x, y * 3.8, x + w, y * 3.8, tocolor(255, 255, 255, alpha), 1, ui.fonts["top_2.5"], 'center', 'center', false, false, true)
    if exports.cr_ui:inArea(x, y, w, h) then
        checkClicker("winscreen", clicktype, amount)
    end
end

function drawFreeSpinScreen(start)
    local w, h = 400 * psx, 225 * psy
    local w, h, size = interpolateBetween(w * 0.75, h * 0.75, 0.75, w, h, 1, (getTickCount() - start) / 1500, "Linear")
    local x, y = (sx - w * 0.75) / 2, (sy - h * 1.2) / 2
    local alpha = 255
    if getTickCount() >= start + 1250 then
        alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount() - (start + 1250)) / 250, "Linear")
        if getTickCount() >= start + 2000 then
            freespininfo = nil
            spincount = spincount + 5
            totalspincount = totalspincount + 5
        end
    end
    dxDrawImage(x, y, w, h, ui.screen["winscreen"], 0, 0, 0, tocolor(255, 255, 255, alpha), true)
    dxDrawBorderedText(0.9, tocolor(0, 0, 0, alpha), '+5\nFREESPINLER', x, y, x + w, y + h, tocolor(254, 254, 67, alpha), size, ui.fonts["top_2.75"], 'center', 'center', false, false, true)
end

function isOnlyCandy()
    local st = true
    for icon, state in pairs(slot.game[gameindex][spinindex].remove) do
        if icon ~= "candy" then
            st = false
            break
        end
    end
    return st
end

function drawSpinWinScreen(old, new, multiplier, start)
    local x, y, w, h = sx * 0.3925, sy * 0.125, (750 * psx) * 0.7, (120 * psy) * 0.7
    local new = math.floor(interpolateBetween(old, 0, 0, new, 0, 0, (getTickCount() - start) / 1000, "Linear"))
    local alpha = 255
    if getTickCount() >= start + 2250 then
        alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount() - (start + 2250)) / 250, "Linear")
    end
    dxDrawImage(x, y, w, h, ui.screen["spinwin"], 0, 0, 0, tocolor(255, 255, 255, alpha))
    local y = y + (10 * psy)
    dxDrawBorderedText(0.85, tocolor(217, 14, 27, alpha), (exports.cr_global:formatMoney(math.floor(new)).. (multiplier and " x " .. multiplier .. " " or " ")  .. "CR"), x, y, x + w, y + h, tocolor(254, 240, 1, alpha), 0.85, ui.fonts["top_2.75"], "center", "center", false, false, true)
end

function updateTotalWin(lasttotal, add, start)
    if add then
        totalwin = math.floor(interpolateBetween(lasttotal, 0, 0, lasttotal + add, 0, 0, (getTickCount() - start) / 750, "OutQuad"))
        if getTickCount() >= start + 750 then
            updatetotalwinscreen = nil
        end
    else
        updatetotalwinscreen = nil
    end
end

function drawClose(x, y, w, h)
    local mouse = exports.cr_ui:inArea(x, y, w, h)
    if mouse then
        dxDrawRectangle(x, y, w, h, tocolor(245, 75, 75))
        checkClicker("close")
    end
    dxDrawImage((x + (x + w) - (10 * psx)) / 2, (y + (y + h) - (10 * psy)) / 2, 10 * psx, 10 * psy, "assets/x.png", 0, 0, 0, tocolor(255, 255, 255))
end


function drawBackground()
    --general
    dxDrawRectangle(cx - (5 * psx), cy - (20 * psy), csx + (10 * psx), csy + (25 * psy), tocolor(31, 31, 31))
    drawClose((cx + csx) - (35 * psx), cy - (20 * psy), 40 * psx, 20 * psy)
    if true then
        local cx, cy = cx - (50 * psx), cy - (10 * psy)
        dxDrawImage(cx + (375 * psx), cy + (95 * psy), (950 * psx), (630 * psy), ui.screen["slot"])
        drawSlot(cx + (375 * psx), cy + (95 * psy), (953 * psx), (630 * psy))
    end
    dxDrawImage(cx, cy, csx, csy, ui.screen["background"])
    dxDrawImage(cx + (322 * psx), cy + (30 * psy), 951 * psx, 693 * psy, ui.screen["slotborder"])
    dxDrawImage(cx + (320 * psx), cy + (30 * psy), 953 * psx, 693 * psy, ui.screen["bordercake"])
    if updatetotalwinscreen then
        local totalwin, add, start = unpack(updatetotalwinscreen)
        updateTotalWin(totalwin, add, start)
    end
    if not spinwinscreen or (spinwinscreen and getTickCount() >= (spinwinscreen[4] + 2500)) then
        if multipliers[gameindex] and (spinindex == (#slot.game[gameindex]) and spinindex ~= 1) and not slot.game[gameindex + 1] and not juststay then if not tonumber(multipliers[gameindex]) then multipliers[gameindex] = getTickCount() onMultipliersExploded() end time = 2000 end
        local alpha = 255
        if spinwinscreen then
            alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - (spinwinscreen[4] + 2500)) / 250, "Linear")
            if alpha == 255 then
                spinwinscreen = false
                if not updatetotalwinscreen then updatetotalwinscreen = {totalwin, spinwin, getTickCount()} end
                spinwin = false
                if multipliers[gameindex] or (slot.game[gameindex][spinindex].remove and slot.game[gameindex][spinindex].remove.candy) then
                    if slot.game[gameindex + 1] then
                        skipscreen = getTickCount()
                    end
                    setTimer(function()
                        skipscreen = false
                        if slot.game[gameindex + 1] then
                            if freespinadded then freespinadded = false end
                            startgame = getTickCount()
                            gameindex = gameindex + 1
                            explodestreak = 0
                            spinindex = 1
                            explodeanim = {}
                            exploded = false
                            nextspin = false
                            candysound = false
                        else
                            if gameindex ~= 1 then
                                removeAllSounds()
                                setSoundVolume(giveSound("background-music.oga", true), 0.2)
                                showWinScreen(exports.cr_global:formatMoney((totalwin or 0)) .. " CR", totalspincount .. " #00cfbeFREESPINLER", "gamefinished")
                            else
                                onFarmFinish()
                            end
                        end
                    end, 1050, 1)
                end
            end
        end
        dxDrawImage(cx + (320 * psx), cy + (20 * psy), 953 * psx, 693 * psy, ui.screen["title"], 0, 0, 0, tocolor(255, 255, 255, alpha))
    else
        local old, new, multiplier, start = unpack(spinwinscreen)
        drawSpinWinScreen(old, new, multiplier, start)
    end
    --left freespin
    if juststay and not skipscreen and not winscreen then
        local x, y = cx + (210 * psx), cy + (250 * psy)
        local w, h, ts = 190 * psx, 125 * psy, 1
        local checkMouse = exports.cr_ui:inArea((x - (w / 2)) + (15 * psx), (y - (h / 2)) + (15 * psy), w - (30 * psx), h - (30 * psy))
        if checkMouse then checkClicker("buyfreespin") if getKeyState("mouse1") then w, h, ts = w * 0.975, h * 0.975, ts * 0.975 end end
        local x, y = x - (w / 2), y - (h / 2)
        dxDrawImage(x, y, w, h, checkMouse and ui.screen["freespinbuyhover"] or ui.screen["freespinbuy"])
        dxDrawBorderedText(1.25, tocolor(240, 52, 155), 'SATIN ALMA', x, y + (25 * psy), x + w, y + h, tocolor(255, 255, 255), ts, ui.fonts["top_1"], 'center', 'top')
        dxDrawBorderedText(1.25, tocolor(240, 52, 155), 'ÖZELLİĞİ', x, y + (45 * psy), x + w, y + h, tocolor(255, 255, 255), ts, ui.fonts["top_1"], 'center', 'top')
        dxDrawBorderedText(1, tocolor(240, 52, 155), exports.cr_global:formatMoney(slot.bets[slot.betindex] * (100)) .. " CR", x, y + (65 * psy), x + w, y + h, tocolor(255, 255, 255), ts, ui.fonts["top_2"], 'center', 'top')
    end
    --bottom menu
    local cy, csy = (cy + csy) - (110 * psy), 110 * psy
    dxDrawRectangle(cx, cy, csx, csy, tocolor(0, 0, 0, 150))
    dxDrawImage(cx + (145 * psx), cy + (25 * psy), 30 * psx, 30 * psy, ui.screen["settings"], 0, 0, 0, interactionColor(cx + (145 * psx), cy + (25 * psy), 30 * psx, 30 * psy, tocolor(225, 225, 225, 200), tocolor(245, 245, 245, 225), "settings"))
    dxDrawImage(cx + (145 * psx), cy + (65 * psy), 30 * psx, 30 * psy, ui.screen["volume"], 0, 0, 0, interactionColor(cx + (145 * psx), cy + (65 * psy), 30 * psx, 30 * psy, (not slot.volume and tocolor(225, 0, 0, 200) or tocolor(225, 225, 225, 200)), not slot.volume and tocolor(245, 0, 0, 225) or tocolor(245, 245, 245, 225), "volume"))
    dxDrawImage(cx + (190 * psx), cy + (30 * psy), 50 * psx, 50 * psy, ui.screen["info"], 0, 0, 0, interactionColor(cx + (190 * psy), cy + (30 * psy), 50 * psx, 50 * psy, tocolor(225, 225, 225, 200), tocolor(245, 245, 245, 225), "info"))
    dxDrawOutlineText("KREDİ", cx + (280 * psx), cy + (25 * psy), nil, nil, tocolor(246, 175, 49), 1, ui.fonts["bottom_1"], "left", "top")
    dxDrawOutlineText(exports.cr_global:formatMoney(exports["slot_core"]:getSlotMoney()) .. ".00 CR", cx + (360 * psx), cy + (25 * psy), nil, nil, tocolor(255, 255, 255), 1, ui.fonts["bottom_1"], "left", "top")
    dxDrawOutlineText("BAHİS", cx + (280 * psx), cy + (55 * psy), nil, nil, tocolor(246, 175, 49), 1, ui.fonts["bottom_1"], "left", "top")
    dxDrawOutlineText(exports.cr_global:formatMoney(slot.bets[slot.betindex]) .. ".00 CR", cx + (360 * psx), cy + (55 * psy), nil, nil, tocolor(255, 255, 255), 1, ui.fonts["bottom_1"], "left", "top")

    if not juststay then
        if tonumber(spincount) then
            dxDrawOutlineText("KALAN ÜCRETSİZ SPİN SAYISI " .. ((spincount + 1) - gameindex), cx + (615 * psx), cy + (60 * psy), nil, nil, tocolor(255, 255, 255), 1, ui.fonts["bottom_1"], "left", "top")
        end
        dxDrawOutlineText("KAZANÇ #ffffff" .. exports.cr_global:formatMoney((totalwin or 0)) .. " CR", cx + (775 * psx), cy - (5 * psy), nil, nil, tocolor(246, 175, 49), 1, ui.fonts["bottom_2"], "center", "top", false, true)
    else
        dxDrawOutlineText("BAHISINI AYARLA VE OYNA!", cx + (635 * psx), cy + (25 * psy), nil, nil, tocolor(255, 255, 255), 1, ui.fonts["bottom_1"], "left", "top")
    end
    --farmbutton
    if true then
        local w, h = 175 * psx, 175 * psy
        local x, y = ((cx + csx) - (300 * psx)) - (w / 2), (cy + (30 * psy)) - (h / 2)
        dxDrawImage(x, y, w, h, ui.screen["farmbutton"], 0, 0, 0, tocolor(255, 255, 255))
        dxDrawImage(x, y, w, h, ui.screen["farmbuttonarrow"], 0, 0, 0, interactionColor(x + (30 * psx), y + (30 * psy), w - (60 * psx), h - (60 * psy), tocolor(225, 225, 225, 225), tocolor(255, 255, 255, 255), "farmbutton"))
    end
    if true then
        local w, h = 70 * psx, 70 * psy
        local x, y = ((cx + csx) - (400 * psx)) - (w / 2), (cy + (55 * psy)) - (h / 2)
        dxDrawImage(x, y, w, h, ui.screen["removebet"], 0, 0, 0, interactionColor(x + (15 * psx), y + (15 * psy), w - (30 * psx), h - (30 * psy), tocolor(225, 225, 225, 225), tocolor(255, 255, 255, 255), "removebet"))
        local x = x + (204 * psx)
        dxDrawImage(x, y, w, h, ui.screen["addbet"], 0, 0, 0, interactionColor(x + (15 * psx), y + (15 * psy), w - (30 * psy), h - (30 * psy), tocolor(225, 225, 225, 225), tocolor(255, 255, 255, 255), "addbet"))
    end
    if winscreen then
        local amount, type, clicktype, start = unpack(winscreen)
        drawWinScreen(amount, type, clicktype, start)
    end
    if freespininfo then
        drawFreeSpinScreen(freespininfo)
    end
end

nextspin = false
candysound = false
--skipscreen = true
function drawSlot(x, y, w, h)
	if loading then
		dxDrawRectangle(cx, cy, csx, csy, tocolor(18, 18, 20, 150), true)
		exports.cr_ui:drawSpinner({
			position = {
				x = (sx - 128) / 2,
				y = (sy - 128) / 2
			},
			size = 128,
			speed = 2,
			variant = 'solid',
			color = 'white',
			postGUI = true
		})
	end
	
    local tick = getTickCount()
    if not slot.game[gameindex][spinindex] then return end
    local first, remove, anim, add, earn = slot.game[gameindex][spinindex].first, slot.game[gameindex][spinindex].remove, slot.game[gameindex][spinindex].anim, slot.game[gameindex][spinindex].add, slot.game[gameindex][spinindex].earn
    local explode, addnews, nextgame
    if spinindex ~= 1 then
        explode, addnews, nextgame = startgame + 250, startgame + 750, startgame + 1750
    else
        explode, addnews, nextgame = startgame + 1500, startgame + 2000, startgame + 3000
    end
    if juststay then remove = false anim = false add = false end
    for c, v in pairs(first) do
        local x = x + ((155 * psx) * c) - (65 * psx)
        local _x, _y = x, y
        local y = y
        dxDrawLine(x + (77.5 * psx), y, x + (77.5 * psx), y + h, tocolor(255, 255, 255, c ~= 6 and 50 or 0), 5)
        if spinindex == 1 then
            y = interpolateBetween((-1000 * psy), 0, 0, y, 0, 0, (tick - startgame) / (150 + (150 * c)), "OutQuad")
        end
        if skipscreen then
            y = interpolateBetween(y, 0, 0, (y + h) + (1000 * psy), 0, 0, (tick - skipscreen) / (150 + (150 * c)), "InQuad")
        else
            if not remove and tick >= addnews and not juststay and slot.game[gameindex + 1] then
                if spinindex ~= 1 and multipliers[gameindex] then
                    if not tonumber(multipliers[gameindex]) then multipliers[gameindex] = getTickCount() onMultipliersExploded() end
                else
                    y = interpolateBetween(y, 0, 0, (y + h) + (1000 * psy), 0, 0, (tick - addnews) / (150 + (150 * c)), "InQuad")
                end
            end
        end
        if add and add[c] and tick >= addnews and not juststay then
            local y = interpolateBetween((-1000 * psy), 0, 0, y, 0, 0, (tick - addnews) / (150 + (150 * c)), "OutQuad")
            for i, v in pairs(add[c]) do
                local v = type(v) ~= "table" and {v} or v
                local candy, multiplier = unpack(v)
                local diff = (i - -1) * (125 * psy)
                local y = y + ((125 * psy) * i) - (55 * psy)
                drawCandy(x, y, candy, candyremove, explode, (candyremove and tick >= explode + 300), multiplier)
            end
        end
        for i, v in pairs(v) do
            local y = y
            local v = type(v) ~= "table" and {v} or v
            local candy, multiplier = unpack(v)
            if candy == "candy" and not candysound then candysound = true giveSound("candy-hit.oga") end
            local candyremove = (remove and remove[candy])
            if anim and anim[c] and tick >= addnews and not juststay then
                local new = anim[c][i]
                if new then
                    local diff = (new - i) * (125 * psy)
                    y = interpolateBetween(y + ((125 * psy) * i) - (55 * psy), 0, 0, y + ((125 * psy) * new) - (55 * psy), 0, 0, (tick - addnews) / diff, "OutQuad")
                else
                    y = y + ((125 * psy) * i) - (55 * psy)
                end
            else
                y = y + ((125 * psy) * i) - (55 * psy)
            end
            drawCandy(x, y, candy, candyremove, explode, (candyremove and tick >= explode + 300), multiplier)
            if multiplier and not multipliers[gameindex] then multipliers[gameindex] = true end
            if candyremove and not juststay then
                if tick >= explode + 300 and tick <= addnews then
                    drawExplodeAnim(x, y, c, i, candy, earn)
                end
            end
        end
    end
    if not nextspin and not remove and tick >= nextgame and not juststay then
        if not (spinindex ~= 1 and multipliers[gameindex]) then
            nextspin = true
            if slot.game[gameindex + 1] then
                if freespinadded then freespinadded = false end
                startgame = getTickCount()
                gameindex = gameindex + 1
                explodestreak = 0
                spinindex = 1
                explodeanim = {}
                exploded = false
                nextspin = false
                candysound = false
            else
                if gameindex ~= 1 then
                    removeAllSounds()
                    setSoundVolume(giveSound("background-music.oga", true), 0.2)
                    showWinScreen(exports.cr_global:formatMoney(totalwin) .. " CR", totalspincount .. " #00cfbeFREESPINLER", "gamefinished")
                else
                    onFarmFinish()
                end
            end
        end
    end
end

function drawCandy(_x, _y, candy, remove, start, candyexploded, multiplier)
    local tick = getTickCount()
    local w, h = unpack(candys.sizes[candy])
    local w, h = w * psx, h * psy
    if remove and tick >= start then
        if candy ~= "candy" then
            w, h = interpolateBetween(w, h, 0, w * 1.25, h * 1.25, 0, (tick - start) / 250, "OutQuad")
        else
            if not freespinadded or freespinadded == spinindex then
                if tick < start + 250 then
                    w, h = interpolateBetween(w, h, 0, w * 1.25, h * 1.25, 0, (tick - start) / 250, "OutQuad")
                else
                    w, h = interpolateBetween(w * 1.25, h * 1.25, 0, w, h, 0, (tick - (start + 250)) / 250, "InQuad")
                end
            end
        end
    end
    local x, y = _x - (w / 2), _y - (h / 2)
    local uw, uh = dxGetMaterialSize(ui.icons[candy])
    local uy = 0
    local hitting
    if y >= cy + (660 * psy) then
        hitting = true
    elseif y <= cy - (20 * psy) then
        hitting = true
    end
    local alpha = (hitting or candyexploded) and 0 or 255
    if hitting then return end
    if not multiplier then
        dxDrawImageSection(x, y, w, h, 0, 0, uw, uh, ui.icons[candy], 0, 0, 0, tocolor(255, 255, 255, (candy == "candy" and not hitting) and 255 or alpha))
    else
        local start = tonumber(multipliers[gameindex])
        if start then
            w, h = interpolateBetween(w, h, 0, w * 1.25, h * 1.25, 0, (tick - start) / 350, "OutQuad")
            if tick >= start + 350 then
                alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (tick - (start + 350)) / 150, "OutQuad")
            end
        else
            start = tick
        end
        local x, y = _x - (w / 2), _y - (h / 2)
        dxDrawImageSection(x, y, w, h, 0, 0, uw, uh, tick >= (start + 500) and ui.icons["explode"] or ui.icons[candy], 0, 0, 0, tocolor(255, 255, 255, tick >= (start + 500) and 255 or alpha))
        local x, y = x + (5 * psx), y + (10 * psy)
        local textsize, textalpha = 1, 255
        if tick > (start + 350) then
            x, y, textsize = interpolateBetween(x, y, 1, sx * 0.49, sy * 0.1, 0.5, (tick - (start + 350)) / 500, "OutQuad")
            if tick >= (start + 750) then
                textalpha = interpolateBetween(255, 0, 0, 0, 0, 0, (tick - (start + 750)) / 150, "Linear")
            end
        end 
        dxDrawBorderedText(textsize * 2, tocolor(217, 14, 27, textalpha), multiplier .. "X", x, y, x + w, y + h, tocolor(254, 240, 1, textalpha), textsize, ui.fonts["top_2.95"], "center", "center", false, false, true)
    end
end

explodeanim = {}
exploded = false
freespinadded = false
function drawExplodeAnim(x, y, c, i, candy, earn)
    if not exploded and candy ~= "candy" then exploded = getTickCount() + 250 onScreenExplode( candy, earn) end
    if not explodeanim[c] then explodeanim[c] = {} end
    if not explodeanim[c][i] then explodeanim[c][i] = 0 end
    if not freespinadded and candy == "candy" then 
        if gameindex == 1 then
            if #slot.game > 1 and not freespinfromfarm then
                setTimer(showWinScreen, 500, 1, 10, "#00cfbeFREESPINLER", "setfreespin")
            else
                givefreespinfromfarm = true
            end
        else
            if not farm then
                giveSound("free-spin-start.oga")
            end
            showfreespininfo(getTickCount())
            if not freespinskipcontrol[gameindex] then
                setTimer(function()
                    if slot.game[gameindex + 1] then
                        skipscreen = getTickCount()
                    end
                end, 1000, 1)
                setTimer(function()
                    skipscreen = false
                    if slot.game[gameindex + 1] then
                        if freespinadded then freespinadded = false end
                        startgame = getTickCount()
                        gameindex = gameindex + 1
                        explodestreak = 0
                        spinindex = 1
                        explodeanim = {}
                        exploded = false
                        nextspin = false
                        candysound = false
                    else
                        if gameindex ~= 1 then
                            removeAllSounds()
                            setSoundVolume(giveSound("background-music.oga", true), 0.2)
                            showWinScreen(exports.cr_global:formatMoney((totalwin or 0)) .. " CR", totalspincount .. " #00cfbeFREESPINLER", "gamefinished")
                        else
                            onFarmFinish()
                        end
                    end
                end, 2050, 1)
            end
        end
        freespinadded = spinindex
    end
    local w, h = 300 * psx, 300 * psy
    local x, y = x - (w / 2), y - (h / 2)
    explodeanim[c][i] = explodeanim[c][i] + 5
    if ui.explode[math.floor(explodeanim[c][i] / 9)] and candy ~= "candy" then
        dxDrawImage(x, y, w, h, ui.explode[math.floor(explodeanim[c][i] / 9)])
    end
end

explodestreak = 0
function onScreenExplode(candy, earn)
    if earn > 0 then
        showSpinWinScreen(earn)
    end
    if candy ~= "candy" then
        freespinskipcontrol[gameindex] = true
        explodestreak = explodestreak + 1
        giveSound(math.min(explodestreak, 7) .. ".mp3")
        setTimer(function()
            if slot.game[gameindex][spinindex + 1] then
                startgame = getTickCount()
                spinindex = spinindex + 1
                explodeanim = {}
                exploded = false
                candysound = false
            else
                freespinadded = false
                nextspin = true
                if slot.game[gameindex + 1] then
                    startgame = getTickCount()
                    gameindex = gameindex + 1
                    explodestreak = 0
                    spinindex = 1
                    explodeanim = {}
                    exploded = false
                    nextspin = false
                    candysound = false
                else
                    if gameindex ~= 1 then
                        removeAllSounds()
                        setSoundVolume(giveSound("background-music.oga", true), 0.2)
                        showWinScreen(exports.cr_global:formatMoney(totalwin or 0) .. " CR", totalspincount .. " #00cfbeFREESPINLER", "gamefinished")
                    else
                        onFarmFinish()
                    end
                end
            end
        end, 1500, 1)
    end
end

function onMultipliersExploded()
    local multipliers = getTotalMultipliers(slot.game[gameindex][spinindex].first)
    if multipliers > 1 then
        showSpinWinScreen((spinwin * multipliers) - spinwin, multipliers)
        giveSound("multipliers-boom.oga")
    end
end

function getTotalMultipliers(senario)
    local multipliers
    for c, v in pairs(senario) do
        for i, v in pairs(v) do
            if type(v) == "table" then
                local _, multiplier = unpack(v)
                multipliers = (multipliers or 0) + multiplier
            end
        end
    end
    if not multipliers then multipliers = 1 end
    return multipliers
end

function onClickLib(elm, tick, ...)
	if loading then return end
    local args = {...}
    giveSound("click.oga")
    if elm == "buyfreespin" and not skipscreen and tick >= startgame + 2000 and not gamestarted then
        buySenario("freespin", slot.bets[slot.betindex] * 100)    
		loading = true
    elseif elm == "farmbutton" and not gamestarted then 
        buySenario("farm", slot.bets[slot.betindex])
		loading = true
    elseif elm:find("bet") and not gamestarted then
        local elm = elm:gsub("bet", "")
        if elm == "add" then
            slot.betindex = math.min(slot.betindex + 1, #slot.bets)
        else
            slot.betindex = math.max(slot.betindex - 1, 1)
        end
    elseif elm == "volume" then
        slot.volume = not (slot.volume)
        if slot.volume == false then
            removeAllSounds()
        else
            setSoundVolume(giveSound("background-music.oga", true), 0.2)
        end
    elseif elm == "winscreen" then
        local type, arg = unpack(args)
        if type == "setfreespin" then
            spincount = arg
            totalspincount = arg
            winscreen = false
            skipscreen = tick
            removeAllSounds()
            setSoundVolume(giveSound("free-spin-bg.oga", true), 0.2)
            setTimer(function()
                startgame = getTickCount()
                explodeanim = {}
                exploded = nil
                explodestreak = 0
                skipscreen = nil
                gameindex, spinindex = 2, 1
                juststay = nil
                freespinadded = false
                setTimer(function()
                    setTimer(function()
                        giveSound("sweet-hit.oga")
                    end, 100, 5)
                end, 150, 1)
            end, 1050, 1)
        elseif type == "gamefinished" then
            juststay = true
            nextspin = false
            winscreen = false
            gamestarted = false
        end
    elseif elm == "close" and not gamestarted then
        panelStatement()
    end
end

function showWinScreen(amount, type, clicktype)
    if type == "#00cfbeFREESPINLER" then
        giveSound("free-spin-start.oga")
    else
        giveSound("free-spin-end-bg.oga")
        triggerServerEvent("slot-gamefinished", root)
    end
    juststay = true
    winscreen = {amount, type, clicktype, getTickCount()}
end

function showSpinWinScreen(add, multiplier)
    local old = (spinwin or 0)
    spinwin = old + add
    spinwinscreen = {old, spinwin, multiplier, getTickCount()}
end

function showfreespininfo(start)
    freespininfo = start
end

function interactionColor(x, y, w, h, color1, color2, elm)
    if exports.cr_ui:inArea(x, y, w, h) then
        checkClicker(elm)
    end
    return exports.cr_ui:inArea(x, y, w, h) and color2 or color1
end

function dxDrawBorderedText(outline, outlinecolor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(removeHEXFromString(text), left + oX, top + oY, right + oX, bottom + oY, outlinecolor or tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

function dxDrawOutlineText(text, left, top, right, bottom, color, scale, font, alignX, alignY, postgui, colorcode, outlineColor)
    dxDrawText(removeHEXFromString(text), left + 1, top + 1, right, bottom, outlineColor or tocolor(0, 0, 0, textAlpha and textAlpha * 255 or 255), scale, font, alignX, alignY, false, false, postgui)
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, false, false, postgui, colorcode)
end

function removeHEXFromString(str)
    return string.gsub(str, '#%x%x%x%x%x%x', '')
end

clicked = false
function checkClicker(elm, ...)
    if getKeyState("mouse1") then
        if not clicked then clicked = true end
    else
        if clicked then
            onClickLib(elm, getTickCount(), ...)
            clicked = false
        end
    end
end

addEvent("slot.removeLoading", true)
addEventHandler("slot.removeLoading", root, function()
    loading = false
end)