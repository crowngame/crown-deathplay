local clickTick = 0
local fonts = {
    main = exports.cr_fonts:getFont("UbuntuRegular", 9),
	awesome = exports.cr_fonts:getFont("FontAwesome", 9)
}

function renderSplash()
	dxDrawImage(0, 0, screenSize.x, screenSize.y, ":cr_ui/public/images/vignette.png", 0, 0, 0, tocolor(255, 255, 255, 220))
	
	dxDrawText("", 48, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 150), 1, fonts.awesome, "center")
	dxDrawText("crown deathplay v" .. exports.cr_global:getScriptVersion(), 38, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 150), 1, fonts.main)
	
	dxDrawText(music.paused and "" or "", 48, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 150), 1, fonts.awesome, "center")
	dxDrawText(music.sound and ((musics[music.index].name or "Müzik") .. (" (" .. convertMusicTime(math.floor(getSoundPosition(music.sound))) .. "/" .. convertMusicTime(math.floor(getSoundLength(music.sound))) .. ")") or "") or "Yükleniyor...", 40, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 150), 1, fonts.main)
	
	if music.sound and not isLoading then
		if exports.cr_ui:inArea(16, screenSize.y - 32, dxGetTextWidth(music.paused and "" or "", 1, fonts.awesome), dxGetFontHeight(1, fonts.awesome)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			clickTick = getTickCount()
			setSoundPaused(music.sound, not music.paused)
			music.paused = not music.paused
		end
	end
end