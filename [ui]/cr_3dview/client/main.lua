screenWidth, screenHeight = guiGetScreenSize()

screenRenderTarget = false

skinData = false
vehicleData = false
objectData = false

getLastTick = getTickCount()
lastCamVelocity = { 0, 0, 0 }
currentCamPos = { 0, 0, 0 }
lastCamPos = { 0, 0, 0 }

addEventHandler("onClientPreRender", root, function()
    if isElement(screenRenderTarget) then
        dxSetRenderTarget(screenRenderTarget, true)
        dxSetRenderTarget()
    end
end, true, "low-5")

function getCameraVelocity()
    if getTickCount() - getLastTick < 100 then
        return lastCamVelocity[1], lastCamVelocity[2], lastCamVelocity[3]
    end

    local currentCamPos = { getElementPosition(getCamera()) }
    lastCamVelocity = { currentCamPos[1] - lastCamPos[1], currentCamPos[2] - lastCamPos[2], currentCamPos[3] - lastCamPos[3] }
    lastCamPos = { currentCamPos[1], currentCamPos[2], currentCamPos[3] }

    return lastCamVelocity[1], lastCamVelocity[2], lastCamVelocity[3]
end

function removeProcesses()
    processObjectPreview()
    processVehiclePreview()
    processSkinPreview()
end

function isSkinValid(model)
    local foundSlot = false

    local validPedModels = getValidPedModels()
    for i = 1, #validPedModels do
        if validPedModels[i] == model then
            foundSlot = i
            break
        end
    end

    return foundSlot
end

function returnMaxValue(inTable)
    local itemCount = #inTable
    local outTable = {}

    for i, v in pairs(inTable) do
        if v then
            outTable[i] = math.abs(v)
        end
    end

    local hasChanged
    repeat
        hasChanged = false
        itemCount = itemCount - 1

        for i = 1, itemCount do
            if outTable[i] > outTable[i + 1] then
                outTable[i], outTable[i + 1] = outTable[i + 1], outTable[i]
                hasChanged = true
            end
        end
    until hasChanged == false

    return outTable[#outTable]
end

function matrixMultiply(mat1, mat2)
    local matrixOut = {}

    for i = 1, #mat1 do
        matrixOut[i] = {}

        for j = 1, #mat2[1] do
            local num = mat1[i][1] * mat2[1][j]

            for n = 2, #mat1[1] do
                num = num + mat1[i][n] * mat2[n][j]
            end

            matrixOut[i][j] = num
        end
    end

    return matrixOut
end

function createElementMatrix(pos, rot)
    local rx, ry, rz = math.rad(rot[1]), math.rad(rot[2]), math.rad(rot[3])
    return {
        { math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry), math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry), -math.cos(rx) * math.sin(ry), 0 },
        { -math.cos(rx) * math.sin(rz), math.cos(rz) * math.cos(rx), math.sin(rx), 0 },
        { math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx), math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx), math.cos(rx) * math.cos(ry), 0 },
        { pos[1], pos[2], pos[3], 1 }
    }
end

function getEulerAnglesFromMatrix(mat)
    local nz1, nz2, nz3

    nz3 = math.sqrt(mat[2][1] * mat[2][1] + mat[2][2] * mat[2][2])
    nz1 = -mat[2][1] * mat[2][3] / nz3
    nz2 = -mat[2][2] * mat[2][3] / nz3

    local vx = nz1 * mat[1][1] + nz2 * mat[1][2] + nz3 * mat[1][3]
    local vz = nz1 * mat[3][1] + nz2 * mat[3][2] + nz3 * mat[3][3]

    return math.deg(math.asin(mat[2][3])), -math.deg(math.atan2(vx, vz)), -math.deg(math.atan2(mat[2][1], mat[2][2]))
end

function getPositionFromMatrixOffset(mat, pos)
    return pos[1] * mat[1][1] + pos[2] * mat[2][1] + pos[3] * mat[3][1] + mat[4][1], pos[1] * mat[1][2] + pos[2] * mat[2][2] + pos[3] * mat[3][2] + mat[4][2], pos[1] * mat[1][3] + pos[2] * mat[2][3] + pos[3] * mat[3][3] + mat[4][3]
end