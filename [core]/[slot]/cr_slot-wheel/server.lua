addEvent("slot:giveMoney", true)
addEventHandler("slot:giveMoney", root, function(amount)
	if client ~= source then return end
	if getElementData(client, "loggedin") == 1 then
		if amount > 0 then
			exports.cr_global:giveMoney(client, amount)
			exports.cr_discord:sendMessage("kumar-log", "[SLOT] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(amount) .. "$ miktar para kazandı.")
		end
	end
end)

addEvent("slot:takeMoney", true)
addEventHandler("slot:takeMoney", root, function(amount)
	if client ~= source then return end
	if getElementData(client, "loggedin") == 1 then
		if amount > 0 then
			exports.cr_global:takeMoney(client, amount)
			exports.cr_discord:sendMessage("kumar-log", "[SLOT] " .. getPlayerName(client):gsub("_", " ") .. " isimli oyuncu " .. exports.cr_global:formatMoney(amount) .. "$ miktar para kaybetti.")
		end
	end
end)