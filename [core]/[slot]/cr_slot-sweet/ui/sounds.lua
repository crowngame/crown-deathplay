sounds = {}
function giveSound(name, loop)
    if not slot.volume then return end
    sounds[name] = playSound("assets/sounds/" .. name, loop or false)
    return sounds[name]
end


function removeAllSounds()
    for name, v in pairs(sounds) do
        if v and isElement(v) then destroyElement(v) end
    end
end