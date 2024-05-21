
function responce()
	triggerClientEvent(source, "legitimateResponceRecived", source)
end
addEvent("tintDemWindows", true)
addEventHandler("tintDemWindows", root, responce)