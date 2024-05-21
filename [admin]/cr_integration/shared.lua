mysql = exports.cr_mysql

TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}

staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Stajyer Yetkili",
		[2] = "Yetkili I",
		[3] = "Yetkili II",
		[4] = "Yetkili III",
		[5] = "Kıdemli Yetkili",
		[6] = "Lider Yetkili",
		[7] = "Genel Yetkili",
		[8] = "Sunucu Sorumlusu",
		[9] = "Developer",
		[10] = "Sunucu Sahibi",
	},

	[2] = {
		[0] = "Oyuncu",
		[1] = "Rehber",
		[2] = "Rehber Sorumlusu",
	},

	[3] = {
		[0] = "Oyuncu",
		[1] = "VCT Member",
		[2] = "VCT Leader",
	},

	[4] = {
		[0] = "Oyuncu",
		[1] = "Script Tester",
		[2] = "Trial Scripter",
		[3] = "Lead Scripter",
	},

	[5] = {
		[0] = "Oyuncu",
		[1] = "Mapper",
		[2] = "Lead Mapper",
	}, 
}

function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end

--================================================================================================================

function isPlayerServerOwner(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 10)
end

function isPlayerDeveloper(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 9)
end

function isPlayerServerManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 8)
end

function isPlayerGeneralAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 7)
end

function isPlayerLeaderAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 6)
end

function isPlayerSeniorAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 5)
end

function isPlayerAdmin3(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 4)
end

function isPlayerAdmin2(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 3)
end

function isPlayerAdmin1(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 2)
end

function isPlayerTrialAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 1)
end

--================================================================================================================

function isPlayerSupporter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 1)
end

function isPlayerSupporterManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 2)
end

--================================================================================================================

function isPlayerTester(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 1)
end

function isPlayerScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 2)
end

function isPlayerLeadScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 3)
end

--================================================================================================================

function isPlayerVCTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 1)
end

function isPlayerVehicleConsultant(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 2)
end

--================================================================================================================

function isPlayerMappingTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 2)
end

function isPlayerMappingTeamMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 1)
end

--================================================================================================================

function isPlayerStaff(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return isPlayerTrialAdmin(player) or isPlayerSupporter(player) or isPlayerScripter(player) or isPlayerVCTMember(player) or isPlayerMappingTeamMember(player)
end

function isPlayerIA(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return false
end

function isPlayerManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local manager = getElementData(player, "manager") or 0
	return (manager == 1)
end

--================================================================================================================

adminTitles = {
	[0] = "Oyuncu",
	[1] = "Stajyer Yetkili",
	[2] = "Yetkili I",
	[3] = "Yetkili II",
	[4] = "Yetkili III",
	[5] = "Kıdemli Yetkili",
	[6] = "Lider Yetkili",
	[7] = "Genel Yetkili",
	[8] = "Sunucu Sorumlusu",
	[9] = "Developer",
	[10] = "Sunucu Sahibi",
}

function getAdminGroups()
	return { SUPPORTER, TRIALADMIN, ADMIN, SENIORADMIN, LEADADMIN }
end

function getAdminTitles()
	return adminTitles
end

function getHelperNumber()
	return SUPPORTER
end

function getAuxiliaryStaffNumbers()
	return table.concat(AUXILIARY_GROUPS, ",")
end

function getAdminStaffNumbers()
	return table.concat(ADMIN_GROUPS, ",")
end

function getAdminTitle(number)
	return adminTitles[number] or "Oyuncu"
end