-- this module describe the group/permission system

-- group functions are used on connected players only
-- multiple groups can be set to the same player, but the gtype config option can be used to set some groups as unique

-- api

local cfg = module("cfg/groups")
local groups = cfg.groups or {}
local xusers = cfg.users or {}

function BR.getGroups()
  return groups
end

function BR.getGroupGradeInfo(group, gradeNameOrRank)
  if not groups[group]?._config?.grades then return nil end
  local isRank = tonumber(gradeNameOrRank) ~= nil
  for k, grade in next, groups[group]?._config?.grades do
    if (isRank and k == gradeNameOrRank) or string.lower(grade.name) == string.lower(gradeNameOrRank) then
      local _data = table.clone(grade)
      _data['rank'] = k
      _data['group'] = group
      return _data
    end
  end
  return nil
end

function BR.getGroupMaxGrade(group)
  return groups[group]?._config?.grades and #groups[group]?._config?.grades or 0
end

-- return group title
function BR.getGroupTitle(group)
  local g = groups[group]

  return g?._config?.title or ""
end

function BR.getGroupData(group)
  return groups[group]
end

-- get groups keys of a connected user
function BR.getUserGroups(user_id)
  local data = BR.getUserDataTable(user_id)
  if data then
    if data.groups == nil then
      data.groups = {} -- init groups
    end

    return data.groups
  else
    return {}
  end
end

-- add a group to a connected user
function BR.addUserGroup(user_id, group, grade)
  if not BR.hasGroup(user_id, group, grade) then
    local user_groups = BR.getUserGroups(user_id)
    local ngroup = groups[group]
    if ngroup then
      if ngroup?._config?.gtype ~= nil then
        -- copy group list to prevent iteration while removing
        local _user_groups = {}
        for k, v in pairs(user_groups) do
          _user_groups[k] = v
        end

        for k in pairs(_user_groups) do -- remove all groups with the same gtype
          local kgroup = groups[k]
          if kgroup?._config?.gtype == ngroup?._config?.gtype then
            BR.removeUserGroup(user_id, k)
          end
        end
      end

      -- add group
      user_groups[group] = { rank = grade or 0 }
      local gtype = ngroup?._config?.gtype

      if gtype == 'job' then
        user_groups[group]['duty'] = true
      end

      local player = BR.getUserSource(user_id)
      if ngroup?._config?.onjoin and player ~= nil then
        ngroup._config.onjoin(player) -- call join callback
      end

      -- trigger join event


      local user_group = user_groups[group]
      local rank = user_group?.rank or 0
      local rankName = rank > 0 and ngroup?._config?.grades?[rank]?.name or ""
      local jobType = ngroup?._config?.jobType or false
      local isboss = ngroup?._config?.grades?[rank]?.isboss or false

      TriggerEvent("BR:playerJoinGroup", {
        user_id = user_id,
        name = group,
        group = group,
        gtype = gtype,
        rank = rank,
        rankName = rankName,
        jobType = jobType,
        isboss = isboss,
        onduty = user_groups[group]['duty']
      })

      if player then
        TriggerClientEvent("BR:updateGroupInfo", player, {
          name = group,
          group = group,
          gtype = gtype,
          jobType = jobType,
          rankName = rankName,
          rank = rank,
          isboss = isboss,
          duty = user_groups[group]['duty'],
          action = 'enter'
        })
        TriggerClientEvent('BR:SetPlayerData', player, BR.getPlayerInfo(player))
      end
    end
  end
end

-- remove a group from a connected user
function BR.removeUserGroup(user_id, group)
  local groupdef = groups[group]
  local user_groups = BR.getUserGroups(user_id)
  local source = BR.getUserSource(user_id)

  local gtype = groupdef?._config?.gtype
  local user_group = user_groups[group]
  local rank = user_group?.rank or 0
  local rankName = rank > 0 and groupdef?._config?.grades?[rank]?.name or ""
  local jobType = groupdef?._config?.jobType or false
  local isboss = groupdef?._config?.grades?[rank]?.isboss or false

  user_groups[group] = nil

  TriggerEvent("BR:playerLeaveGroup", {
    user_id = user_id,
    group = group,
    name = group,
    gtype = gtype,
    rank = rank,
    rankName = rankName,
    jobType = jobType,
    isboss = isboss,
    onduty = false
  })

  if source then
    if groupdef._config?.onleave then
      groupdef._config.onleave(source)
    end
    TriggerClientEvent("BR:updateGroupInfo", source, {
      name = group,
      group = group,
      gtype = gtype,
      jobType = jobType,
      rankName = rankName,
      rank = rank,
      isboss = isboss,
      duty = false,
      action = 'leave'
    })
    TriggerClientEvent('BR:SetPlayerData', source, BR.getPlayerInfo(source))
  end
