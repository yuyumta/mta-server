
local Timer = {}	

function getting (PlayerSource, rh,gh,bh,r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4,rand )
--outputChatBox("getting started.")
    if Timer[PlayerSource] then
        killTimer( Timer[PlayerSource] )
    end
    rand = tonumber(rand)
    if rand == 0 then
    Timer[PlayerSource] = setTimer( 
	    function ( playerVehicle )
		    if PlayerSource then
			    local vehicle = getPedOccupiedVehicle( PlayerSource )
			    if vehicle and rh and gh and bh and r1 and g1 and b1 and r2 and g2 and b2 and r3 and g3 and b3 and r4 and g4 and b4 then
				if not exports["race_league"]:returnColorThing() then
					--setVehicleOverrideLights ( vehicle, 2 )
					setVehicleHeadLightColor ( vehicle, rh,gh,bh)
					setVehicleColor ( vehicle,r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 )
				end
			    end
			end
	    end, 1000, 0, vehicle )
    end
end

addEvent( "getting", true )
addEventHandler( "getting", getRootElement(), getting )

function stopwhileupdate(PlayerSource)
    if Timer[PlayerSource] then
        killTimer( Timer[PlayerSource] )
        Timer[PlayerSource] = nil
    end
end
addEvent( "stopwhileupdate", true )
addEventHandler( "stopwhileupdate", getRootElement(), stopwhileupdate )

function removeStateOnQuit()
    if Timer[source] then
        killTimer( Timer[source] )
    end
  	Timer[source] = nil
end
addEventHandler( "onPlayerQuit", getRootElement(), removeStateOnQuit )
