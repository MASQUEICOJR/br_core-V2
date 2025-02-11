--[[
ALTER TABLE `vrp_user_homes`
	CHANGE COLUMN `home` `home` VARCHAR(255) NOT NULL AFTER `user_id`,
	DROP INDEX `home`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`user_id`,`home`);]]

local cfg = module("cfg/homes")

BR.prepare("BR/get_address","SELECT * FROM vrp_user_homes WHERE user_id = @user_id")
BR.prepare("BR/get_home_owner","SELECT user_id FROM vrp_user_homes WHERE home = @home AND number = @number")
BR.prepare("BR/rm_address","DELETE FROM vrp_user_homes WHERE user_id = @user_id AND home = @home")
BR.prepare("BR/rm_address_chest","DELETE FROM srv_data WHERE dkey = @dkey")
BR.prepare("BR/set_address","REPLACE INTO vrp_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")

local components = {}

function BR.getUserAddress(user_id)
	local rows = BR.query("BR/get_address",{ user_id = user_id })
	return rows
end

function BR.getUserAddress2(user_id)
	local rows = BR.query("BR/get_address",{ user_id = user_id })
	return rows[1]
end

function BR.setUserAddress(user_id,home,number)
	BR.execute("BR/set_address",{ user_id = user_id, home = home, number = number })
end

function BR.removeUserAddress(user_id,home,chestid)
	BR.execute("BR/rm_address",{ user_id = user_id, home = home })
	BR.execute("BR/rm_address_chest",{ dkey = "chest:u"..user_id.."-"..chestid.."home" })
end

function BR.getUserByAddress(home,number)
	local rows = BR.query("BR/get_home_owner",{ home = home, number = number })
	if #rows > 0 then
		return rows[1].user_id
	end
	return false
end

function BR.findFreeNumber(home,max)
	local i = 1
	while i <= max do
		if not BR.getUserByAddress(home,i) then
			return i
		end
		i = i+1
	end
end

function BR.defHomeComponent(name,oncreate,ondestroy)
	components[name] = { oncreate,ondestroy }
end

local uslots = {}
for k,v in pairs(cfg.slot_types) do
	uslots[k] = {}
	for l,w in pairs(v) do
		uslots[k][l] = { used = false }
	end
end

local function allocateSlot(stype)
	local slots = cfg.slot_types[stype]
	if slots then
		local _uslots = uslots[stype]
		for k,v in pairs(slots) do
			if _uslots[k] and not _uslots[k].used then
				_uslots[k].used = true
				return k
			end
		end
	end
	return nil
end

local function freeSlot(stype, id)
	local slots = cfg.slot_types[stype]
	if slots then
		uslots[stype][id] = { used = false }
	end
end

local function getAddressSlot(home_name,number)
	for k,v in pairs(uslots) do
		for l,w in pairs(v) do
			if w.home_name == home_name and tostring(w.home_number) == tostring(number) then
				return k,l
			end
		end
	end
	return nil,nil
end

local function is_empty(table)
	for k,v in pairs(table) do
		return false
	end
	return true
end

local function leave_slot(user_id,player,stype,sid)
	local slot = uslots[stype][sid]
	local home = cfg.homes[slot.home_name]
	if home then
		local tmp = BR.getUserTmpTable(user_id)
		if tmp then
			tmp.home_stype = nil
			tmp.home_sid = nil
		end

		if player and home and home.entry_point then
			BRclient._teleport(player,table.unpack(home.entry_point))
			slot.players[user_id] = nil
		end

		for k,v in pairs(cfg.slot_types[stype][sid]) do
			local name,x,y,z = table.unpack(v)

			if name == "entry" then
				local nid = "BR:home:slot"..stype..sid
				BRclient._removeNamedMarker(player,nid)
				BR.removeArea(player,nid)
			else
				local component = components[v[1]]
				if component then
					local data = slot.components[k]
					if not data then
						data = {}
						slot.components[k] = data
					end
					component[2](slot.owner_id, stype, sid, k, v._config or {}, data, x, y, z, player)
				end
			end
		end

		if is_empty(slot.players) then
			freeSlot(stype,sid)
		end
	end
end

local function enter_slot(user_id,player,stype,sid)
	local slot = uslots[stype][sid]
	local home = cfg.homes[slot.home_name]
	local tmp = BR.getUserTmpTable(user_id)

	if tmp then
		tmp.home_stype = stype
		tmp.home_sid = sid
	end

	slot.players[user_id] = player

	local menu = { name = slot.home_name }
	menu["Sair"] = { function(player,choice)
		leave_slot(user_id,player,stype,sid)
	end }

	local function entry_enter(player,area)
		BR.openMenu(player,menu)
	end

	local function entry_leave(player,area)
		BR.closeMenu(player)
	end

	for k,v in pairs(cfg.slot_types[stype][sid]) do
		local name,x,y,z = table.unpack(v)

		if name == "entry" then
			BRclient._teleport(player, x,y,z)
			local nid = "BR:home:slot"..stype..sid
			BR.setArea(player,nid,x,y,z,1,1,entry_enter,entry_leave)
		else
			local component = components[v[1]]
			if component then
				local data = slot.components[k]
				if not data then
					data = {}
					slot.components[k] = data
				end
				component[1](slot.owner_id, stype, sid, k, v._config or {},data,x,y,z,player)
			end
		end
	end
