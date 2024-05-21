local screenW, screenH = guiGetScreenSize()

function openWindow()
    if isElement(window) then destroyElement(window) end
    window = guiCreateWindow((screenW - 545) / 2, (screenH - 311) / 2, 545, 205, "Crown Deathplay - E-pin Aktifleştirme Arayüzü", false)
    guiWindowSetSizable(window, false)
	exports.cr_global:centerWindow(window)
    
    editbox = guiCreateEdit((545 - 502) / 2, (220 - 40) / 2, 500, 40, "", false, window)
    guiEditSetMaxLength(editbox, 22)
    closeGUI = guiCreateButton(15, 264, 182, 37, "Kapat", false, window)
    addEventHandler("onClientGUIClick", closeGUI, function()
        destroyElement(window)
        showCursor(false)
    end, false)
    
    go = guiCreateButton((545 - 502) / 2, (285) / 2, 500, 40, "Onayla", false, window)
	
    addEventHandler("onClientGUIClick", go, function()
        guiText = guiGetText(editbox)
        if #guiText < 18 then
            outputChatBox("[!]#FFFFFF Hatalı epin numarası girdiniz veya bu epin kullanıldı.", 255, 0, 0, true)
        else
            triggerServerEvent("epin:useEpin", localPlayer, localPlayer, _, guiText)
        end
    end, false)
	
    text = guiCreateLabel(22, 34, 509, 61, "Merhabalar, discord üzerinden aldığınız kodu buraya yapıştırın ve onaylayın.\nAldığınız ürün direk envanterinize teslim edilecektir bizi desteklediğiniz için teşekkürler!\nÜrün satın almak için discord.gg/crowndp", false, window) 
end

function openManagement()
	if isElement(panelM) then destroyElement(panelM) end
    panelM = guiCreateWindow((screenW - 542) / 2, (screenH - 562) / 2, 542, 562, "Crown Deathplay - Epin Arayüzü", false)
    guiWindowSetSizable(panelM, false)

    gridList = guiCreateGridList(10, 42, 507, 419, false, panelM)
    guiGridListAddColumn(gridList, "Epin", 0.5)
    guiGridListAddColumn(gridList, "Tip", 0.2)
    guiGridListAddColumn(gridList, "Miktar", 0.2)
    
	addEventHandler("onClientGUIDoubleClick", gridList, function()
		local selectedRow, selectedCol = guiGridListGetSelectedItem(gridList)
		local epin = guiGridListGetItemText(Gridlist, selectedRow, selectedCol)
		outputChatBox("[!]#FFFFFF " .. epin .. " numaralı epin kopyalandı.", 0, 255, 0, true)
		setClipboard(epin)
    end, false)
	
    close = guiCreateButton(10, 527, 522, 25, "Kapat", false, panelM)
	
    addEventHandler("onClientGUIClick", close, function()
        destroyElement(panelM)
        showCursor(false)
    end, false)
	
    guiCreateLabel(15, 473, 502, 35, "Epini kopyalamak için çift tıklayın.", false, panelM)    
end

function goManagement(data)
    showCursor(true)
    openManagement()
    for i=1, #data do
        row = guiGridListAddRow(Gridlist)
        guiGridListSetItemText(Gridlist, row, 1, data[i].epin, false, false)
        guiGridListSetItemText(Gridlist, row, 2, epinTypeConvertTR[data[i].type], false, false)
        if data[i].type == "gun" then
            guiGridListSetItemText(Gridlist, row, 3, getWeaponNameFromID(data[i].value), false, false)
        elseif data[i].type == "balance" then
            guiGridListSetItemText(Gridlist, row, 3, (data[i].value) .. " TL", false, false)
        else
            guiGridListSetItemText(Gridlist, row, 3, (data[i].value), false, false)
        end
    end
end
addEvent("epin:loadEpins", true)
addEventHandler("epin:loadEpins", root, goManagement)

function openPanel()
    if guiGetVisible(window) then
		destroyElement(window)
        showCursor(false)
    else
        openWindow()
        showCursor(true)
	end
end
bindKey("F6", "down", openPanel)
addCommandHandler("epin", openPanel)