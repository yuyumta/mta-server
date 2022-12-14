------------------------ Spawnpoints ------------------------

local Spawnpoints = { }

addEvent("onMapStarting",true)
addEventHandler('onMapStarting', getRootElement(),
function()
	Spawnpoints = getAll("spawnpoint")
end)

function getAll(name)
	local result = {}
	for i,element in ipairs(getElementsByType(name)) do
		result[i] = {}
		result[i].id = getElementID(element) or i
		local position = { tonumber(getElementData(element,"posX")), tonumber(getElementData(element,"posY")), tonumber(getElementData(element,"posZ")) }
		local rotation = 0
		if getElementData(element,"rotation") then
		    rotation = tonumber(getElementData(element,"rotation"))
		elseif getElementData(element,"rotZ") then
		    rotation = tonumber(getElementData(element,"rotZ"))
		end
		local vehicle = tonumber(getElementData(element,"vehicle"))
		result[i].position = position
		result[i].rotation = rotation
		result[i].vehicle = vehicle
	end
	return result
end

addEvent("onRaceStateChanging",true)
addEventHandler("onRaceStateChanging", getRootElement(),
function ( state )
    if (state == "GridCountdown") then
	    for i,player in ipairs(getElementsByType("player")) do
			if getPedOccupiedVehicle(player) then
			    local spawn = Spawnpoints[1]
				local veh = getPedOccupiedVehicle(player)
				local x, y, z = unpack(spawn.position)
				local model = spawn.vehicle
				local r = spawn.rotation
				setCameraTarget( player, player )
				setElementModel ( veh, model )
                setElementPosition ( veh, x, y, z )
				setElementRotation ( veh, 0, 0, r )
				--outputChatBox ( "#ff0000vehicle:#00ff00"..tostring(getVehicleNameFromModel(model)).." #ff0000x:#00ff00"..tostring(round(x,2)).." #ff0000y:#00ff00"..tostring(round(y,2)).." #ff0000z:#00ff00"..tostring(round(z,2)).." #ff0000r:#00ff00"..tostring(round(r,2)), player, 255,255,255,true )
			end
		end
	end
end)

function round(what,prec) return math.floor(what*math.pow(10,prec)+0.5) / math.pow(10,prec) end
