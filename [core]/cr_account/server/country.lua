local mysql = exports.cr_mysql

function changeCountry(country)
	if isElement(source) then
		country = tonumber(country)
		if country then
			local dbid = getElementData(source, "dbid")
			setElementData(source, "country", country)
			dbExec(mysql:getConnection(), "UPDATE characters SET country = ? WHERE id = ?", country, dbid)
		end
	end
end
addEvent("account.countryChange", true)
addEventHandler("account.countryChange", root, changeCountry)

function setUlke(thePlayer, commandName, targetPlayer, country)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		country = tonumber(country)
		if country then
			if country >= 0 and country <= 49 then
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					local dbid = getElementData(targetPlayer, "dbid")
					setElementData(targetPlayer, "country", country)
					dbExec(mysql:getConnection(), "UPDATE characters SET country = " .. country .. " WHERE id = " .. dbid)
					
					outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun ülkesi [" .. country .. "] olarak değiştirildi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili ülkenizi [" .. country .. "] olarak değiştirdi.", targetPlayer, 0, 0, 255, true)
				end
			else
				outputChatBox("[!]#FFFFFF Bu sayıya ait bir ülke bulunmuyor.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Ülke ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("setulke", setUlke, false, false)

function ulkeDegistir(thePlayer, commandName)
	triggerClientEvent(thePlayer, "account.countryPanel", thePlayer)
end 
addCommandHandler("ulkedegistir", ulkeDegistir)