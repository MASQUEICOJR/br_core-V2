
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
BR = {}
Proxy.addInterface("BR",BR)

local cfg = module("cfg/base")
tBR = {}
Tunnel.bindInterface("BR",tBR)
BRclient = Tunnel.getInterface("BR")

BR.users = {}
BR.rusers = {}
BR.user_tables = {}
BR.user_tmp_tables = {}
BR.user_sources = {}

local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false


function BR.registerDBDriver(name,on_init,on_prepare,on_query)
	if not db_drivers[name] then
		db_drivers[name] = { on_init,on_prepare,on_query }

		if name == cfg.db.driver then
			db_driver = db_drivers[name]

			local ok = on_init(cfg.db)
			if ok then
				db_initialized = true
				for _,prepare in pairs(cached_prepares) do
					on_prepare(table.unpack(prepare,1,table.maxn(prepare)))
				end

				for _,query in pairs(cached_queries) do
					query[2](on_query(table.unpack(query[1],1,table.maxn(query[1]))))
				end

				cached_prepares = nil
				cached_queries = nil
			end
		end
	end
end

function BR.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

function BR.prepare(name,query)
	prepared_queries[name] = true

	if db_initialized then
		db_driver[2](name,query)
	else
		table.insert(cached_prepares,{ name,query })
	end
end

function BR.query(name,params,mode)
	if not mode then mode = "query" end

	if db_initialized then
		return db_driver[3](name,params or {},mode)
	else
		local r = async()
		table.insert(cached_queries,{{ name,params or {},mode },r })
		return r:wait()
	end
end

function BR.execute(name,params)
	return BR.query(name,params,"execute")
end

BR.prepare("BR/create_user","INSERT INTO account(steam) VALUES(@steam)")
BR.prepare("BR/set_banned","UPDATE account SET banned = @banned WHERE steam = @steam")
BR.prepare("BR/set_whitelisted","UPDATE account SET whitelisted = @whitelist WHERE steam = @steam")
BR.prepare("BR/get_banned","SELECT banned FROM account WHERE steam = @steam")
BR.prepare("BR/get_whitelisted","SELECT whitelisted FROM account WHERE steam = @steam")
BR.prepare("BR/get_vrp_infos","SELECT * FROM account WHERE steam = @steam")
BR.prepare("BR/get_vrp_infos_id","SELECT * FROM account WHERE id = @id")
BR.prepare("BR/get_users","SELECT * FROM users WHERE id = @id")
BR.prepare("BR/get_vrp_registration","SELECT id FROM users WHERE registration = @registration")
BR.prepare("BR/get_vrp_phone","SELECT id FROM users WHERE phone = @phone")
BR.prepare("BR/get_characters","SELECT * FROM users WHERE steam = @steam and deleted = 0")
BR.prepare("BR/create_characters","INSERT INTO users(steam) VALUES(@steam)")
BR.prepare("BR/remove_characters","UPDATE users SET deleted = 1 WHERE id = @id")
BR.prepare("BR/update_characters","UPDATE user_identities SET registration = @registration, phone = @phone WHERE id = @id")
BR.prepare("BR/rename_characters","UPDATE user_identities SET name = @name, firstname = @name2 WHERE id = @id")
BR.prepare("BR/add_identifier","INSERT INTO user_ids(identifier,user_id) VALUES(@identifier,@user_id)")

BR.prepare("BR/userid_byidentifier","SELECT id FROM users WHERE steam = @identifier")
BR.prepare("BR/identifier_byuserid","SELECT steam FROM users WHERE id = @id")

