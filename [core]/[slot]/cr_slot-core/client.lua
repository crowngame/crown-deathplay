local lp = getLocalPlayer()
local sx, sy = guiGetScreenSize()
local psx, psy = (sx / 1920), (sy / 1080)
local csx, csy = 400 * psx, 125 * psy
local cx, cy = (sx - csx) / 2, (sy - csy) / 2
local icsw, icsh = (339 * psx) * 0.45, (219 * psy) * 0.45
local font = exports.cr_fonts:getFont("UbuntuRegular", 9 * psy)

games = {
    {dxCreateTexture("dede.png"), "dede:panel", false, "dede"},
    {dxCreateTexture("sweet.png"), "sweet:panel", true, "sweet"},
}

function renderUI ( )
    if true then
        local cx, cy, csx, csy = cx - 10 * psx, cy - 25 * psy, csx + 20 * psx, csy + 35 * psy
        dxDrawRectangle(cx, cy, csx, csy, tocolor(12, 12, 12, 255))
        drawClose((cx + csx) - (40 * psx), cy, 40 * psx, 20 * psy)
        dxDrawText("BU OYUN GERÇEK PARAYLA OYNANMAMAKTADIR", cx, cy, cx + csx, cy + (20 * psy), tocolor(225, 225, 225, 255), 1, font, "center", "bottom")
    end
    dxDrawRoundedRectangle("bg2", cx, cy, csx, csy, 10 * psy, tocolor(7, 7, 16, 245))
    for i, v in ipairs(games) do
        local texture, event, state, texture2 = unpack(v)
        local icsw, icsh = icsw, icsh 
        local x, y = (cx + (16 * psx)) + ((i * (icsw + (20 * psx))) - icsw), ((cy + (cy + csy)) - icsh) / 2
        local checkMouse = exports.cr_ui:inArea(x, y, icsw, icsh)
        dxDrawImage(x, y, icsw, icsh, texture)
        dxDrawRoundedRectangle("icon_"..i, x, y, icsw, icsh, 7 * psy, tocolor(0, 0, 0, state and (checkMouse and 25 or 100) or 150))
        if checkMouse then checkClicker(event, state, texture2) end
    end
end

panelstate = false
function panelStatement ( bind, data )
    if not panelstate and isSlotAvailable() then
        if getElementData(lp, "slot:durum") then return end
        panelstate = not panelstate 
        addEventHandler("onClientRender", root, renderUI)
        showCursor(true)
        setElementData(lp, "slot:durum", 1)
    else
        if not bind then
            panelstate = not panelstate 
            removeEventHandler("onClientRender", root, renderUI)
            showCursor(false)
        end
    end
end
bindKey("E", "down", panelStatement)
function onClickLib ( elm, tick, ... )
    if elm == "close" then
        panelStatement(nil, "sda")
        setElementData(lp, "slot:durum", nil)
    else
        local state, texture = unpack({...})
        if state then
            setElementData(getElementData(current_slot, "kumar-obje"), "slotmachine:texture", texture)
            panelStatement()
            triggerEvent(elm, root)
        else
            outputChatBox("Bu sistem şu-anda aktif değildir.", 255, 0, 0)
        end
    end
end

addEventHandler("onClientElementDataChange", root, function(k, o, n)
    if source == lp and k == "slot:durum" and n == nil then
        if current_slot then
            setElementData(current_slot, "slot-player", nil)
            current_slot = nil
        end
    end
end)
setElementData(lp, "slot:durum", nil)

--
local rounded = {};
function dxDrawRoundedRectangle(id,x, y, w, h, radius, color, post)
    if not rounded[id] then
        rounded[id] = {}
    end
    if not rounded[id][w] then
        rounded[id][w] = {}
    end
    if not rounded[id][w][h] then
        local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
        rounded[id][w][h] = svgCreate(w, h, path)
    end
    if rounded[id][w][h] then
        dxDrawImage(x, y, w, h, rounded[id][w][h], 0, 0, 0, color, (post or false))
    end
end

function drawClose ( x, y, w, h )
    local mouse = exports.cr_ui:inArea(x, y, w, h)
    if mouse then
        dxDrawRectangle(x, y, w, h, tocolor(245, 75, 75))
        checkClicker("close")
    end
    dxDrawImage((x + (x + w) - (10 * psx)) / 2, (y + (y + h) - (10 * psy)) / 2, 10 * psx, 10 * psy, "x.png", 0, 0, 0, tocolor(255, 255, 255))
end

clicked = false
function checkClicker ( elm, ... )
    if getKeyState("mouse1") then
        if not clicked then clicked = true end
    else
        if clicked then
            onClickLib(elm, getTickCount(), ...)
            clicked = false
        end
    end
end

function isSlotAvailable()
    local slot = getClosestSlot()
    if slot then
        if (not getElementData(slot, "slot-player") or not isElement(getElementData(slot, "slot-player"))) then
            setElementData(slot, "slot-player", localPlayer)
            current_slot = slot
            return true
        end
        return false
    end
    return false
end

addEventHandler("onClientRender", root, function()
    if getElementData(localPlayer, "slot:durum") then return end
    local slot = getClosestSlot()
    if slot then
        local x, y, z = getElementPosition(slot)
        local x, y = getScreenFromWorldPosition(x, y, z)
        if x and y then
            local slotplaying = (getElementData(slot, "slot-player") and isElement(getElementData(slot, "slot-player")))
            dxDrawText(slotplaying and "Bu slot şuanda başkası tarafından kullanılıyor." or "Slot oynamak için [E] tuşuna basınız.", x, y, x, y, slotplaying and tocolor(232, 113, 114, 250) or tocolor(225, 225, 225, 250), 1, font, "center", "center")
        end
    end
end)

function getClosestSlot()
    local x, y, z = getElementPosition(localPlayer)
    local closest
    for _, elm in ipairs(getElementsByType("kumar-slot")) do
        local dist = getDistanceBetweenPoints3D(x, y, z, getElementPosition(elm))
        if not closest then
            closest = {dist, elm}
        else
            if dist < closest[1] then
                closest = {dist, elm}
            end
        end
    end
    if closest and closest[1] < 2 then
        return closest[2]
    end
    return false
end

function getSlotMoney()
    return getElementData(localPlayer, "money") or 0
end