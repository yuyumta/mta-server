function createWindow()
  GUI = {}
  
  GUI["window"] = guiCreateWindow(0.225,0.225,0.55,0.55,"F3 - Autoteams Manager",true)
  GUI["grid"] = guiCreateGridList(0.0162,0.061,0.7896,0.9178,true,GUI["window"])
  guiGridListSetSelectionMode(GUI["grid"],2)
  guiGridListSetSortingEnabled(GUI["grid"], false)
  addEventHandler("onClientGUIClick", GUI["window"], editCellLostFocus, false )
  
  GUI["col_name"] = guiGridListAddColumn(GUI["grid"],"Team Name",0.3)
  GUI["col_color"] = guiGridListAddColumn(GUI["grid"],"Color",0.15)
  GUI["col_tag"] = guiGridListAddColumn(GUI["grid"],"Tag",0.15)
  GUI["col_group"] = guiGridListAddColumn(GUI["grid"],"Group",0.2)
  GUI["col_required"] = guiGridListAddColumn(GUI["grid"],"Required",0.15)
  addEventHandler("onClientGUIClick", GUI["grid"], editCellLostFocus, false )
  addEventHandler("onClientGUIDoubleClick", GUI["grid"], editCellContent, false )
  
  GUI["btn_load"] = guiCreateButton(0.8165,0.0634,0.1673,0.0728,"Load",true,GUI["window"])
  addEventHandler ("onClientGUIClick", GUI["btn_load"], buttonClicked, false )
  GUI["btn_save"] = guiCreateButton(0.8183,0.8005,0.1655,0.0728,"Save",true,GUI["window"])
  addEventHandler ("onClientGUIClick", GUI["btn_save"], buttonClicked, false )
  GUI["btn_close"] = guiCreateButton(0.8183,0.9038,0.1655,0.0728,"Close",true,GUI["window"])
  addEventHandler ("onClientGUIClick", GUI["btn_close"], buttonClicked, false )
  GUI["btn_add"] = guiCreateButton(0.8183,0.3803,0.1655,0.0728,"Add",true,GUI["window"])
  addEventHandler ("onClientGUIClick", GUI["btn_add"], buttonClicked, false )
  GUI["btn_delete"] = guiCreateButton(0.8183,0.4671,0.1655,0.0728,"Délète",true,GUI["window"])
  addEventHandler ("onClientGUIClick", GUI["btn_delete"], buttonClicked, false )

  guiWindowSetSizable(GUI["window"], false)
  guiWindowSetMovable(GUI["window"], false)
  guiSetVisible(GUI["window"], false)
  open = false
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()) , createWindow)

function editCellAccepted()
  if isElement(GUI["theedit"]) then
    guiGridListSetItemText(GUI["grid"], selectedRow, selectedCol, guiGetText(GUI["theedit"]), false, false)
    if (selectedCol == GUI["col_color"]) then
      guiGridListSetItemColor(GUI["grid"], selectedRow, selectedCol, getColorFromString(guiGetText(GUI["theedit"])))
    end
    destroyElement(GUI["theedit"])
  end
  guiSetInputEnabled(false)
end

function editCellLostFocus()
  if isElement(GUI["theedit"]) then
    destroyElement(GUI["theedit"])
  end
  guiSetInputEnabled(false)
end

function editCellContent()
  selectedRow, selectedCol = guiGridListGetSelectedItem(GUI["grid"])
  
  if (selectedRow ~= -1 and selectedCol ~= -1) then
    local text = guiGridListGetItemText( GUI["grid"], selectedRow, selectedCol )
    local x,y = getCursorPosition()

    if isElement(GUI["theedit"]) then
      destroyElement(GUI["theedit"])
    end
    GUI["theedit"] = guiCreateEdit ( x, y, 0.125, 0.025, text, true)
    addEventHandler("onClientGUIAccepted", GUI["theedit"], editCellAccepted, true)
    addEventHandler("onClientGUIBlur", GUI["theedit"], editCellLostFocus, true)
    guiSetInputEnabled(true)
  end
end

function buttonClicked() 
  if (source == GUI["btn_close"]) then
    wannaTogglePanel()
  end
  if (source == GUI["btn_load"]) then
    triggerServerEvent( "gimmeTheFuckinList", getLocalPlayer())
  end
  if (source == GUI["btn_add"]) then
	  local row = guiGridListAddRow ( GUI["grid"] )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_name"], "-", false, false )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_color"], "#FFFFFF", false, false )
    guiGridListSetItemColor(GUI["grid"], row, GUI["col_color"], getColorFromString("#FFFFFF"))
    guiGridListSetItemText(GUI["grid"], row, GUI["col_tag"], "-", false, false )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_group"], "-", false, false )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_required"], "tag", false, false )
  end
  if (source == GUI["btn_delete"]) then
    local thebadbadrow = guiGridListGetSelectedItem(GUI["grid"])
    guiGridListRemoveRow (GUI["grid"], thebadbadrow)
  end
  if (source == GUI["btn_save"]) then
    local rowCount = guiGridListGetRowCount(GUI["grid"])
    local i = 0
    local theteams = {}
    while i <= rowCount - 1 do
      local teamname = guiGridListGetItemText(GUI["grid"], i, GUI["col_name"])
      theteams[teamname] = {}
      theteams[teamname].name = teamname
		  theteams[teamname].color = guiGridListGetItemText(GUI["grid"], i, GUI["col_color"])
      theteams[teamname].tag = guiGridListGetItemText(GUI["grid"], i, GUI["col_tag"])
      theteams[teamname].aclGroup = guiGridListGetItemText(GUI["grid"], i, GUI["col_group"])
      theteams[teamname].required = guiGridListGetItemText(GUI["grid"], i, GUI["col_required"])
      i = i + 1
    end
    triggerServerEvent( "hereIzDaFuckinList", getLocalPlayer(), theteams)
  end
end

function wannaTogglePanel()
  open = not open
  showCursor ( open )
  guiSetVisible(GUI["window"], open)
  if isElement(GUI["theedit"]) then
    guiSetVisible(GUI["theedit"], open)
  end
  if (open == true) then
    triggerServerEvent( "gimmeTheFuckinList", getLocalPlayer())
  end
end
addEvent("opendaShitForme", true)
addEventHandler("opendaShitForme", getRootElement(), wannaTogglePanel)

function loadDaList(theteams)
  guiGridListClear(GUI["grid"])
	for name,data in pairs(theteams) do
	  local row = guiGridListAddRow ( GUI["grid"] )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_name"], data.name, false, false )
    
    local color = {getColorFromString(data.color)}
		if not color[1] then
			color = {255,255,255}
		end
    guiGridListSetItemText(GUI["grid"], row, GUI["col_color"], data.color, false, false )
    guiGridListSetItemColor(GUI["grid"], row, GUI["col_color"], unpack(color))
    guiGridListSetItemText(GUI["grid"], row, GUI["col_tag"], data.tag, false, false )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_group"], data.aclGroup, false, false )
    guiGridListSetItemText(GUI["grid"], row, GUI["col_required"], data.required, false, false )
  end
end
addEvent("hereIsDaListNub", true)
addEventHandler("hereIsDaListNub", getRootElement(), loadDaList)
