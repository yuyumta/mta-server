local ghostVeh, prevX, prevY, prevZ, ghostPosX, ghostPosY, ghostPosZ, lastCP, lastCPPosX, lastCPPosY, lastCPPosZ
local ghostName = "Unknown"
local checkpoints = {}
local CPMarker = {}
local CPBlip = {}
local CPsizes = {}
local originalMarkerSize = {}
local r = {}
local g = {}
local b = {}
local a = {}
local x, y = guiGetScreenSize()
local sx, sy = x/1920, y/1080
-------------------------------------------------------------------------------------------------------------------------
function getGhostData(recording, bestTime, racer, ped, vehicle)
	if vehicle then
		ghostVeh = vehicle
	end
	if racer then
		ghostName = racer
	end
end
addEventHandler("onClientGhostDataReceive", root, getGhostData)
-------------------------------------------------------------------------------------------------------------------------
function specGhost()
	local veh = getPedOccupiedVehicle(localPlayer)
	local state = getElementData(localPlayer, "state")
	local isSpectatingGhost = getElementData(localPlayer, "isSpectatingGhost")
	local isOnSpawn = getElementData(localPlayer, "isOnSpawn")
	local ghostHasHitLastCP = getElementData(localPlayer, "ghostHitLastCP")
	local blips = getElementsByType("blip")
	local markers = getElementsByType("marker")
	local ghostResName = "race_ghost"
	local raceGhostRes = getResourceFromName(ghostResName)
	if raceGhostRes then
		if getResourceState(raceGhostRes) ~= "running" then
			outputChatBox("The '"..ghostResName.."' resource is not started so ghosts cannot be spectated right now.", 255, 255, 255, true)
			return
		end
	else
		outputChatBox("The '"..ghostResName.."' resource is not started so ghosts cannot be spectated right now.", 255, 255, 255, true)
		return
	end
	if ghostVeh and ghostVeh ~= nil then
		if isOnSpawn == false then
			if ghostHasHitLastCP == false then
				if isSpectatingGhost == true then
					if state == "nolifing" then
						if blips and #blips > 0 then
							for i = 1, #blips do
								if isElement(blips[i]) then
									if r[i] and g[i] and b[i] and a[i] then
										local red, green, blue, alpha = r[i], g[i], b[i], a[i]
										if red and green and blue and alpha then
											setBlipColor(blips[i], red, green, blue, alpha)
										end
									end
								end
							end
						end
						for i = 1, #markers do
							if originalMarkerSize[i] then
								setMarkerSize(markers[i], originalMarkerSize[i])
							end
						end
						setCameraTarget(localPlayer)
						if veh and prevX and prevY and prevZ then
							setElementPosition(veh, prevX, prevY, prevZ+1)
							prevX = nil
							prevY = nil
							prevZ = nil
						end
						setElementData(localPlayer, "state", "alive")
						setCameraTarget(localPlayer)
						setElementData(localPlayer, "isSpectatingGhost", false)
						if isElementFrozen(veh) then
							setElementFrozen(veh, false)
						end
						if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == true then
							removeEventHandler("onClientRender", root, drawGhostInfo)
						end
					end
				elseif isSpectatingGhost == false then
					if state ~= "nolifing" then
						if state == "alive" then
							if blips and #blips > 0 then
								for i = 1, #blips do
									if isElement(blips[i]) then
										r[i], g[i], b[i], a[i] = getBlipColor(blips[i])
										if r[i] and g[i] and b[i] and a[i] then
											setBlipColor(blips[i], r[i], g[i], b[i], 0)
										end
									end
								end
							end
							for i = 1, #markers do
								originalMarkerSize[i] = getMarkerSize(markers[i])
								setMarkerSize(markers[i], 0)
							end
							setElementData(localPlayer, "state", "nolifing")
							if veh then
								prevX, prevY, prevZ = getElementPosition(veh)
								if prevX and prevY and prevZ then
									setTimer(function()
										setElementPosition(veh, prevX, prevY, prevZ+10000)
									end, 200, 1)
								end
							end
							setCameraTarget(ghostVeh)
							setElementData(localPlayer, "isSpectatingGhost", true)
							if not isElementFrozen(veh) then
								setElementFrozen(veh, true)
							end
							if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == false then
								addEventHandler("onClientRender", root, drawGhostInfo)
							end
						elseif state ~= "alive" then
							outputChatBox("You can only initiate ghost spectating when you're in 'alive' state.", 255, 255, 255, true)
							return
						end
					end
				end
			elseif ghostHasHitLastCP == true then
				outputChatBox("The ghost vehicle on this map has already hit the finish line.", 255, 255, 255, true)
				return
			end
		elseif isOnSpawn == true then
			outputChatBox("You cannot spectate the ghost vehicle until the countdown ends.", 255, 255, 255, true)
			return
		end
	elseif not ghostVeh or ghostVeh == nil then
		outputChatBox("This map has no ghost racer yet.", 255, 255, 255, true)
		return
	end
