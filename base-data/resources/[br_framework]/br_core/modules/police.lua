
---INTERNAL USAGE DO NOT EDIT
RegisterNetEvent('br_core:server:GunShotNotify', function (w, a)
    if GetInvokingResource() then return end
    local source = source
    local ped = GetPlayerPed( source )
    local pos = GetEntityCoords(ped)
    local weaponInfo =     nil
    TriggerEvent('br_core:GunShotNotify', source, ped, pos, weaponInfo, a)
end)


function BR.setPlayerHandcuffed( source, state )
    if DoesPlayerExist( source ) then
        Player( source ).state:set('handcuffed', state, true)
    end
end