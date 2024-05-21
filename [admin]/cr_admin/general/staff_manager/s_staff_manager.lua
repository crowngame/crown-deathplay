local mysql = exports.cr_mysql
local staffTitles = exports.cr_integration:getStaffTitles()

function getStaffInfo(username, error)
	local user = mysql:query_fetch_assoc("SELECT id, username, admin, supporter, vct, scripter, mapper FROM accounts WHERE username='" .. mysql:escape_string(username) .. "'")
	local changelogs = {}
	local mQuery1 = nil
	mQuery1 = mysql:query("SELECT (CASE WHEN to_rank>from_rank THEN 1 ELSE 0 END) AS promoted, s.id, a1.username, team, from_rank, to_rank, a2.username AS `by`, details, DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS date FROM staff_changelogs s LEFT JOIN accounts a1 ON s.userid=a1.id LEFT JOIN accounts a2 ON s.`by`=a2.id WHERE s.userid=" .. user.id .. " ORDER BY id DESC")
	while true do
		local row = mysql:fetch_assoc(mQuery1)
		if not row then break end
		table.insert(changelogs, row)
	end
	mysql:free_result(mQuery1)
	local staffInfo = {}
	staffInfo.user = user
	staffInfo.changelogs = changelogs
	staffInfo.error = error
	triggerClientEvent(source, "staff.openStaffManager", source, staffInfo)
end
addEvent("staff.getStaffInfo", true)
addEventHandler("staff.getStaffInfo", root, getStaffInfo)

function getTeamsData()
	staffTitles = exports.cr_integration:getStaffTitles()
	local users = {}
	local q = mysql:query("SELECT a.id, username, admin, supporter, vct, scripter, mapper, adminreports, AVG(rating) AS rating, COUNT(f.staff_id) AS feedbacks FROM accounts a LEFT JOIN feedbacks f ON a.id=f.staff_id WHERE admin > 0 OR supporter > 0 OR vct > 0 OR scripter>0 OR mapper>0 GROUP BY a.id ORDER BY admin DESC, adminreports DESC, supporter DESC, vct DESC, scripter DESC, mapper DESC")
	while true do
		local row = mysql:fetch_assoc(q)
		if not row then break end
		for i, k in ipairs(staffTitles) do
			if not users[i] then users[i] = {} end
			if tonumber(row.admin) > 0 and i == 1 then
				if not row.rank then row.rank = {} end
				row.rank[i] = tonumber(row.admin)
				table.insert(users[i], row)
			end
			if tonumber(row.supporter) > 0 and i == 2 then
				if not row.rank then row.rank = {} end
				row.rank[i] = tonumber(row.supporter)
				table.insert(users[i], row)
			end
			if tonumber(row.vct) > 0 and i == 3 then
				if not row.rank then row.rank = {} end
				row.rank[i] = tonumber(row.vct)
				table.insert(users[i], row)
			end
			if tonumber(row.scripter) > 0 and i == 4 then
				if not row.rank then row.rank = {} end
				row.rank[i] = tonumber(row.scripter)
				table.insert(users[i], row)
			end
			if tonumber(row.mapper) > 0 and i == 5 then
				if not row.rank then row.rank = {} end
				row.rank[i] = tonumber(row.mapper)
				table.insert(users[i], row)
			end
		end
	end
	mysql:free_result(q)
	triggerClientEvent(source, "staff.openStaffManager", source, nil, users)
end
addEvent("staff.getTeamsData", true)
addEventHandler("staff.getTeamsData", root, getTeamsData)

function getChangelogs()
	local changelogs = {}
	local mQuery1 = nil
	mQuery1 = mysql:query("SELECT (CASE WHEN to_rank>from_rank THEN 1 ELSE 0 END) AS promoted, s.id, a1.username, team, from_rank, to_rank, a2.username AS `by`, details, DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS date FROM staff_changelogs s LEFT JOIN accounts a1 ON s.userid=a1.id LEFT JOIN accounts a2 ON s.`by`=a2.id ORDER BY id DESC")
	while true do
		local row = mysql:fetch_assoc(mQuery1)
		if not row then break end
		table.insert(changelogs, row)
	end
	mysql:free_result(mQuery1)
	triggerClientEvent(source, "staff.openStaffManager", source, nil, nil, changelogs)