end

-- get user group by type
-- return group name or an empty string
function BR.getUserGroupByType(user_id, gtype)
  local user_groups = BR.getUserGroups(user_id)
  for k, v in pairs(user_groups) do
    local kgroup = groups[k]
    if kgroup then
      if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
        return k, v, kgroup
      end
    end
  end

  return nil
end

-- return list of connected users by group
function BR.getUsersByGroup(group)
  local users = {}

  for k, v in pairs(BR.rusers) do
    if BR.hasGroup(tonumber(k), group) then users[#users + 1] = tonumber(k) end
  end

  return users
end

-- return list of connected users by permission
function BR.getUsersByPermission(perm)
  local users = {}

  for k, v in pairs(BR.rusers) do
    if BR.hasPermission(tonumber(k), perm) then
      users[#users + 1] = tonumber(k)
    end
  end

  return users
end

-- check if the user has a specific group
function BR.hasGroup(user_id, group, grade)
  local user_groups = BR.getUserGroups(user_id)
  if not grade or grade == 0 then
    return (user_groups[group] ~= nil)
  end
  return user_groups?[group]?.grade == grade
end

local func_perms = {}

-- register a special permission function
-- name: name of the permission -> "!name.[...]"
-- callback(user_id, parts)
--- parts: parts (strings) of the permissions, ex "!name.param1.param2" -> ["name", "param1", "param2"]
--- should return true or false/nil
function BR.registerPermissionFunction(name, callback)
  func_perms[name] = callback
end

--[[
  BR.hasPermission(user_id, '!grade.police.>.major')
  BR.hasPermission(user_id, '!grade.police.>.1')
]]
BR.registerPermissionFunction('grade', function(user_id, parts)
  local group = parts[2]
  local op = #parts == 4 and parts[3] or "="
  local grade = #parts == 4 and parts[4] or parts[3]

  local gradeInfo = BR.getGroupGradeInfo(group, grade)

  if not gradeInfo then return false end
  local user_groups = BR.getUserGroups(user_id)

  if user_groups[group] then
    if op == '=' then
      return (user_groups[group]?.rank or 0) == (gradeInfo.rank or 0)
    end

    if op == "!=" then
      return (user_groups[group]?.rank or 0) ~= (gradeInfo.rank or 0)
    end

    if op == '>' then
      return (user_groups[group]?.rank or 0) > (gradeInfo.rank or 0)
    end

    if op == '<' then
      return (user_groups[group]?.rank or 0) < (gradeInfo.rank or 0)
    end

    if op == '>=' then
      return (user_groups[group]?.rank or 0) >= (gradeInfo.rank or 0)
    end

    if op == '<=' then
      return (user_groups[group]?.rank or 0) <= (gradeInfo.rank or 0)
    end
  end

  return false
end)

-- register not fperm (negate another fperm)
BR.registerPermissionFunction("not", function(user_id, parts)
  return not BR.hasPermission(user_id, "!" .. table.concat(parts, ".", 2))
end)

BR.registerPermissionFunction("is", function(user_id, parts)
  local param = parts[2]
  if param == "inside" then
    local player = BR.getUserSource(user_id)
    if player then
      return BRclient.isInside(player)
    end
  elseif param == "invehicle" then
    local player = BR.getUserSource(user_id)
    if player then
      return BRclient.isInVehicle(player)
    end
  end
end)

--helper functions

function BR.hasGroupWithGrade(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. "." .. grade)
end

function BR.hasGroupWithGradeGreater(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. ".>." .. grade)
end

function BR.hasGroupWithGradeSmaller(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. ".<." .. grade)
end

function BR.hasGroupWithGradeGreaterOrEqual(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. ".>=." .. grade)
end

function BR.hasGroupWithGradeSmallOrEqual(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. ".<=." .. grade)
end

function BR.hasGroupNotInGrade(user_id, group, grade)
  return BR.hasPermission(user_id, "!grade." .. group .. ".!=." .. grade)
end

-- check if the user has a specific permission
function BR.hasPermission(user_id, perm)
  local user_groups = BR.getUserGroups(user_id)

  local fchar = string.sub(perm, 1, 1)

  if fchar == "@" then -- special aptitude permission
    local _perm = string.sub(perm, 2, string.len(perm))
    local parts = splitString(_perm, ".")
    if #parts == 3 then -- decompose group.aptitude.operator
      local group = parts[1]
      local aptitude = parts[2]
      local op = parts[3]

      local alvl = math.floor(BR.expToLevel(BR.getExp(user_id, group, aptitude)))

      local fop = string.sub(op, 1, 1)
      if fop == "<" then -- less (group.aptitude.<x)
        local lvl = parseInt(string.sub(op, 2, string.len(op)))
        if alvl < lvl then return true end
      elseif fop == ">" then -- greater (group.aptitude.>x)
        local lvl = parseInt(string.sub(op, 2, string.len(op)))
        if alvl > lvl then return true end
      else -- equal (group.aptitude.x)
        local lvl = parseInt(string.sub(op, 1, string.len(op)))
        if alvl == lvl then return true end
      end
    end
  elseif fchar == "#" then -- special item permission
    local _perm = string.sub(perm, 2, string.len(perm))
    local parts = splitString(_perm, ".")
    if #parts == 2 then -- decompose item.operator
      local item = parts[1]
      local op = parts[2]

      local amount = BR.getInventoryItemAmount(user_id, item)

      local fop = string.sub(op, 1, 1)
      if fop == "<" then -- less (item.<x)
        local n = parseInt(string.sub(op, 2, string.len(op)))
        if amount < n then return true end
      elseif fop == ">" then -- greater (item.>x)
        local n = parseInt(string.sub(op, 2, string.len(op)))
        if amount > n then return true end
      else -- equal (item.x)
        local n = parseInt(string.sub(op, 1, string.len(op)))
        if amount == n then return true end
      end
    end
  elseif fchar == "!" then -- special function permission
    local _perm = string.sub(perm, 2, string.len(perm))
    local parts = splitString(_perm, ".")
    if #parts > 0 then
      local fperm = func_perms[parts[1]]
      if fperm then
        return fperm(user_id, parts) or false
      else
        return false
      end
    end
  else -- regular plain permission
    -- precheck negative permission
    local nperm = "-" .. perm
    for k, v in pairs(user_groups) do
      if v then -- prevent issues with deleted entry
        local group = groups[k]
        if group then
          for l, w in pairs(group) do -- for each group permission
            if l ~= "_config" and w == nperm then return false end
          end
        end
      end
    end

    -- check if the permission exists
    for k, v in pairs(user_groups) do
      if v then -- prevent issues with deleted entry
        local group = groups[k]
        if group then
          for l, w in pairs(group) do -- for each group permission
            if l ~= "_config" and w == perm then return true end
          end
        end
      end
    end
  end

  return false
end

-- check if the user has a specific list of permissions (all of them)
function BR.hasPermissions(user_id, perms)
  for k, v in pairs(perms) do
    if not BR.hasPermission(user_id, v) then
      return false
    end
  end

  return true
end

function BR.userGroupPromote(user_id, group)
  if not groups[group]?._config?.grades or not BR.hasGroup(user_id, group) then return false end
  local max = BR.getGroupMaxGrade(group)
  local user_groups = BR.getUserGroups(user_id)
  if user_groups?[group]?.rank < max then
    user_groups[group].rank = user_groups[group].rank + 1
    local src = BR.getUserSource(user_id)
    if src then
      TriggerClientEvent("BR:updateGroupRank", src, { group = group, rank = user_groups[group].rank })
      TriggerClientEvent('BR:SetPlayerData', src, BR.getPlayerInfo(src))
    end
    return true
  end

  return false
end

function BR.userGroupDemote(user_id, group)
  if not groups[group]?._config?.grades or not BR.hasGroup(user_id, group) then return false end
  local user_groups = BR.getUserGroups(user_id)
  if user_groups?[group]?.rank > 1 then
    user_groups[group].rank = user_groups[group].rank - 1
    local src = BR.getUserSource(user_id)
    if src then
      TriggerClientEvent("BR:updateGroupRank", src, { group = group, rank = user_groups[group].rank })
      TriggerClientEvent('BR:SetPlayerData', src, BR.getPlayerInfo(src))
    end
    return true
  end

  return false
end

function BR.isGroupGradeBoss(group, grade)
  grade = tonumber(grade)
  local rankInfo = groups[group]?._config?.grades[grade]
  return rankInfo and (grade >= groups[group]?._config?.grades or rankInfo?.isboss)
end

AddEventHandler('br_core:login', function(source, user_id, char_id, first_spawn)
    
  local user_groups = BR.getUserGroups(user_id)
  for k in next, user_groups or {} do
    local group = k
    local ngroup = groups[group]

    local user_group = user_groups[group]
    local rank = user_group?.rank or 0
    local rankName = rank > 0 and ngroup?._config?.grades?[rank]?.name or ""
    local jobType = ngroup?._config?.jobType or false
    local isboss = ngroup?._config?.grades?[rank]?.isboss or false

    TriggerClientEvent("BR:updateGroupInfo", source, {
      name = group,
      group = group,
      gtype = ngroup?._config?.gtype,
      jobType = jobType,
      rankName = rankName,
      rank = rank,
      isboss = isboss,
      duty = user_groups[group]['duty'],
      action = 'enter'
    })
    if group?._config?.onspawn then
      group._config.onspawn(source)
    end
  end
end)
