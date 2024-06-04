local allowedUsers = {
    ["Farid"] = true,
    ["biax"] = true,
}

local screenX, screenY = guiGetScreenSize()
local hackState

local lvl1bones = { [54] = 53, [53] = 52, [52] = 51, [51] = 1, [44] = 43, [43] = 42, [42] = 41, [41] = 1, [1] = 2, [2] = 3, [3] = 4, [26] = 25, [25] = 24, [24] = 23, [23] = 22, [21] = 22, [36] = 35, [35] = 34, [34] = 33, [33] = 32, [31] = 32, [4] = 6, [6] = 7, [7] = 4, [32] = 41, [22] = 51 }
local lvl2bones = { [5] = 32, [22] = 5, [24] = 23, [23] = 22, [32] = 33, [33] = 34, [1] = 5, [51] = 1, [41] = 1, [52] = 51, [42] = 41, [6] = 5, [53] = 52, [43] = 42 }
local lvl3bones = { [24] = 23, [23] = 5, [34] = 33, [33] = 5, [1] = 5, [52] = 1, [42] = 1, [53] = 52, [43] = 42 }

local lockedPlayer

local function isPedAiming (thePedToCheck)
    if isElement(thePedToCheck) then
        if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
            if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
                return true
            end
        end
    end
    return false
end

local function drawPedBones(ped, fDistance, isLocked)
    local aList = {}
    if fDistance < 40 then
        aList = lvl1bones
    elseif fDistance < 90 and fDistance >= 40 then
        aList = lvl2bones
    else
        aList = lvl3bones
    end
    local playerTeam
    local red, green, blue = getPlayerNametagColor(ped)
    if isLocked then
        red, green, blue = 241, 196, 15
    end
    local pedColor = tocolor(red, green, blue, 255)
    for iFrom, iTo in pairs(aList) do
        local x1, y1, z1 = getPedBonePosition(ped, iFrom)
        local x2, y2, z2 = getPedBonePosition(ped, iTo)
        if not (x1 or x2) then
            return
        end
        local screenX1, screenY1 = getScreenFromWorldPosition(x1, y1, z1)
        local screenX2, screenY2 = getScreenFromWorldPosition(x2, y2, z2)
        if screenX1 and screenX2 then
            local scale = 25 / fDistance
            if scale <= 1 then
                scale = 1
            end
            dxDrawLine(screenX1, screenY1, screenX2, screenY2, pedColor, scale)

        end
    end
    local bx, by, bz = getPedBonePosition(ped, 6)
    local screenX1, screenY1 = getScreenFromWorldPosition(bx, by, bz - 0.6)
    if screenX1 and screenY1 then
        local scale = 25 / fDistance
        local width, height = 30 * scale, 30 * scale
        dxDrawImage(screenX1 - width / 2, screenY1, width, height, ":cr_widget/public/images/weapon/" .. getPedWeapon(ped) .. ".png")
    end
end

local function getRangePlayer(x, y, z)
    local nearestPlayer, lastDist = false, 9999
    local cameraX, cameraY, cameraZ = getCameraMatrix()

    local pedTarget = getPedTarget(localPlayer)
    if pedTarget then
        local type = getElementType(pedTarget)
        if type == "player" then
            return pedTarget
        elseif type == "vehicle" then
            return pedTarget:getController()
        end
    end

    local players = getElementsByType("player")
    table.sort(players, function(a, b)
        local distance1 = getDistanceBetweenPoints3D(a.position, x, y, z)
        local distance2 = getDistanceBetweenPoints3D(b.position, x, y, z)
        return distance1 < distance2
    end)

    for index, player in ipairs(players) do
        if player ~= localPlayer and (player:getData("dead") or 0) ~= 1 and localPlayer:getDimension() == player:getDimension() then
            local dist = getDistanceBetweenPoints3D(player.position, x, y, z)
            local dist2 = getDistanceBetweenPoints3D(player.position, localPlayer.position)
            if dist2 <= 100 then
                local isSight = isLineOfSightClear(cameraX, cameraY, cameraZ, player.position, true, false, false, true, false, false, false, localPlayer)

                if lastDist > dist then
                    lastDist = dist
                    nearestPlayer = player
                end
            end
        end
    end

    return nearestPlayer, players
end

local function aimOnPosition(ped)
    local dead = ped:getData("dead") or 0
    if tonumber(dead) ~= 0 then
        return
    end
    local setToX, setToY = 0, 0
    local hx, hy, hz = getPedBonePosition(ped, 6)
    local sx, sy = getScreenFromWorldPosition(hx, hy, hz)

    local vehicle = ped.vehicle
    if sx and sy then
        local aimX, aimY = screenX * 0.550, screenY * 0.3971
        local setToX = math.abs(screenX / 2 - (aimX))
        local setToY = math.abs(screenY / 2 - aimY)

        local a1, a2, a3 = getPedBonePosition(ped, 6)
        local a4, a5, a6 = getElementPosition(ped)
        local b1, b2, b3 = getElementPosition(localPlayer)
        local dist = getDistanceBetweenPoints3D(a1, a2, a3, b1, b2, b3)

        if dist >= 20 then
            setToX = math.abs(screenX / 2 - (screenX * 0.550))
        end

        local setToX, setToY = getWorldFromScreenPosition(sx - setToX, sy + setToY, dist)
        local _, _, setToX1 = getWorldFromScreenPosition(screenX / 2, screenY / 2, dist)
        local _, _, setToX2 = getWorldFromScreenPosition(aimX, aimY, dist)
        local setToX3 = (setToX2 - setToX1)

        local toAdded = vehicle and 0.7 or 0.6
        setCameraTarget(setToX, setToY, b3 - setToX3 + toAdded + (a6 - b3))
    end
end

addCommandHandler("hack", function()
    if not allowedUsers[localPlayer:getData("account:username")] then
        return
    end

    hackState = not hackState
    outputChatBox(tostring(hackState))
end)

setTimer(function()
    if hackState then
        if isPedAiming(localPlayer) then
            local sx, sy, sz = getPedTargetStart(localPlayer)
            local x, y, z = getPedTargetCollision(localPlayer)
            if getKeyState("z") then
                if x and y and z then
                    local player, rangePlayers = getRangePlayer(x, y, z, 10)
                    if player then
                        aimOnPosition(player)
                        lockedPlayer = player
                    end
                end
            else
                lockedPlayer = false
            end
            dxDrawLine3D(sx, sy, sz, x, y, z, tocolor(255, 0, 0), 3)
        else
            lockedPlayer = false
        end
        local cameraX, cameraY, cameraZ = getCameraMatrix()

        for index, player in ipairs(getElementsWithinRange(localPlayer.position, 75, "player")) do
            if player ~= localPlayer then
                local fDistance = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, player.position)
                drawPedBones(player, fDistance, lockedPlayer == player)
            end
        end
    end
end, 0, 0)