end
addEvent("staff.getChangelogs", true)
addEventHandler("staff.getChangelogs", root, getChangelogs)

function editStaff(userid, ranks, details)
	if client ~= source then return end
	if not hasPlayerAccess(source) then
		return false
	end
	local error = nil
	if not userid or not tonumber(userid) then
		outputChatBox("[!]#FFFFFF Bir sorun oluştu.", source, 255, 0, 0, true)
		return false
	else
		userid = tonumber(userid)
	end
	local target = nil
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "account:id") == userid then
			target = player
			break
		end
	end
	staffTitles = exports.cr_integration:getStaffTitles()
	local user = mysql:query_fetch_assoc("SELECT id, username, admin, supporter, vct, scripter, mapper FROM accounts WHERE id='" .. mysql:escape_string(userid) .. "'")
	local tail = ''
	if details and string.len(details)>0 then
		details = "'" .. mysql:escape_string(details) .. "'"
	else
		details = "NULL"
	end
	if ranks[1] and ranks[1] ~= tonumber(user.admin) then
		tail = tail .. "admin=" .. ranks[1] .. ","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid=" .. userid .. ", details=" .. details .. ", `by`=" .. getElementData(source, "account:id") .. ", team=1, from_rank=" .. user.admin .. ", to_rank=" .. ranks[1])
		exports.cr_global:sendMessageToStaff("[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[1][tonumber(user.admin)] .. " yetkisinden " .. staffTitles[1][ranks[1]] .. " yetkisine " .. (ranks[1] > tonumber(user.admin) and "terfiledi" or "düşürdü") .. ".", true)
		exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[1][tonumber(user.admin)] .. " yetkisinden " .. staffTitles[1][ranks[1]] .. " yetkisine " .. (ranks[1] > tonumber(user.admin) and "terfiledi" or "düşürdü") .. ".")
		if target then setElementData(target, "admin_level", ranks[1], true) end
	end
	if ranks[2] and ranks[2] ~= tonumber(user.supporter) then
		tail = tail .. "supporter=" .. ranks[2] .. ","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid=" .. userid .. ", details=" .. details .. ", `by`=" .. getElementData(source, "account:id") .. ", team=2, from_rank=" .. user.supporter .. ", to_rank=" .. ranks[2])
		exports.cr_global:sendMessageToStaff("[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[2][tonumber(user.supporter)] .. " yetkisinden " .. staffTitles[2][ranks[2]] .. " yetkisine " .. (ranks[2] > tonumber(user.supporter) and "terfiledi" or "düşürdü") .. ".", true)
		exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[2][tonumber(user.supporter)] .. " yetkisinden " .. staffTitles[2][ranks[2]] .. " yetkisine " .. (ranks[2] > tonumber(user.supporter) and "terfiledi" or "düşürdü") .. ".")exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[2][tonumber(user.supporter)] .. " yetkisinden " .. staffTitles[2][ranks[2]] .. " yetkisine " .. (ranks[2] > tonumber(user.supporter) and "terfiledi" or "düşürdü") .. ".")
		if target then setElementData(target, "supporter_level", ranks[2], true) end
	end
	if ranks[3] and ranks[3] ~= tonumber(user.vct) then
		tail = tail .. "vct=" .. ranks[3] .. ","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid=" .. userid .. ", details=" .. details .. ", `by`=" .. getElementData(source, "account:id") .. ", team=3, from_rank=" .. user.vct .. ", to_rank=" .. ranks[3])
		exports.cr_global:sendMessageToStaff("[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[3][tonumber(user.vct)] .. " yetkisinden " .. staffTitles[3][ranks[3]] .. " yetkisine " .. (ranks[3] > tonumber(user.vct) and "terfiledi" or "düşürdü") .. ".", true)
		exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[3][tonumber(user.vct)] .. " yetkisinden " .. staffTitles[3][ranks[3]] .. " yetkisine " .. (ranks[3] > tonumber(user.vct) and "terfiledi" or "düşürdü") .. ".")
		if target then setElementData(target, "vct_level", ranks[3], true) end
	end
	if ranks[4] and ranks[4] ~= tonumber(user.scripter) then
		tail = tail .. "scripter=" .. ranks[4] .. ","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid=" .. userid .. ", details=" .. details .. ", `by`=" .. getElementData(source, "account:id") .. ", team=4, from_rank=" .. user.scripter .. ", to_rank=" .. ranks[4])
		exports.cr_global:sendMessageToStaff("[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[4][tonumber(user.scripter)] .. " yetkisinden " .. staffTitles[4][ranks[4]] .. " yetkisine " .. (ranks[4] > tonumber(user.scripter) and "terfiledi" or "düşürdü") .. ".", true)
		exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[4][tonumber(user.scripter)] .. " yetkisinden " .. staffTitles[4][ranks[4]] .. " yetkisine " .. (ranks[4] > tonumber(user.scripter) and "terfiledi" or "düşürdü") .. ".")
		if target then setElementData(target, "scripter_level", ranks[4], true) end
	end
	if ranks[5] and ranks[5] ~= tonumber(user.mapper) then
		tail = tail .. "mapper=" .. ranks[5] .. ","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid=" .. userid .. ", details=" .. details .. ", `by`=" .. getElementData(source, "account:id") .. ", team=5, from_rank=" .. user.mapper .. ", to_rank=" .. ranks[5])
		exports.cr_global:sendMessageToStaff("[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[5][tonumber(user.mapper)] .. " yetkisinden " .. staffTitles[5][ranks[5]] .. " yetkisine " .. (ranks[5] > tonumber(user.mapper) and "terfiledi" or "düşürdü") .. ".", true)
		exports.cr_discord:sendMessage("yetki-log", "[YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili " .. user.username .. " isimli kullanıcıyı " .. staffTitles[5][tonumber(user.mapper)] .. " yetkisinden " .. staffTitles[5][ranks[5]] .. " yetkisine " .. (ranks[5] > tonumber(user.mapper) and "terfiledi" or "düşürdü") .. ".")
		if target then setElementData(target, "mapper_level", ranks[5], true) end
	end
	if tail ~= '' then
		tail = string.sub(tail, 1, string.len(tail)-1)
		if not dbExec(mysql:getConnection(), "UPDATE accounts SET " .. tail .. " WHERE id=" .. userid) then
			outputChatBox("[!]#FFFFFF Bir sorun oluştu.", source, 255, 0, 0, true)
			return false
		end
	end
	triggerEvent("staff.getStaffInfo", source, user.username, user.username .. " isimli oyuncunun yetkisi ayarlandı.")
end
addEvent("staff.editStaff", true)
addEventHandler("staff.editStaff", root, editStaff)

function uykVer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "manager") ~= 1 then
						local accountID = getElementData(targetPlayer, "account:id")
						setElementData(targetPlayer, "manager", 1)
						dbExec(mysql:getConnection(), "UPDATE accounts SET manager = ? WHERE id = ?", 1, accountID)
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya ÜYK yetkisi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size ÜYK yetkisi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_global:sendMessageToAdmins("[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya ÜYK yetkisi verdi.")
						exports.cr_discord:sendMessage("yetki-log", "[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya ÜYK yetkisi verdi.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncunun zaten ÜYK yetkisi var.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("uykver", uykVer, false, false)

function uykAl(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		if targetPlayer then
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") then
					if getElementData(targetPlayer, "manager") == 1 then
						local accountID = getElementData(targetPlayer, "account:id")
						setElementData(targetPlayer, "manager", 0)
						dbExec(mysql:getConnection(), "UPDATE accounts SET manager = ? WHERE id = ?", 0, accountID)
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun ÜYK yetkisi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin ÜYK yetkinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_global:sendMessageToAdmins("[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun ÜYK yetkisini aldı.")
						exports.cr_discord:sendMessage("yetki-log", "[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun ÜYK yetkisini aldı.")
					else
						outputChatBox("[!]#FFFFFF Bu oyuncunun zaten ÜYK yetkisi yok.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu karakterine giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("uykal", uykAl, false, false)

function offlineUykVer(thePlayer, commandName, accountName)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		if accountName then
			dbQuery(function(queryHandler)
				local result, rows, err = dbPoll(queryHandler, 0)
				if rows > 0 then
					data = result[1]
					if data then
						if tonumber(data.manager) ~= 1 then
							dbExec(mysql:getConnection(), "UPDATE accounts SET manager = ? WHERE id = ?", 1, tonumber(data.id))
							outputChatBox("[!]#FFFFFF Başarıyla " .. accountName .. " isimli kullanıcıya ÜYK yetkisi verildi.", thePlayer, 0, 255, 0, true)
							exports.cr_global:sendMessageToAdmins("[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountName .. " isimli kullanıcıya ÜYK yetkisi verdi.")
							exports.cr_discord:sendMessage("yetki-log", "[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountName .. " isimli kullanıcıya ÜYK yetkisi verdi.")
						else
							outputChatBox("[!]#FFFFFF Bu kullanıcının zaten ÜYK yetkisi var.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Böyle bir hesap bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? LIMIT 1", accountName)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ouykver", offlineUykVer, false, false)

function offlineUykAl(thePlayer, commandName, accountName)
	if exports.cr_integration:isPlayerManager(thePlayer) then
		if accountName then
			dbQuery(function(queryHandler)
				local result, rows, err = dbPoll(queryHandler, 0)
				if rows > 0 then
					data = result[1]
					if data then
						if tonumber(data.manager) == 1 then
							dbExec(mysql:getConnection(), "UPDATE accounts SET manager = ? WHERE id = ?", 0, tonumber(data.id))
							outputChatBox("[!]#FFFFFF Başarıyla " .. accountName .. " isimli kullanıcının ÜYK yetkisi alındı.", thePlayer, 0, 255, 0, true)				
							exports.cr_global:sendMessageToAdmins("[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountName .. " isimli kullanıcının ÜYK yetkisini aldı.", true)
							exports.cr_discord:sendMessage("yetki", "[ÜYK-YETKİ] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. accountName .. " isimli kullanıcının ÜYK yetkisini aldı.")
						else
							outputChatBox("[!]#FFFFFF Bu kullanıcının zaten ÜYK yetkisi yok.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Böyle bir hesap bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end, mysql:getConnection(), "SELECT * FROM accounts WHERE username = ? LIMIT 1", accountName)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ouykal", offlineUykAl, false, false)

function showUyks(thePlayer, commandName)
    if exports.cr_integration:isPlayerLeaderAdmin(thePlayer) then
        dbQuery(function(queryHandler)
            local result, rows, err = dbPoll(queryHandler, 0)
            if rows > 0 and result then
				outputChatBox("[!]#FFFFFF ÜYK'lar listeleniyor.", thePlayer, 0, 255, 0, true)
				outputChatBox("==============================", thePlayer, 0, 255, 0, true)
				for _, row in ipairs(result) do
                    outputChatBox(">>#FFFFFF " .. row["username"] .. " - " .. exports.cr_integration:getAdminTitle(tonumber(row["admin"])), thePlayer, 0, 255, 0, true)
                end
				outputChatBox("==============================", thePlayer, 0, 255, 0, true)
				outputChatBox(">>#FFFFFF Toplamda " .. rows .. " ÜYK bulunmakta.", thePlayer, 0, 0, 255, true)
            end
        end, mysql:getConnection(), "SELECT * FROM accounts WHERE manager = 1")
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("uyks", showUyks, false, false)