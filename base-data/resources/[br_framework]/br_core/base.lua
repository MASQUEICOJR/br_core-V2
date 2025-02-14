---@diagnostic disable: duplicate-set-field
local blockCfg = require('@br_core.cfg.block') or {}
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")

lib.locale()

local BLOKED_META <const> = { 'health', 'position', 'hunger', 'thirst', 'weapons', 'groups', 'health', 'gaptitudes' }

BRconfig = module("cfg/base")

BR = {}
Proxy.addInterface("BR", BR)

tBR = {}
Tunnel.bindInterface("BR", tBR) -- listening for client tunnel

-- init
BRclient              = Tunnel.getInterface("BR") -- server -> client tunnel

BR.users              = {}            -- will store logged users (id) by first identifier
BR.rusers             = {}            -- store the opposite of users
BR.user_tables        = {}            -- user data tables (logger storage, saved to database)
BR.user_tmp_tables    = {}            -- user tmp data tables (logger storage, not saved)
BR.user_sources       = {}            -- user sources
BR.character_source   = {}            -- char_id -> source
BR.character_user     = {}            -- char_id -> user_id
BR.source_character   = {}            -- source -> char_id

local prepared_queries = {}

function BR.prepare(name, query)
  if not query then return end
  prepared_queries[name] = query
end

