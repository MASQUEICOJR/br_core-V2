
local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
BR = Proxy.getInterface("BR")
cRP = {}
Tunnel.bindInterface("wnInventory_v2",cRP)
vSERVER = Tunnel.getInterface("wnInventory_v2")

local contagemBandagem = 0
function cRP.SetBandagem(QtdBandagem)
    contagemBandagem = QtdBandagem
end

Citizen.CreateThread(function() 
    while true do
        Wait(1000)
        if contagemBandagem > 0 then
            contagemBandagem = contagemBandagem - 5
            local ped = PlayerPedId()
            local vida = GetEntityHealth(ped)
            if vida + 5 <= 390 then
                if vida > 101 then
                    SetEntityHealth(ped, vida + 5)
                else
                    contagemBandagem = 0
                    TriggerEvent('Notify', 'importante',"Importante", 'A bandagem foi cancelada por você estar em coma.')
                end
            else 
                TriggerEvent('Notify', 'sucesso',"Sucesso", 'Tratamento finalizado.')
                SetEntityHealth(ped, 390)
                contagemBandagem = 0
            end
        end
    end
end)

RegisterNUICallback("invClose",function()
	TransitionFromBlurred(1000)
	SetNuiFocus(false,false)
	vSERVER.closeInvSync()
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	TriggerServerEvent('br_core_inventory:status', false)
end)

function cRP.closeInventory()
	TransitionFromBlurred(1000)
	vSERVER.closeInvSync()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	TriggerServerEvent('br_core_inventory:status', false)
end

RegisterNUICallback("updateperfil",function(data,cb)
	if vSERVER.updateperfil(data.imglink) then
		local img,banner = vSERVER.RetornarImagens()
		cb({retorno = 'confirmado', img = img,banner = banner})
	end
end)

RegisterNUICallback("updatebanner",function(data,cb)
	if vSERVER.updatebanner(data.imglink) then
		local img,banner = vSERVER.RetornarImagens()
		cb({retorno = 'confirmado', img = img,banner = banner})
	end
end)

RegisterNUICallback("comprarSlot",function(data)
	vSERVER.comprarSlot()
	TransitionFromBlurred(1000)
	SetNuiFocus(false,false)
	vSERVER.closeInvSync()
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "hideMenu" })
	TriggerServerEvent('br_core_inventory:status', false)
end)


webhook_bau = ""


Citizen.CreateThread(function()
	while true do

	local msec = 400
	local cds = GetEntityCoords(PlayerPedId())
		for k,v in pairs(CHESTS) do 
			local dist = #(cds - v.coords)
			if dist <= 10.0 then 
				DrawMarker(21, v.coords[1],v.coords[2],v.coords[3]-0.7,0,0,0,0,0,0,0.2,0.2,0.3,255, 255, 255,255,0,0,0,1)
				DrawMarker(27, v.coords[1],v.coords[2],v.coords[3]-1,0,0,0,0,0,0,0.4,0.4,0.5,v.cor1, v.cor2, v.cor3,255,0,0,0,1)		
				msec = 3
				if dist <= 1.2 then 
					if IsControlJustPressed(0, 38) and vSERVER.CheckPerm_bau(v.permissao) then 
						local trabalho,vip,discord = vSERVER.checkJobs()
						local carteira,banco,nome,sobrenome,user_id,identidade,idade,telefone,multas,paypal,coins,foto = vSERVER.Identidade()
						webhook_bau = v.log
						SendNUIMessage({ action = "showMenu2", slot = slots, nome = nome, sobrenome = sobrenome, identidade = identidade, idade = idade, telefone = telefone, multas = multas, paypal = paypal, banco = banco, carteira = carteira, profissao = trabalho, vip = vip, id = user_id, coins = coins, foto = foto})	
						SetNuiFocus(true,true)	
				end 
			end
			end 
		end
		Wait(msec)
	end
end)

