local marker
local blip

local enabled = isEnabledXML()

function clearThirdCheckpoint()
	if marker then destroyElement(marker) end
	marker = nil
	
	if blip then destroyElement(blip) end
	blip = nil
end
addEvent("clearThirdCheckpoint", true)
addEventHandler("clearThirdCheckpoint", root, clearThirdCheckpoint)
addCommandHandler("s", clearThirdCheckpoint)
addCommandHandler("spec", clearThirdCheckpoint)
addCommandHandler("spectate", clearThirdCheckpoint)
addCommandHandler("Toggle spectator", clearThirdCheckpoint)
addCommandHandler("afk", clearThirdCheckpoint)

function setThirdCheckpoint(checkpoint, isFinish, facing)
	if marker then destroyElement(marker) end
	if blip then destroyElement(blip) end
	if not enabled then return false end;

	-- checkpoint object:
	-- { position={x, y, z}, size=size, color={r, g, b}, type=type, vehicle=vehicleID, paintjob=paintjob, upgrades={...} } 
	
	-- For some reason older maps have a color boolean, changing it to default blue
	if checkpoint.color == false then
		checkpoint.color = {}
		checkpoint.color[1] = 0;
		checkpoint.color[2] = 0;
		checkpoint.color[3] = 255;
	end

	marker = createMarker(checkpoint.position[1], checkpoint.position[2], checkpoint.position[3], checkpoint.type or "checkpoint", checkpoint.size, checkpoint.color[1], checkpoint.color[2], checkpoint.color[3] , 255)


	if facing and checkpoint.type == "ring" then
		setMarkerTarget(marker, facing[1], facing[2], facing[3])
	end

	local icon;
	if (isFinish) then
		-- Finish icon
		icon = 53
	else icon = 0 end

	blip = createBlip(checkpoint.position[1], checkpoint.position[2], checkpoint.position[3], icon, 1, checkpoint.color[1], checkpoint.color[2], checkpoint.color[3], 255)
end
addEvent("setThirdCheckpoint", true)
addEventHandler("setThirdCheckpoint", root, setThirdCheckpoint)

function toggleEnabledDisabled()
	enabled = not enabled

	if not enabled then
		outputChatBox("#00FF00[Checkpoints]#FFFFFF You can now see 2 checkpoints", 255, 255, 255, true)
		clearThirdCheckpoint()
	else
		outputChatBox("#00FF00[Checkpoints]#FFFFFF When you hit the next checkpoint you can see 3 checkpoints", 255, 255, 255, true)
	end

	saveXML(enabled)
end
addCommandHandler("checkpoints", toggleEnabledDisabled)