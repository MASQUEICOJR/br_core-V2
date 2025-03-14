lib.locale()
cfg = require "@br_core.cfg.base" 

local Tunnel = require '@br_core.lib.Tunnel' --module("br_core", "lib/Tunnel")
local Proxy = require '@br_core.lib.Proxy' --module("br_core", "lib/Proxy")
local Tools = require '@br_core.lib.Tools' --module("br_core", "lib/Tools")

BR = {}
tBR = {}

Tunnel.bindInterface("BR", tBR)
Proxy.addInterface("BR", BR)

BRserver = Tunnel.getInterface("BR")

local user_id


local players = {} -- keep track of connected players (server id)

---@class TPlayer
---@field birth_date string
---@field datatable table<string, any>
---@field lastname string
---@field firstname string
---@field gender string
---@field phone string
---@field registration string
---@field id number
---@field license string
---@field server_id number
---@field source number
---@field job { label : string, name: string, rankName:string,  rank: string, onduty : boolean, isboss : boolean, type? : string } | nil
---@field gang { label : string, name: string, rankName:string,  rank: string, isboss : boolean} | nil
---@field char_id number
---@field user_id number
---@field money { cash:number, bank: number }
local player

function BR.getPlayer()
  return player
end

RegisterNetEvent('BR:SetPlayerData', function(xPlayer)  
  player = xPlayer
end)

RegisterNetEvent('BR:SetPlayerMetadata', function(xplayerData)
  if player then
    player.datatable = xplayerData
  end  
end)

RegisterNetEvent('BR:client:PlayerMoneyUpdate', function(value, _type)  
  if player then
    player.money = player.money or {}
    player.money[_type] = value
  end
end)

-- functions
function BR.playSound(name, coord, looped, maxdist)
  TriggerServerEvent('chHyperSound:play', nil, name, looped, coord, maxdist, GetPlayerServerId(PlayerId()))
end

function tBR.setUserId(_user_id)
  user_id = _user_id
end

-- get user id (client-side)
function tBR.getUserId()
  return user_id
end

function tBR.teleport(x, y, z)
  local ped = PlayerPedId()
  tBR.unjail() -- force unjail before a teleportation
  -- SetEntityCoords(PlayerPedId(), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
  local entity = ped
  local vehicle = GetVehiclePedIsIn(ped, false)
  if vehicle ~= 0 then entity = vehicle end
  NetworkFadeOutEntity(entity, true, false)
  SetEntityCollision(entity, false, false)
  DoScreenFadeOut(500)
  while not IsScreenFadedOut() do Wait(0) end
  SetEntityCoordsNoOffset(entity, x + 0.001, y + 0.001, z + 0.001, false, false, true)
  local timeout = GetGameTimer() + 5000
  repeat
    local _zz = z
    local isFound, _z = GetGroundZFor_3dCoord(x, y, _zz, true)
    if not isFound and GetGameTimer() < timeout then
      _zz = _zz + 10.0
      isFound, _z = GetGroundZFor_3dCoord(x, y, _zz, true)
    else
      SetEntityCoordsNoOffset(entity, x + 0.001, y + 0.001, _z + 0.001, false, false, true)
    end
  until isFound
  DoScreenFadeIn(250)
  NetworkFadeInEntity(entity, true)
  SetEntityCollision(entity, true, true)
  BRserver._updatePos(x, y, z)
end

---@deprecated use onesync enable in server side
function tBR.getPosition()
  local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
  return x, y, z
end

-- return false if in exterior, true if inside a building
function tBR.isInside()
  local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
  return not (GetInteriorAtCoords(x, y, z) == 0)
end

-- return vx,vy,vz
function tBR.getSpeed()
  local vx, vy, vz = table.unpack(GetEntityVelocity(PlayerPedId()))
  return math.sqrt(vx * vx + vy * vy + vz * vz)
end

function tBR.getCamDirection()
  local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading * math.pi / 180.0)
  local y = math.cos(heading * math.pi / 180.0)
  local z = math.sin(pitch * math.pi / 180.0)

  -- normalize
  local len = math.sqrt(x * x + y * y + z * z)
  if len ~= 0 then
    x = x / len
    y = y / len
    z = z / len
  end

  return x, y, z
end

function tBR.addPlayer(player)
  players[player] = true
end

function tBR.removePlayer(player)
  players[player] = nil
end

function tBR.getPlayers()
  return players
end

