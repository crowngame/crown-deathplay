local screenSize = Vector2(guiGetScreenSize())
local spamTimers = {}

function twitterGUI()
	window = guiCreateWindow((screenSize.x - 480) / 2, (screenSize.y - 180) / 2, 480, 180, "Crown Deathplay - Twitter Arayüzü", false)
	guiWindowSetSizable(window, false)

	label = guiCreateLabel(10, 24, 464, 26, "İçerik:", false, window)
	guiLabelSetVerticalAlign(label, "center")
	
	edit = guiCreateEdit(10, 50, 464, 29, "", false, window)
	
	submit = guiCreateButton(10, 89, 464, 34, "Tweet Gönder ($1,000)", false, window)
	guiSetProperty(submit, "NormalTextColour", "FFAAAAAA")
	
	close = guiCreateButton(10, 133, 464, 34, "Kapat", false, window)
	guiSetProperty(close, "NormalTextColour", "FFAAAAAA")
	
	addEventHandler("onClientGUIClick", guiRoot, function()
		if source == close then
			destroyElement(window)
		elseif source == submit then
			if not isTimer(spamTimers[localPlayer]) then
				if exports.cr_global:hasMoney(localPlayer, 1000) then
					if string.len(guiGetText(edit)) > 0 then
						triggerServerEvent("twitter.sendTweet", localPlayer, guiGetText(edit))
						spamTimers[localPlayer] = setTimer(function() end, 5 * 60 * 1000, 1)
					else
						exports.cr_infobox:addBox("error", "İçerik boş bırakılamaz.")
					end
				else
					exports.cr_infobox:addBox("error", "Tweet göndermek için yeterli paranız yok.")
				end
			else
				exports.cr_infobox:addBox("error", "Her 5 dakikada bir tweet gönderebilirsiniz.")
			end
			destroyElement(window)
		end
	end)
end

addCommandHandler("twitter", function()
	twitterGUI()
end, false, false)