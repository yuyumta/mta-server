
g_colorkey = "F1"
g_openwin = false
---------------------------------
local openfirsttime = true
local randomdefault = false
local firsttime = false
local fname = "settings_gtaru.xml"

if randomdefault then
    randstart = 1
else
    randstart = 0
end

g_randlast = randstart

function setRandAttr (file)
    xmlNodeSetAttribute(file,"rh",math.random(0,255))
	xmlNodeSetAttribute(file,"gh",math.random(0,255))
	xmlNodeSetAttribute(file,"bh",math.random(0,255))
			
	xmlNodeSetAttribute(file,"r1",math.random(0,255))
	xmlNodeSetAttribute(file,"g1",math.random(0,255))
	xmlNodeSetAttribute(file,"b1",math.random(0,255))
			
	xmlNodeSetAttribute(file,"r2",math.random(0,255))
	xmlNodeSetAttribute(file,"g2",math.random(0,255))
	xmlNodeSetAttribute(file,"b2",math.random(0,255))
			
	xmlNodeSetAttribute(file,"r3",math.random(0,255))
	xmlNodeSetAttribute(file,"g3",math.random(0,255))
	xmlNodeSetAttribute(file,"b3",math.random(0,255))
			
	xmlNodeSetAttribute(file,"r4",math.random(0,255))
	xmlNodeSetAttribute(file,"g4",math.random(0,255))
	xmlNodeSetAttribute(file,"b4",math.random(0,255))
	
	xmlNodeSetAttribute(file,"rand",randstart)
end

function start()
	local settingsFile = xmlLoadFile(fname)
	if settingsFile then
        local pos = xmlNodeGetAttributes(settingsFile)		
		if pos.rh and pos.gh and pos.bh and pos.r1 and pos.g1 and pos.b1 and pos.r2 and pos.g2 and pos.b2 and pos.r3 and pos.g3 and pos.b3 and pos.r4 and pos.g4 and pos.b4 and pos.rand then			
            triggerServerEvent ( "getting", getLocalPlayer(), getLocalPlayer(), pos.rh,pos.gh,pos.bh, pos.r1,pos.g1,pos.b1, pos.r2,pos.g2,pos.b2, pos.r3,pos.g3,pos.b3, pos.r4,pos.g4,pos.b4, pos.rand ) 
		    randstart = tonumber(pos.rand)
		    g_randlast = randstart
		    xmlUnloadFile(settingsFile)
		else
		    setRandAttr (settingsFile)
			xmlSaveFile(settingsFile)
			xmlUnloadFile(settingsFile)
			outputChatBox("#FE9F8B[INFO] #EADDB3Fixing color settings file. Press enter /color again.")
		end
    else
		settingsFile = xmlCreateFile(fname,"settings")
		setRandAttr (settingsFile)
		xmlSaveFile(settingsFile)
		xmlUnloadFile(settingsFile)
        if openfirsttime then
		    firsttime = true
		end
	end
end

function set(source, rh, gh, bh, r1, g1, b1, r2, g2, b2, rand )
    local settingsFile = xmlLoadFile(fname)
	if settingsFile then
		xmlNodeSetAttribute(settingsFile,"rh", rh)
		xmlNodeSetAttribute(settingsFile,"gh", gh)
		xmlNodeSetAttribute(settingsFile,"bh", bh)
			
		xmlNodeSetAttribute(settingsFile,"r1", r1)
		xmlNodeSetAttribute(settingsFile,"g1", g1)
		xmlNodeSetAttribute(settingsFile,"b1", b1)
			
		xmlNodeSetAttribute(settingsFile,"r2", r2)
		xmlNodeSetAttribute(settingsFile,"g2", g2)
		xmlNodeSetAttribute(settingsFile,"b2", b2)
			
		xmlNodeSetAttribute(settingsFile,"r3",math.random(0,255))
		xmlNodeSetAttribute(settingsFile,"g3",math.random(0,255))
		xmlNodeSetAttribute(settingsFile,"b3",math.random(0,255))
			
		xmlNodeSetAttribute(settingsFile,"r4",math.random(0,255))
		xmlNodeSetAttribute(settingsFile,"g4",math.random(0,255))
		xmlNodeSetAttribute(settingsFile,"b4",math.random(0,255))
		xmlNodeSetAttribute(settingsFile,"rand",rand)
		
	    xmlSaveFile(settingsFile)
	    xmlUnloadFile(settingsFile)
    end
