function canAccessManager(thePlayer)
	if not thePlayer then
		thePlayer = localPlayer
	end
	
	if not localPlayer then
		return false
	end
	
	if exports.cr_integration:isPlayerSeniorAdmin(thePlayer) then
		return true
	end
	return false
end