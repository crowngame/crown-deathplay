categories = {
	{"Kişisel Özellikler"},
	{"Araç Özellikleri"},
	{"Özel Araçlar"},
	{"Silahlar"},
}

personalFeatures = {
	-- icon, name, rgb, price, page/event, server/client
	{"", "İsim Değişikliği", {50, 185, 222}, 70, 1},
	{"", "K. Adı Değişikliği", {234, 163, 83},70 , 2},
	{"", "VIP", {231, 202, 31}, 0, 3},
	{"", "Karakter Slotu (+1)", {45, 218, 157}, 25, "market.buyCharacterSlot", 1},
	{"", "Araç Slotu (+1)", {45, 218, 157}, 25, "market.buyVehicleSlot", 1},
	{"", "Mülk Slotu (+1)", {45, 218, 157}, 25, "market.buyPropertySlot", 1},
	{"", "History Sildirme (-1)", {232, 113, 114}, 5, "market.buyRemoveHistory", 1},
	{"", "Şans Kutusu", {231, 202, 31}, 0, 4},
	{"", "Özel Rozet", {129, 236, 236}, 100, 5},
	{"", "Elite Pass", {255, 212, 59}, 250, "market.buyElitePass", 1},
}

vehicleFeatures = {
	-- icon, name, rgb, price, page/event, server/client
	{"", "Plaka Değişikliği", {255, 212, 59}, 30, 1},
	{"", "Cam Filmi", {255, 212, 59}, 40, 2},
	{"", "Neon Sistemi", {255, 212, 59}, 60, "neon.showList", 2},
	{"", "Kaplama Sistemi", {255, 212, 59}, 100, 3},
	{"", "Kelebek Kapı", {255, 212, 59}, 35, 4},
	{"", "Plaka Tasarımı", {255, 212, 59}, 40, "plateDesign.showList", 2},
}

privateVehicles = {
	-- name, model, id, price
	{"Mercedes Maybach", 516, 1023, 450},
	{"Helikopter", 487, 413, 400},
	{"Audi A7", 529, 301, 290},
	{"Cadillac Esclade", 400, 113, 250},
	{"Mercedes-Benz G63", 479, 771, 250},
	{"Volkswagen Passat", 540, 628, 230},
	{"Land Rover Range Rover", 490, 1010, 230},
	{"BMW M4", 412, 526, 220},
	{"Nissan GTR", 474, 203, 200},
	{"Mercedes AMG GTR", 602, 520, 200},
	{"BMW i8", 527, 666, 150},
}

privateWeapons = {
	-- name, model, id, price
	{"Sniper", 358, 34, 250},
	{"Rifle", 357, 33, 200},
	{"M4", 356, 31, 150},
	{"AK-47", 355, 30, 100},
	{"Shotgun", 349, 25, 75},
	{"Tec-9", 372, 32, 50},
	{"Uzi", 352, 28, 50},
	{"Deagle", 348, 24, 25},
}

vips = {
	-- vip, price
	[1] = 2,
	[2] = 4,
	[3] = 6,
	[4] = 8,
	[5] = 10,
}

luckBoxes = {
	{581, "Bronz Şans Kutusu", 20},
	{582, "Gümüş Şans Kutusu", 40},
	{583, "Altın Şans Kutusu", 60},
	{584, "Elmas Şans Kutusu", 80},
}

function checkValidCharacterName(text)
	local foundSpace, valid = false, true
	local lastChar, current = " ", ""
	for i = 1, #text do
		local char = text:sub(i, i)
		if char == " " then
			if i == #text then
				valid = false
				return false, "İsminizde yanlışlık bulundu."
			else
				foundSpace = true
			end
			
			if #current < 2 then
				valid = false
				return false, "İsminiz çok kısa."
			end
			current = ""
		elseif lastChar == " " then
			if char < "A" or char > "Z" then
				valid = false
				return false, "İsminizde sadece baş harfler büyük olmalıdır."
			end
			current = current .. char
		elseif (char >= "a" and char <= "z") or (char >= "A" and char <= "Z") or (char == "'") then
			current = current .. char
		else
			valid = false
			return false, "İsminizde uygunsuz karakter olmamalıdır."
		end
		lastChar = char
	end
	
	if valid and foundSpace and #text < 30 and #current >= 3 then
		return true, "Başarılı!"
	else
		return false, "İsminiz çok uzun veya çok kısa, 3 - 30 karakter olmalıdır."
	end
end

function checkValidUsername(text)
	if string.len(text) < 3 then
		return false, "Kullanıcı adınız minimum 3 karakter olmalıdır."
	elseif string.len(text) >= 20 then
		return false, "Kullanıcı adınız maximum 20 karakter olmalıdır."
	elseif string.match(text,"%W") then
		return false, "Kullanıcı adınızda uygunsuz karakter olmamalıdır."
	else
		return true, "Başarılı!"
	end
end

function isPrivateVehicle(model)
    for _, vehicle in ipairs(privateVehicles) do
        if model == vehicle[2] then
            return true
        end
    end
    return false
end