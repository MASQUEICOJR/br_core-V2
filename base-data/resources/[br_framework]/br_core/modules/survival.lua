local cfg = module("cfg/base")

-- api

function BR.getHunger(user_id)
  local data = BR.getUserDataTable(user_id)
  if data then
    return data.hunger
  end

  return 0
end

function BR.getThirst(user_id)
  local data = BR.getUserDataTable(user_id)
  if data then
    return data.thirst
  end

  return 0
end

function BR.setHunger(user_id, value)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.hunger = value
    if data.hunger < 0 then
      data.hunger = 0
    elseif data.hunger > 100 then
      data.hunger = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('hunger', data.hunger, true)
  end
end


function BR.setStress(user_id, value)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.stress = value
    if data.stress < 0 then
      data.stress = 0
    elseif data.stress > 100 then
      data.stress = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('stress', data.stress, true)
  end
end

function BR.setThirst(user_id, value)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.thirst = value
    if data.thirst < 0 then
      data.thirst = 0
    elseif data.thirst > 100 then
      data.thirst = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('thirst', data.thirst, true)
  end
end

function BR.varyStress(user_id, variation)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.stress = data.stress + variation


    -- apply overflow as damage
    local overflow = data.stress - 100
    if overflow > 0 then
      BRclient._varyHealth(BR.getUserSource(user_id), -overflow * cfg.overflow_damage_factor)
    end

    if data.stress < 0 then
      data.stress = 0
    elseif data.stress > 100 then
      data.stress = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('stress', data.stress, true)
  end
end

function BR.varyHunger(user_id, variation)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.hunger = data.hunger + variation


    -- apply overflow as damage
    local overflow = data.hunger - 100
    if overflow > 0 then
      BRclient._varyHealth(BR.getUserSource(user_id), -overflow * cfg.overflow_damage_factor)
    end

    if data.hunger < 0 then
      data.hunger = 0
    elseif data.hunger > 100 then
      data.hunger = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('hunger', data.hunger, true)
  end
end

function BR.varyThirst(user_id, variation)
  local data = BR.getUserDataTable(user_id)
  if data then
    data.thirst = data.thirst + variation

    -- apply overflow as damage
    local overflow = data.thirst - 100
    if overflow > 0 then
      BRclient._varyHealth(BR.getUserSource(user_id), -overflow * cfg.overflow_damage_factor)
    end

    if data.thirst < 0 then
      data.thirst = 0
    elseif data.thirst > 100 then
      data.thirst = 100
    end

    local src = BR.getUserSource(user_id)
    Player(src).state:set('thirst', data.hunger, true)
  end
end

-- tunnel api (expose some functions to clients)

function tBR.varyHunger(variation)
  local user_id = BR.getUserId(source)
  if user_id then
    BR.varyHunger(user_id, variation)
  end
end

function tBR.varyThirst(variation)
  local user_id = BR.getUserId(source)
  if user_id then
    BR.varyThirst(user_id, variation)
  end
end


function tBR.notifyDeath(data)

end

function tBR.notifyAfterDeath()
  local source = source
  if cfg?.clear_inventory_on_death then
    exports.ox_inventory:ClearInventory( source, {
      'identification',
      'mastercard'
    })
  end
  local user_id = BR.getUserId(source)
  if not user_id then return end
  BR.setHunger( user_id, 0.0 )
  BR.setThirst( user_id, 0.0 )
  BR.setStress( user_id, 0.0)
end

-- tasks

-- hunger/thirst increase
function task_update()
  for k, v in pairs(BR.users) do
    BR.varyHunger(v, cfg.hunger_per_minute)
    BR.varyThirst(v, cfg.thirst_per_minute)
  end

  SetTimeout(60000, task_update)
end

async(function()
  if cfg.survival then
    task_update()
  end
end)

-- handlers

-- -- init values
-- AddEventHandler("BR:playerJoin", function(user_id, source, name, last_login)
--   local data = BR.getUserDataTable(user_id)
--   if data.hunger == nil then
--     data.hunger = 0
--     data.thirst = 0
--   end
-- end)

-- -- add survival progress bars on spawn
-- AddEventHandler("BR:playerSpawn", function(user_id, source, first_spawn)
--   local data = BR.getUserDataTable(user_id)
--   BRclient._setPolice(source, cfg.police)
--   BRclient._setFriendlyFire(source, cfg.pvp)
--   BR.setHunger(user_id, data.hunger)
--   BR.setThirst(user_id, data.thirst)
-- end)
