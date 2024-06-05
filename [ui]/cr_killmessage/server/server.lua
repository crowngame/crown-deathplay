addEventHandler("onPlayerWasted", root, function(ammo, killer, weapon, bodypart)
    if killer and getElementType(killer) == "player" and killer ~= source and weapon then
		local score = getElementData(killer, "score") or 0
		local kr, kg, kb = getPlayerNametagColor(killer)
		local sr, sg, sb = getPlayerNametagColor(source)
		local vip = getElementData(killer, "vip") or 0
        triggerClientEvent(root, "killmessage1.sendKill", root, getPlayerName(killer), getPlayerName(source), weapon, score, { kr, kg, kb }, { sr, sg, sb }, vip)
    end
end)

addEventHandler("onPlayerWasted", root, function(killerWeaponAmmo, killer, deathReason)
    if getElementType(source) ~= "player" then return end

    local killerName, killerNameColor

    if not isElement(killer) or getElementType(killer) ~= "player" then
		killerName = ""
		killerNameColor = {0, 0, 0}
    else
        killerName = getPlayerName(killer)
        killerNameColor = { getPlayerNametagColor(killer) }
    end

    if (deathReason == 19) or (deathReason == 20) or (deathReason == 21) then
        if getElementType(killer) == "player" then
            deathReason = getPedWeapon(killer)
        end
    end

    triggerClientEvent(root, "killmessage2.sendKill", root, killerName, killerNameColor, deathReason, getPlayerName(source), { getPlayerNametagColor(source) })
end)