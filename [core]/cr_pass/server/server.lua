local mysql = exports.cr_mysql

function addMissionValue(thePlayer, missionID, missionValue)
	if thePlayer and missionID and missionValue then
		local characterID = getElementData(thePlayer, "dbid")
		dbQuery(function(qh, thePlayer, characterID, missionID, missionValue)
			local result, rows, err = dbPoll(qh, 0)
			if rows > 0 and result then
				for index, value in ipairs(result) do
					if value.mission_id == missionID then
						if passMissions[missionID][2] > value.mission_value then
							dbExec(mysql:getConnection(), "UPDATE pass_missions SET mission_value = mission_value + ? WHERE id = ?", missionValue, value.id)
							loadDatas(thePlayer)
						end
					end
				end
			else
				dbExec(mysql:getConnection(), "INSERT INTO pass_missions SET character_id = ?, mission_id = ?, mission_value = ?", characterID, missionID, missionValue)
				loadDatas(thePlayer)
			end
		end, {thePlayer, characterID, missionID, missionValue}, mysql:getConnection(), "SELECT * FROM pass_missions WHERE character_id = ? AND mission_id = ?", characterID, missionID)
	end
end

function setMissionValue(thePlayer, missionID, missionValue)
	if thePlayer and missionID and missionValue then
		local characterID = getElementData(thePlayer, "dbid")
		dbQuery(function(qh, thePlayer, characterID, missionID, missionValue)
			local result, rows, err = dbPoll(qh, 0)
			if rows > 0 and result then
				for index, value in ipairs(result) do
					if value.mission_id == missionID then
						if passMissions[missionID][2] > value.mission_value then
							dbExec(mysql:getConnection(), "UPDATE pass_missions SET mission_value = ? WHERE id = ?", missionValue, value.id)
							loadDatas(thePlayer)
						end
					end
				end
			else
				dbExec(mysql:getConnection(), "INSERT INTO pass_missions SET character_id = ?, mission_id = ?, mission_value = ?", characterID, missionID, missionValue)
				loadDatas(thePlayer)
			end
		end, {thePlayer, characterID, missionID, missionValue}, mysql:getConnection(), "SELECT * FROM pass_missions WHERE character_id = ? AND mission_id = ?", characterID, missionID)
	end
end

