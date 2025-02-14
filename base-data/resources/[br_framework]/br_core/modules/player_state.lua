function tBR.updateCustomization(customization)
  local user_id = BR.getUserId(source)
  if user_id then
    local playerTable = BR.getPlayerTable(user_id)
    if playerTable?.id then
      -- BR.setPlayerData(playerTable.id, 'player:custom', customization)
      MySQL.update.await('UPDATE players SET skin = ? WHERE id = ?', {json.encode(customization), playerTable.id})
    end
  end
end

function tBR.updateHealth(health)
  local user_id = BR.getUserId(source)
  if user_id then
    local data = BR.getUserDataTable(user_id)
    if data then
      data.health = health
    end
  end
end

function BR.createPlayer(user_id, firstname, lastname, gender, date)
  local datatable = {
    groups = {},
    health = 200,
    weapons = {},
    position = nil,
    thirst = 0,
    hunger = 0,
    stress = 0
  }
  local inventory = {}
  local money = { cash = BRconfig?.money_type?.cash or 1000, bank = BRconfig?.money_type?.bank or 1000 }
  local registration = BR.generateRegistrationNumber()
  local phone = BR.generateRandomPhoneNumber()
  return BR.createNewCharacter(user_id, firstname, lastname, gender, registration, phone, date, money, inventory, datatable)
end

function BR.setPlayerBucket(player, bucketId, population)
  SetPlayerRoutingBucket(player, bucketId)
  if bucketId ~= 0 then
    SetRoutingBucketEntityLockdownMode(bucketId, 'strict')
    SetRoutingBucketPopulationEnabled(bucketId, population)
  end
end

function BR.getWeapons(user_id)
  return BR.getUserDataTable(user_id)?.weapons or {}
end

function BR.giveWeapons(user_id, weapons, clear_before)
  local src = BR.getUserSource(user_id)
  if not src then return end
  local datatable = BR.getUserDataTable(user_id)
  local ped = GetPlayerPed(src)
  if clear_before then
    datatable.weapons = {}
    RemoveAllPedWeapons(ped, true)
  end

  for weapon, prop in next, weapons or {} do
    local hash = joaat(weapon)
    local ammo = prop.ammo or 0
    if ammo > 150 then ammo = 150 end
    if ammo < 0 then ammo = 0 end
    GiveWeaponToPed(ped, hash, ammo, false, false)
    for _, wcomp in next, prop?.components or {} do
      GiveWeaponComponentToPed(ped, hash, joaat(wcomp))
    end

    if prop?.liveries and #prop.liveries > 0 then
      TriggerClientEvent('br_core:client:weapon_sync', src, 'LIVERY', weapon, prop.liveries)
    end

    if prop?.tint then
      TriggerClientEvent('br_core:client:weapon_sync', src, 'TINT', weapon, prop?.tint)
    end

    datatable.weapons[weapon] = prop
  end

  TriggerClientEvent('BR:SetPlayerMetadata', src, datatable)
end

function BR.replaceWeapons(user_id, weapons)
  local old = BR.getWeapons(user_id)
  BR.giveWeapons(user_id, weapons, true)
  return old
end

function BR.setArmour(user_id, armour)
  if armour > 100 then armour = 100 end
  if armour < 0 then armour = 0 end
  local src = BR.getUserSource(user_id)
  if not src then return end
  local ped = GetPlayerPed(src)
  SetPedArmour(ped, armour)
end

function BR.getPlayerId( user_id)
  return BR.getPlayerTable(user_id)?.id  
end

function BR.getCharId( src )
  local id = Player(src).state.char_id
  if id then return id end
  local user_id = BR.getUserId( src )
  return BR.getPlayerId( user_id)
end

function BR.getUserIdByPlayerId( char_id )
  local id = MySQL.scalar.await('SELECT user_id	FROM players WHERE id = ?', {char_id})

  return id and tonumber(id) or nil
end

