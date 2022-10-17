function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
	if type(sEventName) == "string" and isElement(pElementAttachedTo) and type(func) == "function" then
		local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
		if type(aAttachedFunctions) == "table" and #aAttachedFunctions > 0 then
			for i, v in ipairs(aAttachedFunctions) do
				if v == func then
					return true
				end
			end
		end
	end
	return false
end
------------------------------------------------------------------------------------------------------------------------
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
		else
			rotation = 0
		end
		local vehicle = tonumber(getElementData(element,"vehicle"))
		local size
		if getElementData(element,"size") then
			size = tonumber(getElementData(element,"size"))
		else
			size = 5.0
		end
		local type
		if getElementData(element,"type") then
			type = tostring(getElementData(element,"type"))
		else
			type = "checkpoint"
		end
		result[i].position = position;
		result[i].rotation = rotation;
		result[i].vehicle = vehicle;
		result[i].size = size;
		result[i].type = type;
		result[i].element = element;
	end
	return result
end
------------------------------------------------------------------------------------------------------------------------
function math.clamp(low, value, high)
	return math.max(low, math.min(value, high))
end
------------------------------------------------------------------------------------------------------------------------
function getPositionFromElementOffset(x, y, z, rx, ry, rz, offZ)
	rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
	local tx =  offZ * (math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)) + x
	local ty =  offZ * (math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)) + y
	local tz =  offZ * (math.cos(rx)*math.cos(ry)) + z
    return tx, ty, tz
end