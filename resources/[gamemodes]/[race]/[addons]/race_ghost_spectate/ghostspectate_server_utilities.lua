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
			size = 3.0
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