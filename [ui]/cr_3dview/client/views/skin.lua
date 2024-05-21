function setSkinProjection(x, y, w, h, skinAlpha)
    if not skinData or not skinData.projection then
        return
    end

    skinData.projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight }
    skinData.onScreenPosition = { x, y, w, h }

    if skinAlpha and skinAlpha >= 0 and skinAlpha <= 255 then
        setElementAlpha(skinData.pedElement, math.min(skinAlpha, 254))
        skinData.alpha = skinAlpha
    end

    return renderTheActiveSkinImage()
end

function setSkin(skinId)
    if not skinData or not skinId then
        return
    end

    setElementModel(skinData.pedElement, skinId)
    setElementCollidableWith(skinData.pedElement, getCamera(), false)
end

function setSkinAlpha(alpha)
    if not skinData or not alpha or alpha < 0 or alpha > 255 then
        return
    end

    setElementAlpha(skinData.pedElement, math.min(alpha, 254))
    skinData.alpha = alpha
end

function setSkinPositionOffsets(x, y, z)
    if not skinData then
        return
    end

    skinData.elementPositionOffsets = { x, y, z }
end

function rotateSkin(cursorRelativeX)
    if not skinData then
        return
    end

    skinData.elementRotation[3] = (skinData.elementRotation[3] - (0.5 - cursorRelativeX) * 50) % 360
end

function processSkinAnimation(block, value)
    if not skinData then
        return
    end

    return setPedAnimation(skinData.pedElement, block, value, -1, true, false, false, false)
end

function getSkinElement()
    if not skinData then
        return false
    end

    return skinData.pedElement
end

function setSkinFov(fov)
    if not skinData then
        return
    end

    dxSetShaderValue(skinData.shader, "sFov", fov)
end

function processSkinPreview(skinId, x, y, w, h)
    if not skinId then
        if skinData then
            removeEventHandler("onClientPreRender", root, onClientSkinRender)

            if isElement(skinData.shaderElement) then
                engineRemoveShaderFromWorldTexture(skinData.shader, "*", skinData.pedElement)
                destroyElement(skinData.shader)
            end

            if isElement(skinData.shader) then
                destroyElement(skinData.shader)
            end

            if isElement(skinData.pedElement) then
                destroyElement(skinData.pedElement)
            end

            if not vehicleData then
                destroyElement(screenRenderTarget)
            end

            skinData = nil
        end

        return
    end

    if skinData then
        return
    end

    removeProcesses()

    local cameraPosX, cameraPosY, cameraPosZ = getCameraMatrix()

    skinData = {
        pedElement = createPed(skinId or 0, 0, 0, 0),
        elementRadius = 0,
        elementPosition = { cameraPosX, cameraPosY, cameraPosZ },
        elementRotation = { 0, 0, 180 },
        elementRotationOffsets = { 0, 0, 0 },
        elementPositionOffsets = { 0, 0, 0 },
        onScreenPosition = { x, y, w, h },
        alpha = 255,
        zDistanceSpread = -1,
        projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight },
        shader = dxCreateShader("public/shaders/ped.fx", 0, 0, false, "all")
    }

    if not isElement(screenRenderTarget) then
        screenRenderTarget = dxCreateRenderTarget(screenWidth, screenHeight, true)
    end

    setPedWalkingStyle(skinData.pedElement, getPedWalkingStyle(localPlayer))
    setElementAlpha(skinData.pedElement, 254)
    setElementStreamable(skinData.pedElement, false)
    setElementFrozen(skinData.pedElement, true)
    setElementCollisionsEnabled(skinData.pedElement, false)
    setElementDimension(skinData.pedElement, getElementDimension(localPlayer))
    setElementInterior(skinData.pedElement, getElementInterior(localPlayer))
    setElementCollidableWith(skinData.pedElement, getCamera(), false)

    skinData.elementRadius = math.max(returnMaxValue({ getElementBoundingBox(skinData.pedElement) }), 1)

    local tempRadius = getElementRadius(skinData.pedElement)
    if tempRadius > skinData.elementRadius then
        skinData.elementRadius = tempRadius
    end
    if not skinData.shader then
        return
    end

    if isElement(screenRenderTarget) then
        dxSetShaderValue(skinData.shader, "secondRT", screenRenderTarget)
    end

    dxSetShaderValue(skinData.shader, "sFov", math.rad(({ getCameraMatrix() })[8]))
    dxSetShaderValue(skinData.shader, "sAspect", screenHeight / screenWidth)
    engineApplyShaderToWorldTexture(skinData.shader, "*", skinData.pedElement)

    addEventHandler("onClientPreRender", root, onClientSkinRender, true, "low-5")

    return skinData.pedElement
end

function renderTheActiveSkinImage()
    if skinData and isElement(screenRenderTarget) then
        local x, y, w, h = unpack(skinData.onScreenPosition)
        return dxDrawImageSection(x, y, w, h, x, y, w, h, screenRenderTarget, 0, 0, 0, tocolor(255, 255, 255, skinData.alpha))
    end
end

function onClientSkinRender()
    if not skinData.pedElement or not skinData.shader then
        return
    end

    local projPosX, projPosY, projSizeX, projSizeY = unpack(skinData.projection)
    projSizeX, projSizeY = projSizeX * 0.5, projSizeY * 0.5
    projPosX, projPosY = projPosX + projSizeX - 0.5, -(projPosY + projSizeY - 0.5)
    projPosX, projPosY = 2 * projPosX, 2 * projPosY

    local cameraMatrix = getElementMatrix(getCamera())
    local rotationMatrix = createElementMatrix({ 0, 0, 0 }, skinData.elementRotation)
    local positionMatrix = createElementMatrix(skinData.elementRotationOffsets, { 0, 0, 0 })
    local transformMatrix = matrixMultiply(positionMatrix, rotationMatrix)

    local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
    local distTemp = skinData.zDistanceSpread

    local posTemp = skinData.elementPositionOffsets
    local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, { posTemp[1], 1.6 * skinData.elementRadius + distTemp + posTemp[2], posTemp[3] })
    local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)

    local velocityX, velocityY, velocityZ = getCameraVelocity()
    local vectorLength = math.sqrt(velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ)
    local cameraCom = {
        cameraMatrix[2][1] * vectorLength,
        cameraMatrix[2][2] * vectorLength,
        cameraMatrix[2][3] * vectorLength
    }

    velocityX, velocityY, velocityZ = velocityX + cameraCom[1], velocityY + cameraCom[2], velocityZ + cameraCom[3]

    setElementPosition(skinData.pedElement, posX + velocityX, posY + velocityY, posZ + velocityZ, false)
    setElementRotation(skinData.pedElement, rotX, rotY, rotZ, "ZXY")

    dxSetShaderValue(skinData.shader, "sCameraPosition", cameraMatrix[4])
    dxSetShaderValue(skinData.shader, "sCameraForward", cameraMatrix[2])
    dxSetShaderValue(skinData.shader, "sCameraUp", cameraMatrix[3])
    dxSetShaderValue(skinData.shader, "sElementOffset", 0, -distTemp, 0)
    dxSetShaderValue(skinData.shader, "sWorldOffset", -velocityX, -velocityY, -velocityZ)
    dxSetShaderValue(skinData.shader, "sMoveObject2D", projPosX, projPosY)
    dxSetShaderValue(skinData.shader, "sScaleObject2D", math.min(projSizeX, projSizeY) * 2, math.min(projSizeX, projSizeY) * 2)
    dxSetShaderValue(skinData.shader, "sProjZMult", 2)
end