local mysql = exports.cr_mysql

addEvent("leaderboard.loadDatas", true)
addEventHandler("leaderboard.loadDatas", root, function(category)
	if category == 1 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT id, charactername, kills, deaths FROM characters ORDER BY kills DESC LIMIT 100")
	elseif category == 2 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT id, charactername, money, bankmoney FROM characters ORDER BY money + bankmoney DESC LIMIT 100")
	elseif category == 3 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT name, turf_kills FROM factions ORDER BY turf_kills DESC LIMIT 100")
	elseif category == 4 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT id, charactername, hoursplayed, minutesPlayed FROM characters ORDER BY hoursplayed DESC LIMIT 100")
	elseif category == 5 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT id, charactername, pass_level FROM characters ORDER BY pass_level DESC LIMIT 100")
	elseif category == 6 then
		dbQuery(loadDatasCallback, {client}, mysql:getConnection(), "SELECT id, username, balance FROM accounts ORDER BY balance DESC LIMIT 100")
	end
end)

function loadDatasCallback(queryHandler, client)
	local result, rows, err = dbPoll(queryHandler, 0)
	if rows > 0 and result then
		triggerClientEvent(client, "leaderboard.loadDatas", client, result)
	end
end