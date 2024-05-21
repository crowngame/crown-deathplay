local index = 1
local gameTypes = {
	"█ Eğlenceli Deathplay!",
    "█ En Yüksek FPS!",
	"█ FPS & LAG Sıkıntısı Yok!",
	"█ Crown Deathplay v" .. getScriptVersion(),
	"█ Sezon 6",
}

setTimer(function()
	if index >= #gameTypes then
        index = 1
	else
		index = index + 1
    end
	setGameType(gameTypes[index])
end, 1000 * 5, 0)