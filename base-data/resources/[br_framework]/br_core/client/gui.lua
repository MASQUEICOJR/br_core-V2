local menu_state = {}
local point = false
local anims = {
	{ dict = "random@mugging3","handsup_standing_base", anim = "handsup_standing_base" },
	{ dict = "random@arrests@busted", anim = "idle_a" },
	{ dict = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss" },
	{ dict = "mini@strip_club@idles@bouncer@base", anim = "base" },
	{ dict = "anim@mp_player_intupperfinger", anim = "idle_a_fp" },
	{ dict = "random@arrests", anim = "generic_radio_enter" },
	{ dict = "mp_player_int_upperpeace_sign", anim = "mp_player_int_peace_sign" }
}

function tBR.openMenuData(menudata)
	SendNUIMessage({ act = "open_menu", menudata = menudata })
end

function tBR.closeMenu()
	SendNUIMessage({ act = "close_menu" })
end

function tBR.getMenuState()
	return menu_state
end

RegisterCommand("keybind",function(source,args)
    if not IsPauseMenuActive() then
        local ped = PlayerPedId()
        if not menu_celular and GetEntityHealth(ped) > 101 then
            if args[1] == "1" then
                TriggerServerEvent("inventory:useItem","1",1)
            elseif args[1] == "2" then
                TriggerServerEvent("inventory:useItem","2",1)
            elseif args[1] == "3" then
                TriggerServerEvent("inventory:useItem","3",1)
            elseif args[1] == "4" then
                TriggerServerEvent("inventory:useItem","4",1)
            elseif args[1] == "5" then
                TriggerServerEvent("inventory:useItem","5",1)
            end
        end
    end
end)

RegisterKeyMapping("keybind 1","Inventario slot 1","keyboard","1")
RegisterKeyMapping("keybind 2","Inventario slot 2","keyboard","2")
RegisterKeyMapping("keybind 3","Inventario slot 3","keyboard","3")
RegisterKeyMapping("keybind 4","Inventario slot 4","keyboard","4")

--[ CANCELANDO O F6 ]--------------------------------------------------------------------------------------------------------------------

local cancelando = false
RegisterNetEvent('cancelando')
AddEventHandler('cancelando',function(status)
    cancelando = status
end)

Citizen.CreateThread(function()
	while true do
		local idle = 500
		if cancelando then
			idle = 4
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,29,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,137,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,169,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)			
		end

		if menu_celular then
			idle = 4
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,16,true)
			DisableControlAction(0,17,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,170,true)				
			DisableControlAction(0,182,true)	
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,344,true)			
		end

		if menu_state.opened then
			idle = 4
			DisableControlAction(0,75)
		end

		for _,block in pairs(anims) do
			if IsEntityPlayingAnim(PlayerPedId(),block.dict,block.anim,3) or object then
				idle = 4
			    BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,137,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
			end
		end
	  Citizen.Wait(idle)
	end
end)

function tBR.prompt(title,default_text)
	SendNUIMessage({ act = "prompt", title = title, text = tostring(default_text) })
	SetNuiFocus(true)
end

function tBR.request(id,text,time)
	SendNUIMessage({ act = "request", id = id, text = tostring(text), time = time })
end

RegisterNUICallback("menu",function(data,cb)
	if data.act == "close" then
		BRserver._closeMenu(data.id)
	elseif data.act == "valid" then
		BRserver._validMenuChoice(data.id,data.choice,data.mod)
	end
end)

RegisterNUICallback("menu_state",function(data,cb)
	menu_state = data
end)

RegisterNUICallback("prompt",function(data,cb)
	if data.act == "close" then
		SetNuiFocus(false)
		BRserver._promptResult(data.result)
	end
end)

RegisterNUICallback("request",function(data,cb)
	if data.act == "response" then
		BRserver._requestResult(data.id,data.ok)
	end
end)

