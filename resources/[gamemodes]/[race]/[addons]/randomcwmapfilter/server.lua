-- Add strings to the line below to include them in the map search. It is case sensitive, keep this in mind. Love, yuyu. <3
-- https://www.lua.org/manual/5.1/manual.html#5.4.1
local prefix = {'CW', 'VL2021', '%u%uvs%u%u', '%u%u%-%u%u'}
local command = 'randomcw'

function startCWMap ( player, car )
	local compatibleMaps = call ( getResourceFromName ( "mapmanager" ), "getMapsCompatibleWithGamemode", getResourceFromName ( "race" ) )
	local cwMapsWithCar = {}
	local cwMaps = {}
	local cwMapID
	local mapID = {}
	local mapName = {}
	local cwMapsName = {}
	
	for i, map in ipairs ( compatibleMaps ) do
		mapID[i] = map
		mapName[i] = getResourceInfo ( map, "name" )
	end

	for i, p in ipairs ( prefix ) do
		for i, name in ipairs ( mapName ) do
			if string.match ( tostring( name ), p ) then
				table.insert ( cwMaps, mapID[i] )
				table.insert ( cwMapsName, name )
			end
		end
	end

	if car then
		local carFixed = string.gsub(" "..car, "%W%l", string.upper):sub(2)
		for i, name in ipairs ( cwMapsName ) do
			if string.match ( tostring( name ), carFixed ) then
				table.insert ( cwMapsWithCar, cwMaps[i] )
			end
			if string.match ( tostring( name ), car ) then
				table.insert ( cwMapsWithCar, cwMaps[i] )
			end
		end
		if ( #cwMapsWithCar == 0 ) then
			outputChatBox( "Not found maps with " ..carFixed.. "." )
			return
		else
			outputChatBox ("[CW] ".. getPlayerNametagText ( player ).. " starting random CW map with " ..car.. ".", getRootElement(), 0, 240, 0, true)
			cwMapID = math.random ( #cwMapsWithCar )
			exports.mapmanager:changeGamemodeMap ( cwMapsWithCar[cwMapID], race )
		end
	else
		if ( #cwMaps == 0 ) then
			outputChatBox( "Not found maps." )
			return
		end
		outputChatBox ( "[CW] "..getPlayerNametagText( player ).. " starting random CW map.", getRootElement(), 0, 240, 0, true)
		cwMapID = math.random ( #cwMaps )
		exports.mapmanager:changeGamemodeMap ( cwMaps[cwMapID], race )
	end

end


addCommandHandler ( command ,
	function ( player, command, car )
		local accountname = ''
		if ( isGuestAccount ( getPlayerAccount ( player ) ) == false ) then
			accountname = getAccountName ( getPlayerAccount ( player ) )
			if isObjectInACLGroup ( "user." .. accountname, aclGetGroup ( "Admin" ) ) then
				startCWMap ( player, car )
			else
				outputChatBox ( "You are not admin." )
                        end
		else
			outputChatBox ( "You are not admin." )
		end
	end
)