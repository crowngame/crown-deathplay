function canPlayerAccessStaffManager(player)
	return exports.cr_integration:isPlayerTrialAdmin(player) or exports.cr_integration:isPlayerSupporter(player) or exports.cr_integration:isPlayerVCTMember(player) or exports.cr_integration:isPlayerLeadScripter(player) or exports.cr_integration:isPlayerMappingTeamLeader(player)
end

function hasPlayerAccess(player)
	if exports.cr_integration:isPlayerManager(player) then
		return true
	end
	return false
end