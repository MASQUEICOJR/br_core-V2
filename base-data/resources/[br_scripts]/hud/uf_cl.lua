-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
BR = Proxy.getInterface("BR")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vAZserver = Tunnel.getInterface('mid_hud')
vAZ = {}
Tunnel.bindInterface('mid_hud', vAZ)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false

local hunger = 100
local thirst = 100
local stress = 0
local hudoff = false
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- CLOCKVARIABLES
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- local clockHours = 18
-- local clockMinutes = 0
-- local timeDate = GetGameTimer()
-- local weatherSync = "EXTRASUNNY"
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- THREADGLOBAL
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if GetGameTimer() >= (timeDate + 10000) then
-- 			timeDate = GetGameTimer()
-- 			clockMinutes = clockMinutes + 1

-- 			if clockMinutes >= 60 then
-- 				clockHours = clockHours + 1
-- 				clockMinutes = 0

-- 				if clockHours >= 24 then
-- 					clockHours = 0
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(10000)
-- 	end
-- end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- HUD:SYNCTIMERS
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent("hud:syncTimers")
-- AddEventHandler("hud:syncTimers",function(timer)
-- 	clockHours = parseInt(timer[2])
-- 	clockMinutes = parseInt(timer[1])
-- 	weatherSync = timer[3]
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusHunger")
AddEventHandler("statusHunger",function(number)
	hunger = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusThirst")
AddEventHandler("statusThirst",function(number)
	thirst = parseInt(number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSFOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusFoods")
AddEventHandler("statusFoods",function(statusThirst,statusHunger)
	thirst = parseInt(statusThirst)
	hunger = parseInt(statusHunger)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATUSSTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("statusStress")
AddEventHandler("statusStress",function(number)
	stress = parseInt(number)
end)

inCar = false
Citizen.CreateThread(function()
while true do
	local likizao = 300 -- aumentar caso queira menor ms
	local ped = PlayerPedId()
	inCar = IsPedInAnyVehicle(ped, false)

	if inCar then 
		vehicle = GetVehiclePedIsIn(ped, false)
		local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
		local armour = GetPedArmour(ped)
		local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
		local x,y,z = table.unpack(GetEntityCoords(ped,false))
		local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))

		SendNUIMessage({
			action = "inCar",
			health = vida,
			armour = armour,
			stamina = stamina,
			street = street,
			hunger = parseInt(hunger),
			thirst = parseInt(thirst),
			stress = parseInt(stress),
			hudoff = hudoff,
		})	
	end

	Citizen.Wait(likizao)	
end
end)

Citizen.CreateThread(function()
	while true do
		local likizao = 200 -- aumentar caso queira menor ms
		if inCar then 
			likizao = 60 -- aumentar caso queira menor ms
			local speed = math.ceil(GetEntitySpeed(vehicle) * 2.236936)
			local _,lights,highlights = GetVehicleLightsState(vehicle)
			local marcha = GetVehicleCurrentGear(vehicle)
			local fuel = GetVehicleFuelLevel(vehicle)
			local engine = GetVehicleEngineHealth(vehicle)
			local farol = "off"

			if lights == 1 and highlights == 0 then farol = "normal"
			elseif (lights == 1 and highlights == 1) or (lights == 0 and highlights == 1) then 
				farol = "alto"
			end

			carGear = GetVehicleCurrentGear(vehicle)
			rpm = GetVehicleCurrentRpm(vehicle)
            rpm = math.ceil(rpm * 10000, 2)
            vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)
			SendNUIMessage({
				only = "updateSpeed",
				speed = speed,
				marcha = carGear,
				fuel = parseInt(fuel),
				engine = parseInt(engine/10),
				farol = farol,
				rpmnail = vehicleNailRpm,
                rpm = rpm/100,
				cinto = CintoSeguranca,
				hudoff = hudoff,
			})			
		end
		Citizen.Wait(likizao)	
	end
end)


Citizen.CreateThread(function()
	while true do
		local likizao = 300 -- aumentar caso queira menor ms
		if not inCar then 
			
			DisplayRadar(false)
			local ped = PlayerPedId()
			local vida = math.ceil((100 * ((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100))))
			local armour = GetPedArmour(ped)
			local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
			local x,y,z = table.unpack(GetEntityCoords(ped,false))
			local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z))

			SendNUIMessage({
				action = "update",
				health = vida,
				armour = armour,
				stamina = stamina,
				street = street,
				hudoff = hudoff,
				hunger = parseInt(hunger),
				thirst = parseInt(thirst),
				stress = parseInt(stress),
			})			

		else
			DisplayRadar(true)
		end
		Citizen.Wait(likizao)	
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEATBELT
-----------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then hr = 360.0 + hr end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
  end

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			timeDistance = 4
			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				SetEntityHealth(ped,GetEntityHealth(ped)-10)

				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
		
			end

			if IsControlJustReleased(1,47) then
				if CintoSeguranca then
					TriggerEvent("sounds:source","unbelt",0.5)
					CintoSeguranca = false
				else
					TriggerEvent("sounds:source","belt",0.5)
					CintoSeguranca = true
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		Citizen.Wait(timeDistance)
	end
end)

