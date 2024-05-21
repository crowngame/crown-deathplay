function sendTopRightNotification(thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown) --Server-side
	triggerClientEvent(thePlayer, "hudOverlay:drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end