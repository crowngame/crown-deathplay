local mysql = exports.cr_mysql

addEvent("account.requestLogin", true)
addEventHandler("account.requestLogin", root, function(username, password, checkSave)
	if client ~= source then return end
	dbQuery(loginCallback, {client, username, password, checkSave}, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ?", mysql:escape_string(tostring(username)))
end)

function loginCallback(queryHandler, client, username, password, checkSave)
	local result, rows, err = dbPoll(queryHandler, -1)
	if rows > 0 and result[1] then
        data = result[1]
		local encryptedPassword = string.upper(md5(password))
		if data["password"] == encryptedPassword then
			if tonumber(data["banned"]) == 0 then
				if (((tonumber(data["admin"]) > 0) or (tonumber(data["supporter"]) > 0) or (tonumber(data["vct"]) > 0) or (tonumber(data["mapper"]) > 0) or (tonumber(data["scripter"]) > 0)) and (data["mtaserial"] ~= getPlayerSerial(client))) then
					exports.cr_infobox:addBox(client, "error", "Farklı serial'den yetkili hesabına giriş yapamazsınız, lütfen yönetim ekibiyle iletişime geçin.")
					triggerClientEvent(client, "account.removeLoading", client)
					return
				end
				
				setElementData(client, "account:loggedin", true)
				setElementData(client, "account:id", tonumber(data["id"]))
				
				setElementData(client, "account:username", data["username"])
				setElementData(client, "account:charLimit", tonumber(data["characterlimit"]))
				setElementData(client, "electionsvoted", data["electionsvoted"])
				setElementData(client, "account:creationdate", data["registerdate"])
				setElementData(client, "credits", tonumber(data["credits"]))
	
				setElementData(client, "admin_level", tonumber(data["admin"]))
				setElementData(client, "supporter_level", tonumber(data["supporter"]))
				setElementData(client, "vct_level", tonumber(data["vct"]))
				setElementData(client, "mapper_level", tonumber(data["mapper"]))
				setElementData(client, "scripter_level", tonumber(data["scripter"]))
				setElementData(client, "manager", tonumber(data["manager"]))
	
				triggerClientEvent(client, "hud:loadSettings", client)
				triggerClientEvent(client, "nametag:loadSettings", client)
				
				setElementData(client, "charlimit", tonumber(data["charlimit"]))
				setElementData(client, "balance", tonumber(data["balance"]))
				
				setElementData(client, "tamirKit", tonumber(data["tamirKit"]))
				setElementData(client, "rdstats", tonumber(data["rdstats"]))
				
				setElementData(client, "youtuber", tonumber(data["youtuber"]))
				setElementData(client, "dm_plus", tonumber(data["dm_plus"]))
				setElementData(client, "donater", tonumber(data["donater"]))
				
				exports["cr_reports"]:reportLazyFix(client)
				setElementData(client, "adminreports", tonumber(data["adminreports"]))
				setElementData(client, "adminreports_saved", tonumber(data["adminreports_saved"]))
				if tonumber(data["referrer"]) and tonumber(data["referrer"]) > 0 then
					setElementData(client, "referrer", tonumber(data["referrer"]))
				end
				
				setElementData(client, "hiddenadmin", data["hiddenadmin"])
	
				local vehicleConsultationTeam = exports.cr_integration:isPlayerVehicleConsultant(client)
				setElementData(client, "vehicleConsultationTeam", vehicleConsultationTeam)
	
				if tonumber(data["adminjail"]) == 1 then
					setElementData(client, "adminjailed", true)
				else
					setElementData(client, "adminjailed", false)
				end
				setElementData(client, "jailtime", tonumber(data["adminjail_time"]))
				setElementData(client, "jailadmin", data["adminjail_by"])
				setElementData(client, "jailreason", data["adminjail_reason"])
	
				if data["monitored"] ~= "" then
					setElementData(client, "admin:monitor", data["monitored"])
				end

				for i = 1, 6 do
					setElementData(client, "job_level:" .. i, data["jlevel_" .. i])
				end
				
				triggerClientEvent(client, "vehicle_rims", client)
	
				local characters = {}
				dbQuery(function(qh, client)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, value in ipairs(res) do
							if value.cked == 0 then
								local i = #characters + 1
								if not characters[i] then
									characters[i] = {}
								end
	
								characters[i][1] = value.id
								characters[i][2] = value.charactername
								characters[i][3] = value.age
								characters[i][4] = value.gender
								characters[i][5] = value.skin
								characters[i][6] = value.height
								characters[i][7] = value.weight
								characters[i][8] = value.x, value.y, value.z
								characters[i][9] = value.cked
								characters[i][10] = ""
							end
						end
					end
	
					setElementData(client, "account:characters", characters)
					triggerClientEvent(client, "account.loadCharacterSelector", client, characters)
				end, {client}, mysql:getConnection(), "SELECT * FROM characters WHERE account = ?", tonumber(data["id"]))
	
				dbExec(mysql:getConnection(), "UPDATE `accounts` SET `ip`='" .. getPlayerIP(client) .. "', `mtaserial`='" .. getPlayerSerial(client) .. "' WHERE `id`='" ..  tostring(data["id"])  .. "'")
				triggerClientEvent(client, "account.removeLogin", client)
			else
				exports.cr_infobox:addBox(client, "error", "Bu hesap yasaklanmıştır.")
			end
		else
			exports.cr_infobox:addBox(client, "error", username .. " isimli kullanıcı için şifreler eşleşmiyor.")
		end
	else
		exports.cr_infobox:addBox(client, "error", username .. " isimli kullanıcı veritabanında bulunamadı.")
	end
	
	triggerClientEvent(client, "account.removeLoading", client)
end

addEvent("account.requestRegister", true)
addEventHandler("account.requestRegister", root, function(username, password)
	if client ~= source then return end
	
	local mtaSerial = getPlayerSerial(client)
	local password = string.upper(md5(password))
	local ipAddress = getPlayerIP(client)
	
	dbQuery(registerCallback, {client, username, password, mtaSerial, ipAddress, password}, mysql:getConnection(), "SELECT username, mtaserial FROM accounts WHERE (username = ? or mtaserial = ?)", mysql:escape_string(tostring(username)), mysql:escape_string(tostring(mtaSerial)))
end)

function registerCallback(queryHandler, client, username, password, serial, ip, password)
	local result, rows, err = dbPoll(queryHandler, 0)
	if rows > 0 then
		exports.cr_infobox:addBox(client, "error", result[1]["username"] .. " isimli bir hesaba zaten sahipsiniz.")
	else
		dbExec(mysql:getConnection(), "INSERT INTO `accounts` SET `username`='" .. mysql:escape_string(tostring(username)) .. "', `password`='" .. mysql:escape_string(tostring(password)) .. "', `registerdate`=NOW(), `ip`='" .. ip .. "', `mtaserial`='" .. serial .. "', `activated`='1'")
		exports.cr_infobox:addBox(client, "success", "Başarıyla " .. username .. " isimli hesabınız oluşturuldu.")
	end
	triggerClientEvent(client, "account.removeLoading", client)
end

function spawnCharacter(characterID, remoteAccountID, theAdmin, targetAccountName, location)
	if theAdmin then
		client = theAdmin
	end
	
	if not client then
		return false
	end
	
	if not characterID then
		return false
	end
	
	if not tonumber(characterID) then
		return false
	end
	characterID = tonumber(characterID)
	
	triggerEvent("setDrunkness", client, 0)
	setElementData(client, "alcohollevel", 0)

	removeMasksAndBadges(client)
	
	setElementData(client, "pd.jailserved", nil)
	setElementData(client, "pd.jailtime", nil)
	setElementData(client, "pd.jailtimer", nil)
	setElementData(client, "pd.jailstation", nil)
	setElementData(client, "loggedin", 0)
	
	local timer = getElementData(client, "pd.jailtimer")
	if isTimer(timer) then
		killTimer(timer)
	end
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	
	local accountID = tonumber(getElementData(client, "account:id"))
	
	local data = false
	
	if theAdmin then
		accountID = remoteAccountID
		sqlQuery = "SELECT * FROM `characters` WHERE `id`='" .. mysql:escape_string(tostring(characterID)) .. "' AND `account`='" .. mysql:escape_string(tostring(accountID)) .. "'"
	else
		sqlQuery = "SELECT * FROM `characters` WHERE `id`='" .. mysql:escape_string(tostring(characterID)) .. "' AND `account`='" .. mysql:escape_string(tostring(accountID)) .. "' AND `cked`=0"
	end
	
	dbQuery(function(qh, client, characterID, remoteAccountID, theAdmin, targetAccountName, location)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			data = res[1]
			if data then
				if data["description"] then
					setElementData(client, "look", fromJSON(data["description"]) or {"", "", "", "", data["description"], ""})
				end
				
				setElementData(client, "weight", data["weight"])
				setElementData(client, "height", data["height"])
				setElementData(client, "race", tonumber(data["skincolor"]))
				setElementData(client, "maxvehicles", tonumber(data["maxvehicles"]))
				setElementData(client, "maxinteriors", tonumber(data["maxinteriors"]))
				
				setElementData(client, "age", tonumber(data["age"]))
				setElementData(client, "month", tonumber(data["month"]))
				setElementData(client, "day", tonumber(data["day"]))
				
				local country = tonumber(data["country"])
				if country > 0 then
					setElementData(client, "country", country)
				else
					triggerClientEvent(client, "account.countryPanel", client)		
				end
				
				-- LANGUAGES
				local lang1 = tonumber(data["lang1"])
				local lang1skill = tonumber(data["lang1skill"])
				local lang2 = tonumber(data["lang2"])
				local lang2skill = tonumber(data["lang2skill"])
				local lang3 = tonumber(data["lang3"])
				local lang3skill = tonumber(data["lang3skill"])
				local currentLanguage = tonumber(data["currlang"]) or 1
				setElementData(client, "languages.current", currentLanguage, false)
				
				if lang1 == 0 then
					lang1skill = 0
				end
				
				if lang2 == 0 then
					lang2skill = 0
				end
				
				if lang3 == 0 then
					lang3skill = 0
				end
				
				setElementData(client, "languages.lang1", lang1)
				setElementData(client, "languages.lang1skill", lang1skill)
				
				setElementData(client, "languages.lang2", lang2)
				setElementData(client, "languages.lang2skill", lang2skill)
				
				setElementData(client, "languages.lang3", lang3)
				setElementData(client, "languages.lang3skill", lang3skill)
				-- END OF LANGUAGES
				
				setElementData(client, "timeinserver", tonumber(data["timeinserver"]))
				
				setElementData(client, "account:character:id", characterID)
				setElementData(client, "dbid", characterID)
				exports["cr_items"]:loadItems(client, true)
				
				setElementData(client, "loggedin", 1)
				
				local playerWithNick = getPlayerFromName(tostring(data["charactername"]))
				if isElement(playerWithNick) and (playerWithNick ~= client) then
					triggerEvent("savePlayer", playerWithNick)
					if theAdmin then
						kickPlayer(playerWithNick, client, exports.cr_global:getPlayerFullAdminTitle(theAdmin) .. " isimli yetkili hesabınıza giriş yaptı.")
					else
						kickPlayer(playerWithNick, client, "Başkası senin karakterinde oturum açmış olabilir.")
					end
				end
				
				setElementData(client, "bleeding", 0)
				
				setElementData(client, "legitnamechange", 1)
				setPlayerName(client, tostring(data["charactername"]))
				local pid = getElementData(client, "playerid")
				local fixedName = string.gsub(tostring(data["charactername"]), "_", " ")
				setElementData(client, "legitnamechange", 0)
				
				setPlayerNametagShowing(client, false)
				setElementFrozen(client, true)
				setPedGravity(client, 0.008)
				
				local locationToSpawn = {}
				if location then
					locationToSpawn.x = location[1]
					locationToSpawn.y = location[2]
					locationToSpawn.z = location[3]
					locationToSpawn.rot = location[4]
					locationToSpawn.int = location[5]
					locationToSpawn.dim = location[6]
				else
					locationToSpawn.x = tonumber(data["x"])
					locationToSpawn.y = tonumber(data["y"])
					locationToSpawn.z = tonumber(data["z"])
					locationToSpawn.rot = tonumber(data["rotation"])
					locationToSpawn.int = tonumber(data["interior_id"])
					locationToSpawn.dim = tonumber(data["dimension_id"])
				end
				spawnPlayer(client, locationToSpawn.x, locationToSpawn.y, locationToSpawn.z, locationToSpawn.rot, tonumber(data["skin"]))
				setElementDimension(client, locationToSpawn.dim)
				setElementInterior(client, locationToSpawn.int, locationToSpawn.x, locationToSpawn.y, locationToSpawn.z)
				setCameraInterior(client, locationToSpawn.int)

				exports.cr_items:loadItems(client)

				setCameraTarget(client, client)
				if tonumber(data["health"]) < 20 then
					setElementHealth(client, 20)
				else
					setElementHealth(client, tonumber(data["health"]))
				end
				setPedArmor(client, tonumber(data["armor"]))
				
				local teamElement = nil
				if (tonumber(data["faction_id"]) ~= -1) then
					teamElement = exports.cr_pool:getElement("team", tonumber(data["faction_id"]))
					if not (teamElement) then
						data["faction_id"] = -1
						dbExec(mysql:getConnection(), "UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. tostring(characterID) .. "' LIMIT 1")
					end
				end
				
				if teamElement then
					setPlayerTeam(client, teamElement)
				else
					setPlayerTeam(client, getTeamFromName("Citizen"))
				end

				local adminLevel = getElementData(client, "admin_level")
				local gmLevel = getElementData(client, "account:gmlevel")
				exports.cr_global:updateNametagColor(client)
				
				-- ADMIN JAIL
				local jailed = getElementData(client, "adminjailed")
				local jailws_time = getElementData(client, "jailtime")
				local jailws_by = getElementData(client, "jailadmin")
				local jailws_reason = getElementData(client, "jailreason")

				if location then
					setElementPosition(client, location[1], location[2], location[3])
					setElementPosition(client, location[4], 0, 0)
				end
				
				if jailed then
					local incVal = getElementData(client, "playerid")
					
					setElementDimension(client, 55000 + incVal)
					setElementInterior(client, 6)
					setCameraInterior(client, 6)
					setElementPosition(client, 263.821807, 77.848365, 1001.0390625)
					setPedRotation(client, 267.438446)
					
					setElementData(client, "jailserved", 0, false)
					setElementData(client, "adminjailed", true)
					setElementData(client, "jailreason", jailws_reason, false)
					setElementData(client, "jailadmin", jailws_by, false)
					
					if jailws_time ~= 999 then
						if not getElementData(client, "jailtimer") then
							setElementData(client, "jailtime", jailws_time+1, false)
							triggerEvent("admin:timerUnjailPlayer", client, client)
						end
					else
						setElementData(client, "jailtime", "Unlimited", false)
						setElementData(client, "jailtimer", true, false)
					end
					
					setElementInterior(client, 6)
					setCameraInterior(client, 6)
				end
				
				setElementData(client, "faction", tonumber(data["faction_id"]))
				setElementData(client, "factionMenu", 0)
				
				local factionPerks = type(data["faction_perks"]) == "string" and fromJSON(data["faction_perks"]) or { }
				setElementData(client, "factionPackages", factionPerks)
				setElementData(client, "factionrank", tonumber(data["faction_rank"]))
				setElementData(client, "factionphone", tonumber(data["faction_phone"]))
				setElementData(client, "factionleader", tonumber(data["faction_leader"]))
				
				local factionPerks = type(data["faction_perms"]) == "string" and fromJSON(data["faction_perms"]) or {}
				setElementData(client, "factionperms", factionPerms)
				
				setElementData(client, "businessprofit", 0)
				setElementData(client, "legitnamechange", 0)
				setElementData(client, "muted", tonumber(muted))
				setElementData(client, "minutesPlayed", tonumber(data["minutesPlayed"]))
				setElementData(client, "hoursplayed", tonumber(data["hoursplayed"]))
				setElementData(client, "boxHours", tonumber(data["boxHours"]))
				setElementData(client, "boxCount", tonumber(data["boxCount"]))
				setElementData(client, "mission", tonumber(data["mission"]))
				setElementData(client, "mekanik", tonumber(data["mekanik"]))
				setElementData(client, "blindfold", tonumber(data["blindfold"]))
				setPlayerAnnounceValue(client, "score", data["hoursplayed"])
				setElementData(client, "alcohollevel", tonumber(data["alcohollevel"]) or 0)
				exports.cr_global:setMoney(client, tonumber(data["money"]), true)
				exports.cr_global:checkMoneyHacks(client)
				
				setElementData(client, "tags", (fromJSON(data["tags"] or "")))
				
				setElementData(client, "kills", tonumber(data["kills"]))
				setElementData(client, "deaths", tonumber(data["deaths"]))
				exports.cr_rank:checkPlayerRank(client, false)
				
				setElementData(client, "pass_type", tonumber(data["pass_type"]))
				setElementData(client, "pass_level", tonumber(data["pass_level"]))
				setElementData(client, "pass_xp", tonumber(data["pass_xp"]))
				
				setElementData(client, "vip", 0)
				local resource = getResourceFromName("cr_vip")
				if resource then
					local state = getResourceState(resource)
					if state == "running" then
						setElementData(client, "vip", 0)
						exports.cr_vip:loadVIP(characterID)
					end
				end

				if (tonumber(data["blindfold"]) == 1) then
					fadeCamera(client, false)
				else
					fadeCamera(client, true)
				end

				setElementData(client, "restrain", tonumber(data["cuffed"]))
				setElementData(client, "tazed", false)
				setElementData(client, "realinvehicle", 0)
				
				setElementData(client, "hunger", tonumber(data["hunger"]) or 100)
				setElementData(client, "thirst", tonumber(data["thirst"]) or 100)
				
				setElementData(client, "job", tonumber(data["job"]) or 0)
				setElementData(client, "jobLevel", tonumber(data["jobLevel"]) or 0)
				setElementData(client, "jobProgress", tonumber(data["jobProgress"]) or 0)
				
				if tonumber(data["job"]) == 1 then
					if data["jobTruckingRuns"] then
						setElementData(client, "job-system:truckruns", tonumber(data["jobTruckingRuns"]))
						dbExec(mysql:getConnection(), "UPDATE `jobs` SET `jobTruckingRuns`='0' WHERE `jobCharID`='" .. tostring(characterID) .. "' AND `jobID`='1' ")
					end
					triggerClientEvent(client,"restoreTruckerJob",client)
				end
				triggerEvent("restoreJob", client)
				
				setElementData(client, "license.car", tonumber(data["car_license"]))
				setElementData(client, "license.bike", tonumber(data["bike_license"]))
				setElementData(client, "license.boat", tonumber(data["boat_license"]))
				setElementData(client, "license.pilot", tonumber(data["pilot_license"]))
				setElementData(client, "license.fish", tonumber(data["ficr_license"]))
				setElementData(client, "license.gun", tonumber(data["gun_license"]))
				setElementData(client, "license.gun2", tonumber(data["gun2_license"]))
				
				setElementData(client, "bankmoney", tonumber(data["bankmoney"]))
				setElementData(client, "fingerprint", tostring(data["fingerprint"]))
				setElementData(client, "tag", tonumber(data["tag"]))
				setElementData(client, "gender", tonumber(data["gender"]))
				setElementData(client, "deaglemode", 1)
				setElementData(client, "shotgunmode", 1)
				setElementData(client, "firemode", 0)
				setElementData(client, "hunger", tonumber(data["hunger"]))
				setElementData(client, "poop", tonumber(data["poop"]))
				setElementData(client, "thirst", tonumber(data["thirst"]))
				setElementData(client, "pee", tonumber(data["pee"]))
				setElementData(client, "level", tonumber(data["level"]))
				setElementData(client, "hoursaim", tonumber(data["hoursaim"]))
				setElementData(client, "clothing:id", tonumber(data["clothingid"]) or nil)
				
				if (tonumber(data["restrainedobj"]) > 0) then
					setElementData(client, "restrainedObj", tonumber(data["restrainedobj"]))
				end
				
				if (tonumber(data["restrainedby"]) > 0) then
					setElementData(client, "restrainedBy", tonumber(data["restrainedby"]))
				end

				takeAllWeapons(client)
				triggerEvent("updateLocalGuns", client)
				
				dbQuery(function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, data in ipairs(res) do
							local theVehicle = exports.cr_pool:getElement("vehicle", tonumber(data.id))
							if not theVehicle then
								exports["cr_vehicle"]:reloadVehicle(data.id)
							end
						end
					end
				end, mysql:getConnection(), "SELECT id FROM `vehicles` WHERE deleted=0 AND owner='" .. (data["id"]) .. "'")
				
				setPedStat(client, 70, 999)
				setPedStat(client, 71, 999)
				setPedStat(client, 72, 999)
				setPedStat(client, 74, 999)
				setPedStat(client, 76, 999)
				setPedStat(client, 77, 999)
				setPedStat(client, 78, 999)
				setPedStat(client, 77, 999)
				setPedStat(client, 78, 999)
				
				toggleAllControls(client, true, true, true)
				triggerClientEvent(client, "onClientPlayerWeaponCheck", client)
				setElementFrozen(client, false)
				
				if (tonumber(data["cuffed"]) == 1) then
					toggleControl(client, "sprint", false)
					toggleControl(client, "fire", false)
					toggleControl(client, "jump", false)
					toggleControl(client, "next_weapon", false)
					toggleControl(client, "previous_weapon", false)
					toggleControl(client, "accelerate", false)
					toggleControl(client, "brake_reverse", false)
					toggleControl(client, "aim_weapon", false)
				end
				
				setPedFightingStyle(client, tonumber(data["fightstyle"]))     
				triggerEvent("onCharacterLogin", client, charname, tonumber(data["faction_id"]))
				triggerClientEvent(client, "account.spawnCharacterComplete", client, fixedName, adminLevel, gmLevel, tonumber(data["faction_id"]), tonumber(data["faction_rank"]))
				triggerClientEvent(client, "item:updateclient", client)
				
				setElementAlpha(client, 255)
				
				triggerClientEvent(client, "setPlayerCustomAnimation", client, client, data["customanim"])
				triggerEvent("realism:applyWalkingStyle", client, data["walkingstyle"] or 118, true)
				triggerClientEvent(client, "drawAllMyInteriorBlips", client)
				triggerEvent("playerGetMotds", client)
			end
		end
	end, {client, characterID, remoteAccountID, theAdmin, targetAccountName, location}, mysql:getConnection(), sqlQuery)
end
addEvent("account.spawnCharacter", true)
addEventHandler("account.spawnCharacter", root, spawnCharacter)

function removeMasksAndBadges(client)
    for k, v in ipairs({ exports.cr_items:getMasks(), exports.cr_items:getBadges() }) do
        for kx, vx in pairs(v) do
            if getElementData(client, vx[1]) then
               setElementData(client, vx[1], false)
            end
        end
    end
end

addEvent("account.resetPlayer", true)
addEventHandler("account.resetPlayer", root, function()
    if client ~= source then return end
	
	exports.cr_global:updateNametagColor(source)
	
	for index, value in pairs(getAllElementData(source)) do
		if index ~= "playerid" then
			removeElementData(source, index)
		end
    end

    setElementData(source, "loggedin", 0)
	setElementData(source, "account:loggedin", false)
	setElementData(source, "account:username", "")
	setElementData(source, "account:id", 0)
	setElementData(source, "dbid", false)
	setElementData(source, "admin_level", 0)
	setElementData(source, "hiddenadmin", 0)
	setElementData(source, "globalooc", 1)
	setElementData(source, "muted", 0)
	setElementData(source, "loginattempts", 0)
	setElementData(source, "timeinserver", 0)
	setElementData(source, "chatbubbles", 0)
	setElementData(source, "headTurning", true)
	setElementData(source, "voiceChannel", exports.cr_voice:getDefaultVoiceChannel())
	setElementDimension(source, 9999)
	setElementInterior(source, 0)
end)

addEvent("account.checkCharacterName", true)
addEventHandler("account.checkCharacterName", root, function(player, name)
	if client ~= source then return end
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if (rows > 0) and (res[1] ~= nil) then
			triggerClientEvent(player, "account.receiveCharacterName", player, false, name)
		else
			triggerClientEvent(player, "account.receiveCharacterName", player, true, name)
		end
	end, mysql:getConnection(), "SELECT charactername FROM characters WHERE charactername='" .. name:gsub(" ", "_") .. "'")
end)

function newCharacter(_characterName, _characterDescription, _race, _gender, _skin, _height, _weight, _age, _languageselectws, _month, _day, _location)
	characterName, characterDescription, race, gender, skin, height, weight, age, languageselected, month, day, location = _characterName, _characterDescription, _race, _gender, _skin, _height, _weight, _age, _languageselectws, _month, _day, _location	
	characterName = string.gsub(tostring(characterName), " ", "_")
	dbQuery(function(qh, client, characterName, race, gender, skin, height, weight, age, languageselected, month, day)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			exports.cr_infobox:addBox(client, "error", "Böyle bir karakter bulunuyor.")
		else
			local accountID = getElementData(client, "account:id")
			local accountUsername = getElementData(client, "account:username")
			local fingerprint = md5((characterName) .. accountID .. race .. gender .. age)
			
			if month == "Ocak" then
				month = 1
			end
			
			local walkingstyle = 118
			if gender == 1 then
				walkingstyle = 129
			end
			
			location = { 2034.1220703125 + math.random(3, 6), -1415.0302734375 + math.random(3, 6), 16.9921875, 90, 0, 0, "Crown Deathplay" }
			
			dbExec(mysql:getConnection(), "INSERT INTO `characters` SET `charactername`='" .. mysql:escape_string(tostring(characterName)).. "', `x`='" .. location[1] .. "', `y`='" .. location[2] .. "', `z`='" .. location[3] .. "', `rotation`='" .. location[4] .. "', `interior_id`='" .. location[5] .. "', `dimension_id`='" .. location[6] .. "', `lastarea`='" .. (location[7]) .. "', `gender`='" .. (gender) .. "', `skincolor`='" .. (race) .. "', `weight`='" .. (weight) .. "', `height`='" .. (height) .. "', `description`='', `account`='" .. (accountID) .. "', `skin`='" .. (skin) .. "', `age`='" .. (age) .. "', `fingerprint`='" .. (fingerprint) .. "', `lang1`='" .. (languageselected) .. "', `lang1skill`='100', `currLang`='1' , `month`='" .. (month or "1") .. "', `day`='" .. (day or "1") .. "', `walkingstyle`='" .. (walkingstyle) .. "'")
	
			dbQuery(function(qh, client, characterName, race, gender, skin, height, weight, age, languageselected, month, day)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local id = res[1]["id"]
					setElementData(client, "dbid", id, false)
					exports.cr_global:giveItem(client, 16, skin)
					exports.cr_global:giveItem(client, 152, characterName .. ";" .. (gender == 0 and "Bay" or "Bayan") .. ";" .. exports.cr_global:formatDate(day or 1) .. " " .. exports.cr_global:numberToMonth(month or 1) .. " " .. exports.cr_global:getBirthYearFromAge(age) .. ";" .. fingerprint)
					exports.cr_global:giveItem(client, 160, 1)
			
					setElementData(client, "dbid", nil)
					triggerClientEvent(client, "account.newCharacter", client, 3, tonumber(id))
				end
			end, {client, characterName, race, gender, skin, height, weight, age, languageselected, month, day}, exports.cr_mysql:getConnection(), "SELECT id FROM characters WHERE id = LAST_INSERT_ID()")
		end
	end, {client, characterName, race, gender, skin, height, weight, age, languageselected, month, day}, exports.cr_mysql:getConnection(), "SELECT charactername FROM characters WHERE charactername='" .. (characterName) .. "'")
end
addEvent("account.newCharacter", true)
addEventHandler("account.newCharacter", root, newCharacter)

function adminLoginToPlayerCharacter(thePlayer, commandName, ...)
    if exports.cr_integration:isPlayerLeaderAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
        else
            targetChar = table.concat({...}, "_")
            dbQuery(loginCharacterAdminCallback, {thePlayer, targetChar}, mysql:getConnection(), "SELECT `characters`.`id` AS `targetCharID` , `characters`.`account` AS `targetUserID` , `accounts`.`admin` AS `targetAdminLevel`, `accounts`.`username` AS `targetUsername`, `characters`.`charactername` AS `targetCharacterName` FROM `characters` LEFT JOIN `accounts` ON `characters`.`account`=`accounts`.`id` WHERE `charactername`='" .. mysql:escape_string(tostring(targetChar)) .. "' LIMIT 1")
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("loginto", adminLoginToPlayerCharacter, false, false)
 
function loginCharacterAdminCallback(qh, thePlayer, name)
	local res, rows, err = dbPoll(qh, 0)
	if rows > 0 and res[1] then
		local fetchData = res[1]
		local targetCharID = tonumber(fetchData["targetCharID"]) or false
        local targetUserID = tonumber(fetchData["targetUserID"]) or false
        local targetAdminLevel = tonumber(fetchData["targetAdminLevel"]) or 0
        local targetUsername = fetchData["targetUsername"] or false
        local targetCharacterName = fetchData["targetCharacterName"] or false
        local theAdminPower = exports.cr_global:getPlayerAdminLevel(thePlayer)
        if targetCharID and  targetUserID then
            local adminTitle = exports.cr_global:getPlayerFullIdentity(thePlayer)
            if targetAdminLevel > theAdminPower then
				outputChatBox("[!]#FFFFFF Sizden daha yüksek yetkiye sahip kişinin karakterine giriş yapamazsın.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				exports.cr_global:sendMessageToAdmins("[GİRİŞ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili yüksek yetkiye sahip bir yetkilinin karakterine girmeye çalıştı (" .. targetUsername .. ").")
				return false
            end
           
			outputChatBox("[!]#FFFFFF Başarıyla " .. targetCharacterName:gsub("_"," ") .. " (" .. targetUsername .. ") isimli oyuncunun karakterine giriş yaptınız.", thePlayer, 0, 255, 0, true)
			exports.cr_global:sendMessageToAdmins("[GİRİŞ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetCharacterName:gsub("_", " ") .. " " .. targetUsername .. " isimli oyuncunun karakterine giriş yaptı.")
			exports.cr_discord:sendMessage("loginto-log", "[LOGINTO] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetCharacterName:gsub("_", " ") .. " " .. targetUsername .. " isimli oyuncunun karakterine giriş yaptı.")
            spawnCharacter(targetCharID, targetUserID, thePlayer, targetUsername)
        end
	else
		outputChatBox("[!]#FFFFFF Karakter adı bulunamadı.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

addEvent("account.requestPlayerInfo", true)
addEventHandler("account.requestPlayerInfo", root, function()
    if client ~= source then return end
    triggerEvent("account.resetPlayer", client)
	dbQuery(function(queryHandler, client)
        local res, rows, err = dbPoll(queryHandler, 0)
        if rows > 0 and res[1] then
            local data = res[1]
            if data then
                local admin = tostring(data.admin) or "Bilinmiyor"
                local reason = tostring(data.reason) or "Bilinmiyor"
                local date = tostring(data.date) or "Bilinmiyor"
                local endTick = tonumber(data.end_tick) or 0
                triggerClientEvent(client, "account.banScreen", client, { admin, reason, date, endTick })
            end
        end
    end, {client}, mysql:getConnection(), "SELECT * FROM bans WHERE serial = ?", mysql:escape_string(tostring(getPlayerSerial(client))))
end)

addEvent("account.resetPlayerName", true)
addEventHandler("account.resetPlayerName", root, function(oldNick, newNick)
	if client ~= source then return end
	setElementData(client, "legitnamechange", 1)
	setPlayerName(client, oldNick)
	setElementData(client, "legitnamechange", 0)
	exports.cr_global:sendMessageToAdmins("[ADM] " .. tostring(oldNick) .. " isimli oyuncu kendi adını değiştirmek için çalıştı, " .. tostring(newNick) .. ".")
end)

addEventHandler("onPlayerJoin", root, function()
	setElementData(source, "loggedin", 0)
	setElementData(source, "account:loggedin", false)
	setElementData(source, "account:username", "")
	setElementData(source, "account:id", 0)
	setElementData(source, "dbid", false)
	setElementData(source, "admin_level", 0)
	setElementData(source, "hiddenadmin", 0)
	setElementData(source, "globalooc", 1)
	setElementData(source, "muted", 0)
	setElementData(source, "loginattempts", 0)
	setElementData(source, "timeinserver", 0)
	setElementData(source, "chatbubbles", 0)
	setElementData(source, "headTurning", true)
	setElementData(source, "voiceChannel", exports.cr_voice:getDefaultVoiceChannel())
	exports.cr_global:updateNametagColor(source)
end)