local nextNode = nil
local prev, curr
local node1, node2
local lastNodeID = 1
local nextNodeID = 1
local id, idx
local x, y, z
local xx, yy, zz
local xx2, yy2, zz2
local rx, ry, rz
local gx, gy, gz
local prev_dst = math.huge
local dst = 0
local color_r, color_g, color_b, color_a
local my_weight = 1500
local arrowSize = 2
local assistTimer = nil
local recording = nil
local img = dxCreateTexture("arrow.png")
local ghostVeh
-------------------------------------------------------------------------------------------------------------------------
function show()
	if isEventHandlerAdded("onClientPreRender", root, drawRacingLine) == false then
		addEventHandler("onClientPreRender", root, drawRacingLine)
	end
end
-------------------------------------------------------------------------------------------------------------------------
function hide()
	if isEventHandlerAdded("onClientPreRender", root, drawRacingLine) == true then
		removeEventHandler("onClientPreRender", root, drawRacingLine)
	end
end
-------------------------------------------------------------------------------------------------------------------------
function destroy()
	if isTimer(assistTimer) then 
		killTimer(assistTimer) 
		assistTimer = nil
	end
	if isEventHandlerAdded("onClientPreRender", root, drawRacingLine) == true then
		removeEventHandler("onClientPreRender", root, drawRacingLine)
	end
	recording = nil
end
-------------------------------------------------------------------------------------------------------------------------
function onClientResStart()
	addEventHandler("onClientPlayerFinish", root, destroy)
	saveSettings()
	loadSettings()
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResStart)
-------------------------------------------------------------------------------------------------------------------------
function onClientResStop()
	if isTimer(assistTimer) then 
		killTimer(assistTimer) 
		assistTimer = nil
	end
	if ghostVeh and ghostVeh ~= nil then
		ghostVeh = nil
	end
end
addEventHandler("onClientResourceStop", root, onClientResStop)
-------------------------------------------------------------------------------------------------------------------------
function onClientGhostDataReceive(rec, bestTime, racer, ped, vehicle)
	if vehicle then
		ghostVeh = vehicle
	end
	if recording then
		destroy()
	end
	recording = {}
	local i = 1
	while(rec[i]) do
		if (rec[i].ty == "po") then
			table.insert(recording, rec[i])
		end
		i = i + 1			
	end
	lastNodeID = 1 
	nextNodeID = 1
	assistTimer = setTimer(updateRacingLine, 50, 0)
	show()
end
addEventHandler("onClientGhostDataReceive", root, onClientGhostDataReceive)
-------------------------------------------------------------------------------------------------------------------------
function updateRacingLine()
	if ghostVeh then
		local vehType = getVehicleType(ghostVeh)
		if vehType == "Plane" or vehType == "Helicopter" or vehType == "Boat" then
			hide()
		else
			show()
		end
		prev_dst = math.huge
		dst = 0	
		nextNode = nil
		lastNodeID = nextNodeID
		id = lastNodeID
		while(recording[id]) do
				x, y, z = recording[id].x, recording[id].y, recording[id].z
				dst = getDistanceBetweenPoints3D(x, y, z, getElementPosition(ghostVeh))
				if dst < 50 and id >= lastNodeID then
					nextNode = id
					break
				end	
			id = id + 1			
		end
		if nextNode ~= nil then
			prev_dst = math.huge
			dst = 0
			x, y, z = getElementPosition(ghostVeh)
			prev = recording[nextNode]	
			idx = nextNode + 1			
			curr = recording[idx]				
			if curr and prev then
				prev_dst = getDistanceBetweenPoints3D(prev.x, prev.y, prev.z, x, y, z) or 0
				dst = getDistanceBetweenPoints3D(curr.x, curr.y, curr.z, x, y, z) or 0
				if prev_dst > dst then
					nextNodeID = idx
				end
			end
		end
		my_weight = 1500
		arrowSize = 2
		my_weight = (getVehicleHandling(ghostVeh).mass)
		arrowSize = math.clamp(1.5, (0.04*my_weight+180)/150, 5) -- forza style arrow size
	end
end
-------------------------------------------------------------------------------------------------------------------------
function drawRacingLine()
	if ghostVeh then
		if Settings["ghostRouteHighlight"] == 1 then
			local isSpectatingGhost = getElementData(localPlayer, "isSpectatingGhost")
			if isSpectatingGhost == true then
				local start = nextNodeID
				for i = start, start+12, 1 do
					node1 = recording[i]
					if node1 then
						color_r = 255
						color_g = 255
						color_b = 255
						color_a = 127
						rx, ry, rz = node1.rX, node1.rY, node1.rZ
						if rx > 180 then
							rx = rx - 360
						end
						if ry > 180 then
							ry = ry - 360
						end
						xx, yy, zz = getPositionFromElementOffset(node1.x, node1.y, node1.z, rx, ry, rz, -4)
						_, gx, gy, gz, _ = processLineOfSight(node1.x, node1.y, node1.z, xx, yy, zz, true, false, false, true)
						if not gx and math.abs(rx) < 80 and math.abs(ry) < 70 then
							gx, gy, gz = node1.x, node1.y, getGroundPosition(node1.x, node1.y, node1.z)
							if math.abs(gz - node1.z) > 15 then
								gx, gy, gz = nil
							end
						end
						if gx then
							gx, gy, gz = getPositionFromElementOffset(gx, gy, gz, rx, ry, rz, 0.2)
							if gx and xx2 and i ~= start then
								dxDrawMaterialLine3D(gx, gy, gz, xx2, yy2, zz2, img, arrowSize, tocolor(color_r, color_g, color_b, color_a), xx, yy, zz)
							end
							xx2, yy2, zz2 = gx, gy, gz				
						else
							xx2, yy2, zz2 = nil, nil, nil	
						end
					end
				end
			end
		end
	end
end