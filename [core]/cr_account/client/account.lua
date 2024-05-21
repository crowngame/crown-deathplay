local sizeX, sizeY = 250, 40
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 1.9
local clickTick = 0

local selectedPage = 1
local hidePassword = true

local _rememberMe = false
local accountInfo = false

isLoading = false
passedIntro = false

local selectedTextBox = ""
local textBoxes = {
	["login_username"] = {"", false},
	["login_password"] = {"", false},
	["register_username"] = {"", false},
	["register_password"] = {"", false},
	["register_password_again"] = {"", false},
}

local fonts = {
    font1 = exports.cr_fonts:getFont("UbuntuRegular", 10),
    font2 = exports.cr_fonts:getFont("UbuntuBold", 10),
    font3 = exports.cr_fonts:getFont("UbuntuRegular", 9),
    awesome = exports.cr_fonts:getFont("FontAwesome", 11),
    awesome2 = exports.cr_fonts:getFont("FontAwesome", 10),
    awesome3 = exports.cr_fonts:getFont("FontAwesome", 9)
}

function renderAccount()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(18, 18, 20, 150))
	
	if not passedIntro then
        if not isElement(introMusic) then
            introMusic = playSound("public/sounds/intro.mp3")
        end
        renderIntro()
        return
    end
	
	dxDrawImage((screenSize.x - 150) / 2, screenY - 220, 150, 150, ":cr_ui/public/images/logos/solid.png", 0, 0, 0, exports.cr_ui:getServerColor(1, 230))
	
	if selectedPage == 1 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(textBoxes["login_username"][2] and textBoxes["login_username"][1] or "kullanıcı adı", screenX + 15, screenY - 44, nil, nil, selectedTextBox == "login_username" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		
		if exports.cr_ui:inArea(screenX, screenY - 55, sizeX, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not isLoading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "login_username"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(hidePassword and (textBoxes["login_password"][2] and string.rep("*", #textBoxes["login_password"][1]) or "şifre") or (textBoxes["login_password"][2] and textBoxes["login_password"][1] or "şifre"), screenX + 15, screenY + 6, nil, nil, selectedTextBox == "login_password" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 7, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY - 5, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not isLoading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "login_password"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Beni Hatırla
		rememberMeCheckbox = exports.cr_ui:drawCheckbox({
            position = {
                x = screenX,
                y = screenY + 41
            },
            size = 20,

            name = "account_rememberMe",
            disabled = false,
            text = "Beni Hatırla",
            helperText = {
                text = "",
                color = theme.GRAY[200],
            },

            variant = "soft",
            color = "gray",
            checked = _rememberMe,

            disabled = not isLoading
        })
		
		--> Giriş Yap
		dxDrawRectangle(screenX, screenY + 68, sizeX, sizeY, exports.cr_ui:inArea(screenX, screenY + 68, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("giriş yap", screenX + sizeX - 125, screenY + 79, nil, nil, tocolor(20, 20, 20, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 68, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			
			if string.match(textBoxes["login_username"][1], "['\"\\%;]") or string.match(textBoxes["login_password"][1], "['\"\\%;]") then
                textBoxes["login_username"][1] = ""
                textBoxes["login_password"][1] = ""
				exports.cr_infobox:addBox("error", "Kullanılamaz karakterler tespit edildi.")
                return
            end

            if textBoxes["login_username"][1] == "" or textBoxes["login_password"][1] == "" then
                if textBoxes["login_username"][1] == "" then
                    exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
                end

                if textBoxes["login_password"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
                end

                return
            end

            if string.len(textBoxes["login_username"][1]) < 3 or string.len(textBoxes["login_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["login_password"][1]) < 3 or string.len(textBoxes["login_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Üst üste çok işlem yaptınız, 3 saniye bekleyin.")
                return
            end

            spamTimer = setTimer(function() end, 3000, 1)
			
			isLoading = true
			addEventHandler("onClientRender", root, renderLoading)
			triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
			
			if rememberMeCheckbox.checked then
				exports.cr_json:jsonSave("account_info", { username = textBoxes["login_username"][1], password = textBoxes["login_password"][1], rememberMe = rememberMeCheckbox.checked }, true)
			end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 113, sizeX, sizeY, exports.cr_ui:inArea(screenX, screenY + 113, sizeX, sizeY) and tocolor(25, 25, 25, 255) or tocolor(20, 20, 20, 255))
		dxDrawText("kayıt ol", screenX + sizeX - 125, screenY + 124, nil, nil, exports.cr_ui:getServerColor(1, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 113, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			selectedPage = 2
		end
	elseif selectedPage == 2 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(textBoxes["register_username"][2] and textBoxes["register_username"][1] or "kullanıcı adı", screenX + 15, screenY - 44, nil, nil, selectedTextBox == "register_username" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		
		if exports.cr_ui:inArea(screenX, screenY - 55, sizeX, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not isLoading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_username"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(hidePassword and (textBoxes["register_password"][2] and string.rep("*", #textBoxes["register_password"][1]) or "şifre") or (textBoxes["register_password"][2] and textBoxes["register_password"][1] or "şifre"), screenX + 15, screenY + 6, nil, nil, selectedTextBox == "register_password" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 7, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY - 5, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not isLoading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_password"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Şifre Yeniden
		dxDrawRectangle(screenX, screenY + 45, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(hidePassword and (textBoxes["register_password_again"][2] and string.rep("*", #textBoxes["register_password_again"][1]) or "şifre yeniden") or (textBoxes["register_password_again"][2] and textBoxes["register_password_again"][1] or "şifre yeniden"), screenX + 15, screenY + 56, nil, nil, selectedTextBox == "register_password_again" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hidePassword and "" or "", screenX + sizeX - 20, screenY + 57, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:inArea(screenX + sizeX - 40, screenY + 57, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			hidePassword = not hidePassword
		end
		
		if exports.cr_ui:inArea(screenX, screenY + 45, sizeX - 35, sizeY) then
			exports.cr_cursor:setCursor("all", "ibeam")
			if not isLoading and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				selectedTextBox = "register_password_again"
				textBoxes[selectedTextBox][1] = ""
				textBoxes[selectedTextBox][2] = true
			end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 95, sizeX, sizeY, exports.cr_ui:inArea(screenX + 95, screenY + 95, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("kayıt ol", screenX + sizeX - 125, screenY + 106, nil, nil, tocolor(20, 20, 20, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:inArea(screenX, screenY + 95, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			
			if string.match(textBoxes["register_username"][1], "['\"\\%;]") or string.match(textBoxes["register_password"][1], "['\"\\%;]") or string.match(textBoxes["register_password_again"][1], "['\"\\%;]") then
                textBoxes["register_username"][1] = ""
                textBoxes["register_password"][1] = ""
				exports.cr_infobox:addBox("error", "Kullanılamaz karakterler tespit edildi.")
                return
            end

            if textBoxes["register_username"][1] == "" or textBoxes["register_password"][1] == "" or textBoxes["register_password_again"][1] == "" then
                if textBoxes["register_username"][1] == "" then
                    exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
                end

                if textBoxes["register_password"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
                end
				
                if textBoxes["register_password_again"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre tekrarı boş bırakılamaz.")
                end

                return
            end

            if string.len(textBoxes["register_username"][1]) < 3 or string.len(textBoxes["register_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["register_password"][1]) < 6 or string.len(textBoxes["register_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 6 ile 32 karakter arasında olmalıdır.")
                return
            end
			
			if textBoxes["register_password"][1] ~= textBoxes["register_password_again"][1] then
				exports.cr_infobox:addBox("error", "Şifreler eşleşmiyor.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Üst üste çok işlem yaptınız, 3 saniye bekleyin.")
                return
            end
			
			spamTimer = setTimer(function() end, 3000, 1)
			
			isLoading = true
			addEventHandler("onClientRender", root, renderLoading)
			triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
		end
		
		--> Giriş Yap
		dxDrawText("giriş sekmesine dön", screenX + sizeX - 125, screenY + 145, nil, nil, exports.cr_ui:inArea(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1), 15) and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1, "center")
		
		if exports.cr_ui:inArea(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() and not isLoading then
			clickTick = getTickCount()
			selectedPage = 1
		end
	end
	
	if not accountInfo then
		local data, status = exports.cr_json:jsonGet("account_info", true)
		
		if status then
			if data.rememberMe then
				textBoxes["login_username"][1] = tostring(data.username)
				textBoxes["login_username"][2] = true
				textBoxes["login_password"][1] = tostring(data.password)
				textBoxes["login_password"][2] = true
				_rememberMe = true
				rememberMeCheckbox.checked = true
			else
				_rememberMe = false
				rememberMeCheckbox.checked = false
			end
		end
		
		accountInfo = true
	end
end

function renderLoading()
	exports.cr_ui:drawSpinner({
        position = {
            x = (screenSize.x - 128) / 2,
            y = (screenSize.y - 128) / 2
        },
        size = 128,
        speed = 2,
        variant = 'solid',
        color = 'white',
		postGUI = true
    })
end

--==================================================================================================================

function eventWrite(...)
    write(...)
end

function write(char)
	if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] then
		if not isLoading then
			local text = textBoxes[selectedTextBox][1]
			if #text <= 20 then
				textBoxes[selectedTextBox][1] = (textBoxes[selectedTextBox][1] .. char):gsub(" ", "")
				playSound(":cr_ui/public/sounds/key.mp3")
			end
		end
	end
end

function removeCharacter(key, state)
    if key == "backspace" and state then
        if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] then
			if not isLoading then
				local text = textBoxes[selectedTextBox][1]
				if #text > 0 then
					textBoxes[selectedTextBox][1] = string.sub(text, 1, #text - 1)
					playSound(":cr_ui/public/sounds/key.mp3")
				end
			end
        end
    end
end

function enterKey(key, state)
    if (key == "enter" and state) and (clickTick + 600 <= getTickCount()) and not isLoading then
        if selectedPage == 1 then
			clickTick = getTickCount()
			
			if string.match(textBoxes["login_username"][1], "['\"\\%;]") or string.match(textBoxes["login_password"][1], "['\"\\%;]") then
                textBoxes["login_username"][1] = ""
                textBoxes["login_password"][1] = ""
				exports.cr_infobox:addBox("error", "Kullanılamaz karakterler tespit edildi.")
                return
            end

            if textBoxes["login_username"][1] == "" or textBoxes["login_password"][1] == "" then
                if textBoxes["login_username"][1] == "" then
                    exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
                end

                if textBoxes["login_password"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
                end

                return
            end

            if string.len(textBoxes["login_username"][1]) < 3 or string.len(textBoxes["login_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["login_password"][1]) < 3 or string.len(textBoxes["login_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Üst üste çok işlem yaptınız, 3 saniye bekleyin.")
                return
            end

            spamTimer = setTimer(function() end, 3000, 1)
			
			isLoading = true
			addEventHandler("onClientRender", root, renderLoading)
			triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
			
			if rememberMeCheckbox.checked then
				exports.cr_json:jsonSave("account_info", { username = textBoxes["login_username"][1], password = textBoxes["login_password"][1], rememberMe = rememberMeCheckbox.checked }, true)
			end
        elseif selectedPage == 2 then
			clickTick = getTickCount()
			
			if string.match(textBoxes["register_username"][1], "['\"\\%;]") or string.match(textBoxes["register_password"][1], "['\"\\%;]") or string.match(textBoxes["register_password_again"][1], "['\"\\%;]") then
                textBoxes["register_username"][1] = ""
                textBoxes["register_password"][1] = ""
				exports.cr_infobox:addBox("error", "Kullanılamaz karakterler tespit edildi.")
                return
            end

            if textBoxes["register_username"][1] == "" or textBoxes["register_password"][1] == "" or textBoxes["register_password_again"][1] == "" then
                if textBoxes["register_username"][1] == "" then
                    exports.cr_infobox:addBox("error", "Kullanıcı adı boş bırakılamaz.")
                end

                if textBoxes["register_password"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre boş bırakılamaz.")
                end
				
                if textBoxes["register_password_again"][1] == "" then
                    exports.cr_infobox:addBox("error", "Şifre tekrarı boş bırakılamaz.")
                end

                return
            end

            if string.len(textBoxes["register_username"][1]) < 3 or string.len(textBoxes["register_username"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Kullanıcı adı 3 ile 32 karakter arasında olmalıdır.")
                return
            end

            if string.len(textBoxes["register_password"][1]) < 6 or string.len(textBoxes["register_password"][1]) > 32 then
                exports.cr_infobox:addBox("error", "Şifre 6 ile 32 karakter arasında olmalıdır.")
                return
            end
			
			if textBoxes["register_password"][1] ~= textBoxes["register_password_again"][1] then
				exports.cr_infobox:addBox("error", "Şifreler eşleşmiyor.")
                return
            end

            if isTransferBoxActive() then
                exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
                return
            end

            if isTimer(spamTimer) then
                exports.cr_infobox:addBox("error", "Üst üste çok işlem yaptınız, 3 saniye bekleyin.")
                return
            end
			
			spamTimer = setTimer(function() end, 3000, 1)
			
			isLoading = true
			addEventHandler("onClientRender", root, renderLoading)
			triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
		end
    end
end

function pasteClipboardText(clipboardText)
	if clipboardText then
		if selectedTextBox ~= "" and textBoxes[selectedTextBox][2] then
			if not isLoading then
				local text = textBoxes[selectedTextBox][1]
				if #text <= 20 then
					textBoxes[selectedTextBox][1] = textBoxes[selectedTextBox][1] .. clipboardText
					playSound(":cr_ui/public/sounds/key.mp3")
				end
			end
		end
	end
end

--==================================================================================================================

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "loggedin") ~= 1 then
		isLoading = true
		addEventHandler("onClientRender", root, renderLoading)
		
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setCameraMatrix(2459.5144042969, -1982.6452636719, 23.969715118408, 2392.5031738281, -1920.1370849609, -16.058067321777)
		fadeCamera(true)
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender", root, renderAccount)
		addEventHandler("onClientRender", root, renderSplash)
		addEventHandler("onClientCharacter", root, eventWrite)
		addEventHandler("onClientKey", root, removeCharacter)
		addEventHandler("onClientKey", root, enterKey)
		addEventHandler("onClientPaste", root, pasteClipboardText)
		
		isLoading = false
		removeEventHandler("onClientRender", root, renderLoading)
	end
end)

addEvent("account.removeLogin", true)
addEventHandler("account.removeLogin", root, function()
    showCursor(false)
    removeEventHandler("onClientRender", root, renderAccount)
    removeEventHandler("onClientRender", root, renderSplash)
    removeEventHandler("onClientCharacter", root, eventWrite)
    removeEventHandler("onClientKey", root, removeCharacter)
    removeEventHandler("onClientKey", root, enterKey)
	removeEventHandler("onClientPaste", root, pasteClipboardText)
end)

addEvent("account.removeLoading", true)
addEventHandler("account.removeLoading", root, function()
    isLoading = false
	removeEventHandler("onClientRender", root, renderLoading)
end)

addEvent("account.spawnCharacterComplete", true)
addEventHandler("account.spawnCharacterComplete", root, function()
	clearChatBox()
	showChat(true)
	showCursor(false)
	fadeCamera(false, 0)
	setCameraTarget(localPlayer, localPlayer)
	addEventHandler("onClientRender", root, renderLoading)

	setTimer(function()
		removeEventHandler("onClientRender", root, renderLoading)
		fadeCamera(true, 2, 0, 0, 0)
		
		if isTimer(music.timer) then killTimer(music.timer)end
		if isElement(music.sound) then destroyElement(music.sound) end

		outputChatBox("[!]#FFFFFF " .. getPlayerName(localPlayer):gsub("_", " ") .. " isimli karakterinize giriş sağlandı.", 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF Keyifli DM'ler ve eğlenceler dileriz.", 0, 255, 0, true)
		
		triggerEvent("playSuccessfulSound", localPlayer)
	end, 2000, 1)
end)

addEventHandler("onClientPlayerChangeNick", root, function(oldNick, newNick)
	if (source == localPlayer) then
		local legitNameChange = getElementData(localPlayer, "legitnamechange")
		if (oldNick ~= newNick) and (legitNameChange == 0) then
			cancelEvent()
			triggerServerEvent("account.resetPlayerName", localPlayer, oldNick, newNick)
		end
	end
end)