RegisterNetEvent("wni-inv:openChest")
AddEventHandler("wni-inv:openChest",function()
	local trabalho,vip,discord = vSERVER.checkJobs()
	local carteira,banco,nome,sobrenome,user_id,identidade,idade,telefone,multas,paypal,coins, foto = vSERVER.Identidade()	
	SendNUIMessage({ action = "showMenu2", slot = slots, nome = nome, sobrenome = sobrenome, identidade = identidade, idade = idade, telefone = telefone, multas = multas, paypal = paypal, banco = banco, carteira = carteira, profissao = trabalho, vip = vip,coins = coins, id = user_id, foto = foto})
	local identity = false
	SetNuiFocus(true,true)
	TriggerServerEvent('br_core_inventory:status', true)
end)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		if not craft then 
			if IsControlJustPressed(0,243) and not IsPlayerFreeAiming(PlayerId()) and GetEntityHealth(PlayerPedId()) >= 102 and not BR.isHandcuff() then
				local trabalho,vip,discord,empresa,staff = vSERVER.checkJobs()
				local carteira,banco,nome,sobrenome,user_id,identidade,idade,telefone,multas,paypal,coins, foto = vSERVER.Identidade()
				local img,banner = vSERVER.RetornarImagens()
				
				SendNUIMessage({ action = "showMenu", slot = slots, nome = nome, sobrenome = sobrenome, identidade = identidade, idade = idade, telefone = telefone, multas = multas, paypal = paypal, banco = banco, carteira = carteira, profissao = trabalho, vip = vip, coins = coins, empresa = empresa, staff = staff, url = url, id = user_id, img = img, banner = banner, valor_bolso = valor_bolso})
				local identity = false
				TriggerServerEvent('br_core_inventory:status', true)
				SetNuiFocus(true,true)
				TransitionToBlurred(1000)
				SetCursorLocation(0.5,0.5)
			end
			if IsControlJustPressed(0,316) and not IsPlayerFreeAiming(PlayerId()) and GetEntityHealth(PlayerPedId()) >= 102 and not BR.isHandcuff() then
				vSERVER.chestOpen()
			end
		end
		Citizen.Wait(5)
	end
end)

RegisterNetEvent("trunkchest:Open")
AddEventHandler("trunkchest:Open",function()
	if not craft then
		local trabalho,vip,discord,empresa,staff = vSERVER.checkJobs()
		local carteira,banco,nome,sobrenome,user_id,identidade,idade,telefone,multas,paypal,coins,foto = vSERVER.Identidade()
		SendNUIMessage({ action = "showMenu2", slot = slots, nome = nome, sobrenome = sobrenome, identidade = identidade, idade = idade, telefone = telefone, multas = multas, paypal = paypal, banco = banco, carteira = carteira, profissao = trabalho, coins = coins, vip = vip, empresa = empresa, staff = staff, url = url, id = user_id})
		local identity = false
		TriggerServerEvent('br_core_inventory:status', true)
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SetCursorLocation(0.5,0.5)
	end
end)

RegisterNUICallback("useItem",function(data)
	vSERVER.useItem(data.item,data.type,data.amount)
end)


RegisterNUICallback("dropItem",function(data)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		TriggerEvent("Notify","negado","Você não pode dropar itens quando estiver em um veículo.")
	else	
		vSERVER.dropItem(data.item,data.amount)
	end
end)

function disableControls()
    DisableControlAction(1, 157)
    DisableControlAction(1, 158)
    DisableControlAction(1, 160)
    DisableControlAction(1, 164)
end

RegisterCommand("keybind_1",function(source,args)
    disableControls()
	vSERVER.handleKeybind("n1")
end)

RegisterCommand("keybind_2",function(source,args)
    disableControls()
	vSERVER.handleKeybind("n2")
end)

RegisterCommand("keybind_3",function(source,args)
    disableControls()
	vSERVER.handleKeybind("n3")
end)

RegisterCommand("keybind_4",function(source,args)
    disableControls()
	vSERVER.handleKeybind("n4")
end)



RegisterKeyMapping("keybind_1", "KeyBind", "keyboard", "1")
RegisterKeyMapping("keybind_2", "KeyBind", "keyboard", "2")
RegisterKeyMapping("keybind_3", "KeyBind", "keyboard", "3")
RegisterKeyMapping("keybind_4", "KeyBind", "keyboard", "4")

RegisterNUICallback("setKeyBindItemInventory", function(data)
    vSERVER.setKeybind(data.index, data.key)
end)