function BR.login(source, user_id, char_id, firstcreation)
  if BR.getUserId(source) ~= user_id then
    DropPlayer(source, locale('identity_check_fail'))
    return false
  end

  local character = BR.getCharacter(char_id)
  if not character then
    DropPlayer(source, locale('character_load_fail'))
    return false
  end

  BR.user_tables[user_id] = character
  BR.user_tables[user_id].datatable = BR.user_tables[user_id].datatable or {}
  BR.user_tables[user_id].datatable['stress'] = BR.user_tables[user_id].datatable['stress'] or 0.0
  BR.user_tables[user_id].datatable['hunger'] = BR.user_tables[user_id].datatable['hunger'] or 0.0
  BR.user_tables[user_id].datatable['thirst'] = BR.user_tables[user_id].datatable['thirst'] or 0.0
  BR.user_tables[user_id].datatable['health'] = BR.user_tables[user_id].datatable['health'] or 200
  BR.user_tables[user_id].datatable['weapons'] = BR.user_tables[user_id].datatable['weapons'] or {}
  BR.user_tables[user_id].datatable['groups'] = BR.user_tables[user_id].datatable['groups'] or {}  
  if firstcreation then
    BR.user_tables[user_id].datatable['position'] = nil
  else
    BR.user_tables[user_id].datatable['position'] = BR.user_tables[user_id].datatable['position'] or cfg.fristspawn 
  end

  -- local custom = BR.getPlayerData(character.id, 'player:custom')
  -- BR.user_tables[user_id].customization = custom and json.decode(custom)
  Player(source).state:set('name', ("%s %s"):format(character.firstname, character.lastname), true)
  Player(source).state:set('id', user_id)
  Player(source).state:set('char_id', character.id, true)

  BR.character_source[character.id] = source
  BR.character_user[character.id] = user_id
  BR.source_character[source] = char_id

  TriggerEvent("br_core:login", source, user_id, char_id, firstcreation)
  TriggerClientEvent('BR:SetPlayerData', source, BR.getPlayerInfo(source))
  BRclient._setMaxHealth(source, 200)
  Wait(0)
  BRclient._setHealth(source, BR.user_tables[user_id].datatable['health'])
  return true
end


function BR.getCharaterIdBySource( src )
  return BR.source_character[src]
end

function BR.getUserIdByCharacterId( char_id )
  return BR.character_user[char_id]
end

function BR.getSourceByCharacterId( char_id )
  return BR.character_source[char_id]
end

function BR.save(user_id, x)
  if x ~= '__INTERNAL__' then return end
  if not next(BR.user_tables[user_id] or {}) then return end
  local player = BR.user_tables[user_id]
  if player?.user_id ~= user_id then return end
  -- if BR.user_tables[user_id].isReady then
  local char_id = player?.id
  local src = BR.getUserSource(user_id)
  local ped = GetPlayerPed(src)
  local position = GetEntityCoords(ped)
  BR.user_tables[user_id].datatable['position'] = position
  BR.updateCharacter(char_id, BR.user_tables[user_id])  
end

RegisterNetEvent('br_core:server:updatePlayerAppearance', function(char_id, data)
  if GetInvokingResource() then return end
  local source = source
  local user_id = BR.getUserId(source)
  if not user_id then return end
  local xPlayer = BR.getCharacter(char_id, false)
  if not xPlayer then return end
  MySQL.update.await('UPDATE players SET skin = ? WHERE id = ?', { json.encode(data), char_id})
end)


RegisterNetEvent('br_core:player:ready', function(state)
  if GetInvokingResource() then return end
  local source = source
  local user_id = BR.getUserId(source)
  if not user_id then return end
  if BR.user_tables[user_id] then
    BR.user_tables[user_id].isReady = state
    if state then
      if GetPlayerRoutingBucket( source ) ~= 0 then
        SetPlayerRoutingBucket( source, 0)
      end
      lib.print.info('PLAYER READY TO SAVE [ ' .. user_id .. ' ]')
    end
  end
end)