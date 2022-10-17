function onClientResourceStart()
	setWorldSpecialPropertyEnabled("randomfoliage", false)
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)
-------------------------------------------------------------------------------------------------------------------------
addEvent("onClientMapStarting", true)
function onClientMapStarting()
	setWorldSpecialPropertyEnabled("randomfoliage", false)
end
addEventHandler("onClientMapStarting", root, onClientMapStarting)
-------------------------------------------------------------------------------------------------------------------------
function onClientResourceStop()
	setWorldSpecialPropertyEnabled("randomfoliage", true)
end
addEventHandler( "onClientResourceStop", resourceRoot, onClientResourceStop)