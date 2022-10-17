
font_list = {
	"default",
	"default-bold",
	"clear",
	"arial",
	"sans",
	"pricedown",
	"bankgothic",
	"diploma",
	"beckett",
	"unifont"
}
g_openwin = false


function updateTooltipPosition(_,_, x, y)
        guiSetPosition(label, x + 8, y + 10, false)
        guiBringToFront(label)
end

function changeSpeedometerPosition(_, btnState, x, y)
        if btnState == "down" then
                g_settings.Position[1] = x
                g_settings.Position[2] = y
        end
        if isEditingPosition then
                isEditingPosition = false
                showCursor(false)
                guiSetVisible(label, false)
                removeEventHandler("onClientCursorMove", g_Root, updateTooltipPosition)
                removeEventHandler("onClientClick", g_Root, changeSpeedometerPosition)
                saveSettingsToFile()
                return;
        end
end

function saveSettingsToFile()
        local xml = xmlCreateFile("speedometer_settings.xml", "settings")
        if not xml then return false end
        local visualsNode = xmlCreateChild(xml, "visuals")
        xmlNodeSetAttribute(visualsNode, "display", tostring(g_settings.Display))
        xmlNodeSetAttribute(visualsNode, "posX", g_settings.Position[1])
        xmlNodeSetAttribute(visualsNode, "posY", g_settings.Position[2])
	xmlNodeSetAttribute(visualsNode, "units", g_settings.Units)
	xmlNodeSetAttribute(visualsNode, "font", g_settings.Font)
	xmlNodeSetAttribute(visualsNode, "color", g_settings.Color)
	xmlNodeSetAttribute(visualsNode, "speedoScale", g_settings.speedoScale)

        local ret = xmlSaveFile(xml)
        xmlUnloadFile(xml)
        return ret
end

function loadSettingsFromFile()
        local xml = xmlLoadFile("speedometer_settings.xml")
        if not xml then return false end

        local visualsNode = xmlFindChild(xml, "visuals", 0)
        g_settings.Display = (xmlNodeGetAttribute(visualsNode, "display") == "true")
        g_settings.Position[1] = xmlNodeGetAttribute(visualsNode, "posX")
        g_settings.Position[2] = xmlNodeGetAttribute(visualsNode, "posY")
	g_settings.Units = xmlNodeGetAttribute(visualsNode, "units")
	g_settings.Font = xmlNodeGetAttribute(visualsNode, "font")
	g_settings.Color = xmlNodeGetAttribute(visualsNode, "color")
	g_settings.speedoScale = xmlNodeGetAttribute(visualsNode, "speedoScale")

	xmlUnloadFile(xml)
        return true
end


function resetSettings()
	g_settings = {
		Display = true,
		Position = { 15, g_ScreenSize[2] / 2 + 153 * 0.55 },
		Units = 'km/h',
		Font = dxCreateFont('fonts/msgothic.ttf', 5) or 'default',
		Color = '0xFFFFFFFF',
	        speedoScale = 2.1
	}
	saveSettingsToFile()
end
addCommandHandler("reset_speedometer", resetSettings)

function letMePositionSpeedometer()
        if not isEditingPosition then
                isEditingPosition = true
                showCursor(true)
                local x, y = getCursorPosition()
                x, y = x * g_ScreenSize[1], y * g_ScreenSize[2]
                guiSetPosition(label, x, y, false)
                guiSetVisible(label, true)
                addEventHandler("onClientCursorMove", g_Root, updateTooltipPosition)
                addEventHandler("onClientClick", g_Root, changeSpeedometerPosition)
        end
end
addCommandHandler("move_speedometer", letMePositionSpeedometer)

-- Command to set the Speedometer gauge visibility on/off
function consoleSetSpeedometerVisibility(commandName, visibility)
	if visibility ~= "on" and visibility ~= "off" then
                outputGuiPopup("Syntax: /speedometer [on|off]")
                return
        end
        if visibility == "on" and not g_settings.Display then
		g_settings.Display = true
        elseif g_settings.Display then
                g_settings.Display = false
        else
                return
        end

        if saveSettingsToFile() then
                local text = "Speedometer is now "
                if g_settings.Display then
                        text = text .. "visible."
                else
                        text = text .. "hidden."
                end
                outputGuiPopup(text)
        end

end
addCommandHandler("speedometer", consoleSetSpeedometerVisibility)

function consoleSetSpeedometerScale(commandName, number)
	if tonumber(number) == nil then
		outputGuiPopup("Syntax: /scale_speedometer [number]")
		return
	end

	g_settings.speedoScale = number

	if saveSettingsToFile() then
		outputGuiPopup("Speedometer scale is now " .. number)
	end
end
addCommandHandler("scale_speedometer", consoleSetSpeedometerScale)

function consoleSetSpeedometerFont(commandName, font)

	if not font then
		outputChatBox(table.concat(font_list, ", "))
		outputGuiPopup("Syntax: /font_speedometer [fontname]")
		return
	end

	for i, v in pairs(font_list) do

		if v == font then
			g_settings.Font = font
			outputGuiPopup("Speedometer font is now " .. font)
			return

		end
	end
	outputGuiPopup("Invalid font name \"" .. font .. "\".")

end	

addCommandHandler("font_speedometer", consoleSetSpeedometerFont)
