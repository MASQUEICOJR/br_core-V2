local cfg = module("cfg/groups")
local groups = cfg.groups
local users = cfg.users
local selectors = cfg.selectors

function BR.getGroupTitle(group)
	local g = groups[group]
	if g and g._config and g._config.title then
		return g._config.title
	end
	return group
end

function BR.getUserGroups(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then 
		if data.groups == nil then
			data.groups = {}
		end
		return data.groups
	else
		return {}
	end
end

function BR.getUserGroupByType(user_id,gtype)
	local user_groups = BR.getUserGroups(user_id)
	for k,v in pairs(user_groups) do
		local kgroup = groups[k]
		if kgroup then
			if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
				return kgroup._config.title
			end
		end
	end
	return ""
end
function BR.addUserGroup(user_id,group)
	if not BR.hasGroup(user_id,group) then
		local user_groups = BR.getUserGroups(user_id)
		local ngroup = groups[group]
		if ngroup then
			if ngroup._config and ngroup._config.gtype ~= nil then
				local _user_groups = {}
				for k,v in pairs(user_groups) do
					_user_groups[k] = v
				end

				for k,v in pairs(_user_groups) do
					local kgroup = groups[k]
					if kgroup and kgroup._config and ngroup._config and kgroup._config.gtype == ngroup._config.gtype then
						BR.removeUserGroup(user_id,k)
					end
				end
			end

			user_groups[group] = true
			local player = BR.getUserSource(user_id)
			if ngroup._config and ngroup._config.onjoin and player ~= nil then
				ngroup._config.onjoin(player)
			end

			local gtype = nil
			if ngroup._config then
				gtype = ngroup._config.gtype 
			end
			TriggerEvent("BR:playerJoinGroup",user_id,group,gtype)
		end
	end
end

function BR.getUsersByPermission(perm)
	local users = {}
	for k,v in pairs(BR.rusers) do
		if BR.hasPermission(tonumber(k),perm) then
			table.insert(users,tonumber(k))
		end
	end
	return users
end

function BR.removeUserGroup(user_id,group)
	local user_groups = BR.getUserGroups(user_id)
	local groupdef = groups[group]
	if groupdef and groupdef._config and groupdef._config.onleave then
		local source = BR.getUserSource(user_id)
		if source then
			groupdef._config.onleave(source)
		end
	end

	local gtype = nil
	if groupdef._config then
		gtype = groupdef._config.gtype 
	end

	TriggerEvent("BR:playerLeaveGroup",user_id,group,gtype)
	user_groups[group] = nil
end

function BR.hasGroup(user_id,group)
	local user_groups = BR.getUserGroups(user_id)
	return (user_groups[group] ~= nil)
end

local func_perms = {}

function BR.registerPermissionFunction(name,callback)
	func_perms[name] = callback
end

BR.registerPermissionFunction("not",function(user_id,parts)
	return not BR.hasPermission(user_id,"!"..table.concat(parts,".",2))
end)

BR.registerPermissionFunction("is",function(user_id,parts)
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

function BR.hasPermission(user_id,perm)
	local user_groups = BR.getUserGroups(user_id)
	local fchar = string.sub(perm,1,1)

	if fchar == "@" then
		local _perm = string.sub(perm,2,string.len(perm))
		local parts = splitString(_perm,".")
		if #parts == 3 then
			local group = parts[1]
			local aptitude = parts[2]
			local op = parts[3]

			local alvl = math.floor(BR.expToLevel(BR.getExp(user_id,group,aptitude)))

			local fop = string.sub(op,1,1)
			if fop == "<" then
				local lvl = parseInt(string.sub(op,2,string.len(op)))
				if alvl < lvl then
					return true
				end
			elseif fop == ">" then
				local lvl = parseInt(string.sub(op,2,string.len(op)))
				if alvl > lvl then
					return true
				end
			else
				local lvl = parseInt(string.sub(op,1,string.len(op)))
				if alvl == lvl then
					return true
				end
			end
		end
	elseif fchar == "#" then
		local _perm = string.sub(perm,2,string.len(perm))
		local parts = splitString(_perm,".")
		if #parts == 2 then
			local item = parts[1]
			local op = parts[2]

			local amount = BR.getInventoryItemAmount(user_id, item)

			local fop = string.sub(op,1,1)
			if fop == "<" then
				local n = parseInt(string.sub(op,2,string.len(op)))
				if amount < n then
					return true
				end
			elseif fop == ">" then
				local n = parseInt(string.sub(op,2,string.len(op)))
				if amount > n then
					return true
				end
			else
				local n = parseInt(string.sub(op,1,string.len(op)))
				if amount == n then
					return true
				end
			end
		end
	elseif fchar == "!" then
		local _perm = string.sub(perm,2,string.len(perm))
		local parts = splitString(_perm,".")
		if #parts > 0 then
			local fperm = func_perms[parts[1]]
			if fperm then
				return fperm(user_id, parts) or false
			else
				return false
			end
		end
	else
		local nperm = "-"..perm
		for k,v in pairs(user_groups) do
			if v then
				local group = groups[k]
				if group then
					for l,w in pairs(group) do
						if l ~= "_config" and w == nperm then
							return false
						end
					end
				end
			end
		end

		for k,v in pairs(user_groups) do
			if v then
				local group = groups[k]
				if group then
					for l,w in pairs(group) do
						if l ~= "_config" and w == perm then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function BR.hasPermissions(user_id, perms)
	for k,v in pairs(perms) do
		if not BR.hasPermission(user_id, v) then
			return false
		end
	end
	return true
end

local selector_menus = {}
for k,v in pairs(selectors) do
	local kgroups = {}

	local function ch_select(player,choice)
		local user_id = BR.getUserId(player)
		if user_id then
			local gname = kgroups[choice]
			if gname then
				BR.addUserGroup(user_id,gname)
				BR.closeMenu(player)
			end
		end
	end

	local menu = { name = k }
	for l,w in pairs(v) do
		if l ~= "_config" then
			local title = BR.getGroupTitle(w)
			kgroups[title] = w
			menu[title] = {ch_select}
		end
	end

	selector_menus[k] = menu
end

local function build_client_selectors(source)
	local user_id = BR.getUserId(source)
	if user_id then
		for k,v in pairs(selectors) do
			local gcfg = v._config
			local menu = selector_menus[k]

			if gcfg and menu then
				local x = gcfg.x
				local y = gcfg.y
				local z = gcfg.z

				local function selector_enter(source)
					local user_id = BR.getUserId(source)
					if user_id and BR.hasPermissions(user_id,gcfg.permissions or {}) then
						BR.openMenu(source,menu) 
					end
				end

				local function selector_leave(source)
					BR.closeMenu(source)
				end

				BRclient._addMarker(source,23,x,y,z-0.95,1,1,0.5,255,0,0,50,100)
				BR.setArea(source,"BR:gselector:"..k,x,y,z,1,1,selector_enter,selector_leave)
			end
		end
	end
end

-- AddEventHandler("BR:playerSpawn",function(user_id,source,first_spawn)
-- 	if first_spawn then
-- 		build_client_selectors(source)
-- 		local user = users[user_id]
-- 		if user then
-- 			for k,v in pairs(user) do
-- 				BR.addUserGroup(user_id,v)
-- 			end
-- 		end

-- 		BR.addUserGroup(user_id,"user")
-- 	end

-- 	local user_groups = BR.getUserGroups(user_id)
-- 	for k,v in pairs(user_groups) do
-- 		local group = groups[k]
-- 		if group and group._config and group._config.onspawn then
-- 			group._config.onspawn(source)
-- 		end
-- 	end
-- end)

function BR.IniciarModuleGroup(user_id) 
	local user_groups = BR.getUserGroups(user_id)
	for k,v in pairs(user_groups) do
		local group = groups[k]
		if group and group._config and group._config.onspawn then
			group._config.onspawn(source)
		end
	end
end