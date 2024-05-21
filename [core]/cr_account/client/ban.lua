local CONTAINER_SIZES = {
    x = 500,
    y = 540
}

local x, y = screenSize.x / 2 - CONTAINER_SIZES.x / 2, screenSize.y / 2 - CONTAINER_SIZES.y / 2 - 50

local banDetails = {}

function renderBanScreen()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(18, 18, 20, 150))
	dxDrawImage(screenSize.x / 2 - 75, screenSize.y / 2 - 300, 150, 150, ":cr_ui/public/images/logos/solid.png", 0, 0, 0, exports.cr_ui:rgba(theme.RED[700]))

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y + 200,
        },

        text = 'Sunucudan yasaklandınız.',
        alignX = 'left',
        alignY = 'top',
        color = theme.WHITE,
        scale = 'h1',
        wrap = false,

        fontWeight = 'bold',
    })

    exports.cr_ui:drawList({
        position = {
            x = x,
            y = y + 300,
        },
        size = {
            x = CONTAINER_SIZES.x,
            y = CONTAINER_SIZES.y - 300
        },

        padding = 20,
        rowHeight = 35,

        name = 'list',
        header = 'Yasak Detayları',
        items = {
            { icon = '', text = 'Yasaklayan: ' .. banDetails[1], key = '' },
            { icon = '', text = 'Yasaklanma Sebebi: ' .. banDetails[2], key = '' },
            { icon = '', text = 'Yasaklanma Tarihi: ' .. banDetails[3], key = '' },
            { icon = '', text = 'Bitiş Süresi: ' .. ((banDetails[4] == -1) and 'Sınırsız' or secondsToTimeDesc(banDetails[4] / 1000)), key = '' },
        },

        variant = 'soft',
        color = 'gray',
    })

    exports.cr_ui:drawTypography({
        position = {
            x = x,
            y = y + 250,
        },

        text = 'Kuralları ihlal ettiğiniz için sunucudan yasaklandınız. Aşağıdan detayları\ngörüntüleyebilirsiniz.',
        alignX = 'left',
        alignY = 'top',
        color = theme.GRAY[300],
        scale = 'body',
        wrap = false,

        fontWeight = 'regular',
    })
end

addEvent("account.banScreen", true)
addEventHandler("account.banScreen", root, function(_banDetails)
    if _banDetails then
		banDetails = _banDetails
		
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setCameraMatrix(-350.67303466797, 2229.3159179688, 46.286087036133, -257.8219909668, 2193.5864257812, 36.182357788086)
		fadeCamera(true)
		showCursor(true)
		showChat(false)
		music.timer = setTimer(playMusic, 0, 0)
		
		if isEventHandlerAdded("onClientRender", root, renderAccount) then
			removeEventHandler("onClientRender", root, renderAccount)
		end
		
		if isEventHandlerAdded("onClientRender", root, renderSplash) then
			removeEventHandler("onClientRender", root, renderSplash)
		end
		
		addEventHandler("onClientRender", root, renderBanScreen)
		addEventHandler("onClientRender", root, renderSplash)
		addEventHandler("onClientKey", root, function()
			cancelEvent()
		end)
	end
end)