function BR.query(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.query.await(prepared_queries[name], params)
end

function BR.execute(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.query.await(prepared_queries[name], params)
end

function BR.scalar(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.scalar.await(prepared_queries[name], params)
end

function BR.insert(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.insert.await(prepared_queries[name], params)
end

function BR.single(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.single.await(prepared_queries[name], params)
end

function BR.update(name, params)
  if not prepared_queries[name] then
    error('Query [' .. name .. '] not found.', 1)
  end
  return MySQL.update.await(prepared_queries[name], params)
end

-- identification system

--- sql.
-- return user id or nil in case of error (if not found, will create it)
function BR.getUserByIdentifier(identifier)
  return BR.single('BR/getUser', { identifier })
end

--internal br_core only
local function CreateNewUser(license, discord, fivemId)
  return BR.insert('BR/create_user', { license, discord, fivemId })
end

function BR.getPlayerEndpoint(player)
  return GetPlayerEndpoint(player) or '0.0.0.0'
end

function BR.getPlayerName(player)
  return GetPlayerName(player) or "unknown"
end

--- sql
function BR.isBanned(user_id)
  return BR.single('BR/getUserBanned', { user_id }) ~= nil
end

--- sql
function BR.setBanned(user_id, banned, reason)
  if banned then
    reason = reason or 'Banido por não seguir as regras'
    BR.update("BR/setUserBanned", { user_id, reason })
  else
    BR.update('BR/removeUserBan', { user_id })
  end
end

--- sql
function BR.isAllowed(user_id)
  return BR.scalar("BR/isUserAllowed", { user_id })
end

--- sql
function BR.setAllowed(user_id, allow)
  allow = allow and 1 or 0
  return BR.update("BR/setUserAllowed", { allow, user_id })
end

function BR.setUData(user_id, key, value)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  if type(value) == "table" then value = json.encode(value) end
  BR.execute("BR/setUData", { user_id, key, value })
end

function BR.getUData(user_id, key)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  return BR.scalar('BR/getUData', { user_id, key }) or nil
end

function BR.setSData(key, value)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  if type(value) == "table" then value = json.encode(value) end
  BR.execute("BR/setServerData", { key, value })
end

function BR.getSData(key)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  return BR.scalar('BR/getServerData', { key }) or nil
end

function BR.setPlayerData(player_id, key, value)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  if type(value) == "table" then value = json.encode(value) end
  BR.execute("BR/setPlayerData", { player_id, key, value })
end

function BR.getPlayerData(player_id, key)
  if type(key) ~= "string" then error('Key need be a string', 1) end
  return BR.scalar('BR/getPlayerData', { player_id, key }) or nil
end

-- return user data table for BR internal persistant connected user storage

function BR.getPlayerTable(user_id)
  return BR.user_tables[user_id]
end

function BR.getUserDataTable(user_id)
  return BR.user_tables[user_id]?.datatable
end

function BR.setUserMetadata(user_id, key, value)
  if type(key) ~= 'string' then return end
  if table.contains(BLOKED_META, key) then return end
  if BR.user_tables[user_id]?.datatable then
    if BR.user_tables[user_id].datatable[key] ~= value then
      BR.user_tables[user_id].datatable[key] = value
      TriggerClientEvent('BR:SetPlayerMetadata', BR.getUserSource(user_id), BR.user_tables[user_id].datatable)
    end
  end
end

function BR.getUserMetadata(user_id, key)
  return BR.user_tables[user_id]?.datatable?[key]
end

function BR.getUserTmpTable(user_id)
  return BR.user_tmp_tables[user_id]
end

-- return the player spawn count (0 = not spawned, 1 = first spawn, ...)
function BR.getSpawns(user_id)
  local tmp = BR.getUserTmpTable(user_id)
  if tmp then
    return tmp.spawns or 0
  end

  return 0
end

function BR.getUserId(source)
  if source ~= nil and source ~= 0 then
    local license = BR.getPlayerIdentifier(source, 'license')
    return BR.users[license]
  end
  return nil
end

-- return map of user_id -> player source
function BR.getUsers()
  local users = {}
  for k, v in pairs(BR.user_sources) do
    users[k] = v
  end

  return users
end

-- return source or nil
function BR.getUserSource(user_id)
  return BR.user_sources[user_id]
end

function BR.ban(source, reason)
  local user_id = BR.getUserId(source)

  if user_id then
    BR.setBanned(user_id, true)
    BR.kick(source, "[Banned] " .. reason)
  end
end

function BR.kick(source, reason)
  DropPlayer(source, reason)
end

-- drop BR player/user (internal usage)
function BR.dropPlayer(source)
  print(source)
  BRclient._removePlayer(-1, source)

  local user_id = BR.getUserId(source)
  if user_id then
    local char_id = BR.source_character[source]
    BR.user_tables[user_id].isReady = false
    TriggerEvent("BR:playerLeave", user_id, source)
    BR.save(user_id, '__INTERNAL__')
    Wait(1000)
    BR.users[BR.rusers[user_id]] = nil
    BR.rusers[user_id] = nil
    BR.user_tables[user_id] = nil
    BR.user_tmp_tables[user_id] = nil
    BR.user_sources[user_id] = nil
    if char_id then
      BR.source_character[source] = nil
      BR.character_source[char_id] = nil
      BR.character_user[char_id] = nil
    end
  end
end

CreateThread(function()
  while true do
    for k in next, BR.user_tables or {} do
      if BR.user_tables[k].isReady then
        BR.save(k, '__INTERNAL__')
      end
    end
    Wait(60000)
  end
end)


-- handlers
function BR.getPlayerIdentifier(source, xtype)
  return GetPlayerIdentifierByType(source, xtype or "license")
end

function BR.notify(source, title, message, time, _type)  
  TriggerClientEvent('ox_lib:notify', source, {
    title = title,
    description = message,
    duration = time or 5000,
    showDuration = true,
    position = 'top-right',
    type = _type or 'inform', -- 'inform' or 'error' or 'success'or 'warning'
  })
end

local function deffer_uppdate(d, m)
  d.update(m)
  Wait(1000)
end

AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
  local source = source
  local license = BR.getPlayerIdentifier(source, 'license')

  deferrals.defer()

  Wait(50)

  lib.print.info('Player trying to enter', GetPlayerName(source), source)

  if not license then
    return deferrals.done(locale('license_not_found'))
  end

  deffer_uppdate(deferrals, locale('conn_check_self'))

  local user = BR.getUserByIdentifier(license)

  if not user then
    local discord = BR.getPlayerIdentifier(source, 'discord')

    if not discord then
      return deferrals.done(locale('discord_id_not_found'))
    end

    local fivemId = BR.getPlayerIdentifier(source, 'fivem')
    if not fivemId then
      return deferrals.done(locale('fivem_id_not_found'))
    end

    local userId = CreateNewUser(license, discord, fivemId)
    if not userId then
      return deferrals.done(locale('user_created_error'))
    end

    return deferrals.done(locale('user_created', userId, GetConvar('br_core:discord', 'DISCORD LINK NOT FOUND')))
  end

  deffer_uppdate(deferrals, locale('conn_check_allowed'))

  if BRconfig.enable_allowlist and not user.allowed then
    return deferrals.done(locale('user_not_allowed', user.id, GetConvar('br_core:discord', 'DISCORD LINK NOT FOUND')))
  end

  deffer_uppdate(deferrals, locale('conn_check_banned'))

  local isBanned, reason = BR.isBanned(user.id)

  if isBanned then
    return deferrals.done(locale('user_as_banned', reason, user.id))
  end

  if BR.rusers[user.id] then
    DropPlayer(BR.user_tables[user.id], locale('user_already_connected'))
    Wait(1000)
    if not next(BR.user_tables[user.id] or {}) then
      BR.users[license] = nil
      BR.rusers[user.id] = nil
      BR.user_tables[user.id] = nil
      BR.user_sources[user.id] = nil
      BR.user_tmp_tables[user.id] = nil
    end
    return deferrals.done(locale('user_already_connected'))
  end

  BR.users[license] = user.id
  BR.rusers[user.id] = license
  BR.user_tables[user.id] = {}
  BR.user_sources[user.id] = source
  BR.user_tmp_tables[user.id] = { spawns = 0 }

  Wait(0)
  deferrals.done()
end)

AddEventHandler("playerDropped", function(reason)
  local source = source  
  BR.dropPlayer(source)
end)


AddEventHandler('playerJoining', function(_)
  local source  = source
  local user_id = BR.getUserId(source)
  if not user_id then
    DropPlayer(source, locale('login_failed'))
    return CancelEvent()
  end
  BR.user_sources[user_id] = source
  local spawns = (BR.user_tmp_tables[user_id]?.spawns or 0)
  local first_spawn = spawns == 1
  BR.user_tmp_tables[user_id].spawns = BR.user_tmp_tables[user_id].spawns + 1
  if first_spawn then
    for _, v in next, BR.user_sources or {} do
      BRclient._addPlayer(source, v)
    end
    BRclient._addPlayer(-1, source)
    TriggerEvent("BR:playerJoin", source, user_id, first_spawn)
  end
end)

function BR.getPlayerInfo(source)
  local playerTable = BR.getPlayerTable(BR.getUserId(source))
  if playerTable then   
    local playerJob = { label = 'Desempregado', name = 'civil', rankName = "", rank = 0, onduty = false, isboss = false, type = nil }
    local playerGang = { label = 'Nenhuma', name = 'none', rankName = "", rank = 0, isboss = false }

    local job, jinfo, jkgroup = BR.getUserGroupByType(playerTable.user_id, "job")
    if job then
      playerJob.label = jkgroup?._config?.title or ""
      playerJob.name = job
      playerJob.onduty = jinfo?.duty or false
      playerJob.rank = jinfo?.rank or 0
      playerJob.rankName = jkgroup?._config?.grades?[playerJob.rank]?.name or ""
      playerJob.type = jkgroup?._config?.jobtype
      playerJob.isboss = jkgroup?._config?.grades?[playerJob.rank]?.isboss or false
    end

    local gang, ginfo, gkgroup = BR.getUserGroupByType(playerTable.user_id, "gang")
    if gang then
      playerGang.label = gkgroup?._config?.title or ""
      playerGang.name = gang
      playerGang.rank = ginfo?.rank or 0
      playerGang.rankName = gkgroup?._config?.grades?[playerGang.rank]?.name or ""
      playerGang.isboss = gkgroup?._config?.grades?[playerGang.rank]?.isboss or false
    end


    return {
      birth_date = os.date('%d/%m/%Y', playerTable.birth_date // 1000),
      datatable = playerTable.datatable,
      lastname = playerTable.lastname,
      firstname = playerTable.firstname,
      gender = playerTable.gender,
      char_id = playerTable.id,
      money = playerTable.money,
      phone = playerTable.phone,
      registration = playerTable.registration,
      user_id = playerTable.user_id,
      license = playerTable.license,
      server_id = source,
      source = source,
      id = playerTable.id,
      job = playerJob,
      gang = playerGang
    }
  end

  return nil
end

local function prepareGroup(user_grous, gtype)
  local groups = BR.getGroups()
  for k, v in next, user_grous or {} do
    if groups[k]?._config?.gtype == gtype then
      return k, v, groups[k]
    end
  end
end

function BR.getPlayerInfoOffLine(char_id)
  local character = BR.getCharacter(char_id, false)
  if character then
    local playerJob = { label = 'Desempregado', name = 'civil', rankName = "", rank = 0, onduty = false, isboss = false, type = nil }
    local playerGang = { label = 'Nenhuma', name = 'none', rankName = "", rank = 0, isboss = false }

    local job, jinfo, jkgroup = prepareGroup(character.datatable.groups, "job")
    if job then
      playerJob.label = jkgroup?._config?.title or ""
      playerJob.name = job
      playerJob.onduty = jinfo?.duty or false
      playerJob.rank = jinfo?.rank or 0
      playerJob.rankName = jkgroup?._config?.grades?[playerJob.rank]?.name or ""
      playerJob.type = jkgroup?._config?.jobtype
      playerJob.isboss = jkgroup?._config?.grades?[playerJob.rank]?.isboss or false
    end

    local gang, ginfo, gkgroup = prepareGroup(character.user_id, "gang")
    if gang then
      playerGang.label = gkgroup?._config?.title or ""
      playerGang.name = gang
      playerGang.rank = ginfo?.rank or 0
      playerGang.rankName = gkgroup?._config?.grades?[playerGang.rank]?.name or ""
      playerGang.isboss = gkgroup?._config?.grades?[playerGang.rank]?.isboss or false
    end

    return {
      birth_date = os.date('%d/%m/%Y', character.birth_date // 1000),
      datatable = character.datatable,
      lastname = character.lastname,
      firstname = character.firstname,
      gender = character.gender,
      char_id = character.id,
      money = character.money,
      phone = character.phone,
      registration = character.registration,
      user_id = character.user_id,
      license = character.license,
      server_id = nil,
      source = nil,
      id = character.id,
      job = playerJob,
      gang = playerGang
    }
  end
  return nil
end

lib.callback.register('br_core:server:getPlayerData', function(source)
  return BR.getPlayerInfo(source)
end)


RegisterCommand('testfw', function()
  local license = 'license:89f2de13f3dc0b2a5bf991021d7fa5c8370f4afe'
  local user_id = 1
  BR.users[license] = user_id
  BR.rusers[user_id] = license
  BR.user_sources[user_id] = source
  local user = MySQL.single.await("SELECT * FROM players WHERE id = ?", { user_id })
  if not user then return end
  user.datatable = json.decode(user?.datatable or '{}')
  user.inventory = json.decode(user?.inventory or '[]')
  user.money = json.decode(user?.money or '{"cash": 0, "bank": 1000}')
  BR.user_tables[user_id] = user
  BR.addUserGroup(user_id, 'police', 1)
end)

RegisterCommand('re', function(source)
  local license = GetPlayerIdentifierByType(source, "license")
  local user = BR.getUserByIdentifier(license)
  local user_id = user.id
  BR.users[license] = user_id
  BR.rusers[user_id] = license
  BR.user_sources[user_id] = source
end)

-- RegisterCommand('tw', function(source, args, raw)
--   local user_id = BR.getUserId(source)
--   if user_id then
--     BR.replaceWeapons(user_id, {})
--   end
-- end)

-- RegisterCommand('vt', function(source, args, raw)
--   print(json.encode(BR.user_tables))
--   print(json.encode(BR.rusers))
--   print(json.encode(BR.user_sources))
-- end)

-- RegisterCommand('ex', function(source, args, raw)
--   local code = raw
--   local x, err = load("return " .. code:sub(3), '', "bt", _G)
--   if not x then
--     print('ERROR', err)
--     return
--   end

--   local _, result = pcall(x)
--   print('RESULT', result)
-- end)

-- --onesync event
AddEventHandler('entityCreating', function(handle)
  local _type = GetEntityType(handle)
  local model = GetEntityModel(handle)
  if (_type == 1 and blockCfg.peds[model]) or
      (_type == 2 and blockCfg.vehicles[model]) then
    CancelEvent()
  end
end)
