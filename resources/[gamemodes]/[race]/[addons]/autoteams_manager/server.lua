teams = {}

function toggleClientPanel(player)
  triggerClientEvent(player, "opendaShitForme", getRootElement() )
end

function onSomeoneLoggedIn()
  local accountName = getAccountName(getPlayerAccount(source))
  if isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) then
    unbindKey(source,"F3","down", toggleClientPanel)
    bindKey(source,"F3","down", toggleClientPanel)
  end
end
addEventHandler("onPlayerLogin", getRootElement(), onSomeoneLoggedIn)

function sendGridtoClient()
  local theteams = {}
	local rootNode = xmlLoadFile("config.xml")
	local children = xmlNodeGetChildren(rootNode)
	for _,node in pairs(children) do
		local attributes = xmlNodeGetAttributes(node)
		local name = attributes.name
		theteams[name] = attributes
	end
	xmlUnloadFile(rootNode)
	triggerClientEvent(source, "hereIsDaListNub", getRootElement(), theteams)
end
addEvent("gimmeTheFuckinList", true)
addEventHandler("gimmeTheFuckinList", getRootElement(), sendGridtoClient)

function saveNewTeams(theteams)
  local thexml = xmlCreateFile("config.xml", "teams")
  for name,settings in next,theteams do
    local child = xmlCreateChild(thexml, "team")
    xmlNodeSetAttribute(child, "name", name)
    xmlNodeSetAttribute(child, "tag", settings.tag)
    xmlNodeSetAttribute(child, "color", settings.color)
    xmlNodeSetAttribute(child, "aclGroup", settings.aclGroup)
    xmlNodeSetAttribute(child, "required", settings.required)
  end
  xmlSaveFile(thexml)
  xmlUnloadFile(thexml)
  
  initiate()
end
addEvent("hereIzDaFuckinList", true)
addEventHandler("hereIzDaFuckinList", getRootElement(), saveNewTeams)

function startedResource()
	for k,v in pairs(getElementsByType("player")) do
    local accountName = getAccountName(getPlayerAccount(v))
    if isObjectInACLGroup("user."..accountName,aclGetGroup("Admin")) then
      if (isKeyBound (v,"F3") == false) then
        unbindKey(v,"F3","down", toggleClientPanel)
        bindKey(v,"F3","down", toggleClientPanel)
      end
		end
	end
end
addEventHandler("onResourceStart",getResourceRootElement(),startedResource)

------------
-- Events --
------------

function playerJoined()
  check(source)
end
addEventHandler("onPlayerJoin",getRootElement(),playerJoined)

function playerChangedNick(oldNick,newNick)
	-- Use timer to wait until the nick really has changed
	setTimer(check,100,1,source)
end
addEventHandler("onPlayerChangeNick",getRootElement(),playerChangedNick)

function playerQuit()
	removePlayerFromTeam(source)
end
addEventHandler("onPlayerQuit",getRootElement(),playerQuit)

-- Check for ACL Groups on login/logout
function loggedIn()
	check(source)
end
addEventHandler("onPlayerLogin",getRootElement(),loggedIn)

function loggedOut()
	check(source)
  unbindKey(source,"F3","down", toggleClientPanel)
end
addEventHandler("onPlayerLogout",getRootElement(),loggedOut)


---
-- Reads the settings and creates the teams if enabled.
--
function initiate()
  teams = {}
  
	for k,v in pairs(getElementsByType("team")) do
    local players = getPlayersInTeam (v)
		for playerKey, playerValue in ipairs ( players ) do
			setPlayerTeam( playerValue, nil)
		end
		destroyElement(v)
	end
	
	local rootNode = xmlLoadFile("config.xml")
	local children = xmlNodeGetChildren(rootNode)
	if children == false then
		outputDebugString("children == false")
		return
	end
	for _,node in pairs(children) do
		local attributes = xmlNodeGetAttributes(node)
		local name = attributes.name
		teams[name] = attributes
		if not toboolean(get("noEmptyTeams")) then
		  local color = {getColorFromString(attributes.color)}
		  if not color[1] then
			  color = {255,255,255}
		  end
			teams[name].team = createTeam(name,unpack(color))
		end
	end
	for k,v in pairs(getElementsByType("player")) do
		check(v)
	end
	xmlUnloadFile(rootNode)
end
addEventHandler("onResourceStart",getResourceRootElement(),initiate)

---------------
-- Functions --
---------------