RegisterNUICallback("init",function(data,cb)
	SendNUIMessage({ act = "cfg", cfg = {} })
	TriggerEvent("BR:NUIready")
end)

function tBR.setDiv(name,css,content)
	SendNUIMessage({ act = "set_div", name = name, css = css, content = content })
end

function tBR.setDivContent(name,content)
	SendNUIMessage({ act = "set_div_content", name = name, content = content })
end

function tBR.removeDiv(name)
	SendNUIMessage({ act = "remove_div", name = name })
end

local object = nil

function tBR.loadAnimSet(dict)
	RequestAnimSet(dict)
	while not HasAnimSetLoaded(dict) do
		Citizen.Wait(10)
	end
	SetPedMovementClipset(PlayerPedId(),dict,0.25)
end

function tBR.CarregarAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function tBR.CarregarObjeto(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Citizen.Wait(10)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,false,true,1,true)
	else
		tBR.CarregarAnim(dict)
		TaskPlayAnim(ped,dict,anim,3-.0,3.0,-1,flag,0,0,0,0)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
	end
	Citizen.InvokeNative(0xAD738C3085FE7E11,object,true,true)
end

function tBR.DeletarObjeto()
    tBR.stopAnim(true)
    TriggerEvent("binoculos")
    if DoesEntityExist(object) then
        TriggerServerEvent("trydeleteobj",ObjToNet(object))
        object = nil
    end
end

local menu_celular = false
RegisterNetEvent("status:celular")
AddEventHandler("status:celular",function(status)
	menu_celular = status
end)

--[ COOLDOWN ]---------------------------------------------------------------------------------------------------------------------------

local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)
--[  ]-----------------------------------------------------------------------------

RegisterKeyMapping ( 'br_core:accept' , 'Aceitar' , 'keyboard' , 'y' )

RegisterCommand('br_core:accept', function()
    SendNUIMessage({ act = "event", event = "Y" })
end, false)

RegisterKeyMapping ( 'br_core:decline' , 'Negar' , 'keyboard' , 'U' )

RegisterCommand('br_core:decline', function()
    SendNUIMessage({ act = "event", event = "U" })
end, false)

--[  ]-----------------------------------------------------------------------------

RegisterKeyMapping ( 'br_core:up' , 'Cima' , 'keyboard' , 'UP' )

RegisterCommand('br_core:up', function()
	if menu_state.opened then
		SendNUIMessage({ act = "event", event = "UP" }) 
        tBR.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET") 
	end
end, false)

RegisterKeyMapping ( 'br_core:down' , 'Baixo' , 'keyboard' , 'DOWN' )

