screenSize = Vector2(guiGetScreenSize())

fonts = exports.cr_ui:useFonts()

textures = {
    [0] = dxCreateTexture("public/images/weapons/0.png"),
    [1] = dxCreateTexture("public/images/weapons/1.png"),
    [2] = dxCreateTexture("public/images/weapons/2.png"),
    [3] = dxCreateTexture("public/images/weapons/3.png"),
    [4] = dxCreateTexture("public/images/weapons/4.png"),
    [5] = dxCreateTexture("public/images/weapons/5.png"),
    [6] = dxCreateTexture("public/images/weapons/6.png"),
    [7] = dxCreateTexture("public/images/weapons/7.png"),
    [8] = dxCreateTexture("public/images/weapons/8.png"),
    [9] = dxCreateTexture("public/images/weapons/9.png"),
    [10] = dxCreateTexture("public/images/weapons/10.png"),
    [11] = dxCreateTexture("public/images/weapons/11.png"),
    [12] = dxCreateTexture("public/images/weapons/12.png"),
    [14] = dxCreateTexture("public/images/weapons/14.png"),
    [15] = dxCreateTexture("public/images/weapons/15.png"),
    [16] = dxCreateTexture("public/images/weapons/16.png"),
    [17] = dxCreateTexture("public/images/weapons/17.png"),
    [18] = dxCreateTexture("public/images/weapons/18.png"),
    [22] = dxCreateTexture("public/images/weapons/22.png"),
    [23] = dxCreateTexture("public/images/weapons/23.png"),
    [24] = dxCreateTexture("public/images/weapons/24.png"),
    [25] = dxCreateTexture("public/images/weapons/25.png"),
    [26] = dxCreateTexture("public/images/weapons/26.png"),
    [27] = dxCreateTexture("public/images/weapons/27.png"),
    [28] = dxCreateTexture("public/images/weapons/28.png"),
    [29] = dxCreateTexture("public/images/weapons/29.png"),
    [30] = dxCreateTexture("public/images/weapons/30.png"),
    [31] = dxCreateTexture("public/images/weapons/31.png"),
    [32] = dxCreateTexture("public/images/weapons/32.png"),
    [33] = dxCreateTexture("public/images/weapons/33.png"),
    [34] = dxCreateTexture("public/images/weapons/34.png"),
    [35] = dxCreateTexture("public/images/weapons/35.png"),
    [36] = dxCreateTexture("public/images/weapons/36.png"),
    [37] = dxCreateTexture("public/images/weapons/37.png"),
    [38] = dxCreateTexture("public/images/weapons/38.png"),
    [39] = dxCreateTexture("public/images/weapons/39.png"),
    [40] = dxCreateTexture("public/images/weapons/40.png"),
    [41] = dxCreateTexture("public/images/weapons/41.png"),
    [42] = dxCreateTexture("public/images/weapons/42.png"),
    [43] = dxCreateTexture("public/images/weapons/43.png"),
    [44] = dxCreateTexture("public/images/weapons/44.png"),
    [45] = dxCreateTexture("public/images/weapons/45.png"),
    [46] = dxCreateTexture("public/images/weapons/46.png")
}

function interpolateBetween(x1, y1, z1, x2, y2, z2, progress, easing)
    local function applyEasing(value, easingType)
        if easingType == "Linear" then
            return value
        elseif easingType == "OutQuad" then
            return value * (2 - value)
        else
            return value
        end
    end

    local x = x1 + (x2 - x1) * applyEasing(progress, easing)
    local y = y1 + (y2 - y1) * applyEasing(progress, easing)
    local z = z1 + (z2 - z1) * applyEasing(progress, easing)

    return x, y, z
end

function getSmoothRGB(tickCount)
    local period = 2000
    local r = math.floor(127 * math.sin(2 * math.pi * (tickCount % period) / period) + 128)
    local g = math.floor(127 * math.sin(2 * math.pi * (tickCount % period) / period + 2 * math.pi / 3) + 128)
    local b = math.floor(127 * math.sin(2 * math.pi * (tickCount % period) / period + 4 * math.pi / 3) + 128)
    return r, g, b
end