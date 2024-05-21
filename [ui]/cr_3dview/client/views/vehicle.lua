function setVehicleProjection(x, y, w, h, vehicleAlpha)
    if not vehicleData or not vehicleData.projection then
        return
    end

    vehicleData.projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight }
    vehicleData.onScreenPosition = { x, y, w, h }

    if vehicleAlpha and vehicleAlpha >= 0 and vehicleAlpha <= 255 then
        setElementAlpha(vehicleData.vehicleElement, math.min(vehicleAlpha, 254))
        vehicleData.alpha = vehicleAlpha
    end

    return renderTheActiveVehicleImage()
end

function setPreviewVehicleModel(vehicleModel)
    if not vehicleData or not vehicleModel then
        return
    end

    setElementModel(vehicleData.vehicleElement, vehicleModel)
    setElementCollidableWith(vehicleData.vehicleElement, getCamera(), false)
end

function setVehicleAlpha(alpha)
    if not vehicleData or not alpha or alpha < 0 or alpha > 255 then
        return
    end

    setElementAlpha(vehicleData.vehicleElement, math.min(alpha, 254))
    vehicleData.alpha = alpha
end

function rotateVehicle(cursorRelativeX)
    if not vehicleData then
        return
    end

    vehicleData.elementRotation[3] = cursorRelativeX * 360
end

function toggleVehicleDamages(state)
    if not vehicleData or not isElement(vehicleData.vehicleElement) then
        return
    end

    if state ~= vehicleData.damageView then
        if state then
            for i = 0, 6 do
                if i <= 5 then
                    setVehicleDoorState(vehicleData.vehicleElement, i, getVehicleDoorState(vehicleData.mainVehicle, i))
                end

                setVehiclePanelState(vehicleData.vehicleElement, i, getVehiclePanelState(vehicleData.mainVehicle, i))
            end

            setVehicleWheelStates(vehicleData.vehicleElement, getVehicleWheelStates(vehicleData.mainVehicle))
        else
            fixVehicle(vehicleData.vehicleElement)
        end

        vehicleData.damageView = state
    end
end

function setVehiclePositionOffsets(x, y, z)
    if not vehicleData then
        return
    end

    vehicleData.elementPositionOffsets = { x, y, z }
end

function processVehiclePreview(vehicle, x, y, w, h, damageView)
    if not vehicle or not isElement(vehicle) then
        if vehicleData then
            removeEventHandler("onClientPreRender", getRootElement(), onClientVehicleRender)

            if isElement(vehicleData.shaderElement) then
                engineRemoveShaderFromWorldTexture(vehicleData.shader, "*", vehicleData.vehicleElement)
                destroyElement(vehicleData.shader)
            end

            if isElement(vehicleData.vehicleElement) then
                destroyElement(vehicleData.vehicleElement)
            end

            if isElement(vehicleData.shader) then
                destroyElement(vehicleData.shader)
            end

            if not skinData then
                destroyElement(screenRenderTarget)
            end

            vehicleData = nil
        end

        return
    end

    if vehicleData then
        return
    end
    removeProcesses()

    local cameraPosX, cameraPosY, cameraPosZ = getCameraMatrix()

    vehicleData = {
        mainVehicle = vehicle,
        vehicleElement = createVehicle(getElementModel(vehicle) or 0, cameraPosX, cameraPosY, cameraPosZ, 0, 0, 0, getVehiclePlateText(vehicle) or ''),
        elementRadius = 0,
        elementPosition = { cameraPosX, cameraPosY, cameraPosZ },
        elementRotation = { 0, 0, 145 },
        elementRotationOffsets = { 0, 0, 0 },
        elementPositionOffsets = { 0, 0, 0 },
        onScreenPosition = { x, y, w, h },
        alpha = 255,
        zDistanceSpread = -1,
        projection = { x / screenWidth, y / screenHeight, w / screenWidth, h / screenHeight },
        shader = dxCreateShader("public/shaders/vehicle.fx", 0, 0, false, "all"),
        damageView = damageView
    }

    if not isElement(screenRenderTarget) then
        screenRenderTarget = dxCreateRenderTarget(screenWidth, screenHeight, true)
    end

    setElementAlpha(vehicleData.vehicleElement, 254)
    setElementStreamable(vehicleData.vehicleElement, false)
    setElementFrozen(vehicleData.vehicleElement, true)
    setElementCollisionsEnabled(vehicleData.vehicleElement, false)
    setElementCollidableWith(vehicleData.vehicleElement, getCamera(), false)

    setTimer(
            function()
                setVehicleColor(vehicleData.vehicleElement, getVehicleColor(vehicle))
            end,
            100, 1)

    for k, v in ipairs(getVehicleUpgrades(vehicle)) do
        addVehicleUpgrade(vehicleData.vehicleElement, v)
    end

    if damageView then
        for i = 0, 6 do
            if i <= 5 then
                setVehicleDoorState(vehicleData.vehicleElement, i, getVehicleDoorState(vehicle, i))
            end

            setVehiclePanelState(vehicleData.vehicleElement, i, getVehiclePanelState(vehicle, i))
        end

        setVehicleWheelStates(vehicleData.vehicleElement, getVehicleWheelStates(vehicle))
    end

    vehicleData.elementRadius = math.max(returnMaxValue({ getElementBoundingBox(vehicleData.vehicleElement) }) or 0, 1) or 0

    local tempRadius = getElementRadius(vehicleData.vehicleElement) or 0
    if tempRadius > vehicleData.elementRadius then
        vehicleData.elementRadius = tempRadius
    end

    if not vehicleData.shader then
        return
    end

    if isElement(screenRenderTarget) then
        dxSetShaderValue(vehicleData.shader, "secondRT", screenRenderTarget)
    end

    dxSetShaderValue(vehicleData.shader, "sFov", math.rad(({ getCameraMatrix() })[8]))
    dxSetShaderValue(vehicleData.shader, "sAspect", screenHeight / screenWidth)
    engineApplyShaderToWorldTexture(vehicleData.shader, "*", vehicleData.vehicleElement)

    addEventHandler("onClientPreRender", getRootElement(), onClientVehicleRender, true, "low-5")

    return vehicleData.vehicleElement
