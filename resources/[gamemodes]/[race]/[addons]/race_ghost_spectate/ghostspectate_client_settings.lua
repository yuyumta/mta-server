Settings = {
	["ghostInfo"] = 1,
	["ghostRouteHighlight"] = 1,
	["ghostCPBlips"] = 1,
	["ghostCPMarkers"] = 1,
	["ghostTimesUpOnFinish"] = 1
}
-------------------------------------------------------------------------------------------------------------------------
function saveSettings()
    local file = xmlLoadFile( "/settings/race_ghost_spectate.xml")
	if not file then
		file = xmlCreateFile("/settings/race_ghost_spectate.xml", "settings")
	end
    for key, val in pairs(Settings) do
        local child = xmlFindChild(file, key, 0)
        if child then
            xmlNodeSetValue(child, tonumber(val))
        else
            child = xmlCreateChild(file, key)
            xmlNodeSetValue(child, tonumber(val))
        end
    end
	xmlSaveFile(file)
    xmlUnloadFile(file)	
end
-------------------------------------------------------------------------------------------------------------------------
function loadSettings()
	local file = xmlLoadFile("/settings/race_ghost_spectate.xml")
	if not file then
		file = xmlCreateFile("/settings/race_ghost_spectate.xml", "settings")
		for key, val in pairs(Settings) do
			local child = xmlCreateChild(file, key)
			xmlNodeSetValue(child, tonumber(val))
		end
		xmlSaveFile(file)
	end
	local cfg = {
		["ghostInfo"] = tonumber(xmlNodeGetValue(xmlFindChild(file, "ghostInfo", 0))),
		["ghostRouteHighlight"] = tonumber(xmlNodeGetValue(xmlFindChild(file, "ghostRouteHighlight", 0))),
		["ghostCPBlips"] = tonumber(xmlNodeGetValue(xmlFindChild(file, "ghostCPBlips", 0))),
		["ghostCPMarkers"] = tonumber(xmlNodeGetValue(xmlFindChild(file, "ghostCPMarkers", 0))),
		["ghostTimesUpOnFinish"] = tonumber(xmlNodeGetValue(xmlFindChild(file, "ghostTimesUpOnFinish", 0)))
	}
	Settings = cfg
	xmlUnloadFile(file)
end