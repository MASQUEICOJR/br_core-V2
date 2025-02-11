-----------------------------------------------------------------------------------------------------------------------------------------
-- ONCLIENTRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("onClientResourceStart")
AddEventHandler("onClientResourceStart",function(Resource)
	if GetCurrentResourceName() == Resource then
		
		
		DoScreenFadeOut(0)
		DisplayRadar(false)
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		TriggerEvent("spawn:Opened")
		return
	end
end)