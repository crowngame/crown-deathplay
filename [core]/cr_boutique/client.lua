local containerSizes = {
	x = 300,
	y = 155
}
local theme = exports.cr_ui:useTheme()
local helperTextValue = ""

local ped = createPed(299, 2016.529296875, -1408.419921875, 16.9921875, 180)
setElementDimension(ped, 0)
setElementInterior(ped, 0)
setElementFrozen(ped, true)
setElementData(ped, "name", "Kıyafet Mağazası")

function renderBoutique()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(renderTimer) then
	        showCursor(true)
	        renderTimer = setTimer(function()
				local window = exports.cr_ui:drawWindow({
					position = {
						x = 0,
						y = 0,
					},
					size = containerSizes,

					centered = true,

					header = {
						title = "Kıyafet Mağazası",
						close = true
					},

					postGUI = false,
				})

				if window.clickedClose then
					showCursor(false)
					killTimer(renderTimer)
				end
				
				local input = exports.cr_ui:drawInput({
					position = {
						x = window.x,
						y = window.y
					},
					size = {
						x = containerSizes.x - 25,
						y = 30,
					},

					variant = "solid",
					color = "green",
					disabled = false,

					name = "skin_shop_id",
					placeholder = "Skin ID",
					helperText = {
						text = helperTextValue,
						color = theme.RED[800]
					},

					postGUI = false
				})
				
				local button = exports.cr_ui:drawButton {
					position = {
						x = window.x,
						y = window.y + 60
					},
					size = {
						x = containerSizes.x - 25,
						y = 30,
					},

					variant = "solid",
					color = "green",
					disabled = false,

					text = "Kullan",

					postGUI = false
				}
				
				if button.pressed then
					helperTextValue = ""
					
					if input.value == "" then
						helperTextValue = "ID bölümü boş bırakılamaz."
						return
					end
					
					if not tonumber(input.value) then
						helperTextValue = "Geçerli bir ID girin."
						return
					end
					
					if not isValidSkin(input.value) then
						helperTextValue = "Geçerli bir ID girin."
						return
					end
					
					triggerServerEvent("boutique.setSkin", localPlayer, tonumber(input.value))
				end
	        end, 0, 0)
	    else
	        killTimer(renderTimer)
	        showCursor(false)
	    end
	end
end

addEvent("boutique.renderUI", true)
addEventHandler("boutique.renderUI", root, function()
	renderBoutique()
end)

function isValidSkin(i)
    local id = tonumber(i)
    assert(id, "Bad argument 1 @ isValidSkin [Number expected, got " .. type(i) .. "]")
    for key,skin in ipairs (getValidPedModels()) do 
        if id == skin then 
            return true
        end 
    end
    return false
end