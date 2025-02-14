local SetVehicleManualGear = function(vehicle, bool) Citizen.InvokeNative(0x337EF33DA3DDB990, vehicle, bool) end


function tBR.spawnVehicle(model, pos, isserver, type)      
    if isserver then        
        return BRserver.spawnVehicle(model, pos) --lib.callback.await('br_core:server:spawnvehicle', false, model, pos)
    else
        if not IsModelInCdimage(model) then return false end
        lib.requestModel(model, 10000)
        local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, pos?.w or 0.0, true, true)
        SetModelAsNoLongerNeeded(model)
        return vehicle
    end
end

function tBR.getNearbyVehicles(coord, radius)
    return lib.getNearbyVehicles(coord, radius, false)
end

function tBR.getClosestVehicle(coord, radius)
    return lib.getClosestVehicle(coord, radius, false)
end

function tBR.getVehicleProps(vehicle)
    if vehicle and DoesEntityExist(vehicle) then
        return lib.getVehicleProperties(vehicle)
    end
    return {}
end

function tBR.setVehicleProps(vehicle, fix)
    if vehicle and DoesEntityExist(vehicle) then
        lib.setVehicleProperties(vehicle, fix)
        return true
    end
    return false
end

function tBR.deleteVehicles(radius)
    radius = radius or 1.0
    for _, info in next, lib.getNearbyVehicles(GetEntityCoords(cache.ped), radius, true) or {} do
        SetEntityAsMissionEntity(info.vehicle, true, true)
        DeleteVehicle(info.vehicle)
    end
end

function tBR.fixVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)        
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleTyreFixed(vehicle, 0)
        SetVehicleTyreFixed(vehicle, 1)
        SetVehicleTyreFixed(vehicle, 2)
        SetVehicleTyreFixed(vehicle, 3)
        SetVehicleTyreFixed(vehicle, 4)
        SetVehicleTyreFixed(vehicle, 5)
        SetVehicleTyreFixed(vehicle, 45)
        SetVehicleTyreFixed(vehicle, 47)
        local rot = GetEntityRotation(vehicle, 2)
        if rot.y ~= 0 then
            SetEntityRotation(vehicle, rot.x, 0.0, rot.z, 2, false)
            SetVehicleOnGroundProperly(vehicle)
        end
    end
end


function tBR.ejectVehicle()
    local vehicle = GetVehiclePedIsIn(cache.ped, false)
    if vehicle ~= 0 then
        TaskLeaveVehicle(cache.ped, vehicle, 16)
    end
end

-- AddStateBagChangeHandler('vehicle:property', '', function( bagName, _, value)
--     local localVehicle = GetEntityFromStateBagName(bagName)
--     if DoesEntityExist(localVehicle) then
--     -- if GetPlayerServerId(cache.playerId) ~= tonumber(Entity(localVehicle).state['vehicle:owner'] or 0) then return end        
--         lib.setVehicleProperties( localVehicle, value, true )
--     end
-- end)

AddStateBagChangeHandler('br_core:garages:setGearType', '', function(bagName, _, value)
    if GetGameBuildNumber() < 3095 then return end 
    if not value or not GetEntityFromStateBagName then return end

    while NetworkIsInTutorialSession() do Wait(0) end

    local entityExists, entity = pcall(lib.waitFor, function()
        local entity = GetEntityFromStateBagName(bagName)
        if entity > 0 then return entity end
    end, '', 10000)

    if not entityExists then return end

    if GetEntityType( entity ) ~= 2 then return end
    local model = GetEntityModel(entity)
    
    if IsThisModelABike(model) or IsThisModelACar(model) or IsThisModelAnAmphibiousCar(model) or IsThisModelAQuadbike(model) or IsThisModelAnAmphibiousQuadbike(model) then        
        SetVehicleManualGear(entity, value == 'GEAR_MANUAL' or value == 1)
        Wait(200)
        if NetworkGetEntityOwner(entity) == cache.playerId then
            SetVehicleManualGear(entity, value == 'GEAR_MANUAL' or value == 1)
            Entity(entity).state:set('br_core:garages:setGearType', nil, true)
        end
    end    
end)
