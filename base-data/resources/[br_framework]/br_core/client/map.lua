
local Tools = module("br_core", "lib/Tools")


function tBR.addBlip(x,y,z,idtype,idcolor,text,scale)
  local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001) 
  SetBlipSprite(blip, idtype)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip,idcolor)
  SetBlipScale(blip, scale)

  if text ~= nil then
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
  end

  if scale == nil then
    SetBlipScale(blip, 0.6)
  end

  return blip
end

function tBR.addBlipProperty(x,y,z,idtype,idcolor,text,scale)
  local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001) 
  SetBlipSprite(blip, idtype)
  SetBlipCategory(blip, 10)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip,idcolor)
  SetBlipScale(blip, scale)

  if text ~= nil then
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
  end

  if scale == nil then
    SetBlipScale(blip, 0.4)
  end

  return blip
end

function tBR.addBlipToEntity(id,idtype,idcolor,text,scale)
  local player = GetPlayerFromServerId(id)
  local ped = GetPlayerPed(player)
  if ped ~= PlayerPedId() then
    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, idtype)
    SetBlipColour(blip, idcolor)
    SetBlipScale(blip,scale)
    
    if text ~= nil then
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(text)
      EndTextCommandSetBlipName(blip)
    end

    if scale == nil then
      SetBlipScale(blip, 0.8)
    end

    return blip
  end
  
  return false
end


function tBR.removeBlip(id)
  RemoveBlip(id)
end

local named_blips = {}

function tBR.setNamedBlip(name,x,y,z,idtype,idcolor,text)
  tBR.removeNamedBlip(name) -- remove old one

  named_blips[name] = tBR.addBlip(x,y,z,idtype,idcolor,text)
  return named_blips[name]
end

-- remove a named blip
function tBR.removeNamedBlip(name)
  if named_blips[name] ~= nil then
    tBR.removeBlip(named_blips[name])
    named_blips[name] = nil
  end
end

-- GPS

-- set the GPS destination marker coordinates
function tBR.setGPS(x,y)
  SetNewWaypoint(x+0.0001,y+0.0001)
end

-- set route to native blip id
function tBR.setBlipRoute(id)
  SetBlipRoute(id,true)
end

-- MARKER

local markers = {}
local marker_ids = Tools.newIDGenerator()
local named_markers = {}

-- add a circular marker to the game map
-- return marker id
function tBR.addMarker(x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  local marker = {x=x,y=y,z=z,sx=sx,sy=sy,sz=sz,r=r,g=g,b=b,a=a,visible_distance=visible_distance}


  -- default values
  if marker.sx == nil then marker.sx = 2.0 end
  if marker.sy == nil then marker.sy = 2.0 end
  if marker.sz == nil then marker.sz = 0.7 end

  if marker.r == nil then marker.r = 0 end
  if marker.g == nil then marker.g = 155 end
  if marker.b == nil then marker.b = 255 end
  if marker.a == nil then marker.a = 200 end

  -- fix gta5 integer -> double issue
  marker.x = marker.x+0.001
  marker.y = marker.y+0.001
  marker.z = marker.z+0.001
  marker.sx = marker.sx+0.001
  marker.sy = marker.sy+0.001
  marker.sz = marker.sz+0.001

  if marker.visible_distance == nil then marker.visible_distance = 150 end

  local id = marker_ids:gen()
  markers[id] = marker

  return id
end

-- remove marker
function tBR.removeMarker(id)
  if markers[id] then
    markers[id] = nil
    marker_ids:free(id)
  end
end

-- set a named marker (same as addMarker but for a unique name, add or update)
-- return id
function tBR.setNamedMarker(name,x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  tBR.removeNamedMarker(name) -- remove old marker

  named_markers[name] = tBR.addMarker(x,y,z,sx,sy,sz,r,g,b,a,visible_distance)
  return named_markers[name]
end

function tBR.removeNamedMarker(name)
  if named_markers[name] then
    tBR.removeMarker(named_markers[name])
    named_markers[name] = nil
  end
end

-- markers draw loop
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local px,py,pz = tBR.getPosition()

    for k,v in pairs(markers) do
      -- check visibility
      if GetDistanceBetweenCoords(v.x,v.y,v.z,px,py,pz,true) <= v.visible_distance then
        DrawMarker(1,v.x,v.y,v.z,0,0,0,0,0,0,v.sx,v.sy,v.sz,v.r,v.g,v.b,v.a,0,0,0,0)
      end
    end
  end
end)

-- AREA

local areas = {}

-- create/update a cylinder area
function tBR.setArea(name,x,y,z,radius,height)
  local area = {x=x+0.001,y=y+0.001,z=z+0.001,radius=radius,height=height}

  -- default values
  if area.height == nil then area.height = 6 end

  areas[name] = area
end

-- remove area
function tBR.removeArea(name)
  if areas[name] then
    areas[name] = nil
  end
end

-- areas triggers detections
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(250)

    local px,py,pz = tBR.getPosition()

    for k,v in pairs(areas) do

      local player_in = (GetDistanceBetweenCoords(v.x,v.y,v.z,px,py,pz,true) <= v.radius and math.abs(pz-v.z) <= v.height)

      if v.player_in and not player_in then
        BRserver._leaveArea(k)
      elseif not v.player_in and player_in then
        BRserver._enterArea(k)
      end

      v.player_in = player_in 
    end
  end
end)

function tBR.setStateOfClosestDoor(doordef, locked, doorswing)
  local x,y,z = tBR.getPosition()
  local hash = doordef.modelhash
  if hash == nil then
    hash = GetHashKey(doordef.model)
  end

  SetStateOfClosestDoorOfType(hash,x,y,z,locked,doorswing+0.0001)
end

function tBR.openClosestDoor(doordef)
  tBR.setStateOfClosestDoor(doordef, false, 0)
end

function tBR.closeClosestDoor(doordef)
  tBR.setStateOfClosestDoor(doordef, true, 0)
end