---
-- Checks the player's nick and ACL Groups and sets his team if necessary.
--
-- @param   player   player: The player element
--
function check(player)
	if not isElement(player) or getElementType(player) ~= "player" then
		debug("No player")
		return
	end
	local nick = getPlayerName(player)
	
	--set player white
	setPlayerNametagColor(player, 255,255,255)
	
	local accountName = getAccountName(getPlayerAccount(player))
	for name,data in pairs(teams) do
		local tagMatch = false
		local aclGroupMatch = false
		if data.tag ~= nil and string.find(nick,data.tag,1,true) then
			tagMatch = true
		end
		if data.aclGroup ~= nil and accountName and isObjectInACLGroup("user."..accountName,aclGetGroup(data.aclGroup)) then
			aclGroupMatch = true
		end
		if data.required == "both" then
			if tagMatch and aclGroupMatch then
				addPlayerToTeam(player,name)
        --Check Vehicle color (and set it to team color)
        if isPedInVehicle(player) then
          local vehicle = getPedOccupiedVehicle(player)
          if getPedOccupiedVehicleSeat(player) == 0 then
            if getPlayerTeam(player) then
	            local r,g,b = getTeamColor(getPlayerTeam(player))
	            setVehicleColor(vehicle,r,g,b,r,g,b,r,g,b,r,g,b)
	            setPlayerNametagColor(player, r,g,b)
            else
              setVehicleColor(vehicle,255,255,255,255,255,255,255,255,255,255,255,255)
            end
          end
        end
				return
			end
		else
			if tagMatch or aclGroupMatch then
				addPlayerToTeam(player,name)
        --Check Vehicle color (and set it to team color)
        if isPedInVehicle(player) then
          local vehicle = getPedOccupiedVehicle(player)
          if getPedOccupiedVehicleSeat(player) == 0 then
            if getPlayerTeam(player) then
	            local r,g,b = getTeamColor(getPlayerTeam(player))
	            setVehicleColor(vehicle,r,g,b,r,g,b,r,g,b,r,g,b)
	            setPlayerNametagColor(player, r,g,b)
            else
              setVehicleColor(vehicle,255,255,255,255,255,255,255,255,255,255,255,255)
            end
          end
        end
				return
			end
		end
	end
	removePlayerFromTeam(player)
	
--Check Vehicle color (and set it to team color)
	if isPedInVehicle(player) then
	  local vehicle = getPedOccupiedVehicle(player)
	  if getPedOccupiedVehicleSeat(player) == 0 then
      if getPlayerTeam(player) then
		    local r,g,b = getTeamColor(getPlayerTeam(player))
		    setVehicleColor(vehicle,r,g,b,r,g,b,r,g,b,r,g,b)
		    setPlayerNametagColor(player, r,g,b)
      else
        setVehicleColor(vehicle,255,255,255,255,255,255,255,255,255,255,255,255)
      end
	  end
	end
	
end

---
-- Adds a player to the team appropriate for the name.
-- It is not checked if the team is really defined in the table, since
-- it should only be called if it is.
--
-- Creates the team if it doesn't exist.
--
-- @param   player   player: The player element
-- @param   string   name: The name of the team
--
function addPlayerToTeam(player,name)
    local oldteam = getPlayerTeam(player)
	local team = teams[name].team
	if not isElement(team) or getElementType(team) ~= "team" then
	  local color = {getColorFromString(teams[name].color)}
	  if not color[1] then
		  color = {255,255,255}
	  end
		
		team = createTeam(teams[name].name,unpack(color))
		teams[name].team = team
    elseif team == oldteam then
        return
	end
    triggerEvent("onPlayerTeamChange", player, oldteam, team)
	setPlayerTeam(player,team)
	debug("Added player '"..getPlayerName(player).."' to team '"..name.."'")
end

---
-- Removes a player from a team. Also checks if any team
-- needs to be removed.
--
-- @param   player   player: The player element
--
function removePlayerFromTeam(player)
    triggerEvent("onPlayerTeamChange", player, getPlayerTeam(player), nil)
	setPlayerTeam(player,nil)
	debug("Removed player '"..getPlayerName(player).."' from team")
	if toboolean(get("noEmptyTeams")) then
		for k,v in pairs(teams) do
			local team = v.team
			if isElement(team) and getElementType(team) == "team" then
				if countPlayersInTeam(team) == 0 then
					destroyElement(team)
				end
			end
		end
	end
end


function vehiclepaint(player,seat)
	if (seat == 0) then
	  if (getPlayerTeam(player)) then
		  local r,g,b = getTeamColor(getPlayerTeam(player))
		  setVehicleColor(source,r,g,b,r,g,b,r,g,b,r,g,b)
		  setPlayerNametagColor(player, r,g,b)
		else
		  setVehicleColor(source,255,255,255,255,255,255,255,255,255,255,255,255)
		  setPlayerNametagColor(player, 255,255,255)
		end
	end
end
addEventHandler("onVehicleEnter",getRootElement(),vehiclepaint)

function vehicleModelChange(pickupID, pickupType, vehicleModel)
  if (pickupType == "vehiclechange") then
    if getPlayerTeam(source) then
      local r,g,b = getTeamColor(getPlayerTeam(source))
      local vehicle = getPedOccupiedVehicle(source)
      if getPedOccupiedVehicleSeat(source) == 0 then
        setVehicleColor(vehicle,r,g,b,r,g,b,r,g,b,r,g,b)
      end
      setPlayerNametagColor(source, r,g,b)
    else
      local vehicle = getPedOccupiedVehicle(source)
      if getPedOccupiedVehicleSeat(source) == 0 then
        setVehicleColor(vehicle,255,255,255,255,255,255,255,255,255,255,255,255)
      end
      setPlayerNametagColor(source, 255,255,255)
    end
  end
end
addEventHandler("onPlayerPickUpRacePickup", getRootElement(), vehicleModelChange)

---
-- Converts a string-boolean into a boolean.
--
-- @param   string   string: The string (e.g. "false")
-- @return  true/false       Returns false if the string is "false" or evaluates to false (nil/false), true otherwise
--
function toboolean(string)
	if string == "false" or not string then
		return false
	end
	return true
end

-- Little debug function to turn on/off debug
setElementData(getResourceRootElement(),"debug",false)
function debug(string)
	if getElementData(getResourceRootElement(),"debug") then
		outputDebugString("autoteams: "..string)
	end
end