end
bindKey("G", "down", specGhost)
-------------------------------------------------------------------------------------------------------------------------
function fixForSpec()
	local veh = getPedOccupiedVehicle(localPlayer)
	local state = getElementData(localPlayer, "state")
	if state == "nolifing" then
		setCameraTarget(ghostVeh)
		setElementData(localPlayer, "isSpectatingGhost", true)
		if veh and not isElementFrozen(veh) then
			setElementFrozen(veh, true)
		end
		if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == false then
			addEventHandler("onClientRender", root, drawGhostInfo)
		end
	end
end
addCommandHandler("fixforspecghostspec", fixForSpec)
-------------------------------------------------------------------------------------------------------------------------
function onClientDie()
	local veh = getPedOccupiedVehicle(localPlayer)
	local theRealData = getElementData(localPlayer, "state")
	local blips = getElementsByType("blip")
	local markers = getElementsByType("marker")
	if blips and #blips > 0 then
		for i = 1, #blips do
			if isElement(blips[i]) then
				if r[i] and g[i] and b[i] and a[i] then
					local red, green, blue, alpha = r[i], g[i], b[i], a[i]
					if red and green and blue and alpha then
						setBlipColor(blips[i], red, green, blue, alpha)
					end
				end
			end
		end
	end
	for i = 1, #markers do
		if originalMarkerSize[i] then
			setMarkerSize(markers[i], originalMarkerSize[i])
		end
	end
	setCameraTarget(localPlayer)
	if veh and prevX and prevY and prevZ then
		setElementPosition(veh, prevX, prevY, prevZ+1)
		prevX = nil
		prevY = nil
		prevZ = nil
	end
	setElementData(localPlayer, "state", theRealData)
	setCameraTarget(localPlayer)
	setElementData(localPlayer, "isSpectatingGhost", false)
	if isElementFrozen(veh) then
		setElementFrozen(veh, false)
	end
	if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == true then
		removeEventHandler("onClientRender", root, drawGhostInfo)
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, onClientDie)
-------------------------------------------------------------------------------------------------------------------------
addEvent("onClientMapStarting", true)
function onClientMapStarting()
	local ghostHasHitLastCP = getElementData(localPlayer, "ghostHitLastCP")
	if ghostHasHitLastCP == true then
		setElementData(localPlayer, "ghostHitLastCP", false)
	end
	checkpoints = getAll("checkpoint")
	lastCP = checkpoints[#checkpoints]
	if lastCP then
		lastCPPosX, lastCPPosY, lastCPPosZ = unpack(lastCP.position)
	end
	if ghostVeh then
		setElementData(ghostVeh, "ghost.checkpoint", 0)
	end
end
addEventHandler("onClientMapStarting", root, onClientMapStarting)
-------------------------------------------------------------------------------------------------------------------------
addEvent("getCPSizes", true)
function getCPSizes(checkpointSizes)
	CPsizes = checkpointSizes
end
addEventHandler("getCPSizes", root, getCPSizes)
-------------------------------------------------------------------------------------------------------------------------
function mainCode()
	local veh = getPedOccupiedVehicle(localPlayer)
	local state = getElementData(localPlayer, "state")
	local isSpectatingGhost = getElementData(localPlayer, "isSpectatingGhost")
	local ghostHasHitLastCP = getElementData(localPlayer, "ghostHitLastCP")
	local blips = getElementsByType("blip")
	local markers = getElementsByType("marker")
	local ghostCP
	if ghostVeh then
		ghostCP = getElementData(ghostVeh, "ghost.checkpoint")
		ghostPosX, ghostPosY, ghostPosZ = getElementPosition(ghostVeh)
	end
	if isSpectatingGhost == true and state == "alive" then
		setElementData(localPlayer, "state", "nolifing")
	elseif isSpectatingGhost == false and getElementData(source, "firstSpawnDone") == true then
		setElementData(localPlayer, "state", state)
	end
	if ghostPosX and ghostPosY and lastCPPosX and lastCPPosY and CPsizes and #CPsizes == #checkpoints then
		local ghostToLastCPDistance = getDistanceBetweenPoints2D(ghostPosX, ghostPosY, lastCPPosX, lastCPPosY)
		if isSpectatingGhost == true and state == "nolifing" then
			if ghostToLastCPDistance and CPsizes and CPsizes[#checkpoints] and ghostToLastCPDistance < CPsizes[#checkpoints]*2 then
				if ghostHasHitLastCP == false then
					if checkpoints and #checkpoints > 0 then
						if ghostCP == #checkpoints then
							if blips and #blips > 0 then
								for i = 1, #blips do
									if isElement(blips[i]) then
										if r[i] and g[i] and b[i] and a[i] then
											local red, green, blue, alpha = r[i], g[i], b[i], a[i]
											if red and green and blue and alpha then
												setBlipColor(blips[i], red, green, blue, alpha)
											end
										end
									end
								end
							end
							for i = 1, #markers do
								if originalMarkerSize[i] then
									setMarkerSize(markers[i], originalMarkerSize[i])
								end
							end
							setCameraTarget(localPlayer)
							if veh and prevX and prevY and prevZ then
								setElementPosition(veh, prevX, prevY, prevZ+1)
								prevX = nil
								prevY = nil
								prevZ = nil
							end
							setElementData(localPlayer, "state", state)
							setCameraTarget(localPlayer)
							setElementData(localPlayer, "isSpectatingGhost", false)
							if veh and isElementFrozen(veh) then
								setElementFrozen(veh, false)
							end
							if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == true then
								removeEventHandler("onClientRender", root, drawGhostInfo)
							end
							if Settings["ghostTimesUpOnFinish"] == 1 then
								if #getElementsByType("player") > 1 then
									executeCommandHandler("spectate")
								else
									triggerServerEvent("timesUpPalServer", localPlayer)
								end
							elseif Settings["ghostTimesUpOnFinish"] == 0 then
								executeCommandHandler("spectate")
							end
							setElementData(localPlayer, "ghostHitLastCP", true)
						end
					end
				end
			end
		elseif isSpectatingGhost == false and state ~= "nolifing" then
			if ghostToLastCPDistance and CPsizes and CPsizes[#checkpoints] and ghostToLastCPDistance < CPsizes[#checkpoints]*2 then
				if ghostHasHitLastCP == false then
					if checkpoints and #checkpoints > 0 then
						if ghostCP == #checkpoints then
							setElementData(localPlayer, "ghostHitLastCP", true)
						end
					end
				end
			end
		end
	end
	for k, v in ipairs(getElementsByType("player")) do
		if v ~= localPlayer then
			local otherPlayerState = getElementData(v, "state")
			local otherPlayerVehicle = getPedOccupiedVehicle(v)
			if otherPlayerVehicle and otherPlayerState == "nolifing" then
				setElementDimension(v, 69)
				setElementDimension(otherPlayerVehicle, 69)
			elseif otherPlayerVehicle and otherPlayerState ~= "nolifing" then
				if getElementDimension(v) ~= 666 and getElementDimension(otherPlayerVehicle) ~= 666 then
					setElementDimension(v, 0)
					setElementDimension(otherPlayerVehicle, 0)
				end
			end
		end
	end
	if ghostVeh and ghostVeh ~= nil and CPsizes and #CPsizes == #checkpoints then
		if checkpoints and #checkpoints > 0 then
			for i = 1, #checkpoints do
				if isSpectatingGhost == true then
					if ghostCP and ghostCP ~= nil and ghostCP ~= false and i+1 == ghostCP+2 then
						local color = { 255, 255, 255, 128 }
						local CPposX, CPposY, CPposZ = unpack(checkpoints[i].position)
						if Settings["ghostCPMarkers"] == 0 then
							if isElement(CPMarker[i]) then
								destroyElement(CPMarker[i])
							end
						end
						if Settings["ghostCPBlips"] == 0 then
							if isElement(CPBlip[i]) then
								destroyElement(CPBlip[i])
							end
						end
						if not isElement(CPMarker[i]) then
							if Settings["ghostCPMarkers"] == 1 and CPsizes[i] ~= nil then
								CPMarker[i] = createMarker(CPposX, CPposY, CPposZ, checkpoints[i].type, CPsizes[i], color[1], color[2], color[3], color[4])
							end
						end
						if not isElement(CPBlip[i]) then
							if i < #checkpoints then
								if Settings["ghostCPBlips"] == 1 then
									CPBlip[i] = createBlip(CPposX, CPposY, CPposZ, 0, 2, color[1], color[2], color[3], color[4])
								end
							elseif i == #checkpoints then
								if Settings["ghostCPBlips"] == 1 then
									CPBlip[i] = createBlip(CPposX, CPposY, CPposZ, 53, 2, color[1], color[2], color[3], color[4])
								end
								if isElement(CPMarker[i]) then
									setMarkerIcon(CPMarker[i], "finish")
								end
							end
							if isElement(CPBlip[i]) then
								setBlipOrdering(CPBlip[i], 2)
							end
						end
						if ghostCP+2 <= #checkpoints then
							if Settings["ghostCPMarkers"] == 0 then
								if isElement(CPMarker[ghostCP+2]) then
									destroyElement(CPMarker[ghostCP+2])
								end
							end
							if Settings["ghostCPBlips"] == 0 then
								if isElement(CPBlip[ghostCP+2]) then
									destroyElement(CPBlip[ghostCP+2])
								end
							end
							local nextCPposX, nextCPposY, nextCPposZ = unpack(checkpoints[ghostCP+2].position)
							if not isElement(CPMarker[ghostCP+2]) then
								if Settings["ghostCPMarkers"] == 1 and CPsizes[ghostCP+2] ~= nil then
									CPMarker[ghostCP+2] = createMarker(nextCPposX, nextCPposY, nextCPposZ, checkpoints[ghostCP+2].type, CPsizes[ghostCP+2], color[1], color[2], color[3], color[4])
								end
							end
							if not isElement(CPBlip[ghostCP+2]) then
								if ghostCP+2 < #checkpoints then
									if Settings["ghostCPBlips"] == 1 then
										CPBlip[ghostCP+2] = createBlip(nextCPposX, nextCPposY, nextCPposZ, 0, 2, color[1], color[2], color[3], color[4])
									end
								elseif ghostCP+2 == #checkpoints then
									if Settings["ghostCPBlips"] == 1 then
										CPBlip[ghostCP+2] = createBlip(nextCPposX, nextCPposY, nextCPposZ, 53, 2, color[1], color[2], color[3], color[4])
									end
									if isElement(CPMarker[ghostCP+2]) then
										setMarkerIcon(CPMarker[ghostCP+2], "finish")
									end
								end
								if isElement(CPBlip[ghostCP+2]) then
									setBlipOrdering(CPBlip[ghostCP+2], 2)
								end
							end
							if isElement(CPMarker[i]) then
								setMarkerTarget(CPMarker[i], unpack(checkpoints[ghostCP+2].position))
							end
						end
					end
				elseif isSpectatingGhost == false then
					if isElement(CPMarker[i]) then
						destroyElement(CPMarker[i])
					end
					if isElement(CPBlip[i]) then
						destroyElement(CPBlip[i])
					end
					if ghostCP and ghostCP ~= nil and ghostCP ~= false and ghostCP+2 <= #checkpoints then
						if isElement(CPMarker[ghostCP+1]) then
							destroyElement(CPMarker[ghostCP+1])
						end
						if isElement(CPBlip[ghostCP+1]) then
							destroyElement(CPBlip[ghostCP+1])
						end
						if isElement(CPMarker[ghostCP+2]) then
							destroyElement(CPMarker[ghostCP+2])
						end
						if isElement(CPBlip[ghostCP+2]) then
							destroyElement(CPBlip[ghostCP+2])
						end
					end
				end
				if ghostCP and ghostCP ~= nil and ghostCP ~= false and i+1 == ghostCP+2 then
					local cpX, cpY, cpZ = unpack(checkpoints[i].position)
					if ghostPosX and ghostPosY and cpX and cpY then
						local ghostToNormalCPDistance = getDistanceBetweenPoints2D(ghostPosX, ghostPosY, cpX, cpY)
						if ghostToNormalCPDistance and CPsizes and CPsizes[i] and ghostToNormalCPDistance < CPsizes[i]*2 then
							setElementData(ghostVeh, "ghost.checkpoint", i)
							if isSpectatingGhost == true then
								if Settings["ghostCPMarkers"] == 1 then
									playSoundFrontEnd(43)
								end
							end
							if isElement(CPMarker[i]) then
								destroyElement(CPMarker[i])
							end
							if isElement(CPBlip[i]) then
								destroyElement(CPBlip[i])
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, mainCode)
-------------------------------------------------------------------------------------------------------------------------
function drawGhostInfo()
	if ghostVeh and ghostVeh ~= nil and ghostName and ghostName ~= nil then
		if Settings["ghostInfo"] == 1 then
			local ghostCP = getElementData(ghostVeh, "ghost.checkpoint") or 0
			if ghostCP and checkpoints and #checkpoints > 0 then
				dxDrawText("Ghost: "..ghostName:gsub('#%x%x%x%x%x%x', '').." | Checkpoint: "..ghostCP.." / "..#checkpoints.."", 0*sx+1, 1044*sy+1, 1920*sx+1, 1080*sy+1, tocolor(0, 0, 0, 255), 1.00*sy, "bankgothic", "center", "center", false, false, false, true, false)
				dxDrawText("#FFFFFFGhost: "..ghostName.." #FFFFFF| Checkpoint: "..ghostCP.." / "..#checkpoints.."", 0*sx, 1044*sy, 1920*sx, 1080*sy, tocolor(255, 255, 255, 255), 1.00*sy, "bankgothic", "center", "center", false, false, false, true, false)
			end
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------
function onResStop()
	local veh = getPedOccupiedVehicle(localPlayer)
	local isSpectatingGhost = getElementData(localPlayer, "isSpectatingGhost")
	local ghostHasHitLastCP = getElementData(localPlayer, "ghostHitLastCP")
	local theRealData = getElementData(localPlayer, "state")
	local blips = getElementsByType("blip")
	local markers = getElementsByType("marker")
	if isSpectatingGhost == true then
		if blips and #blips > 0 then
			for i = 1, #blips do
				if isElement(blips[i]) then
					if r[i] and g[i] and b[i] and a[i] then
						local red, green, blue, alpha = r[i], g[i], b[i], a[i]
						if red and green and blue and alpha then
							setBlipColor(blips[i], red, green, blue, alpha)
						end
					end
				end
			end
		end
		for i = 1, #markers do
			if originalMarkerSize[i] then
				setMarkerSize(markers[i], originalMarkerSize[i])
			end
		end
		setCameraTarget(localPlayer)
		if veh and prevX and prevY and prevZ then
			setElementPosition(veh, prevX, prevY, prevZ+1)
			prevX = nil
			prevY = nil
			prevZ = nil
		end
		setElementData(localPlayer, "state", theRealData)
		setCameraTarget(localPlayer)
		setElementData(localPlayer, "isSpectatingGhost", false)
		if isElementFrozen(veh) then
			setElementFrozen(veh, false)
		end
		if isEventHandlerAdded("onClientRender", root, drawGhostInfo) == true then
			removeEventHandler("onClientRender", root, drawGhostInfo)
		end
		if ghostVeh and ghostVeh ~= nil then
			ghostVeh = nil
		end
	elseif isSpectatingGhost == false then
		if ghostVeh and ghostVeh ~= nil then
			ghostVeh = nil
		end
	end
	if ghostHasHitLastCP == true then
		setElementData(localPlayer, "ghostHitLastCP", false)
	end
	for i = 1, #CPMarker do
		if isElement(CPMarker[i]) then
			destroyElement(CPMarker[i])
		end
	end
	for i = 1, #CPBlip do
		if isElement(CPBlip[i]) then
			destroyElement(CPBlip[i])
		end
	end
	for i = 1, #CPsizes do
		CPsizes[i] = nil
	end
end
addEventHandler("onClientResourceStop", root, onResStop)