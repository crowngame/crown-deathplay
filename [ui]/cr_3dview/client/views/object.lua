function setObjectProjection(x, y, w, h, objectAlpha)
    if not objectData or not objectData.projection then
        return
    end

    objectData.projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight }
    objectData.onScreenPosition = { x, y, w, h }

    if objectAlpha and objectAlpha >= 0 and objectAlpha <= 255 then
        setElementAlpha(objectData.objectElement, math.min(objectAlpha, 254))
        objectData.alpha = objectAlpha
    end

    return renderTheActiveObjectImage()
end

function setPreviewObjectModel(objectId)
    if not objectData or not objectId then
        return
    end

    setElementModel(objectData.objectElement, objectId)
    setElementCollidableWith(objectData.objectElement, getCamera(), false)
end

function setObjectAlpha(alpha)
    if not objectData or not alpha or alpha < 0 or alpha > 255 then
        return
    end

    setElementAlpha(objectData.objectElement, math.min(alpha, 254))
    objectData.alpha = alpha
end

function setObjectPositionOffsets(x, y, z)
    if not objectData then
        return
    end

    objectData.elementPositionOffsets = { x, y, z }
end

function rotateObject(cursorRelativeX)
    if not objectData then
        return
    end

    objectData.elementRotation[3] = cursorRelativeX
end

function getObjectElement()
    if not objectData then
        return false
    end

    return objectData.objectElement
end

function processObjectPreview(objectId, x, y, w, h)
    if not objectId then
        if objectData then
            removeEventHandler("onClientPreRender", root, onClientObjectRender)

            if isElement(objectData.shaderElement) then
                engineRemoveShaderFromWorldTexture(objectData.shader, "*", objectData.objectElement)
                destroyElement(objectData.shader)
            end

            if isElement(objectData.shader) then
                destroyElement(objectData.shader)
            end

            if isElement(objectData.objectElement) then
                destroyElement(objectData.objectElement)
            end

            if not vehicleData then
                destroyElement(screenRenderTarget)
            end

            objectData = nil
        end

        return
    end

    if objectData then
        return
    end

    removeProcesses()
    local cameraPosX, cameraPosY, cameraPosZ = getCameraMatrix()

    objectData = {
        objectElement = createObject(objectId or 0, cameraPosX, cameraPosY, cameraPosZ),
        elementRadius = 0,
        elementPosition = { cameraPosX, cameraPosY, cameraPosZ },
        elementRotation = { 0, 0, 180 },
        elementRotationOffsets = { 0, 0, 0 },
        elementPositionOffsets = { 0, 0, 0 },
        onScreenPosition = { x, y, w, h },
        alpha = 255,
        zDistanceSpread = -1,
        projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight },
        shader = dxCreateShader("public/shaders/object.fx", 0, 0, false, "all")
    }

    if not isElement(screenRenderTarget) then
        screenRenderTarget = dxCreateRenderTarget(screenWidth, screenHeight, true)
    end

    setElementAlpha(objectData.objectElement, 254)
    setElementStreamable(objectData.objectElement, false)
    setElementFrozen(objectData.objectElement, true)
    setElementCollisionsEnabled(objectData.objectElement, false)
    setElementCollidableWith(objectData.objectElement, getCamera(), false)

    objectData.elementRadius = math.max(returnMaxValue({ getElementBoundingBox(objectData.objectElement) }), 1)

    local tempRadius = getElementRadius(objectData.objectElement)
    if tempRadius > objectData.elementRadius then
        objectData.elementRadius = tempRadius
    end
    if not objectData.shader then
        return
    end

    if isElement(screenRenderTarget) then
        dxSetShaderValue(objectData.shader, "secondRT", screenRenderTarget)
    end

    dxSetShaderValue(objectData.shader, "sFov", math.rad(({ getCameraMatrix() })[8]))
    dxSetShaderValue(objectData.shader, "sAspect", screenHeight / screenWidth)
    engineApplyShaderToWorldTexture(objectData.shader, "*", objectData.objectElement)

    addEventHandler("onClientPreRender", root, onClientObjectRender, true, "low-5")

    return objectData.objectElement
end

function renderTheActiveObjectImage()
    if objectData and isElement(screenRenderTarget) then
        local x, y, w, h = unpack(objectData.onScreenPosition)
        return dxDrawImageSection(x, y, w, h, x, y, w, h, screenRenderTarget, 0, 0, 0, tocolor(255, 255, 255, objectData.alpha))
    end
end

function onClientObjectRender()
    if not objectData.objectElement or not objectData.shader then
        return
    end

    local projPosX, projPosY, projSizeX, projSizeY = unpack(objectData.projection)
    projSizeX, projSizeY = projSizeX * 0.5, projSizeY * 0.5
    projPosX, projPosY = projPosX + projSizeX - 0.5, -(projPosY + projSizeY - 0.5)
    projPosX, projPosY = 2 * projPosX, 2 * projPosY

    local cameraMatrix = getElementMatrix(getCamera())
    local rotationMatrix = createElementMatrix({ 0, 0, 0 }, objectData.elementRotation)
    local positionMatrix = createElementMatrix(objectData.elementRotationOffsets, { 0, 0, 0 })
    local transformMatrix = matrixMultiply(positionMatrix, rotationMatrix)

    local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
    local distTemp = objectData.zDistanceSpread

    local posTemp = objectData.elementPositionOffsets
    local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, { posTemp[1], 1.6 * objectData.elementRadius + distTemp + posTemp[2], posTemp[3] })
    local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)

    local velocityX, velocityY, velocityZ = getCameraVelocity()
    local vectorLength = math.sqrt(velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ)
    local cameraCom = {
        cameraMatrix[2][1] * vectorLength,
        cameraMatrix[2][2] * vectorLength,
        cameraMatrix[2][3] * vectorLength
    }

    velocityX, velocityY, velocityZ = velocityX + cameraCom[1], velocityY + cameraCom[2], velocityZ + cameraCom[3]

    setElementPosition(objectData.objectElement, posX + velocityX, posY + velocityY, posZ + velocityZ)
    setElementRotation(objectData.objectElement, rotX, rotY, rotZ, "ZXY")

    dxSetShaderValue(objectData.shader, "sCameraPosition", cameraMatrix[4])
    dxSetShaderValue(objectData.shader, "sCameraForward", cameraMatrix[2])
    dxSetShaderValue(objectData.shader, "sCameraUp", cameraMatrix[3])
    dxSetShaderValue(objectData.shader, "sElementOffset", 0, -distTemp, 0)
    dxSetShaderValue(objectData.shader, "sWorldOffset", -velocityX, -velocityY, -velocityZ)
    dxSetShaderValue(objectData.shader, "sMoveObject2D", projPosX, projPosY)
    dxSetShaderValue(objectData.shader, "sScaleObject2D", math.min(projSizeX, projSizeY) * 2, math.min(projSizeX, projSizeY) * 2)
    dxSetShaderValue(objectData.shader, "sProjZMult", 2)
end