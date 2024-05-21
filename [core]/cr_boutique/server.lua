local mysql = exports.cr_mysql

addEvent("boutique.setSkin", true)
addEventHandler("boutique.setSkin", root, function(skinID)
	if client ~= source then return end
	if skinID and tonumber(skinID) then
		if setElementModel(client, skinID) then
			setElementData(client, "skin", skinID)
			dbExec(mysql:getConnection(), "UPDATE characters SET skin = " .. skinID .. " WHERE id = " .. getElementData(client, "dbid"))
			exports.cr_infobox:addBox(client, "success", "Başarıyla [" .. skinID .. "] ID'li kıyafet giyildi.")
		else
			exports.cr_infobox:addBox(client, "error", "Bir sorun oluştu.")
		end
	else
		exports.cr_infobox:addBox(client, "error", "Bir sorun oluştu.")
	end
end)