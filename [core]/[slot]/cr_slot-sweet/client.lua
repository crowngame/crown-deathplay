local panelstate = false

function panelStatement(bind)
    panelstate = not panelstate
    if panelstate then
        if not slot.game then
            askSenario(1, true)
        end
        setSoundVolume(giveSound("background-music.oga", true), 0.2)
        addEventHandler("onClientRender", root, onRender)
        showCursor(true)
    else
        removeEventHandler("onClientRender", root, onRender)
        showCursor(false)
        removeAllSounds()
        setElementData(localPlayer, "slot:durum", nil)
    end
end

addEvent("sweet:panel", true)
addEventHandler("sweet:panel", root, panelStatement)

function onRender()
    if not slot.game then return end
    drawBackground()
end

function buySenario(type, money)
    if checkMoney(money) then
        if type == "freespin" then
            askSenario(11, false, slot.bets[slot.betindex])
        else
            askSenario(1, false, slot.bets[slot.betindex], "farm")
        end
	else
		triggerEvent("slot.removeLoading", client)
    end
end

function askSenario(count, show, bet, farm, scatters)
    triggerServerEvent("slot-asksenario", root, count, show, bet, farm, scatters)
end

function onFarmFinish()
    triggerServerEvent("slot-gamefinished", root)
    juststay = true
    nextspin = false
    winscreen = false
    gamestarted = false
    if givefreespinfromfarm then
        givefreespinfromfarm = false
        freespinfromfarm = true
        askSenario(10, true, slot.bets[slot.betindex], false, true)
        showWinScreen(10, "#00cfbeFREESPINLER", "setfreespin")
    end
end

addEvent("slot-sendsenario", true)
function getSenarioFromServer(senario, show, farm)
    multipliers = {}
    totalwin = 0
    farm = farm
    local t = show and 0 or 150 + (6 * 150)
    if not show then
        skipscreen = getTickCount()
        gamestarted = true
    end
    setTimer(function()
        slot.game, startgame, spincount = senario, getTickCount(), "Yükleniyor..."
        exploded = nil
        explodestreak = 0
        skipscreen = nil
        freespinadded = false
        freespinfromfarm = false
        freespinskipcontrol = {}
        explodeanim = {}
        skipscreen = nil
        gameindex, spinindex = 1, 1
        if not show then
            juststay = nil
            setTimer(function()
                setTimer(function()
                    giveSound("sweet-hit.oga")
                end, 100, 5)
            end, 150, 1)
        else
            juststay = true
        end
    end, t, 1)
end
addEventHandler("slot-sendsenario", root, getSenarioFromServer)

function checkMoney(amount)
    return exports["slot_core"]:getSlotMoney() >= amount
end