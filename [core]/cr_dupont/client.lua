local shaders = {}
local accessoires = {watchcro = 1, neckcross = 1, earing = 1, glasses = 1, specsm = 1}

function getPrimaryTextureName(model)
	for k, v in ipairs(engineGetModelTextureNames(model)) do
		if not accessoires[v] then
			return v
		end
	end
end

addEvent("dupont.requestDupont", true)
addEventHandler("dupont.requestDupont", root, function(player, clothing)
	local texName = getPrimaryTextureName(getElementModel(player))
    if not shaders[player] then shaders[player] = dxCreateShader("tex.fx", 0, 0, true, "ped") end
	local texture = dxCreateTexture(clothing)
	engineApplyShaderToWorldTexture(shaders[player], texName, player)
    dxSetShaderValue(shaders[player], "tex", texture)
end)