RegisterNUICallback("updateFoto", function(data)
	vSERVER.updateFoto(data.foto)

    SendNUIMessage({action = 'updateImg', foto = data.foto})
end)

RegisterNUICallback("removeKeyBindItemInventory", function(data)
    vSERVER.removeKeybind(data.index, false, nil)
	TriggerEvent("br_core_inventory:Update", "updateMochila")
end)

RegisterNUICallback("sendItem",function(data)
	vSERVER.sendItem(data.item,data.amount)
end)

RegisterNUICallback("takeItem",function(data)

	vSERVER.takeItem(data.item,data.amount,webhook_bau)
end)

RegisterNUICallback("storeItem",function(data)

	vSERVER.storeItem(data.item,data.amount,data.vehname,webhook_bau)
end)

RegisterNUICallback("requestMochila",function(data,cb)
	local inventario,peso,maxpeso = vSERVER.Mochila()
	if inventario then
		local linkimagens = ipimagens
		local bolsos = vSERVER.BolsosDisponivel()
		cb({ inventario = inventario, peso = peso, maxpeso = maxpeso, linkimagens = linkimagens, bolsos = bolsos })
	end
end)

RegisterNUICallback("requestMochila2",function(data,cb)
	local inventario,peso,maxpeso = vSERVER.Mochila()
	local inventario2, peso2, maxpeso2, vehicleName = vSERVER.portaMalas();
	if inventario2 then
		local linkimagens = ipimagens
		local bolsos = vSERVER.BolsosDisponivel()
		cb({ inventario = inventario, inventario2 = inventario2, veiculo = vehicleName, peso2 = peso2, maxpeso2 = maxpeso2, peso = peso, maxpeso = maxpeso, linkimagens = linkimagens, bolsos = bolsos })
	else
		cRP.closeInventory() 
	end
end)



RegisterNetEvent("br_core_inventory:Update")
AddEventHandler("br_core_inventory:Update",function(action)
	SendNUIMessage({ action = action })
end)

Citizen.CreateThread(function()
	while true do
		if inRadio and vSERVER.checkRadio() then
			TriggerEvent("radio:outServers")
			inRadio = false
		end
		Citizen.Wait(10000)
	end
end)

function cRP.repairVehicle(index,status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,true,true)
			local fuel = GetVehicleFuelLevel(v)
			if status then
				SetVehicleFixed(v)
				SetVehicleFuelLevel(v,fuel)
				SetVehicleDeformationFixed(v)
				SetVehicleUndriveable(v,false)
			else
				SetVehicleEngineHealth(v,1000.0)
				SetVehicleBodyHealth(v,1000.0)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end


function cRP.lockpickVehicle(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,true,true)
			if GetVehicleDoorsLockedForPlayer(v,PlayerId()) == 1 then
				SetVehicleDoorsLocked(v,false)
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLocked(v,true)
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
			Wait(200)
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
		end
	end
end



local blockButtons = false
function cRP.blockButtons(status)
	blockButtons = status
end

Citizen.CreateThread(function()
	while true do
		local ORTiming = 500
		if blockButtons then
			ORTiming = 4
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,56,true)
			DisableControlAction(0,57,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,20,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,105,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,327,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,243,true)
		end
		Citizen.Wait(ORTiming)
	end
end)

RegisterNetEvent("Creative:UpdateTrunk")
AddEventHandler("Creative:UpdateTrunk",function(action)
    SendNUIMessage({ action = action })
end)

cRP.getNearChest = function()
	local cds = GetEntityCoords(PlayerPedId())
	for k,v in pairs(CHESTS) do 
		local dist = #(cds - v.coords)
		if dist <= distancia_bau then 
			return true,k
		end 
	end
	return false
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("arrumarpneus")
AddEventHandler("arrumarpneus",function()
    local vehicle = BR.getNearestVehicle(3)
    if vehicle then
        Citizen.Wait(5000)
        for i = 0,8 do
            SetVehicleTyreFixed(vehicle,i)
        end
        BR.DeletarObjeto()
        ClearPedTasksImmediately(PlayerPedId())
    else
        TriggerEvent("Notify","negado","Você precisa estar próximo de um <b>veículo</b>.")
    end
end)