RegisterCommand("hud",function(source,args)
	hudoff = not hudoff
end)

-- RegisterCommand('banco', function(source, args, rawCmd)
-- 	local ped = PlayerPedId()
-- 	if IsPedInAnyVehicle(ped, false) then	
-- 		local carrinhu = GetVehiclePedIsIn(ped, false)
-- 		if not seatbeltIsOn then
-- 			if args[1] then
-- 				local acento = parseInt(args[1])
				
-- 				if acento == 1 then
-- 					if IsVehicleSeatFree(carrinhu, -1) then 
-- 						if GetPedInVehicleSeat(carrinhu, 0) == ped then
-- 							SetPedIntoVehicle(ped, carrinhu, -1)
-- 						else
-- 							TriggerEvent('Notify', 'negado','Você só pode passar para o P1 a partir do P2.')
-- 						end
-- 					else
-- 						TriggerEvent('Notify','negado','O acento deve estar livre.')
-- 					end
-- 				elseif acento == 2 then
-- 					if IsVehicleSeatFree(carrinhu, 0) then 
-- 						if GetPedInVehicleSeat(carrinhu, -1) == ped then
-- 							SetPedIntoVehicle(ped, carrinhu, 0)
-- 						else
-- 							TriggerEvent('Notify', 'negado','Você só pode passar para o P2 a partir do P1.')
-- 						end
-- 					else
-- 						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
-- 					end
-- 				elseif acento == 3 then
-- 					if IsVehicleSeatFree(carrinhu, 1) then 
-- 						if GetPedInVehicleSeat(carrinhu, 2) == ped then
-- 							SetPedIntoVehicle(ped, carrinhu, 1)
-- 						else
-- 							TriggerEvent('Notify', 'negado','Você só pode passar para o P3 a partir do P4.')
-- 						end
-- 					else
-- 						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
-- 					end
-- 				elseif acento == 4 then
-- 					if IsVehicleSeatFree(carrinhu, 2) then 
-- 						if GetPedInVehicleSeat(carrinhu, 1) == ped then
-- 							SetPedIntoVehicle(ped, carrinhu, 2)
-- 						else
-- 							TriggerEvent('Notify', 'negado','Você só pode passar para o P4 a partir do P3.')
-- 						end
-- 					else
-- 						TriggerEvent('Notify', 'negado','O acento deve estar livre.')
-- 					end
-- 				end
-- 			else
-- 				TriggerEvent('Notify', 'negado','Especifique o acento que quer ir!')
-- 			end
-- 		else
-- 			TriggerEvent('Notify', 'negado','Você não pode utilizar esse comando com o cinto de segurança!')
-- 		end
-- 	end
-- end)
	
RegisterCommand("cr",function(source,args)
	local veh = GetVehiclePedIsIn(PlayerPedId(),false)
	local maxspeed = GetVehicleMaxSpeed(GetEntityModel(veh))
	local vehspeed = GetEntitySpeed(veh)*3.605936
	if GetPedInVehicleSeat(veh,-1) == PlayerPedId() and math.ceil(vehspeed) >= 0 and GetEntityModel(veh) ~= -2076478498 and not IsEntityInAir(veh) then
		if args[1] == nil then
			SetEntityMaxSpeed(veh,maxspeed)
			TriggerEvent("Notify","sucesso","Limitador de Velocidade desligado com sucesso.")
		elseif args[1] ~= 0 then
			SetEntityMaxSpeed(veh,0.45*args[1]-0.45)
			TriggerEvent("Notify","sucesso","Velocidade máxima travada em <b>"..args[1].."MP/H</b>.")
		end
	end
end)

