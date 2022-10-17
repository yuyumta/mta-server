function checkForGMSetting(mapInfo)
	local mapRes = mapInfo.resname
	local mapMetaFile = xmlLoadFile(":"..mapRes.."/meta.xml")
	local mapMapAttribute
	local mapMapNode
	local mapFileName
	local isOldMapFormat
	if mapMetaFile then
		mapMapAttribute = xmlFindChild(mapMetaFile, "map", 0)
	end
	if mapMapAttribute then
		mapMapNode = xmlNodeGetAttributes(mapMapAttribute)
	end
	if mapMapNode then
		for name, value in pairs(mapMapNode) do
			if name == "src" then
				mapFileName = value
			end
		end
	end
	if mapMetaFile then
		xmlUnloadFile(mapMetaFile)
	end
	if mapFileName then
		local mapFile = xmlLoadFile(":"..mapRes.."/"..mapFileName.."")
		local totalCPs = getAll("checkpoint")
		local checkpointsAttribute = {}
		local mapCPsNode = {}
		local CPsize = {}
		if mapFile then
			for i = 1, #totalCPs do
				isOldMapFormat = xmlNodeGetAttribute(mapFile, "mod")
				checkpointsAttribute[i] = xmlFindChild(mapFile, "checkpoint", i-1)
				if checkpointsAttribute[i] then
					mapCPsNode[i] = xmlNodeGetAttributes(checkpointsAttribute[i])
				end
				if mapCPsNode[i] then
					for name, value in pairs(mapCPsNode[i]) do
						if name == "size" then
							if isOldMapFormat then
								CPsize[i] = tonumber(value)*4
							elseif not isOldMapFormat then
								CPsize[i] = tonumber(value)
							end
						end
					end
				end
			end
			triggerClientEvent(root, "getCPSizes", resourceRoot, CPsize)
		end
	end
	if mapFile then
		xmlUnloadFile(mapFile)
	end
end
addEventHandler("onMapStarting", root, checkForGMSetting)
-------------------------------------------------------------------------------------------------------------------------
function onPlayerSpawn()
	if not getElementData(source, "firstSpawnDone") then
		setElementData(source, "firstSpawnDone", true)
	end
end
addEventHandler("onPlayerSpawn", root, onPlayerSpawn)