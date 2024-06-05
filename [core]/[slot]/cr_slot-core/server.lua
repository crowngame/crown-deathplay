local mysql = exports.cr_mysql

addEvent("kumar:server", true)
addEventHandler("kumar:server", root, function(state, ...)
    local client = client or source
    if state == "addlog" then
        addLog(client, ...)
    elseif state == "addmoney" then
        exports.cr_global:giveMoney(client, ...)
    elseif state == "takemoney" then
        exports.cr_global:takeMoney(client, ...)
    end
	triggerClientEvent(client, "slot.removeLoading", client)
end)


function addLog(player, out_m, in_m, gametype)
    local dbid = getElementData(player, "dbid") or 0
    local win = (in_m - out_m)
    dbExec(mysql:getConnection(), "INSERT INTO slot_logs (cid, win, gametype) VALUES(?, ?, ?)", dbid, win, gametype)
    dbExec(mysql:getConnection(), "DELETE FROM slot_logs WHERE DATEDIFF(NOW(), history) > 30")
	exports.cr_discord:sendMessage("kumar-log", "[SWEET] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu " .. gametype .. " oynadı ve " .. exports.cr_global:formatMoney(win) .. "$ kazandı/kaybetti.")
end

function loadSlots()
    dbQuery(function(qh)
        local results = dbPoll(qh, -1)
        if results and #results > 0 then
            for _, slotData in ipairs(results) do
                local x, y, z = tonumber(slotData.x), tonumber(slotData.y), tonumber(slotData.z)
                local rx, ry, rz = tonumber(slotData.rx), tonumber(slotData.ry), tonumber(slotData.rz)
                local interior, dimension = tonumber(slotData.interior), tonumber(slotData.dimension)
                local id = tonumber(slotData.id)
                if x and y and z and rx and ry and rz and interior and dimension and id then
                    slotCreate(x, y, z, rx, ry, rz, interior, dimension, id)
                else
                    outputDebugString("Hatalı slot verisi alındı: " .. tostring(slotData.id), 1, 255, 0, 0)
                end
            end
        else
            outputDebugString("Veritabanında slot bulunamadı.", 1, 255, 0, 0)
        end
    end, mysql:getConnection(), "SELECT * FROM slots")
end
addEventHandler("onResourceStart", resourceRoot, loadSlots)

function adm_slot_cmd(player, cmd, state, ...)
    if not exports.cr_integration:isPlayerDeveloper(player) then return end
    if state == "olustur" then
        local x, y, z = getElementPosition(player)
        z = z + 1.9
        local rx, ry, rz = getElementRotation(player)
		rz = rz - 90
        local interior, dimension = getElementInterior(player), getElementDimension(player)
        local elm = slotCreate(x, y, z, rx, ry, rz, interior, dimension)
        local creatorid = getElementData(player, "dbid") or 0
        local tick = getTickCount()
        if dbExec(mysql:getConnection(), "INSERT INTO slots (x, y, z, rx, ry, rz, interior, dimension, creator) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)", x, y, z, rx, ry, rz, interior, dimension, tick) then
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if result then
                    local id = result[1]
                    if id then
                        local id = id.id
                        setElementData(elm, "kumar-slot", id)
                        dbExec(mysql:getConnection(), "UPDATE slots SET creator = ? WHERE id = ?", creatorid, id)
                        outputChatBox("Başarıyla bir slot oluşturdun, slotid: " .. id, player, 255, 255, 255)
                        return
                    end
                end
                outputDebugString("Bir hata meydana geldi, yönetici ile iletişime geçin", 1, 255, 0, 0)
            end, mysql:getConnection(), "SELECT id FROM slots WHERE creator = ?", tick)
        end
    elseif state == "kaldir" then
        local id = tonumber((...))
        if id then
            slotRemove(player, id)
        end
    elseif state == "list" then
        local px, py, pz = getElementPosition(player)
        for _, elm in ipairs(getElementsByType("kumar-slot")) do
            local id = getElementData(elm, "kumar-slot") or -1
            local x, y, z = getElementPosition(elm)
            local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            outputChatBox("Slot ID: " .. id .. ", sana " .. math.ceil(dist) .. " metre uzaklıkta.", player, 255, 255, 255)
        end
    elseif state == "isinlan" then
        local id = tonumber((...))
        if id then
            local elm, obje = getSlotFromID(id)
            if elm then
                local x, y, z = getPositionFromElementOffset(obje, 0, -2, 1)
                local dimension, interior = getElementDimension(elm), getElementInterior(elm)
                setElementPosition(player, x, y, z)
                setElementDimension(player, dimension)
                setElementInterior(player, interior)
            else
                outputChatBox("Bu id'de bir slot bulunamadı!", player, 255, 255, 255)
            end
        end
    end
end
addCommandHandler("slot", adm_slot_cmd)

function slotCreate(x, y, z, rx, ry, rz, interior, dimension, id)
    local z = z - 1
    local obje = createObject(2640, x, y, z - 1, rx, ry, rz - 90)
    setElementData(obje, "slotmachine:texture", "dede")
    setElementCollisionsEnabled(obje, false)
    setTimer(setElementCollisionsEnabled, 3000, 1, obje, true)
    local elm = createElement("kumar-slot")
    setElementPosition(elm, x, y, z)
    setElementData(elm, "kumar-obje", obje)
    setElementDimension(obje, dimension)
    setElementInterior(obje, interior)
    attachElements(elm, obje)
    if id then
        setElementData(elm, "kumar-slot", id)
    end
    return elm
end

function slotRemove(player, id)
    dbQuery(function(qh)
        local results = dbPoll(qh, 0)
        local result = results[1]
        if result then
            local elm, obje = getSlotFromID(id)
            if elm then destroyElement(elm) end
            if obje then destroyElement(obje) end
            outputChatBox("Başarıyla slotid: " .. id .. " silindi.", player, 255, 255, 255)
            dbExec(mysql:getConnection(), "DELETE FROM slots WHERE id = ?", id)
        else
            outputChatBox("Böyle bir slot bulunamadı!", player, 255, 255, 255)
        end
    end, mysql:getConnection(), "SELECT id FROM slots WHERE id = ?", id)
end

function getSlotFromID(id)
    for _, elm in ipairs(getElementsByType("kumar-slot")) do
        local id_ = getElementData(elm, "kumar-slot")
        if id_ == id then
            local obje = getElementData(elm, "kumar-obje")
            return elm, obje
        end
    end
    return false
end

function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)  
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z  
end