local StatusCarro = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local lockStatus = GetVehicleDoorLockStatus(vehicle)
            if (lockStatus == 1) then
				StatusCarro = true
                SendNUIMessage({
					lock = "fecharcarro", 
					status = StatusCarro,
				})
            elseif lockstatus ~= 1 then
				StatusCarro = false
                SendNUIMessage({
					lock = "fecharcarro", 
					status = StatusCarro,
				})
            end
        end
    end
end)

local saltyScreen = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALTYSCREEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaltyChat_PluginStateChanged",function(statusScreen)
	if statusScreen <= 1 then
		if not saltyScreen then
			saltyScreen = true
			SendNUIMessage({ screen = saltyScreen })
		end
	else
		if saltyScreen then
			saltyScreen = false
			SendNUIMessage({ screen = saltyScreen })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOICETALKING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaltyChat_TalkStateChanged",function(status)
	SendNUIMessage({action = "talking", boolean = status})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("SaltyChat_VoiceRangeChanged")
AddEventHandler("SaltyChat_VoiceRangeChanged",function(_,status)
	SendNUIMessage({action = "proximity", number = status })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_HUD:VOICEMODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RadioDisplay")
AddEventHandler("hud:RadioDisplay",function(text)
    SendNUIMessage({action = "channel", text = text})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            HideHudComponentThisFrame(1)  -- Wanted Stars
            HideHudComponentThisFrame(2)  -- Weapon Icon
            HideHudComponentThisFrame(3)  -- Cash
            HideHudComponentThisFrame(4)  -- MP Cash
            HideHudComponentThisFrame(6)  -- Vehicle Name
            HideHudComponentThisFrame(7)  -- Area Name
            HideHudComponentThisFrame(8)  -- Vehicle Class
            HideHudComponentThisFrame(9)  -- Street Name
            HideHudComponentThisFrame(13) -- Cash Change
            HideHudComponentThisFrame(17) -- Save Game
            HideHudComponentThisFrame(20) -- Weapon Stats
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHEALTHREDUCE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			if hunger >= 6 and hunger <= 15 then
				ApplyDamageToPed(ped,1,false)
				TriggerEvent("Notify","amarelo","Sofrendo com a fome.",2000)
			elseif hunger <= 5 then
				ApplyDamageToPed(ped,2,false)
				TriggerEvent("Notify","amarelo","Sofrendo com a fome.",2000)
			end

			if thirst >= 6 and thirst <= 15 then
				ApplyDamageToPed(ped,1,false)
				TriggerEvent("Notify","amarelo","Sofrendo com a sede.",2000)
			elseif thirst <= 5 then
				ApplyDamageToPed(ped,2,false)
				TriggerEvent("Notify","amarelo","Sofrendo com a sede.",2000)
			end
		end

		Citizen.Wait(15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHAKESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)

		if health > 101 then
			if stress >= 99 then
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.75)
				TriggerEvent("Notify","amarelo","Sofrendo com o estresse.",2000)
			elseif stress >= 80 and stress <= 98 then
				timeDistance = 5000
				TriggerEvent("Notify","amarelo","Sofrendo com o estresse.",2000)
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.50)
			elseif stress >= 60 and stress <= 79 then
				timeDistance = 7500
				TriggerEvent("Notify","amarelo","Sofrendo com o estresse.",2000)
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.25)
			elseif stress >= 40 and stress <= 59 then
				timeDistance = 10000
				TriggerEvent("Notify","amarelo","Sofrendo com o estresse.",2000)
				ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)
			end
		end

		Citizen.Wait(timeDistance)
	end
end)


AddEventHandler('onClientMapStart', function()
    Citizen.CreateThread(function()
      local display = true
  
      TriggerEvent('logo:disp', true)
    end)
  end)
  
  RegisterNetEvent('logo:disp')
  AddEventHandler('logo:disp', function(valor)
    SendNUIMessage({
      type = "logo",
      display = valor
    })
  end)