function tBR.getNearestPlayers(radius)
  local _rr = lib.getNearbyPlayers(GetEntityCoords(PlayerPedId()), radius, false)
  local rr = {}
  for _, info in next, _rr do
    rr[GetPlayerServerId(info.id)] = info
  end
  return rr
end

function tBR.getNearestPlayer(radius)
  return lib.getClosestPlayer(GetEntityCoords(cache.ped), radius, false)
end

function BR.notify(title, message, duration, _type)
  lib.notify({
    title = title,
    description = message,
    duration = duration,
    showDuration = true,
    position = 'top-right',
    type = _type or 'inform'
  })
end

-- function tBR.notify(msg)
--   BeginTextCommandThefeedPost("STRING")
--   AddTextComponentSubstringPlayerName(msg)
--   EndTextCommandThefeedPostTicker(true, false)
-- end

-- function tBR.notifyPicture(icon, iconType, sender, flash, text, sub)
--   BeginTextCommandThefeedPost("STRING")
--   AddTextComponentSubstringPlayerName(text)
--   EndTextCommandThefeedPostMessagetext(icon, icon, flash, iconType, sender, sub)
--   EndTextCommandThefeedPostTicker(false, true)
-- end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tBR.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    AnimpostfxPlay(name, 0, true)
  else
    AnimpostfxPlay(name, 0, true)

    CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Wait(math.floor((duration + 1) * 1000))
      AnimpostfxStop(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tBR.stopScreenEffect(name)
  AnimpostfxStop(name)
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will infinitely loop the first element of the sequence until stopAnim is called
function tBR.playAnim(upper, seq, looping)
  local ped = PlayerPedId()
  if seq.task then                                        -- is a task (cf https://github.com/ImagicTheCat/BR/pull/118)
    tBR.stopAnim(true)
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local pos = GetEntityCoords(ped)
      TaskStartScenarioAtPosition(ped, seq.task, pos.x, pos.y, pos.z - 1, GetEntityHeading(ped), 0, false, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tBR.stopAnim(upper)

    local flags = 0
    if upper then flags = flags + 48 end
    if looping then flags = flags + 1 end

    CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k, v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i = 1, loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local timeout = GetGameTimer() + 3000
            while not HasAnimDictLoaded(dict) and GetGameTimer() < timeout do Wait(0) end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end
              TaskPlayAnim(ped, dict, name, inspeed, outspeed, -1, flags, 0, false, false, false)

              Wait(0)

              while GetEntityAnimCurrentTime(ped, dict, name) <= 0.95 and IsEntityPlayingAnim(ped, dict, name, 3) do
                Wait(0)
              end
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tBR.stopAnim(upper, force)
  anims = {} -- stop all sequences

  local ped = PlayerPedId()
  if force then
    ClearPedTasksImmediately(ped)
  else
    if upper then
      ClearPedSecondaryTask(ped)
    else
      ClearPedTasks(ped)
    end
  end
end

-- RAGDOLL
local ragdoll = false

local function startRangdollThread()
  CreateThread(function()
    while ragdoll do
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, false, false, false)
      Wait(10)
    end
  end)
end

-- set player ragdoll flag (true or false)
function tBR.setRagdoll(flag)
  if ragdoll == flag then return end
  ragdoll = flag
  if ragdoll then
    startRangdollThread()
  end
end

function tBR.setMovement(dict)
  if dict then
    if not HasAnimSetLoaded(dict) then
      RequestAnimSet(dict)
      local timeout = GetGameTimer() + 2000
      while not HasAnimSetLoaded(dict) and GetGameTimer() < timeout do Wait(0) end
    end
    if HasAnimSetLoaded(dict) then
      SetPedMovementClipset(PlayerPedId(), dict, 0.0)
      RemoveAnimSet(dict)
    end
  else
    ResetPedMovementClipset(PlayerPedId(), 0.0)
  end
end

function BR.setPedFlags(ped)
  SetPedDropsWeaponsWhenDead(ped, false)
  SetPedConfigFlag(ped, 422, true)
  SetPedConfigFlag(ped, 35, false)
  SetPedConfigFlag(ped, 128, false)
  SetPedConfigFlag(ped, 184, true)
  SetPedConfigFlag(ped, 229, true)
end

-- AddEventHandler('onClientResourceStart', function()
--   print('onClientMapStart')
--   exports.spawnmanager:setAutoSpawn(true)
--   exports.spawnmanager:forceRespawn()  
-- end)