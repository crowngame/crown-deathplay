local start = getTickCount()
local hitmarker = false
local _hitX, _hitY, _hitZ = 0, 0, 0

addEventHandler("onClientPlayerWeaponFire", root, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if hitElement and isElement(hitElement) and source == localPlayer then
		if getElementType(hitElement) == "player" then
			start = getTickCount()
			
			if not hitmarker then
				hitmarker = true
			end
		
			_hitX = hitX
			_hitY = hitY
			_hitZ = hitZ
		end
	end
end)

addEventHandler("onClientRender", root, function()
	if hitmarker then
		local now = getTickCount() - start
		local sx, sy, _ = getScreenFromWorldPosition(_hitX, _hitY, _hitZ)
		
		if sx and now < 700 then
			dxDrawImage(sx - 12.5, sy - 12.5, 25, 25, "public/images/hitmarker.dds")
		elseif now >= 700 then
			hitmarker = false
		end
	end
end)