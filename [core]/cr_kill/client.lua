addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(prevSlot, curSlot)
    if getPedWeapon(localPlayer, curSlot) ~= 0 and getPedWeapon(localPlayer, curSlot) ~= 24 then 
        if getElementInterior(localPlayer) ~= 3 then return end
        if getElementDimension(localPlayer) ~= 313 then return end
        setPedWeaponSlot(localPlayer, 0)
        outputChatBox("[!]#FFFFFF Bu bölgede yalnızca Deagle marka silah kullanabilirsiniz.", 255, 0, 0, true)
        playSoundFrontEnd(4)
    end
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if weapon ~= 0 and weapon ~= 24 then
        if getElementInterior(localPlayer) ~= 3 then return end
        if getElementDimension(localPlayer) ~= 313 then return end
        setPedWeaponSlot(localPlayer, 0)
        outputChatBox("[!]#FFFFFF Bu bölgede yalnızca Deagle marka silah kullanabilirsiniz.", 255, 0, 0, true)
        playSoundFrontEnd(4)
    end
end)