RegisterCommand('br_core:down', function()
	if menu_state.opened then
		SendNUIMessage({ act = "event", event = "DOWN" })
        tBR.playSound("NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end
end, false)

RegisterKeyMapping ( 'br_core:left' , 'Esquerda' , 'keyboard' , 'LEFT' )

RegisterCommand('br_core:left', function()
	if menu_state.opened then
		SendNUIMessage({ act = "event", event = "LEFT" })
        tBR.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end
end, false)

RegisterKeyMapping ( 'br_core:right' , 'Direita' , 'keyboard' , 'RIGHT' )

RegisterCommand('br_core:right', function()
	if menu_state.opened then
		SendNUIMessage({ act = "event", event = "RIGHT" }) 
        tBR.playSound("NAV_LEFT_RIGHT","HUD_FRONTEND_DEFAULT_SOUNDSET")
	end
end, false)

RegisterKeyMapping ( 'br_core:select' , 'Selecionar' , 'keyboard' , 'RETURN' )

RegisterCommand('br_core:select', function()
	if menu_state.opened then
		SendNUIMessage({ act = "event", event = "SELECT" })
		tBR.playSound("SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET") 
	end
end, false)

RegisterKeyMapping ( 'br_core:cancel' , 'Cancelar' , 'keyboard' , 'BACK' )

RegisterCommand('br_core:cancel', function()
	SendNUIMessage({ act = "event", event = "CANCEL" })
end, false)

--[  ]-----------------------------------------------------------------------------

RegisterKeyMapping ( 'br_core:anim01' , '[A] Cruzar os braços' , 'keyboard' , 'F2' )

RegisterCommand('br_core:anim01', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		if IsEntityPlayingAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss",3) then
			tBR.DeletarObjeto()
		else
			tBR.playAnim(true,{{"anim@heists@heist_corona@single_team","single_team_loop_boss"}},true)
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:anim02' , '[A] Aguardar' , 'keyboard' , 'F3' )

RegisterCommand('br_core:anim02', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		if IsEntityPlayingAnim(ped,"mini@strip_club@idles@bouncer@base","base",3) then
			tBR.DeletarObjeto()
		else
			tBR.playAnim(true,{{"mini@strip_club@idles@bouncer@base","base"}},true)
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:cancelAnims' , 'Cancelar animações' , 'keyboard' , 'F6' )

RegisterCommand('br_core:cancelAnims', function()
	local ped = PlayerPedId()
	if cooldown < 1 then
		cooldown = 20
		if GetEntityHealth(ped) > 101 then
			if not menu_state.opened and not cancelando then
				tBR.DeletarObjeto()
				ClearPedTasks(ped)
			end
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:anim10' , '[A] Mãos na cabeça' , 'keyboard' , 'F10' )

RegisterCommand('br_core:anim10', function()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
			tBR.DeletarObjeto()
		else
			tBR.DeletarObjeto()
			tBR.playAnim(true,{{"random@arrests@busted","idle_a"}},true)
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:animX' , '[A] Levantar as mãos' , 'keyboard' , 'X' )

RegisterCommand('br_core:animX', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_celular and not cancelando then
		SetCurrentPedWeapon(ped,GetHashKey("WEAPON_UNARMED"),true)
		if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
			tBR.DeletarObjeto()
		else
			tBR.playAnim(true,{{"random@mugging3","handsup_standing_base"}},true)
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:vehicleZ' , '[V] Ligar motor' , 'keyboard' , 'Z' )

RegisterCommand('br_core:vehicleZ', function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped,false)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
			tBR.DeletarObjeto()
			local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
			SetVehicleEngineOn(vehicle,not running,true,true)
			if running then
				SetVehicleUndriveable(vehicle,true)
			else
				SetVehicleUndriveable(vehicle,false)
			end
		end
	end
end, false)

RegisterKeyMapping ( 'br_core:animp3' , '[A] Beleza' , 'keyboard' , '3' )

RegisterCommand('br_core:animp3', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		tBR.playAnim(true,{{"anim@mp_player_intincarthumbs_upbodhi@ps@","enter"}},false)
	end
end, false)

RegisterKeyMapping ( 'br_core:animp4' , '[A] Saudação' , 'keyboard' , '4' )

RegisterCommand('br_core:animp4', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		tBR.playAnim(true,{{"anim@mp_player_intcelebrationmale@salute","salute"}},false)
	end
end, false)

RegisterKeyMapping ( 'br_core:animp5' , '[A] Assobiar' , 'keyboard' , '5' )

RegisterCommand('br_core:animp5', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		tBR.playAnim(true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false)
	end
end, false)

RegisterKeyMapping ( 'br_core:animp6' , '[A] Vergonha!' , 'keyboard' , '6' )

RegisterCommand('br_core:animp6', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 101 and not menu_state.opened and not menu_celular and not cancelando then
		tBR.playAnim(true,{{"anim@mp_player_intcelebrationmale@face_palm","face_palm"}},false)
	end
end, false)
--[ SYNCCLEAN ]--------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("syncclean")
AddEventHandler("syncclean",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				tBR.DeletarObjeto()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SYNCDELETEPED ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("syncdeleteped")
AddEventHandler("syncdeleteped",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToPed(index)
		if DoesEntityExist(v) then
			Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
			SetPedAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
			DeletePed(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ WALK DAMAGE ]
-----------------------------------------------------------------------------------------------------------------------------------------
local hurt = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		if not IsEntityInWater(ped) then
			if GetEntityHealth(ped) <= 199 then
				setHurt()
			elseif hurt and GetEntityHealth(ped) > 200 then
				setNotHurt()
			end
		end
	end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(PlayerPedId(),"move_m@injured",true)
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
	DisableControlAction(0,21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(),0.0)
    ResetPedMovementClipset(PlayerPedId())
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POINT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if point then
			timeDistance = 4
			local ped = PlayerPedId()
			local camPitch = GetGameplayCamRelativePitch()

			if camPitch < -70.0 then
				camPitch = -70.0
			elseif camPitch > 42.0 then
				camPitch = 42.0
			end
			camPitch = (camPitch + 70.0) / 112.0

			local camHeading = GetGameplayCamRelativeHeading()
			local cosCamHeading = Cos(camHeading)
			local sinCamHeading = Sin(camHeading)
			if camHeading < -180.0 then
				camHeading = -180.0
			elseif camHeading > 180.0 then
				camHeading = 180.0
			end
			camHeading = (camHeading + 180.0) / 360.0

			local blocked = 0
			local nn = 0
			local coords = GetOffsetFromEntityInWorldCoords(ped,(cosCamHeading*-0.2)-(sinCamHeading*(0.4*camHeading+0.3)),(sinCamHeading*-0.2)+(cosCamHeading*(0.4*camHeading+0.3)),0.6)
			local ray = Cast_3dRayPointToPoint(coords.x,coords.y,coords.z-0.2,coords.x,coords.y,coords.z+0.2,0.4,95,ped,7);
			nn,blocked,coords,coords = GetRaycastResult(ray)

			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Pitch",camPitch)
			Citizen.InvokeNative(0xD5BB4025AE449A4E,ped,"Heading",camHeading*-1.0+1.0)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isBlocked",blocked)
			Citizen.InvokeNative(0xB0A6CFD2C69C1088,ped,"isFirstPerson",Citizen.InvokeNative(0xEE778F8C7E1142E2,Citizen.InvokeNative(0x19CAFA3C87F7C2FF))==4)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ SEAT ]
-----------------------------------------------------------------------------------------------------------------------------------------
local disableShuffle = true
function disableSeatShuffle(flag)
    disableShuffle = flag
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
                if GetIsTaskActive(GetPlayerPed(-1), 165) then
                    SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                end
            end
        end
    end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        disableSeatShuffle(false)
        Citizen.Wait(5000)
        disableSeatShuffle(true)
    else
        CancelEvent()
    end
end)

RegisterCommand("seat", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false)


RegisterCommand("keybindPoint",function(source,args)
	if not IsPauseMenuActive() then
		local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) and GetEntityHealth(ped) > 100 and not menu_celular then
			tBR.CarregarAnim("anim@mp_point")

			if not point then
				SetPedCurrentWeaponVisible(ped,0,1,1,1)
				SetPedConfigFlag(ped,36,1)
				TaskMoveNetwork(ped,"task_mp_pointing",0.5,0,"anim@mp_point",24)
				point = true
			else
				Citizen.InvokeNative(0xD01015C7316AE176,ped,"Stop")
				if not IsPedInjured(ped) then
					ClearPedSecondaryTask(ped)
				end

				if not IsPedInAnyVehicle(ped) then
					SetPedCurrentWeaponVisible(ped,1,1,1,1)
				end

				SetPedConfigFlag(ped,36,0)
				ClearPedSecondaryTask(ped)
				point = false
			end
		end
	end
end)

RegisterKeyMapping("keybindPoint","Apontar os dedos","keyboard","b")