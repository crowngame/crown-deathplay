fontElements = {}

local fonts = {
    BebasNeueBold = 'otf',
    BebasNeueLight = 'otf',
    BebasNeueRegular = 'otf',
    EsBuild = 'ttf',
    IckyticketMono = 'ttf',
    Impact = 'ttf',
    Pixellari = 'ttf',
    SweetSixteen = 'ttf',
    UbuntuBold = 'ttf',
    UbuntuLight = 'ttf',
    UbuntuRegular = 'ttf',
    W95FA = 'otf',
    FontAwesome = 'ttf',
}

local sizes = {
    h0 = 24,
    h1 = 20,
    h2 = 18,
    h3 = 16,
    h4 = 14,
    h5 = 12,
    h6 = 11,
    body = 10,
    caption = 9,
}

function initializeFonts()
    for name, ext in pairs(fonts) do
        local path = 'public/fonts/' .. name .. '.' .. ext
        fontElements[name] = {}
        for key, size in pairs(sizes) do
            local fontElement = dxCreateFont(path, size)
            if fontElement then
                fontElements[name][key] = fontElement
            end
        end
    end

    --TODO: FIX BACKWARD COMPATIBILITY
    for key, size in pairs(sizes) do
        fontElements[key] = {
            thin = fontElements.UbuntuLight[key],
            light = fontElements.UbuntuLight[key],
            regular = fontElements.UbuntuRegular[key],
            bold = fontElements.UbuntuBold[key],
            black = fontElements.UbuntuBold[key],
        }
    end
    fontElements.icon = dxCreateFont('public/fonts/FontAwesome.ttf', 20)

    outputConsole('[UI] Fonts initialized')
end
initializeFonts()

function useFonts()
    return fontElements
end