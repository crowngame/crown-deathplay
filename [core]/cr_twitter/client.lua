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
					triggerServerEvent("twitter.sendTweet", localPlayer, guiGetText(edit))
					spamTimers[localPlayer] = setTimer(function() end, 5 * 60 * 1000, 1)
				else
					outputChatBox("[!]#FFFFFF Tweet göndermek için yeterli paranız yok.", 255, 0, 0, true)
					playSoundFrontEnd(4)
				end
			else
				outputChatBox("[!]#FFFFFF Her 5 dakikada bir tweet gönderebilirsiniz.", 255, 0, 0, true)
				playSoundFrontEnd(4)
			end
			destroyElement(window)
		end
	end)
end

addCommandHandler("twitter", function()
	twitterGUI()
end, false, false)