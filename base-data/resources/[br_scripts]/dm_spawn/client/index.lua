-----------------------------------------------------------------------------------------------------------------------------------------
--  SPAWN COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnLocations = {
	["Paleto"] = vec3(-781.29,5562.9,33.33),
	["Hospital"] = vec3(-485.67,-359.36,34.49),
	["Vermelho"] = vec3(-340.49,-876.19,31.07),
	["Garagem Praça"] = vec3(59.11,-866.72,30.55),
	["Delegacia"] = vec3(-1594.07,172.29,59.08),
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ON CLOSE INTERFACE
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnSalvo = nil
local activeCam = nil
local interfaceActive = false
function onCloseInterface()
	if DoesCamExist(activeCam) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(activeCam,false)
		DestroyCam(activeCam,false)
		activeCam = nil
	end

	interfaceActive = false
	SetNuiFocus(false)
	TriggerEvent("ToogleBackCharacter")
	SendNUIMessage({ action = 'close' })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE SPAWNS	
-----------------------------------------------------------------------------------------------------------------------------------------
function ToggleActionMenu()
	interfaceActive = not interfaceActive
	if interfaceActive then
		SetEntityVisible(PlayerPedId(), false)
		TriggerEvent("shortcuts:hide")
		TriggerEvent("flaviin:toggleHud",false)

		SetNuiFocus(true,true)
		SendNUIMessage({ action = 'open', name = Execute.getPrimaryName(), inFaction = Execute.inFaction() })

		activeCam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
		SetCamCoord(activeCam,-1082.17,-59.63,101.49)
		RenderScriptCams(true,true,0,true,true)
		SetCamRot(activeCam,0.0,0.0,30.0,2)
		SetCamActive(activeCam,true)
	else
		SetNuiFocus(false)
		SendNUIMessage({ action = 'close' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	StartFade()
	if data.callback == "faction" then 
		if Execute.spawnFaction() then
			onCloseInterface()
		else
			SetNuiFocus(true,true)
			SendNUIMessage({ action = 'open', name = Execute.getPrimaryName(), inFaction = Execute.inFaction() })
		end 
	else
		if spawnLocations[data.callback] then 
			BR._teleport(spawnLocations[data.callback].x,spawnLocations[data.callback].y,spawnLocations[data.callback].z)
		end

		onCloseInterface()
	end 

	Citizen.Wait(1000)

	EndFade()

	SetTimeout(10*1000,function()
		local ped = PlayerPedId()
		SetEntityHealth(ped,300)
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE CAM ACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNuiCallback("SetCam", function(data, cb)
	local nameSpawn = data.spawn and data.spawn.name
	if spawnLocations[nameSpawn] then 
		local ped = PlayerPedId()

		SetEntityCoords(ped,spawnLocations[nameSpawn]["x"],spawnLocations[nameSpawn]["y"],spawnLocations[nameSpawn]["z"] - 1)
		SetCamCoord(activeCam,spawnLocations[nameSpawn]["x"],spawnLocations[nameSpawn]["y"],spawnLocations[nameSpawn]["z"] + 1)
		SetCamRot(activeCam,0.0,0.0,0.0,2)
	end

	cb(true)
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('rmc_core:ToogleLoginMenu')
AddEventHandler('rmc_core:ToogleLoginMenu',function()
	ToggleActionMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- START FADE
-----------------------------------------------------------------------------------------------------------------------------------------
function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- END FADE
-----------------------------------------------------------------------------------------------------------------------------------------
function EndFade()
	SetEntityVisible(PlayerPedId(), true)
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end

	TriggerEvent("flaviin:toggleHud",true)
end

RegisterCommand('testing', function()
	ToggleActionMenu()
end)