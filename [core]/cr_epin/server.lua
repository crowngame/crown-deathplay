local epins = {}

function saveFromEpins()
	if (fileExists("epins.json")) then fileDelete("epins.json") end
	local jsonFile = fileCreate("epins.json")
	fileWrite(jsonFile, toJSON(epins, false, "tabs"))
	fileClose(jsonFile)
end
addEventHandler("onResourceStop", resourceRoot, saveFromEpins)

function loadFromEpins()
    local files = fileOpen("epins.json")
    local count = fileGetSize(files)
    local data = fileRead(files, count)
    fileClose(files)
    if #data == 0 then return end
    epins = fromJSON(data)
end
addEventHandler("onResourceStart", resourceRoot, loadFromEpins)

function useEpin(thePlayer, commandName, epin)
    if epin then
		check = checkEpin(epin)
        if check then
            vipLevel = check.value
            if check.type == "vip" then
                if getElementData(thePlayer, "vip") > 0 then
                    outputChatBox("[!]#FFFFFF Zaten VIP üyeliğine sahipsiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                    return
                end
                outputChatBox("[!]#FFFFFF Başarıyla epin ile 30 günlük VIP [" .. vipLevel .. "] aldınız.", thePlayer, 0, 255, 0, true)
                exports.cr_vip:addVIP(thePlayer, vipLevel, 30)
				exports.cr_discord:sendMessage("epin-log", "[EPIN] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. epin .. " numaralı epini kullandı ve 30 günlük VIP [" .. vipLevel .. "] kazandı.")
            elseif check.type == "gun" then
                weaponID = check.value
                local mySerial = exports.cr_global:createWeaponSerial(1, getElementData(thePlayer, "dbid"), getElementData(thePlayer, "dbid"))
                exports.cr_global:giveItem(thePlayer, 115, weaponID .. ":" .. mySerial .. ":" .. getWeaponNameFromID(weaponID) .. "::")
                outputChatBox("[!]#FFFFFF Başarıyla epin ile " .. getWeaponNameFromID(weaponID) .. " markalı silahı aldınız.", thePlayer, 0, 255, 0, true)
				exports.cr_discord:sendMessage("epin-log", "[EPIN] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. epin .. " numaralı epini kullandı ve " .. getWeaponNameFromID(weaponID) .. " markalı silahı kazandı.")
            elseif check.type == "balance" then
                balance = check.value
                outputChatBox("[!]#FFFFFF Başarıyla epin ile hesabınıza " .. balance .. " TL bakiye yüklendi.", thePlayer, 0, 255, 0, true)
                setElementData(thePlayer, "balance", getElementData(thePlayer, "balance") + balance)
                dbExec(exports.cr_mysql:getConnection(), "UPDATE accounts SET balance = ? WHERE id = ?", getElementData(thePlayer, "balance") + balance, getElementData(thePlayer, "dbid"))
				exports.cr_discord:sendMessage("epin-log", "[EPIN] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. epin .. " numaralı epini kullandı ve " .. balance .. " TL bakiye kazandı.")
            end
			deleteEpin(epin)
        else
            outputChatBox("[!]#FFFFFF Hatalı epin numarası girdiniz veya bu epin kullanıldı.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    end
end
addEvent("epin:useEpin", true)
addEventHandler("epin:useEpin", root, useEpin)

function epinEkle(thePlayer, commandName, type, value)
    if accessUsers[getElementData(thePlayer, "account:username")] then
        if not tonumber(type) or not tonumber(value) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Epin Tipi (1-3)] [Silah ID / VIP / Miktar]", thePlayer, 255, 194, 14)
            outputChatBox("[!]#FFFFFF Tip 1 = Silah, Tip 2 = VIP, Tip 3 = Bakiye", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF VIP'ler otomatik 1 aylık verilir, silahta ise miktar yerine silah ID, bakiyedeyse verilecek bakiye miktarı yazın.", thePlayer, 0, 0, 255, true)
			return
        else
            type = tonumber(type)
            value = tonumber(value)
            if (value) < 0 or (value) > 500 then
                outputChatBox("KULLANIM: /" .. commandName .. " [Epin Tipi (1-3)] [Silah ID / VIP / Miktar]", thePlayer, 255, 194, 14)
				outputChatBox("[!]#FFFFFF Tip 1 = Silah, Tip 2 = VIP, Tip 3 = Bakiye", thePlayer, 0, 0, 255, true)
				outputChatBox("[!]#FFFFFF VIP'ler otomatik 1 aylık verilir, silahta ise miktar yerine silah ID, bakiyedeyse verilecek bakiye miktarı yazın.", thePlayer, 0, 0, 255, true)
                return
            end
            if (type) < 1 or (type) > 3 then
                outputChatBox("KULLANIM: /" .. commandName .. " [Epin Tipi (1-3)] [Silah ID / VIP / Miktar]", thePlayer, 255, 194, 14)
				outputChatBox("[!]#FFFFFF Tip 1 = Silah, Tip 2 = VIP, Tip 3 = Bakiye", thePlayer, 0, 0, 255, true)
				outputChatBox("[!]#FFFFFF VIP'ler otomatik 1 aylık verilir, silahta ise miktar yerine silah ID, bakiyedeyse verilecek bakiye miktarı yazın.", thePlayer, 0, 0, 255, true)
                return
            end

            if type == 1 and not gunTable[value] then
                outputChatBox("KULLANIM: /" .. commandName .. " [Epin Tipi (1-3)] [Silah ID / VIP / Miktar]", thePlayer, 255, 194, 14)
				outputChatBox("[!]#FFFFFF Tip 1 = Silah, Tip 2 = VIP, Tip 3 = Bakiye", thePlayer, 0, 0, 255, true)
				outputChatBox("[!]#FFFFFF VIP'ler otomatik 1 aylık verilir, silahta ise miktar yerine silah ID, bakiyedeyse verilecek bakiye miktarı yazın.", thePlayer, 0, 0, 255, true)
                return
            end
             if type == 2 then
                if (value) < 1 or (value) > 5  then
                    outputChatBox("[!]#FFFFFF VIP seviyesi 1-5 arasında olmalıdır.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                    return
                end
            end

            code = addEpin(epinType[type], value)
            if type == 1 then
                outputChatBox("[!]#FFFFFF Başarıyla " .. getWeaponNameFromID(value) .. " markalı silah eklendi.", thePlayer, 0, 255, 0, true)
            elseif type == 2 then
                outputChatBox("[!]#FFFFFF Başarıyla 30 günlük VIP [" .. value .. "] eklendi.", thePlayer, 0, 255, 0, true)
            elseif type == 3 then
                outputChatBox("[!]#FFFFFF Başarıyla " .. value .. " TL bakiye eklendi.", thePlayer, 0, 255, 0, true)
            end
			outputChatBox("[!]#FFFFFF Epin Kodu: " .. code, thePlayer, 0, 0, 255, true)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("epinekle", epinEkle, false, false)

function epinSil(thePlayer, commandName, epin)
    if not (epin) then
        outputChatBox("KULLANIM: /" .. commandName .. " [Epin]", thePlayer, 255, 194, 14)
    else
		deleted = deleteEpin(epin)
        if deleted then
            outputChatBox("[!]#FFFFFF Başarıyla " .. epin .. " numaralı epin silindi.", thePlayer, 0, 255, 0, true)
        else
            outputChatBox("[!]#FFFFFF Hatalı epin numarası girdiniz veya böyle epin bulunmamakta.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    end
end
addCommandHandler("epinsil", epinSil, false, false)

function showEpins(thePlayer, commandName)
    if accessUsers[getElementData(thePlayer, "account:username")] then
        triggerClientEvent(thePlayer, "epin:loadEpins", thePlayer, epins)
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("epinler", showEpins, false, false)

function checkEpin(code)
    if #code < 18 or #code > 18 then
        return false
    end

    for i=1, #epins do
        if epins[i].epin == code then
            return epins[i]
        end
    end
    return false
end

local allowed = { { 48, 57 }, { 65, 90 }, { 97, 122 } }

function generateString(len)
    if tonumber(len) then
        math.randomseed(getTickCount())

        local str = ""
        for i = 1, len do
            local charlist = allowed[math.random(1, 3)]
            str = str .. string.char(math.random(charlist[1], charlist[2]))
        end

        return str
    end
    return false
end

function addEpin(type, value)
    epincode = generateString(18)
	table.insert(epins, {epin = epincode, type = type, value = value})
    return epincode
end

function deleteEpin(code)
    if #code < 18 or #code > 18 then
        return false
    end

    for i=1, #epins do
        if epins[i].epin == code then
          return table.remove(epins, i)
        end
    end
    return false
end