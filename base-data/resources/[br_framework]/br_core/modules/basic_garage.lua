---@diagnostic disable-next-line: duplicate-set-field
function tBR.spawnVehicle(model, pos, _type)
    print('model', model, pos, _type)
    local vehicle = CreateVehicleServerSetter(model, _type or 'automobile', pos.x, pos.y, pos.z, pos?.w or 0.0)
    while not DoesEntityExist(vehicle) do Wait(0) end
    return vehicle
end

--proxy
BR.spawnVehicle = tBR.spawnVehicle

function BR.setVehicleGearType(vehicle, gtype)
    if (gtype == 'GEAR_AUTO' or gtype == 0 or gtype == 'GEAR_MANUAL' or gtype == 1) then
        Entity(vehicle).state:set('br_core:garages:setGearType', gtype, true)
    end
end

--tunnel
tBR.setVehicleGearType = BR.setVehicleGearType

function BR.getPlayerVehicleByName(char_id, vehicle)
    return BR.single('BR/getPlayerVehicleBy', { 'vehicle', vehicle, char_id })
end

function BR.isPlayerVehicleSeized(char_id, vehicle)
    return BR.scalar('BR/isPlayerVehicleSeized', { char_id, vehicle })
end

function BR.getAllPlayerVehicles(char_id)
    return BR.query('BR/getPlayerVehicleBy', { 'player_id', char_id })
end

function BR.getPlayerVehicleByPlate(plate)
    return BR.single('BR/getPlayerVehicleByPlate', { plate })
end

function BR.getPlayerVehicleProps(char_id, vehicle)
    return BR.scalar('BR/getPlayerVehicleProps', { char_id, vehicle })
end

function BR.getPlayerVehiclePropsByPlate(plate)
    return BR.scalar('BR/getPlayerVehiclePropsByPlate', { plate })
end

function BR.getPlayerVehicleInGarage(char_id, garageName)
    return BR.query('BR/getPlayerVehicleBy', { 'garage', garageName, char_id })
end

function BR.removeVehicleFromPlayer(char_id, vehicle)
    return BR.update('BR/removeVehicleFromPlayer', { vehicle, char_id })
end

function BR.removePlayerVehicleByPlate(plate)
    return BR.update('BR/removeVehicleFromPlayerByPlate', { plate })
end

function BR.addVehicleToPlayer(char_id, vehicle, plate)
    return BR.single('BR/addPlayerVehicle', { vehicle, char_id, plate })
end

function BR.updatePlayerVehicle(char_id, vehicle, data)
    local ALLOWED_COLUMN_UPDATE = {
        ['seized'] = true,
        ['properties'] = true,
        ['garage'] = true
    }

    local query = 'UPDATE player_vehicles SET #DATA# WHERE vehicle = ? AND player_id = ?'
    local _data = {}
    for column, value in next, data or {} do
        if ALLOWED_COLUMN_UPDATE[column] then
            if type(value) == "table" then
                _data[#_data + 1] = ("`%s` = '%s'"):format(column, json.encode(value))
            elseif type(value) == "boolean" then
                _data[#_data + 1] = ("`%s` = %d"):format(column, value and 1 or 0)
            elseif type(value) == 'string' then
                _data[#_data + 1] = ("`%s` = '%s'"):format(column, value)
            elseif type(value) == 'number' then
                _data[#_data + 1] = ("`%s` = %s"):format(column, tostring(value))
            end
        end
    end

    if #_data > 0 then
        local qq = table.concat(_data, ', ')
        query = query:gsub('#DATA#', qq)
        return MySQL.update.await(query, { vehicle, char_id })
    end

    return false
end

function BR.transferPlayerVehicleToAnothePlayer(owner_char_id, dest_char_id, vehicle)
    return BR.scalar("BR/transferPlayerVehicle", { vehicle, owner_char_id, dest_char_id })
end
