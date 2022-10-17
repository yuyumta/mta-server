g_Me = getLocalPlayer()
g_Root = getRootElement()
g_ResRoot = getResourceRootElement()


g_ScreenSize =  { guiGetScreenSize() }

local isEditingPosition = false

g_Show = false

g_settings = {
	Display = true,
	Position = { 8,  g_ScreenSize[2] / 2 + 153 * 0.55 },
	Units = 'km/h',
	Font = dxCreateFont('fonts/msgothic.ttf', 5) or 'default',
	Color = '0xFFFFFFFF',
	speedoScale = 2.1
}


function show(status)
	g_Show = status
end

function Speedometer()
	if not (g_Show and g_settings.Display) then return end
	car = getPedOccupiedVehicle(getLocalPlayer())


	if car then
		speed = getDistanceBetweenPoints3D(0,0,0,getElementVelocity(car)) * 100

		if getVehicleType(car) == 'Plane' or getVehicleType(car) ==  'Boat' or getVehicleType(car) ==  'Helicopter' and not g_settings.Units == 'none' then
			speed = math.floor(speed / 1.15)
			speed = tostring(speed .. " knots")
			dxDrawText( speed, g_settings.Position[1] + 2, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font) 
			dxDrawText( speed, g_settings.Position[1] - 1, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font) 
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] + 2, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font) 
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] - 1, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font) 
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2], 100, 100, g_settings.Color, g_settings.speedoScale, g_settings.Font) 
			return		
		end


		if g_settings.Units == 'km/h' or g_settings.Units == 'kph' then
			speed = math.floor(speed * 1.61)
			speed = tostring(speed .. " " .. g_settings.Units)
			dxDrawText( speed, g_settings.Position[1] + 2, g_settings.Position[2], g_ScreenSize[2], g_ScreenSize[1], 0xFF000000, g_settings.speedoScale, g_settings.Font)
			dxDrawText( speed, g_settings.Position[1] - 1, g_settings.Position[2], g_ScreenSize[2], g_ScreenSize[1], 0xFF000000, g_settings.speedoScale, g_settings.Font)
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] + 2, g_ScreenSize[2], g_ScreenSize[1], 0xFF000000, g_settings.speedoScale, g_settings.Font)
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] - 1, g_ScreenSize[2], g_ScreenSize[1], 0xFF000000, g_settings.speedoScale, g_settings.Font)
			dxDrawText( speed, g_settings.Position[1], g_settings.Position[2], g_ScreenSize[2], g_ScreenSize[1], g_settings.Color, g_settings.speedoScale, g_settings.Font)
			return
		end

		if g_settings.Units == 'm/h' or g_settings.Units == 'mph' then
                        speed = math.floor(speed)
                        speed = tostring(speed .. " " .. g_settings.Units)
                        dxDrawText( speed, g_settings.Position[1] + 2, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1] - 1, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] + 2, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] - 1, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2], 100, 100, g_settings.Color, g_settings.speedoScale, g_settings.Font)
		end

		if g_settings.Units == 'none' then
                        speed = math.floor(speed)
                        dxDrawText( speed, g_settings.Position[1] + 2, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1] - 1, g_settings.Position[2], 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] + 2, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2] - 1, 100, 100, 0xFF000000, g_settings.speedoScale, g_settings.Font)
                        dxDrawText( speed, g_settings.Position[1], g_settings.Position[2], 100, 100, g_settings.Color, g_settings.speedoScale, g_settings.Font)
		end


	end

end


addEvent("onClientScreenFadedIn", true)
addEventHandler("onClientScreenFadedIn", g_Root,
        function()
                --SetupEvents()
                g_Show = true
        end
)

addEvent("onClientScreenFadedOut", true)
addEventHandler("onClientScreenFadedOut", g_Root,
        function ()
                g_Show = false
        end
)

addEventHandler("onClientResourceStart", g_ResRoot,
        function()
                alert("onClientResourceStart")
                label = guiCreateLabel(0, 0, 200, 40, "Click anywhere on the screen to\nchange speedometer position", false)
                guiSetFont(label, "default-bold-small")
                guiSetVisible(label, false)

                loadSettingsFromFile()

--                triggerServerEvent("onRequestNosSettings", g_Me)

                --bindKey("vehicle_fire", "both", ToggleNOS)
                --bindKey("vehicle_secondary_fire", "both", ToggleNOS)
                g_Show = true
                --SetupEvents()
                --RestoreVehicleNos()
        end
)

addEventHandler("onClientRender", getRootElement(), Speedometer)


addEvent("onClientSpeedometerSettings", true)
addEventHandler("onClientSpeedometerSettings", g_Me,
        function(settings)
                for k,v in pairs(settings) do
                        local currentValue = g_Settings[k]
                        alert(string.format("Setting '%s' has been set to '%s'", tostring(k), tostring(v)))
                        if currentValue ~= v then
                                g_Settings[k] = v
                        end
                end
        end
)


