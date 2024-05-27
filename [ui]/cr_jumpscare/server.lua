addCommandHandler("zaferpartisi3131", function(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if targetPlayer == "all" then
			triggerClientEvent(root, "jumpscare.renderUI", root)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				triggerClientEvent(targetPlayer, "jumpscare.renderUI", targetPlayer)
				outputChatBox(inspect(targetPlayer), thePlayer)
			end
		end
	end
end)