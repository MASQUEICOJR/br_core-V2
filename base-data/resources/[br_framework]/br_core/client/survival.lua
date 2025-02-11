function tBR.varyHealth(variation)
	local ped = PlayerPedId()
	local n = math.floor(GetEntityHealth(ped)+variation)
	SetEntityHealth(ped,n)
end

--[ GETHEALTH ]--------------------------------------------------------------------------------------------------------------------------

function tBR.getHealth()
	return GetEntityHealth(PlayerPedId())
end

--[ SETHEALTH ]--------------------------------------------------------------------------------------------------------------------------

function tBR.setHealth(health)
	SetEntityHealth(PlayerPedId(),parseInt(health))
end

--[ SETFRIENDLYFIRE ]--------------------------------------------------------------------------------------------------------------------

function tBR.setFriendlyFire(flag)
	NetworkSetFriendlyFireOption(flag)
	SetCanAttackFriendly(PlayerPedId(),flag,flag)
end

--[ NOCAUTEVAR ]-------------------------------------------------------------------------------------------------------------------------

local nocauteado = false
local deathtimer = 900

--[ NOCAUTEADO ]-------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if GetEntityHealth(ped) <= 101 and deathtimer >= 0 then
			idle = 5
			if not nocauteado then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				NetworkResurrectLocalPlayer(x,y,z,true,true,false)

				deathtimer = 900
				nocauteado = true
				BRserver._updateHealth(101)

				SetEntityHealth(ped,101)
				SetEntityInvincible(ped,true)

				if IsPedInAnyVehicle(ped) then
					TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
				end

				exports['pma-voice']:toggleMutePlayer(true)
				exports["pma-voice"]:removePlayerFromRadio()
				exports["pma-voice"]:setVoiceProperty('radioEnabled',false)
				TriggerEvent("radio:outServers")
				TriggerEvent("hud:setShow", false)
			else
				if deathtimer > 0 then
				--	drawTxt("VOCE TEM ~r~"..deathtimer.." ~w~SEGUNDOS DE VIDA, AGUARDE POR SOCORRO MÉDICO",4,0.5,0.92,0.35,255,255,255,255)
				else
				--	drawTxt("PRESSIONE ~g~E ~w~PARA VOLTAR AO AEROPORTO OU AGUARDE POR SOCORRO MÉDICO",4,0.5,0.92,0.35,255,255,255,255)
				end
				SetPedToRagdoll(ped,1000,1000,0,0,0,0)
				SetEntityHealth(ped,101)
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,21,true)
				DisableControlAction(0,22,true)
				DisableControlAction(0,23,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,32,true)
				DisableControlAction(0,33,true)
				DisableControlAction(0,34,true)
				DisableControlAction(0,35,true)
				DisableControlAction(0,47,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,58,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,75,true)
				DisableControlAction(0,137,true)
				DisableControlAction(0,140,true)
				DisableControlAction(0,141,true)
				DisableControlAction(0,142,true)
				DisableControlAction(0,143,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,168,true)
				DisableControlAction(0,169,true)
				DisableControlAction(0,170,true)
				DisableControlAction(0,177,true)
				DisableControlAction(0,182,true)
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,263,true)
				DisableControlAction(0,264,true)
				DisableControlAction(0,268,true)
				DisableControlAction(0,269,true)
				DisableControlAction(0,270,true)
				DisableControlAction(0,271,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,311,true)
				DisableControlAction(0,344,true)
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ BUTTONTIMER ]------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
		if GetEntityHealth(ped) <= 101 and deathtimer <= 0 then
			idle = 5
			if IsControlJustPressed(0,38) then
				TriggerEvent("resetBleeding")
                TriggerEvent("resetDiagnostic")
                TriggerServerEvent("clearInventory")
                deathtimer = 900
                nocauteado = false
                ClearPedBloodDamage(ped)
                SetEntityInvincible(ped,false)
                DoScreenFadeOut(1000)
                SetEntityHealth(ped,240)
				TriggerEvent("rainda",0)
                Citizen.Wait(1000)
                SetEntityCoords(PlayerPedId(),-449.2,-340.9,34.51+0.0001,1,0,0,1)
                FreezeEntityPosition(ped,true)
                SetTimeout(5000,function()
                    FreezeEntityPosition(ped,false)
                    Citizen.Wait(1000)
                    DoScreenFadeIn(1000)
                end)
				TriggerEvent("hud:setShow", true)
				exports['pma-voice']:toggleMutePlayer(false)
            end
		end
		Citizen.Wait(idle)
    end
end)

--[ HEALTHRECHARGE ]---------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		SetPlayerHealthRechargeMultiplier(PlayerId(),0)
	end
end)

--[ DEATHTIMER ]-------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if nocauteado and deathtimer > 0 then
			deathtimer = deathtimer - 1
		end
	end
end)

--[ DRAWTXT ]----------------------------------------------------------------------------------------------------------------------------

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

--[ ISINCOMA ]---------------------------------------------------------------------------------------------------------------------------

function tBR.isInComa()
	return nocauteado
end

--[ NETWORKRESSURECTION ]----------------------------------------------------------------------------------------------------------------

function tBR.killGod()
	nocauteado = false
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	NetworkResurrectLocalPlayer(x,y,z,true,true,false)
	ClearPedBloodDamage(ped)
	SetEntityInvincible(ped,false)
	SetEntityHealth(ped,110)
	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)
	TriggerEvent("hud:setShow", true)
	--exports['pma-voice']:setMute(false)
end

--[ NETWORKPRISON ]----------------------------------------------------------------------------------------------------------------------

function tBR.PrisionGod()
	local ped = PlayerPedId()
	if GetEntityHealth(ped) <= 101 then
		nocauteado = false
		ClearPedBloodDamage(ped)
		SetEntityInvincible(ped,false)
		SetEntityHealth(ped,110)
		ClearPedTasks(ped)
		ClearPedSecondaryTask(ped)
		TriggerEvent("hud:setShow", true)
	end
end