end

function setVehicleFov(fov)
    if not vehicleData then
        return
    end

    dxSetShaderValue(vehicleData.shader, "sFov", math.rad(fov))
end

function getVehicleElement()
    if not vehicleData then
        return false
    end

    return vehicleData.vehicleElement
end

function renderTheActiveVehicleImage()
    if vehicleData and isElement(screenRenderTarget) then
        local x, y, w, h = unpack(vehicleData.onScreenPosition)
        return dxDrawImageSection(x, y, w, h, x, y, w, h, screenRenderTarget, 0, 0, 0, tocolor(255, 255, 255, vehicleData.alpha))
    end
end

function onClientVehicleRender()
    if not vehicleData.vehicleElement or not vehicleData.shader then
        return
    end

    local projPosX, projPosY, projSizeX, projSizeY = unpack(vehicleData.projection)
    projSizeX, projSizeY = projSizeX * 0.5, projSizeY * 0.5
    projPosX, projPosY = projPosX + projSizeX - 0.5, -(projPosY + projSizeY - 0.5)
    projPosX, projPosY = 2 * projPosX, 2 * projPosY

    local cameraMatrix = getElementMatrix(getCamera())
    local rotationMatrix = createElementMatrix({ 0, 0, 0 }, vehicleData.elementRotation)
    local positionMatrix = createElementMatrix(vehicleData.elementRotationOffsets, { 0, 0, 0 })
    local transformMatrix = matrixMultiply(positionMatrix, rotationMatrix)

    local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
    local distTemp = vehicleData.zDistanceSpread

    local posTemp = vehicleData.elementPositionOffsets
    local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, { posTemp[1], 1.6 * vehicleData.elementRadius + distTemp + posTemp[2], posTemp[3] })
    local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)

    local velocityX, velocityY, velocityZ = getCameraVelocity()
    local vectorLength = math.sqrt(velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ)
    local cameraCom = {
        cameraMatrix[2][1] * vectorLength,
        cameraMatrix[2][2] * vectorLength,
        cameraMatrix[2][3] * vectorLength
    }

    velocityX, velocityY, velocityZ = velocityX + cameraCom[1], velocityY + cameraCom[2], velocityZ + cameraCom[3] + 5

    setElementPosition(vehicleData.vehicleElement, posX + velocityX, posY + velocityY, posZ + velocityZ)
    setElementRotation(vehicleData.vehicleElement, rotX, rotY, rotZ, "ZXY")

    dxSetShaderValue(vehicleData.shader, "sCameraPosition", cameraMatrix[4])
    dxSetShaderValue(vehicleData.shader, "sCameraForward", cameraMatrix[2])
    dxSetShaderValue(vehicleData.shader, "sCameraUp", cameraMatrix[3])
    dxSetShaderValue(vehicleData.shader, "sElementOffset", 0, -distTemp, 0)
    dxSetShaderValue(vehicleData.shader, "sWorldOffset", -velocityX, -velocityY, -velocityZ)
    dxSetShaderValue(vehicleData.shader, "sMoveObject2D", projPosX, projPosY)
    dxSetShaderValue(vehicleData.shader, "sScaleObject2D", math.min(projSizeX, projSizeY) * 2, math.min(projSizeX, projSizeY) * 2)
    dxSetShaderValue(vehicleData.shader, "sProjZMult", 2)
end