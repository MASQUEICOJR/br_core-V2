----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.OpenPainel(data)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
    CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_b", "prop_cs_tablet", 49, 60309)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateWarnings', function(warnings)
    SendNUIMessage({ action = 'UpdateWarnings', data = warnings })
end)

RegisterNetEvent('updateChatMessage', function(data)
    SendNUIMessage({ action = 'Create:Message', data = data })
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNuiCallback('GetPainelInfos', function(data, cb)
    cb(vTunnel.getFaction())
end)

RegisterNuiCallback('NewWarn', function(data, cb)
    cb(vTunnel.addWarn(data.message))
end)

RegisterNuiCallback('GetMessages', function(data, cb) -- Requisita todas as mensagens
    cb(vTunnel.getChatMessages())
end)
    
RegisterNuiCallback('New:Message', function(data, cb) -- Recebe a mensagem digitada pelo usuário
    cb(vTunnel.sendMessage(data.message))
end)

RegisterNUICallback('close', function(data, cb)
    SendNUIMessage({ action = "close" }) -- Envia a mensagem para o frontend
    SetNuiFocus(false, false)

    vTunnel._close()
    DeletarObjeto()
    isOpen = false
    cb(true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isOpen and IsControlJustReleased(0, 322) then -- 322 = ESC
            SendNUIMessage({ action = "close" }) -- Envia pro frontend
            SetNuiFocus(false, false) -- Remove o foco
            isOpen = false
        end
    end
end)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- OTHERS FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local object
function CarregarAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

function CarregarObjeto(dict,anim,prop,flag,mao,altura,pos1,pos2,pos3)
    local ped = PlayerPedId()

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(10)
    end

    if altura then
        local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
        object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
        SetEntityCollision(object,false,false)

        AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),altura,pos1,pos2,pos3,260.0,60.0,true,true,false,true,1,true)
    else
        CarregarAnim(dict)
        TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
        local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
        object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
        SetEntityCollision(object,false,false)
        AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,mao),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
    end
    SetEntityAsMissionEntity(object,true,true)
end

function DeletarObjeto()
    ClearPedTasks(PlayerPedId())
    if DoesEntityExist(object) then
        DetachEntity(object,false,false)
        TriggerServerEvent("trydeleteobj",ObjToNet(object))
        DeleteEntity(object)
        object = nil
    end
end