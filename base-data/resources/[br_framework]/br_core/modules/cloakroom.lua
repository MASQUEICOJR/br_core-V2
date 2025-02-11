local cfg = module("cfg/cloakrooms")

local menus = {}

function BR.save_idle_custom(player,custom)
	local r_idle = {}
	local user_id = BR.getUserId(player)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			if data.cloakroom_idle == nil then
				data.cloakroom_idle = custom
			end

			for k,v in pairs(data.cloakroom_idle) do
				r_idle[k] = v
			end
		end
	end
	return r_idle
end

function BR.removeCloak(player)
	local user_id = BR.getUserId(player)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			if data.cloakroom_idle ~= nil then
				BRclient._setCustomization(player,data.cloakroom_idle)
				data.cloakroom_idle = nil
			end
		end
	end
end

async(function()
	for k,v in pairs(cfg.cloakroom_types) do
		local menu = { name = k }
		menus[k] = menu
		local not_uniform = false

		if v._config and v._config.not_uniform then
			not_uniform = true
		end

		local choose = function(player,choice)
			local custom = v[choice]
			if custom then
				old_custom = BRclient.getCustomization(player)
				local idle_copy = {}

				if not not_uniform then
					idle_copy = BR.save_idle_custom(player,old_custom)
				end

				if custom.model then
					idle_copy.modelhash = nil
				end

				for l,w in pairs(custom) do
					idle_copy[l] = w
				end

				BRclient._setCustomization(player,idle_copy)
			end
		end

		if not not_uniform then
			menu["> Retirar"] = { function(player,choice) BR.removeCloak(player) end }
		end

		for l,w in pairs(v) do
			if l ~= "_config" then
				menu[l] = { choose }
			end
		end
	end
end)

local function build_client_points(source)
	for k,v in pairs(cfg.cloakrooms) do
		local gtype,x,y,z = table.unpack(v)
		local cloakroom = cfg.cloakroom_types[gtype]
		local menu = menus[gtype]
		if cloakroom and menu then
			local gcfg = cloakroom._config or {}
			local function cloakroom_enter(source,area)
				local user_id = BR.getUserId(source)
				if user_id and BR.hasPermissions(user_id,gcfg.permissions or {}) then
					if gcfg.not_uniform then
						local data = BR.getUserDataTable(user_id)
					end
					BR.openMenu(source,menu)
				end
			end

			local function cloakroom_leave(source,area)
				BR.closeMenu(source)
			end

			BRclient._addMarker(source,21,x,y,z-0.6,0.5,0.5,0.4,255,0,0,50,100)
			BR.setArea(source,"BR:cfg:cloakroom"..k,x,y,z,2,2,cloakroom_enter,cloakroom_leave)
		end
	end
end

AddEventHandler("BR:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_client_points(source)
	end
end)