end

function firstspawn()
	if firsttime then
	    setTimer ( openColorPicker, 3000, 1 )
		firsttime = false
	end
end

function openColorPicker()
	if not g_openwin then
	    local editingVehicle = getPedOccupiedVehicle(getLocalPlayer())
	    if (editingVehicle) then
	        local settingsFile = xmlLoadFile(fname)
		    if settingsFile then
			    local pos = xmlNodeGetAttributes(settingsFile)
	            triggerEvent ("startvalue", getRootElement(), pos.r1, pos.g1, pos.b1, g_randlast )
				xmlUnloadFile(settingsFile)
		        colorPicker.openSelect(colors)
			end
	    end
		g_openwin = true
	else
	    triggerEvent ("close", getRootElement() )
		g_openwin = false
	end
end

function closedColorPicker(rq,gq,bq)
    local editingVehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (editingVehicle) then
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
	    local rh, gh, bh = getVehicleHeadLightColor(editingVehicle)
	    if g_randlast == 1 then
	        rand = 1
			outputChatBox("#FE9F8B[INFO] #EADDB3Vehicle color saved to random." , r1, g1, b1, true )
	    else
	        rand = 0
			outputChatBox("#FE9F8B[INFO] #EADDB3Vehicle color saved." , r1, g1, b1, true )
	    end
	    triggerServerEvent ( "getting", getLocalPlayer(), getLocalPlayer(), rh, gh, bh, r1, g1, b1, r2, g2, b2 ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255),rand) 
        set(getLocalPlayer(), rh, gh, bh, r1, g1, b1, r2, g2, b2, rand )
	else
	    local rq, gq, bq = tonumber(rq), tonumber(gq), tonumber(bq)
	    if g_randlast == 1 then
	        rand = 1
			outputChatBox("#FE9F8B[INFO] #EADDB3Vehicle color saved to random." , rq, gq, bq, true )
	    else
	        rand = 0
			outputChatBox("#FE9F8B[INFO] #EADDB3Vehicle color saved." , rq, gq, bq, true )
	    end
		triggerServerEvent ( "getting", getLocalPlayer(), getLocalPlayer(), rq, gq, bq, rq, gq, bq, rq, gq, bq ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255) ,math.random(0,255),rand) 
        set(getLocalPlayer(), rq, gq, bq, rq, gq, bq, rq, gq, bq, rand )
	end
	editingVehicle = nil
end

function updateColor()
    local editingVehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (not colorPicker.isSelectOpen) then return end
	triggerServerEvent ( "stopwhileupdate", getLocalPlayer(),getLocalPlayer())
	if (guiCheckBoxGetSelected(checkColor4)) then 
	    g_randlast = 1
	else
	    g_randlast = 0
	end
	local r, g, b = colorPicker.updateTempColors()
	if (editingVehicle and isElement(editingVehicle)) then
		local r1, g1, b1, r2, g2, b2 = getVehicleColor(editingVehicle, true)
		if (guiCheckBoxGetSelected(checkColor1)) then
			r1, g1, b1 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor2)) then
			r2, g2, b2 = r, g, b
		end
		if (guiCheckBoxGetSelected(checkColor3)) then
			setVehicleHeadLightColor(editingVehicle, r, g, b)
		end
	    if not (guiCheckBoxGetSelected(checkColor4)) then 
		    setVehicleColor(editingVehicle, r1, g1, b1, r2, g2, b2)
	    end
	end
end
addEventHandler("onClientRender", getRootElement(), updateColor)

--addEvent( "start", true )
--addEventHandler( "start", getRootElement(), start )

addCommandHandler("color",openColorPicker)

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), start )
addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), firstspawn )