addEvent("pass.getReward", true)
addEventHandler("pass.getReward", root, function(rewardType, rewardID)
    if client ~= source then return end

    local characterID = getElementData(client, "dbid")
    local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT 1 FROM pass_rewards WHERE character_id = ? AND reward_type = ? AND reward_id = ?", characterID, rewardType, rewardID), -1)
    
    if result and #result > 0 then
        exports.cr_infobox:addBox(client, "error", "Bu ödülü daha önce aldınız.")
        triggerClientEvent(client, "pass.removeLoading", client)
        return
    end

    if (rewardType == 1) or (rewardType == 2) then
        if getElementData(client, "pass_level") >= rewardID then
            local theReward = passRewards[rewardType][rewardID]
            if theReward then
                if theReward[1] == 1 then
                    exports.cr_global:giveMoney(client, theReward[3])
                    exports.cr_infobox:addBox(client, "success", "Başarıyla " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den $" .. exports.cr_global:formatMoney(theReward[3]) .. " miktar parayı aldınız.")
                    exports.cr_discord:sendMessage("pass-log", "[PASS] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den $" .. exports.cr_global:formatMoney(theReward[3]) .. " miktar parayı aldı.")
                elseif theReward[1] == 2 then
                    local serial1 = tonumber(getElementData(client, "dbid"))
                    local serial2 = tonumber(getElementData(client, "dbid"))
                    local mySerial = exports.cr_global:createWeaponSerial(1, serial1, serial2)
                    local itemValue = theReward[3] .. ":" .. mySerial .. ":" .. getWeaponNameFromID(theReward[3]) .. "::"
                    if exports.cr_items:hasSpaceForItem(client, 115, itemValue) then
                        exports.cr_global:giveItem(client, 115, itemValue)
                        exports.cr_infobox:addBox(client, "success", "Başarıyla " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[2] .. " markalı silahı aldınız.")
                        exports.cr_discord:sendMessage("pass-log", "[PASS] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[2] .. " markalı silahı aldı.")
                    else
                        exports.cr_infobox:addBox(client, "error", "Bu ürünü taşıyabilmek için yeterli alana sahip değilsiniz.")
                    end
                elseif theReward[1] == 3 then
                    if exports.cr_items:hasSpaceForItem(client, theReward[3], 1) then
                        exports.cr_global:giveItem(client, theReward[3], 1)
                        exports.cr_infobox:addBox(client, "success", "Başarıyla " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[2]:gsub("\n", " ") .. " aldınız.")
                        exports.cr_discord:sendMessage("pass-log", "[PASS] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[2]:gsub("\n", " ") .. " aldı.")
                    else
                        exports.cr_infobox:addBox(client, "error", "Bu ürünü taşıyabilmek için yeterli alana sahip değilsiniz.")
                    end
                elseif theReward[1] == 4 then
                    setElementData(client, "balance", math.floor(getElementData(client, "balance") + theReward[3]))
                    dbExec(mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(client, "balance"), getElementData(client, "account:id"))
                    exports.cr_infobox:addBox(client, "success", "Başarıyla " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[3] .. " TL Bakiyeyi aldınız.")
                    exports.cr_discord:sendMessage("pass-log", "[PASS] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. rewardID .. ". seviye " .. getPassName(rewardType) .. " Pass'den " .. theReward[3] .. " TL Bakiyeyi aldı.")
                end
                
                dbExec(mysql:getConnection(), "INSERT INTO pass_rewards SET character_id = ?, reward_type = ?, reward_id = ?", characterID, rewardType, rewardID)
                loadDatas(client)
            else
                exports.cr_infobox:addBox(client, "error", "Bir sorun oluştu.")
            end
        else
            exports.cr_infobox:addBox(client, "error", "Bu ödülü almak için yeterli seviyeye sahip değilsiniz.")
        end
    elseif rewardType == 3 then
        local theMission = passMissions[rewardID]
        if theMission then
            local passXP = getElementData(client, "pass_xp") or 0
            if (passXP + theMission[3]) >= 100 then
                local totalXP = passXP + theMission[3]
                local passLevel = getElementData(client, "pass_level") or 1

                while totalXP >= 100 do
                    totalXP = totalXP - 100
                    passLevel = passLevel + 1
                end

                setElementData(client, "pass_xp", totalXP)
                setElementData(client, "pass_level", passLevel)
            else
                setElementData(client, "pass_xp", passXP + theMission[3])
            end
            
            dbExec(mysql:getConnection(), "UPDATE characters SET pass_level = ?, pass_xp = ? WHERE id = ?", getElementData(client, "pass_level"), getElementData(client, "pass_xp"), characterID)
            dbExec(mysql:getConnection(), "INSERT INTO pass_rewards SET character_id = ?, reward_type = ?, reward_id = ?", characterID, rewardType, rewardID)
            loadDatas(client)
            exports.cr_discord:sendMessage("pass-log", "[PASS] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. rewardID .. ". görevden " .. theMission[3] .. " XP'yi aldı.")
            triggerClientEvent(client, "playSuccessfulSound", client)
        else
            exports.cr_infobox:addBox(client, "error", "Bir sorun oluştu.")
        end
    end
    triggerClientEvent(client, "pass.removeLoading", client)
end)

function loadDatas(client)
    local characterID = getElementData(client, "dbid")

    local data1, data2 = nil, nil
    local query1Completed, query2Completed = false, false

    dbQuery(function(qh, client)
        local result, rows, err = dbPoll(qh, 0)
        if rows > 0 and result then
            data1 = result
        end
        query1Completed = true
        checkAndTriggerEvent(client, data1, data2, query1Completed, query2Completed)
    end, {client}, mysql:getConnection(), "SELECT * FROM pass_missions WHERE character_id = ?", characterID)

    dbQuery(function(qh, client)
        local result, rows, err = dbPoll(qh, 0)
        if rows > 0 and result then
            data2 = result
        end
        query2Completed = true
        checkAndTriggerEvent(client, data1, data2, query1Completed, query2Completed)
    end, {client}, mysql:getConnection(), "SELECT * FROM pass_rewards WHERE character_id = ?", characterID)
end
addEvent("pass.loadDatas", true)
addEventHandler("pass.loadDatas", root, loadDatas)

function checkAndTriggerEvent(client, data1, data2, query1Completed, query2Completed)
    if query1Completed and query2Completed then
        triggerClientEvent(client, "pass.loadDatas", client, {data1, data2})
    end
end