end

function BR.accessHome(user_id,home,number)
	local _home = cfg.homes[home]
	local stype,slotid = getAddressSlot(home,number)
	local player = BR.getUserSource(user_id)
	local owner_id = BR.getUserByAddress(home,number)

	if _home ~= nil and player ~= nil then
		if stype == nil then
			stype = _home.slot
			slotid = allocateSlot(_home.slot)

			if slotid ~= nil then
				local slot = uslots[stype][slotid]
				slot.home_name = home
				slot.home_number = number
				slot.owner_id = owner_id
				slot.players = {}
				slot.components = {}
			end
		end

		if slotid ~= nil then
			enter_slot(user_id,player,stype,slotid)
			return true
		end
	end
end

local function build_entry_menu(user_id,home_name)
	local home = cfg.homes[home_name]
	local shome = cfg.slot_types[home.slot]
	local menu = { name = home_name }

	menu["Interfone"] = { function(player,choice)
		local number = BR.prompt(player,"Numero:","")
		number = parseInt(number)
		local huser_id = BR.getUserByAddress(home_name,number)
		if huser_id then
			if huser_id == user_id then
				if not BR.accessHome(user_id,home_name,number) then
					TriggerClientEvent("Notify",player,"importante","Residência ocupada no momento.")
				end
			else
				local hplayer = BR.getUserSource(huser_id)
				if hplayer ~= nil then
					local nuser_id = BR.getUserId(player)
					local identitys = BR.getUserIdentity(nuser_id)
					if BR.request(hplayer,"<b>"..identitys.name.." "..identitys.firstname.."</b> está tocando seu interfone, deseja aceitar?",30) then
						BR.accessHome(user_id,home_name,number)
					else
						TriggerClientEvent("Notify",player,"negado","Recusaram sua entrada.")
					end
				end
			end
		else
			TriggerClientEvent("Notify",player,"aviso","Interfone inválido.")
		end
	end }

	menu["Comprar"] = { function(player,choice)
		local addresses = BR.getUserAddress(user_id)
		local owner = false
		for k,address in pairs(addresses) do
			if address and address.home == home_name then
				owner = true
			end
		end
		if not owner then
			local number = BR.findFreeNumber(home_name,home.max)
			if number then
				if BR.request(player,"Você deseja <b>comprar</b> esta residência?",30) then
					if BR.tryPayment(user_id,home.buy_price) then
						BR.setUserAddress(user_id,home_name,number)
						TriggerClientEvent("Notify",player,"sucesso","Compra concluida.")
					else
						TriggerClientEvent("Notify",player,"negado","Dinheiro insuficiente.")
					end
				end
			end
		end
	end,"<text01>Valor:</text01><text02>$"..BR.format(parseInt(home.buy_price)).."</text02>" }

	menu["Vender"] = { function(player,choice)
		if BR.request(player,"Você deseja <b>vender</b> sua residência?",30) then
			local addresses = BR.getUserAddress(user_id)
			local owner = false
			for k,address in pairs(addresses) do
				if address and address.home == home_name then
					owner = true
				end
			end
			if owner then
				BR.giveDinheirama(user_id,home.sell_price * 2)
				BR.removeUserAddress(user_id,home_name,shome[1][2]._config.name)
				TriggerClientEvent("Notify",player,"sucesso","Venda concluida.")
			else
				TriggerClientEvent("Notify",player,"negado","Residência não encontrada.")
			end
		end
	end,"<text01>Valor:</text01> <text02>$"..BR.format(parseInt(home.sell_price) * 2).."</text02>" }

	return menu
end

local function build_client_homes(source)
    local user_id = BR.getUserId(source)
    local address = BR.getUserAddress(user_id)
    if user_id then
        for k,v in pairs(cfg.homes) do
            local x,y,z = table.unpack(v.entry_point)
            local function entry_enter(player,area)
                local user_id = BR.getUserId(player)
                if user_id and BR.hasPermissions(user_id,v.permissions or {}) then
                    BR.openMenu(source,build_entry_menu(user_id, k))
                end
            end

            local function entry_leave(player,area)
                BR.closeMenu(player)
            end

            if #address > 0 then
                for kk,vv in pairs(address) do
                    if k == vv.home then
                        BRclient._addBlip(source,x,y,z,411,0,"Minha Residência",0.4,false)
                    end
                end
            end

            --BRclient._addMarker(source,21,x,y,z-0.6,0.5,0.5,0.4,255,0,0,50,100)
            BR.setArea(source,"BR:home"..k,x,y,z,1,1,entry_enter,entry_leave)
        end
    end
end

AddEventHandler("BR:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_client_homes(source)
	else
		local tmp = BR.getUserTmpTable(user_id)
		if tmp and tmp.home_stype then
			leave_slot(user_id,source,tmp.home_stype,tmp.home_sid)
		end
	end
end)

AddEventHandler("BR:playerLeave",function(user_id,player)
	local tmp = BR.getUserTmpTable(user_id)
	if tmp and tmp.home_stype then
		leave_slot(user_id,player,tmp.home_stype,tmp.home_sid)
	end
end)