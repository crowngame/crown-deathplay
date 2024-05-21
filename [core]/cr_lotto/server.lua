local isActive = false
local joinedPlayers = {}

function lotto(thePlayer, commandName, number)
    if isActive then
        if number and tonumber(number) then
            number = tonumber(math.floor(number))
            if number > 0 and number <= 100 then
                if not joinedPlayers[thePlayer] then
                    joinedPlayers[thePlayer] = number
                    outputChatBox("[!]#FFFFFF Başarıyla [" .. number .. "] sayınız ile lotto'ya katıldınız.", thePlayer, 0, 255, 0, true)
                    triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
                else
                    outputChatBox("[!]#FFFFFF Zaten lotto'ya katıldınız.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Girdiğiniz sayı 1 - 100 arasında olmalıdır.", thePlayer, 255, 0, 0, true)
                playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [1 - 100]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Şuanda aktif bir lotto yok, lütfen " .. getRemainingTime() .. " sonra tekrar deneyin.", thePlayer, 255, 0, 0, true)
        playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("lotto", lotto, false, false)

setTimer(function()
    if not isActive then
        local realTime = getRealTime()
        if realTime.minute == 0 then
            isActive = true
            outputChatBox("[LOTTO]#FFFFFF Lotto şuanda aktif, /lotto [1 - 100] komutuyla şanslı sayınızı tutun.", root, 237, 26, 55, true)
            outputChatBox("[LOTTO]#FFFFFF 5 dakika sonra Lotto açıklanıyor.", root, 237, 26, 55, true)

            setTimer(function()
                isActive = false
                local luckyNumber = math.random(1, 100)
                local hasWinner = false

                for player, number in pairs(joinedPlayers) do
                    if number == luckyNumber then
                        hasWinner = true
                        local randomMoney = math.random(100000, 1000000)
                        exports.cr_global:giveMoney(player, randomMoney)
                        outputChatBox("[LOTTO]#FFFFFF " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu [" .. luckyNumber .. "] şanslı sayısı ile $" .. exports.cr_global:formatMoney(randomMoney) .. " para kazandı.", root, 237, 26, 55, true)
                        exports.cr_discord:sendMessage("lotto-log", "[LOTTO] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu [" .. luckyNumber .. "] şanslı sayısı ile $" .. exports.cr_global:formatMoney(randomMoney) .. " para kazandı.")
                    end
                end
                
                if not hasWinner then
                    outputChatBox("[LOTTO]#FFFFFF Maalesef, [" .. luckyNumber .. "] şanslı sayını kimse bulamadı.", root, 237, 26, 55, true)
                    exports.cr_discord:sendMessage("lotto-log", "[LOTTO] Maalesef, [" .. luckyNumber .. "] şanslı sayını kimse bulamadı.")
                end
            end, 60 * 5000, 1)
        end
    end
end, 1000, 0)

addEventHandler("onPlayerQuit", root, function()
    if joinedPlayers[source] then
        joinedPlayers[source] = nil
    end
end)

function getRemainingTime()
    local realTime = getRealTime()
    local minutes = 59 - realTime.minute
    local seconds = 59 - realTime.second

    if minutes <= 0 then
        return seconds .. " saniye"
    end
    
    return minutes .. " dakika, " .. seconds .. " saniye"
end