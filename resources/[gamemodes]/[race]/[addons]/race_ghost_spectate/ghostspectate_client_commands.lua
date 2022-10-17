function info(command, mode)
	mode = tonumber(mode)
	if not mode then
		outputChatBox("[Ghost-Spectate] {info} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
		return
	elseif mode == 1 then
		Settings["ghostInfo"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost information turned on.", 255, 255, 255, true)
	elseif mode == 0 then
		Settings["ghostInfo"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost information turned off.", 255, 255, 255, true)
	else
		outputChatBox("[Ghost-Spectate] {info} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
	end
	saveSettings()
end
addCommandHandler("info", info)
-------------------------------------------------------------------------------------------------------------------------
function route(command, mode)
	mode = tonumber(mode)
	if not mode then
		outputChatBox("[Ghost-Spectate] {route} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
		return
	elseif mode == 1 then
		Settings["ghostRouteHighlight"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost route highlights turned on.", 255, 255, 255, true)
	elseif mode == 0 then
		Settings["ghostRouteHighlight"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost route highlights turned off.", 255, 255, 255, true)
	else
		outputChatBox("[Ghost-Spectate] {route} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
	end
	saveSettings()
end
addCommandHandler("route", route)
-------------------------------------------------------------------------------------------------------------------------
function blips(command, mode)
	mode = tonumber(mode)
	if not mode then
		outputChatBox("[Ghost-Spectate] {blips} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
		return
	elseif mode == 1 then
		Settings["ghostCPBlips"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost checkpoint blips turned on.", 255, 255, 255, true)
	elseif mode == 0 then
		Settings["ghostCPBlips"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost checkpoint blips turned off.", 255, 255, 255, true)
	else
		outputChatBox("[Ghost-Spectate] {blips} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
	end
	saveSettings()
end
addCommandHandler("blips", blips)
-------------------------------------------------------------------------------------------------------------------------
function markers(command, mode)
	mode = tonumber(mode)
	if not mode then
		outputChatBox("[Ghost-Spectate] {markers} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
		return
	elseif mode == 1 then
		Settings["ghostCPMarkers"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost checkpoint markers turned on.", 255, 255, 255, true)
	elseif mode == 0 then
		Settings["ghostCPMarkers"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Ghost checkpoint markers turned off.", 255, 255, 255, true)
	else
		outputChatBox("[Ghost-Spectate] {markers} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
	end
	saveSettings()
end
addCommandHandler("markers", markers)
-------------------------------------------------------------------------------------------------------------------------
function timesUpOnGhostFinish(command, mode)
	mode = tonumber(mode)
	if not mode then
		outputChatBox("[Ghost-Spectate] {time's up} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
		return
	elseif mode == 1 then
		Settings["ghostTimesUpOnFinish"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Next map vote after ghost finishes turned on.", 255, 255, 255, true)
	elseif mode == 0 then
		Settings["ghostTimesUpOnFinish"] = tonumber(mode)
		outputChatBox("[Ghost-Spectate] Next map vote after ghost finishes turned off.", 255, 255, 255, true)
	else
		outputChatBox("[Ghost-Spectate] {time's up} Please select a mode: 1 - [on], 0 - [off].", 255, 255, 255, true)
	end
	saveSettings()
end
addCommandHandler("timesup", timesUpOnGhostFinish)