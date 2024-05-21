screenSize = Vector2(guiGetScreenSize())

theme = exports.cr_ui:useTheme()
fonts = exports.cr_ui:useFonts()

music = {
	sound = nil,
	timer = nil,
	index = 0,
	beginning = false,
	paused = false,
}

function playMusic()
	if not (music.beginning) then
		music.index = math.random(1, #musics)
		music.sound = playSound(musics[music.index].url, false)
		setSoundVolume(music.sound, 0.5)
		music.beginning = true
	else
		if (music.beginning) and (music.sound) and (not getSoundPosition(music.sound)) then
			music.index = music.index >= #musics and 1 or music.index + 1
			music.sound = playSound(musics[music.index].url, false)
			setSoundVolume(music.sound, 0.5)
		end
	end
end

function convertMusicTime(time)
    local minutes = math.floor(math.modf(time, 3600) / 60)
    local seconds = math.floor(math.fmod(time, 60))
    return string.format("%02d:%02d", minutes, seconds)
end

function secondsToTimeDesc(seconds)
	if seconds then
		local results = {}
		local sec = (seconds % 60)
		local min = math.floor((seconds % 3600) / 60)
		local hou = math.floor((seconds % 86400) / 3600)
		local day = math.floor(seconds / 86400)
		
		if day > 0 then table.insert(results, day .. (day == 1 and " gün" or " gün")) end
		if hou > 0 then table.insert(results, hou .. (hou == 1 and " saat" or " saat")) end
		if min > 0 then table.insert(results, min .. (min == 1 and " dakika" or " dakika")) end
		if sec > 0 then table.insert(results, sec .. (sec == 1 and " saniye" or " saniye")) end
		
		return string.reverse(table.concat(results, ", "):reverse():gsub(" ,", " ev ", 1))
	end
	return ""
end