addEvent("slot-asksenario", true)
addEvent("slot-gamefinished", true)

slot.games = {}
function slot.asksenario(count, show, bet, farm, scatters)
    slot.createsenario(client, count, show, bet, farm, scatters)    
    if bet then
        local amount = farm and bet or bet * 100
        triggerEvent("kumar:server", client, "takemoney", amount)
    end
end
addEventHandler("slot-asksenario", root, slot.asksenario)

function slot.finishgame()
    local join, out = unpack(slot.games[client])
    triggerEvent("kumar:server", client, "addmoney", out)
    triggerEvent("kumar:server", client, "addlog", join, out, "sweetbonanza")
    slot.games[client] = nil
end
addEventHandler("slot-gamefinished", root, slot.finishgame)

function slot.createsenario(player, spinamount, show, bet, farm, scatters)
    slot.game = {}
    multipliers = {}
    totalfreespin = 0
    totalwin = 0
    for i=1, spinamount do
        slot.createscreen(i, show, bet, farm, scatters)
    end
    if totalfreespin > 0 then
        for i=spinamount + 1, (spinamount + 1) + totalfreespin do
            slot.createscreen(i, show, bet)
        end
    end
    if bet and player then
        slot.games[player] = {farm and bet or bet * 100, totalwin}
    end
    if devmode then
        ortalama = (ortalama or 0) + totalwin
        outputChatBox(exports.cr_global:formatMoney(totalwin), root, 255, 255, 255)
    else
        triggerClientEvent(player, "slot-sendsenario", root, slot.game, show, farm)
    end
end

function slot.createscreen(gameindex, show, bet, farm, scatters)
    local self = {
        [1] = {first = {}, remove = nil, anim = nil, add = nil, earn = 0},
    }
    candycounter = {}
    local randomscatters = {}
    if not farm then
        if not scatters then
            for i=1, 4 do
                local randomc, randomi = math.random(1, 6), math.random(1, 5)
                if not randomscatters[randomc] then randomscatters[randomc] = {} end
                if randomscatters[randomc][randomi] then
                    repeat
                        randomi = math.random(1, 5)
                    until not randomscatters[randomc][randomi]
                    randomscatters[randomc][randomi] = true
                else
                    randomscatters[randomc][randomi] = true
                end
            end
        end
    end
    for c=1, 6 do
        self[1].first[c] = {}
        for i=1, 5 do
            local candy = slot.getcandy( farm)
            if gameindex == 1 and not show and randomscatters[c] and randomscatters[c][i] then candy = "candy" else if candy == "candy" then candy = slot.getcandy( farm) end end
            candycounter[candy] = (candycounter[candy] or 0) + 1
            self[1].first[c][i] = candy
        end
    end
    slot.continetosenario(gameindex, 1, self, bet, farm, scatters)
end

function slot.continetosenario(gameindex, spinindex, senario, bet, farm, scatters)
    local canremove
    for candy, count in pairs(candycounter) do 
        if count >= 8 and candy ~= "candy" then 
            if candy ~= "low" and candy ~= "medium" and candy ~= "high" then
                if (farm and true or (scatters and true or gameindex ~= 1)) then
                    local earn = slot.calculateprofit(candy, count, bet, senario[spinindex].first) / (farm and 2 or 1)
                    if earn then
                        senario[spinindex].earn = (senario[spinindex].earn or 0) + earn
                    end
                end
                if not canremove then canremove = {} end
                if (farm and true or (scatters and true or gameindex ~= 1)) then
                    canremove[candy] = true
                    candycounter[candy] = 0
                end
            end
        elseif candy == "candy" and count >= (farm and 4 or 3) then
            if not canremove then canremove = {} end
            if gameindex == 1 and not farm then
                if candy == "candy" then
                    canremove[candy] = true
                    candycounter[candy] = 0
                end
            else
                canremove[candy] = true
                candycounter[candy] = 0
                if candy == "candy" and not farm then  
                    totalfreespin = totalfreespin + 4
                end
            end
        end 
    end
    if canremove then
        local onlycandy = true
        local nexttable = {}
        for candy, v in pairs(canremove) do
            if candy ~= "candy" then onlycandy = nil break end
        end
        senario[spinindex].remove = canremove
        for c, v in pairs(senario[spinindex].first) do
            for i, v in pairs(v) do
                local candy = v
                if canremove[candy] and candy ~= "candy" then
                    if not senario[spinindex].add then senario[spinindex].add = {} end
                    if not senario[spinindex].add[c] then senario[spinindex].add[c] = {} end
                    local newcandy = slot.getcandy( farm)
                    table.insert(senario[spinindex].add[c], newcandy)
                    candycounter[newcandy] = (candycounter[newcandy] or 0) + 1
                else
                    if not nexttable[c] then nexttable[c] = {} end
                    nexttable[c][i] = candy
                end
            end
        end
        if onlycandy then
            slot.game[gameindex] = senario
        else
            local nexttable, animt = slot.setcandysindexs(nexttable, senario[spinindex].add)
            senario[spinindex].anim = animt
            senario[spinindex + 1] = {first = nexttable, remove = nil, anim = nil, add = nil, earn = 0}
            slot.continetosenario(gameindex, spinindex + 1, senario, bet, farm)
        end
    else
        local totalearn = slot.calculateprofitwithoutmultipliers(senario)
        local totalearn = slot.calculateprofitwithmultipliers(totalearn, senario[spinindex].first)
        totalwin = (totalwin or 0) + totalearn
        senario[spinindex].earn = totalearn
        slot.game[gameindex] = senario
    end
