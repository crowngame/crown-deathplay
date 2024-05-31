screenSize = Vector2(guiGetScreenSize())

theme = exports.cr_ui:useTheme()
fonts = exports.cr_ui:useFonts()
seasonFonts = {
    season1 = exports.cr_fonts:getFont("sf-bold", 105),
    season1_nametag = exports.cr_fonts:getFont("sf-bold", 75),
    
	season2 = dxCreateFont("public/fonts/2.ttf", 105),
    season2_nametag = dxCreateFont("public/fonts/2.ttf", 75),
    
	season3 = dxCreateFont("public/fonts/3.ttf", 105),
    season3_nametag = dxCreateFont("public/fonts/3.ttf", 75),
    
	season4 = dxCreateFont("public/fonts/4.ttf", 105),
    season4_nametag = dxCreateFont("public/fonts/4.ttf", 75),
    
	season5 = dxCreateFont("public/fonts/5.ttf", 100),
    season5_nametag = dxCreateFont("public/fonts/5.ttf", 25),
	
    season6 = dxCreateFont("public/fonts/6.ttf", 50),
    season6_nametag = dxCreateFont("public/fonts/6.ttf", 20),
}

function dxDrawBorderedText(outline, outlineColor, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, outlineColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

--========================================================================================

local sm = {moov = 0, object1 = nil, object2 = nil}

local function removeCamHandler()
    if (sm.moov == 1) then
        sm.moov = 0
    end
end
 
local function camRender()
    if (sm.moov == 1) then
        local x1,y1,z1 = getElementPosition(sm.object1)
        local x2,y2,z2 = getElementPosition(sm.object2)
        setCameraMatrix(x1, y1, z1, x2, y2, z2)
    else
        removeEventHandler("onClientPreRender", root, camRender)
    end
end

 
function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
    if (sm.moov == 1) then return false end
    sm.object1 = createObject(1337, x1, y1, z1)
    sm.object2 = createObject(1337, x1t, y1t, z1t)
    setElementCollisionsEnabled(sm.object1, false) 
    setElementCollisionsEnabled(sm.object2, false) 
    setElementAlpha(sm.object1, 0)
    setElementAlpha(sm.object2, 0)
    setObjectScale(sm.object1, 0.01)
    setObjectScale(sm.object2, 0.01)
    moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad")
    moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad")
    sm.moov = 1
    setTimer(removeCamHandler, time, 1)
    setTimer(destroyElement, time, 1, sm.object1)
    setTimer(destroyElement, time, 1, sm.object2)
    addEventHandler("onClientPreRender", root, camRender)
    return true
end

addCommandHandler("camera", function()
    local x, y, z, lx, ly, lz = getCameraMatrix()
    outputChatBox(x .. ", " .. y .. ", " .. z .. ", " .. lx .. ", " .. ly .. ", " .. lz)
end)