local animationDuration = 250
local displayDuration = 5000
local fadeOutDuration = 1000

local messages = {}

addEvent("killmessage1.sendKill", true)
addEventHandler("killmessage1.sendKill", root, function(killerName, killedName, weaponID, score, killerNametagColor, killedNametagColor)
    table.insert(messages, { killerName, killedName, weaponID, score, killerNametagColor, killedNametagColor, getTickCount() })
    if #messages > 5 then
        table.remove(messages, 1)
    end
end)

addEventHandler("onClientRender", root, function()
    if (getElementData(localPlayer, "loggedin") == 1) and (getElementData(localPlayer, "hud_settings").killmessage == 1) and (not exports.cr_items:isInventoryShow()) and (not exports.cr_hud:isOverlayShow()) then
        local y = screenSize.y / 2 - (#messages * 10)
        for i, message in ipairs(messages) do
            local killerName, killedName, weaponID, score, killerNametagColor, killedNametagColor, tick = unpack(message)
            local elapsedTime = getTickCount() - tick
            if elapsedTime < displayDuration then
                local alpha = 255
                if elapsedTime >= displayDuration - fadeOutDuration then
                    alpha = 255 * ((displayDuration - elapsedTime) / fadeOutDuration)
                end

                local rectAlpha = 205
                if elapsedTime >= displayDuration - fadeOutDuration then
                    rectAlpha = 205 * ((displayDuration - elapsedTime) / fadeOutDuration)
                end

                local texture = textures[weaponID]
                local imageWidth, imageHeight = dxGetMaterialSize(texture)
                local totalWidth = dxGetTextWidth(killerName, 1, fonts.body.regular) + imageWidth + dxGetTextWidth(killedName, 1, fonts.body.regular) + 20

                local xPos
                if elapsedTime < animationDuration then
                    local startX = screenSize.x
                    local endX = screenSize.x - totalWidth - 20
                    xPos = interpolateBetween(startX, 0, 0, endX, 0, 0, elapsedTime / animationDuration, "OutQuad")
                else
                    xPos = screenSize.x - totalWidth - 20
                end

                dxDrawRectangle(xPos - 5, y - 4, totalWidth + 10, 28, tocolor(18, 18, 20, rectAlpha))
                dxDrawText(killerName:gsub("_", " "), xPos + 2, y + 1, screenSize.x, y + 20, tocolor(killerNametagColor[1], killerNametagColor[2], killerNametagColor[3], alpha), 1, fonts.body.regular)
                xPos = xPos + dxGetTextWidth(killerName, 1, fonts.body.regular) + 12
                dxDrawImage(xPos, y, imageWidth, 20, texture, 0, 0, 0, tocolor(255, 255, 255, alpha))
                xPos = xPos + imageWidth + 10
                dxDrawText(killedName:gsub("_", " "), xPos, y + 1, screenSize.x, y + 20, tocolor(killedNametagColor[1], killedNametagColor[2], killedNametagColor[3], alpha), 1, fonts.body.regular)

                y = y + 30
            else
                table.remove(messages, i)
            end
        end
    end
end)