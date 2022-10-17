autoDay = false
autoNight = false

function day(commandName, auto)
	if auto == 'auto' then
		if autoDay == false then
			addEventHandler('onClientPlayerSpawn', getLocalPlayer(), day)
			autoDay = true
			if autoNight then
				autoNight = false
				outputChatBox("#FE9F8B[INFO] #EADDB3Auto night is now #FF0000DISABLED", 255, 255, 255, true)
			end
			outputChatBox("#FE9F8B[INFO] #EADDB3Auto day is now #00FF00ENABLED", 255, 255, 255, true)
			
		elseif autoDay == true then
			removeEventHandler('onClientPlayerSpawn', getLocalPlayer(), day)
			autoDay = false
			outputChatBox("#FE9F8B[INFO] #EADDB3Auto day is now #FF0000DISABLED", 255, 255, 255, true)
		end
	else
		setTime( 12, 0)
		local weatherID = getWeather()
		if weatherID > 20 then
			setWeather(0)
		end
	end
end
addCommandHandler("day", day)

function night(commandName, auto)
	if auto == 'auto' then
		if autoNight == false then
			addEventHandler('onClientPlayerSpawn', getLocalPlayer(), night)
			autoNight = true
			if autoDay then
				autoDay = false
				outputChatBox("#FE9F8B[INFO] #EADDB3Auto day is now #FF0000DISABLED", 255, 255, 255, true)
			end
			outputChatBox("#FE9F8B[INFO] #EADDB3Auto night is now #00FF00ENABLED", 255, 255, 255, true)

		elseif autoNight == true then
			removeEventHandler('onClientPlayerSpawn', getLocalPlayer(), night)
			autoNight = false
			outputChatBox("#FE9F8B[INFO] #EADDB3Auto night is now #FF0000DISABLED", 255, 255, 255, true)
		end
		
	else
		setTime( 23, 0)
		local weatherID = getWeather()
		if weatherID > 20 then
			setWeather(0)
		end
	end
end

addCommandHandler("night", night)