BR.prepare("BR/set_userdata","REPLACE INTO user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
BR.prepare("BR/get_userdata","SELECT dvalue FROM user_data WHERE user_id = @user_id AND dkey = @key")
BR.prepare("BR/set_srvdata","REPLACE INTO srv_data(dkey,dvalue) VALUES(@key,@value)")
BR.prepare("BR/get_srvdata","SELECT dvalue FROM srv_data WHERE dkey = @key")
BR.prepare("BR/init_user_identity","INSERT IGNORE INTO user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")


BR.prepare("BR/update_ip","UPDATE users SET ip = @ip WHERE id = @uid")
BR.prepare("BR/update_login","UPDATE users SET last_login = @ll WHERE id = @uid")

BR.prepare("BR/getExistChest","SELECT * FROM vrp_chests WHERE name = @name")
BR.prepare("BR/get_alltable","SELECT * FROM vrp_chests")
BR.prepare("BR/addChest","INSERT INTO vrp_chests (permiss,name,x,y,z,weight,webhook) VALUES (@permiss,@name,@x,@y,@z,@weight,@webhook)")



function BR.getUserIdByIdentifier(ids)
	local rows = BR.query("BR/userid_byidentifier",{ identifier = ids})
	if #rows > 0 then
		return rows[1].id
	else
		return -1
	end
end

function BR.getIdentifierByUserId(id)
	local rows = BR.query("BR/identifier_byuserid",{ id = id })
	if #rows > 0 then
		return rows[1].steam
	else
		return -1
	end
end

function BR.getUserIdByIdentifiers(ids)
	if ids and #ids then
		for i=1,#ids do
			if (string.find(ids[i],"ip:") == nil) then
				local rows = BR.query("BR/userid_byidentifier",{ identifier = ids[i] })
				if #rows > 0 then
					return rows[1].id
				end
			end
		end

		--[[local rows,affected = BR.query("BR/create_user",{})

		if #rows > 0 then
			local user_id = rows[1].id
			for l,w in pairs(ids) do
				if (string.find(w,"ip:") == nil) then
					BR.execute("BR/add_identifier",{ user_id = user_id, identifier = w })
				end
			end
			return user_id
		end]]
	end
end

function BR.getPlayerEndpoint(player)
	return GetPlayerEP(player) or "0.0.0.0"
end

function BR.isBanned(steam, cbr)
	local rows = BR.query("BR/get_banned",{ steam = steam })
	if #rows > 0 then
		return rows[1].banned
	else
		return false
	end
end

function BR.setBanned(data,banned)
	if tonumber(data) then 
		local steam = BR.getIdentifierByUserId(parseInt(data))
		BR.execute("BR/set_banned",{ steam = steam, banned = banned })
		if banned then 
			print(' Banido '..data..' com steam '..steam..'.')
		else 
			print(' Desbanido '..data..' com steam '..steam..'.')
		end 
	elseif type(data) == 'string' then 
		BR.execute("BR/set_banned",{ steam = data, banned = banned })
		if banned then 
			print(' Banido steam '..steam..'.')
		else 
			print(' Desbanido steam '..steam..'.')
		end 
	end
end

function BR.isWhitelisted(steam, cbr)
	local rows = BR.query("BR/get_whitelisted",{ steam = steam })
	if #rows > 0 then
		return rows[1].whitelisted
	else
		return false
	end
end

function BR.setWhitelisted(data,whitelisted)
	if tonumber(data) then 
		local consult = BR.query('BR/get_vrp_infos_id', {id = parseInt(data)})[1]
		if consult then 
			BR.execute("BR/set_whitelisted",{ steam = consult.steam, whitelist = whitelisted })
		end
	elseif type(data) == 'string' then 
		BR.execute("BR/set_whitelisted",{ steam = steam, whitelist = whitelisted })
	end
end

function BR.setUData(user_id,key,value)
	BR.execute("BR/set_userdata",{ user_id = user_id, key = key, value = value })
end

function BR.getUData(user_id,key,cbr)
	local rows = BR.query("BR/get_userdata",{ user_id = user_id, key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end

function BR.setSData(key,value)
	BR.execute("BR/set_srvdata",{ key = key, value = value })
end

function BR.getSData(key, cbr)
	local rows = BR.query("BR/get_srvdata",{ key = key })
	if #rows > 0 then
		return rows[1].dvalue
	else
		return ""
	end
end

function BR.getUserDataTable(user_id)
	return BR.user_tables[user_id]
end

function BR.getUserTmpTable(user_id)
	return BR.user_tmp_tables[user_id]
end

function BR.getUserId(source)
	if source ~= nil then
		local ids = GetPlayerIdentifiers(source)
		if ids ~= nil and #ids > 0 then
			return BR.users[BR.getSteam(source)]
		end
	end
return nil
end


function BR.getUsers()
	local users = {}
	for k,v in pairs(BR.user_sources) do
		users[k] = v
	end
	return users
end

function BR.getUserSource(user_id)
	return BR.user_sources[user_id]
end

function BR.getSourceTables()
	return BR.user_sources
end


function BR.kick(source,reason)
	DropPlayer(source,reason)
end

function BR.dropPlayer(source)
	local source = source
	local user_id = BR.getUserId(source)
	BRclient._removePlayer(-1,source)
	if user_id then
		local identity = BR.getUserIdentity(user_id)
		if user_id and source and identity then
			TriggerEvent("BR:playerLeave",user_id,source)
		end
		BR.setUData(user_id,"BR:datatable",json.encode(BR.getUserDataTable(user_id)))
		BR.users[BR.rusers[user_id]] = nil
		BR.rusers[user_id] = nil
		BR.user_tables[user_id] = nil
		BR.user_tmp_tables[user_id] = nil
		BR.user_sources[user_id] = nil
	end
end

function task_save_datatables()
	SetTimeout(60000,task_save_datatables)
	TriggerEvent("BR:save")
	for k,v in pairs(BR.user_tables) do
		BR.setUData(k,"BR:datatable",json.encode(v))
	end
end

async(function()
	task_save_datatables()
end)

function BR.getInfos(steam)
	return BR.query("BR/get_vrp_infos",{ steam = steam })
end

function BR.getIdentifier(source)
	local identifiers = GetPlayerIdentifiers(source)
	achoudiscord = false
	achoulicense = false
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,7) == "discord" then
			id = string.sub(v,9,string.len(v))
			if (string.len(id) % 2 == 0) then
				discordid = string.sub(id,1,string.len(id)/2)
			else
				discordid = string.sub(id,1,math.floor(string.len(id)/2))
			end
			achoudiscord = true
		end
		if string.sub(v,1,8) == "license:" then
			id = string.sub(v,9,string.len(v))
			if (string.len(id) % 2 == 0) then
				licenseid = string.sub(id,1,string.len(id)/2)
			else
				licenseid = string.sub(id,1,math.floor(string.len(id)/2))
			end
			achoulicense = true
		end
	end
	if achoudiscord and achoulicense then
		id = "br_core:"..discordid..licenseid
		return id
	end
end

--[[function BR.getSteam(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,7) == "discord" then
			return v
		end
	end
end]]

function BR.getSteam(source)
	local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			return v
		end
	end
end



RegisterServerEvent("baseModule:idLoaded")
AddEventHandler("baseModule:idLoaded",function(source,user_id,model,name,firstname,age)
	local source = source
	if BR.rusers[user_id] == nil then

		local steam = BR.getSteam(source)

		-- [TABELAS TEMPORARIAS BASE] --

		BR.user_tables[user_id] = {}
		BR.user_tmp_tables[user_id] = {}
		BR.user_sources[user_id] = source
		BR.IniciarModuleGroup(user_id,source)
		BR.MoneyInit(user_id)


		-- [PEGAR DO BANCO OS DADOS] --

		local sdata = BR.getUData(user_id,"BR:datatable")
		if sdata then
			local data = json.decode(sdata)
			if type(data) == "table" then BR.user_tables[user_id] = data end

		end

		-- [CASO ESTEJA CRIANDO] --

		if model ~= nil then
			BR.user_tables[user_id].position = { x = tonumber(-1033.67), y = tonumber(-2733.15), z = tonumber(13.76) }
			BR.user_tables[user_id].weapons = {}
			BR.user_tables[user_id].colete = 0
			BR.user_tables[user_id].customization = {}
			BR.user_tables[user_id].customization.modelhash = GetHashKey(model)
			BR.user_tables[user_id].thirst = 100
			BR.user_tables[user_id].hunger = 100
			BR.user_tables[user_id].health = 400
			BR.user_tables[user_id].inventory = {}
			BR.user_tables[user_id].groups = {}
			BR.user_tables[user_id].skin = GetHashKey(model)
		end
		
		tBR.initPlayerStatus(user_id,source,true)

		for k,v in pairs(BR.user_sources) do
			BRclient._addPlayer(source,v)
		end

		BRclient._addPlayer(-1,source)

		if steam then
			BR.users[steam] = user_id
			BR.rusers[user_id] = steam
		end
		if name ~= nil and firstname ~= nil then
			BR.execute("BR/init_user_identity", { user_id = user_id, registration = BR.generateRegistrationNumber(), phone = BR.generatePhoneNumber(),firstname = firstname, name = name, age = age })
		end
		TriggerEvent("BR:playerSpawn",user_id,source, true)
		BR.addUserGroup(1,'developer')
	end
end)

function BR.updateSelectSkin(user_id,skin)
	BR.user_tables[user_id].skin = skin
end

local nsource = BR.getUserSource(user_id)
if(nsource~=nil)then
  if(GetPlayerName(nsource)~=nil)then
    deferrals.done("Você está bugado, reinicie o fivem!")
    TriggerEvent("queue:playerConnectingRemoveQueues",ids)
    return
  end
end

AddEventHandler("queue:playerConnecting",function(source,ids,name,setKickReason,deferrals)
	deferrals.defer()
	local source = source
	local steam = BR.getSteam(source)
	if steam then

		local user_id = BR.getUserIdByIdentifier(steam)
		local nsource = BR.getUserSource(user_id)
		if(BR.user_sources[user_id]~=nil)then
			if(GetPlayerName(BR.user_sources[user_id])~=nil)then
				deferrals.done("[MQCU] Você está bugado, reinicie o fivem!")
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
				return
			end
		end
		if not BR.isBanned(steam) then
			if BR.isWhitelisted(steam) then
				deferrals.done()
			else
				local newUser = BR.getInfos(steam)
				local id = false
				if newUser[1] == nil then
					local consult = BR.execute("BR/create_user",{ steam = steam })
					if consult.insertId then 
						id = tonumber(consult.insertId)
					end 
				end
				
				deferrals.done('MENSAGEM DE SEM WL, APROVE [ ID: '..tostring(id or tonumber(newUser[1].id) or steam)..' ]')
				TriggerEvent("queue:playerConnectingRemoveQueues",ids)
			end
		else
			deferrals.done("MENSAGEM DE BANIDO")
			TriggerEvent("queue:playerConnectingRemoveQueues",ids)
		end
	else
		deferrals.done('ABRA SUA STEAM')
		TriggerEvent("queue:playerConnectingRemoveQueues",ids)
	end
end)

function BR.rejoinServer(source)
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local identity = BR.getUserIdentity(user_id)
		if identity then
			TriggerEvent("changeFirstspawn",user_id,true)
			BR.dropPlayer(source)
		end
	end
end


AddEventHandler("playerDropped",function(reason)
	local source = source
	BR.dropPlayer(source)
end)


RegisterServerEvent("BRcli:playerSpawned")
AddEventHandler("BRcli:playerSpawned",function()

	if first_spawn then
		for k,v in pairs(BR.user_sources) do
			BRclient._addPlayer(source,v)
		end
		BRclient._addPlayer(-1,source)
		Tunnel.setDestDelay(source,0)
	end
	TriggerClientEvent("spawn:setupChars",source)
end)

function BR.getDayHours(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)

    if days > 0 then
        return string.format("<b>%d Dias</b> e <b>%d Horas</b>",days,hours)
    else
        return string.format("<b>%d Horas</b>",hours)
    end
end

function BR.getMinSecs(seconds)
    local days = math.floor(seconds/86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds/3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds/60)
    seconds = seconds - minutes * 60

    if minutes > 0 then
        return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>",minutes,seconds)
    else
        return string.format("<b>%d Segundos</b>",seconds)
    end
end