end

function slot.calculateprofit(candy, count, bet)
    local t = candys.profits[candy]
    for i, v in ipairs(t) do
        local min, max, amount = unpack(v)
        if count >= min and count <= max then
            return math.ceil(amount * (bet))
        end
    end    
end

function slot.calculateprofitwithoutmultipliers(senario)
    local totalearn = 0
    for i, v in pairs(senario) do
        totalearn = totalearn + v.earn
    end
    return totalearn
end

function slot.calculateprofitwithmultipliers(earn, senario)
    local multipliers
    for c, v in pairs(senario) do
        for i, v in pairs(v) do
            if type(v) == "table" then
                local _, multiplier = unpack(v)
                multipliers = (multipliers or 0) + multiplier
            end
        end
    end
    if not multipliers then multipliers = 1 end
    return earn * multipliers
end

function slot.getcandy(farm)
    if not slot.trymultipliers(farm) then
        local self = slot.candys
        local totalChance = 0
        for _, v in ipairs(self) do
            totalChance = totalChance + v[2]
        end

        local currentChance = 0
        local targetChance = math.random() * totalChance
        for _, v in ipairs(self) do
            currentChance = currentChance + v[2]
            if targetChance <= currentChance then
                return v[1]
            end
        end
    else
        return {slot.getmultipliers()}
    end
end

function slot.trymultipliers(farm)
    local chance = math.random() * (farm and slot.multipliersvaluefarm or slot.multipliersvalue)
    return chance <= 0.5
end

function slot.getmultipliers()
    local self = slot.multipliers
    local totalChance = 0
    for _, v in ipairs(self) do
        totalChance = totalChance + v[2]
    end

    local currentChance = 0
    local targetChance = math.random() * totalChance
    for _, v in ipairs(self) do
        currentChance = currentChance + v[2]
        if targetChance <= currentChance then
            local totalChance = 0
            for _, v in ipairs(v[3]) do
                totalChance = totalChance + v[2]
            end
            local currentChance = 0
            local targetChance = math.random() * totalChance
            for _, s in ipairs(v[3]) do
                currentChance = currentChance + s[2]
                if targetChance <= currentChance then
                    return v[1], s[1]
                end
            end
        end
    end
end

function slot.setcandysindexs(t, add)
    local anim = {}
    for c, v in pairs(t) do
        for i=1, 5 do
            local i = 6 - i
            local value = t[c][i]
            if value then
                if not anim[c] then anim[c] = {} end
                local hi = slot.gethigherindexs(c, i, t)
                if i ~= hi then
                    t[c][i] = nil
                    t[c][hi] = value
                    anim[c][i] = hi
                end
            end
        end
    end
    for c, v in pairs(add) do
        if not t[c] then t[c] = {} end
        for i, v in ipairs(v) do
            t[c][i] = v
        end
    end
    return t, anim
end

function slot.gethigherindexs(c, i, t)
    for _i=1, 5 do
        local _i = 6 - _i
        if _i > i then
            if not t[c][_i] then
                return _i
            end
        end
    end
    return i
end

addCommandHandler("sweetdevmode", function(plr, cmd, st)
    if not exports.cr_integration:isPlayerDeveloper(plr) then return end
    ortalama = 0
    if st == "test" and devmode then
        local macsayisi = 100
        local bet = 10000
        outputChatBox(exports.cr_global:formatMoney(bet * 100) .. "CR bet ile " .. exports.cr_global:formatMoney(macsayisi) .. " maçın sonucu", root, 255, 255, 255)
        for i=1, macsayisi do
            slot.createsenario(nil, 11, nil, bet)    
        end
        outputChatBox(exports.cr_global:formatMoney(macsayisi) .. " kadar maçın ortalama kazancı: " ..  exports.cr_global:formatMoney(ortalama / macsayisi), root, 0, 255, 0)
    elseif st == "state" then
        devmode = not (devmode or false)
        outputChatBox("devmode: " .. (devmode and "açık" or "kapalı"), plr, 255, 0, 0)
    end
end)