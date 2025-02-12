-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
local Tools = module("br_core","lib/Tools")
BR = Proxy.getInterface("BR")
BRclient = Tunnel.getInterface("BR")
local inventory = module("br_core","cfg/inventory")

cRP = {}
local idgens = Tools.newIDGenerator()
Tunnel.bindInterface("wnInventory_v2",cRP)
vCLIENT = Tunnel.getInterface("wnInventory_v2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local vthirst = 0
local vhunger = 0


vGARAGE = Tunnel.getInterface(tunnel_garagem)
vHOMES = Tunnel.getInterface(tunnel_homes)
vTASKBAR = Tunnel.getInterface(tunnel_taskbar)
vPLAYER = Tunnel.getInterface(tunnel_player)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------

local active = {}
local actived = {}
local bandagem = {}
local amountUse = {}
local uchests = {}
local vchests = {}
local syringeTime = {}

BR._prepare("homes/get_homepermissions","SELECT * FROM homes_permissions WHERE home = @home")
BR._prepare("homes/buy_permissions","INSERT INTO homes_permissions (owner, user_id, garage, home, tax) VALUES (1, @user_id, 1, @home, @tax)")
BR._prepare("homes/pay_iptu","UPDATE homes_permissions SET tax = @tax WHERE user_id = @user_id AND home = @home")
BR._prepare("identity/get_number","SELECT * FROM user_identities WHERE phone = @phone")
BR._prepare("identity/new_number","UPDATE user_identities SET phone = @phone WHERE user_id = @user_id")

-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
local registerBlips = {}
local registerTimers = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(registerTimers) do
			if v[4] > 0 then
				v[4] = v[4] - 1
				if v[4] <= 0 then
					table.remove(registerTimers,k)
					vCLIENT.updateRegister(-1,registerTimers)
				end
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
		Citizen.Wait(1000)
	end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- SYRINGETIME
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(syringeTime) do
			if v > 0 then
				syringeTime[k] = v - 1
			end
		end
		Citizen.Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(active) do
			if v > 0 then
				active[k] = v - 1
			end
		end
		Citizen.Wait(1000)
	end
end)

uchests = {}
inventariosAbertos = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Mochila()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local inventory = {}
		local inv = BR.getInventory(user_id)
		if inv then
			for k,v in pairs(inv) do
				if BR.itemBodyList(k) then
					table.insert(inventory, { 
						amount = parseInt(v.amount), 
						name = BR.itemNameList(k), 
						index = BR.itemIndexList(k),  
						key = k,type = BR.itemTypeList(k), 
						peso = BR.getItemWeight(k), 
						desc = BR.itemDescList(k),
						keybind = v.keybind or nil,
					})
				end
			end

			return inventory,BR.getInventoryWeight(user_id),BR.getInventoryMaxWeight(user_id)
		end
	end
end

function cRP.closeInvSync()
	local source = source
	local user_id = BR.getUserId(source)
	if uchests[user_id] then 
		inventariosAbertos[uchests[user_id].chest] = nil
		if uchests[user_id].type == "car" then 
			vGARAGE.vehicleClientTrunk(-1,uchests[(user_id)].netid,true)
		end
		uchests[user_id] = nil
	end
end

function cRP.setKeybind(idname, key)
    local source = source
    local user_id = BR.getUserId(source)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.inventory[idname] then
			if cRP.removeKeybind(idname, false, nil) then
				data.inventory[idname].keybind = key

				BR.setUserData(user_id, data)
				BR.setUData(user_id, "BR:datatable", json.encode(data))

				TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
			end
		end
	end
end

function cRP.removeKeybind(idname, up, slot)
    local source = source
    local user_id = BR.getUserId(source)
    
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.inventory[idname] then
			data.inventory[idname] = { amount = data.inventory[idname].amount, slot = slot or data.inventory[idname].slot }

			BR.setUserData(user_id, data)
            BR.setUData(user_id, "BR:datatable", json.encode(data))

			if up then
				TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
			end

			return true
		end
	end

	return true
end

function cRP.handleKeybind(key)
    local source = source
    local user_id = BR.getUserId(source)
    
	local inve = cRP.Mochila()

	if inve then
		for i, v in ipairs(inve) do
            if v.keybind == key then
                cRP.useItem(v.key, v.type, 1)
            end
        end
	end
end

function cRP.portaMalas()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned,trunk = BRclient.vehList(source,3.0)
		-- print(vehicle,vnetid,placa,vname,lock,banned,trunk,BR.getUserByRegistration(placa))
		if vehicle then	
			placa = placa:gsub("%s","")
			local vehicleName = BR.vehicleName(vname)
			local placa_user_id = BR.getUserByRegistration(placa)
			if placa_user_id then
				if lock == 1 then 
					local myvehicle = {}
					local mala = "chest:u"..parseInt(placa_user_id).."veh_"..vname
					if (not inventariosAbertos[mala] or inventariosAbertos[mala] == nil) or (uchests[user_id] and uchests[user_id].chest == mala) then 
						local data = BR.getSData(mala)
						local sdata = json.decode(data) or {}
						if sdata then
							for k,v in pairs(sdata) do
								if BR.itemBodyList(k) then
									table.insert(myvehicle,{ amount = parseInt(v.amount), name = BR.itemNameList(k), key = k,index = BR.itemIndexList(k), peso = BR.getItemWeight(k), desc = BR.itemDescList(k) })
								end
							end
						end
						vGARAGE.vehicleClientTrunk(-1,vnetid,false)
						inventariosAbertos[mala] = true

						uchests[(user_id)] = {chest = mala,type = "car",chestName = "CARRO "..vname,chest_max = parseInt(inventory.chestweight[vname]),netid = vnetid}
						return myvehicle,parseInt(BR.computeItemsWeight(sdata)),uchests[user_id].chest_max, uchests[(user_id)].chestName
					end
				end
			end
		end
		
		local success,chestName = vCLIENT.getNearChest(source)
		if success then 
			if BR.hasPermission(user_id,CHESTS[chestName].permissao) then 

				local chest = {}
				local mala = "chest:"..chestName
				if (not inventariosAbertos[mala] or inventariosAbertos[mala] == nil) or (uchests[user_id] and uchests[user_id].chest == mala) then 
					local data = BR.getSData(mala)
					local sdata = json.decode(data) or {}

					if sdata then
						for k,v in pairs(sdata) do
							if BR.itemBodyList(k) then
								table.insert(chest,{ amount = parseInt(v.amount), name = BR.itemNameList(k), key = k,index = BR.itemIndexList(k), peso = BR.getItemWeight(k), desc = BR.itemDescList(k) })
							end
						end
					end
					inventariosAbertos[mala] = true

					uchests[(user_id)] = {chest = mala,type = "chest",chestName = chestName,chest_max = CHESTS[chestName].weight}
					return chest,parseInt(BR.computeItemsWeight(sdata)),CHESTS[chestName].weight, uchests[(user_id)].chestName
				end
			end
		end

		local sucesso,homeName,homeWeight = vHOMES.getNearHome(source)

		if sucesso then 
			local chest = {}
				local mala = "chest:"..homeName
				if (not inventariosAbertos[mala] or inventariosAbertos[mala] == nil) or (uchests[user_id] and uchests[user_id].chest == mala) then 
					local data = BR.getSData(mala)
					local sdata = json.decode(data) or {}
					if sdata then
						for k,v in pairs(sdata) do
							if BR.itemBodyList(k) then
								table.insert(chest,{ amount = parseInt(v.amount), name = BR.itemNameList(k), key = k,index = BR.itemIndexList(k), peso = BR.getItemWeight(k), desc = BR.itemDescList(k) })
							end
						end
					end
					inventariosAbertos[mala] = true

						--print(mala,"chest",homeName,homeWeight)
					uchests[(user_id)] = {chest = mala,type = "homes",chestName = homeName,chest_max = homeWeight}
					--print(chest,parseInt(BR.computeItemsWeight(sdata)),homeWeight, uchests[(user_id)].homeName)
					return chest,parseInt(BR.computeItemsWeight(sdata)),homeWeight, uchests[(user_id)].chestName
				end
		end

	end
	return false
end

function cRP.Identidade()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local cash = BR.getMoney(user_id)
		local banco = BR.getBankMoney(user_id)
		local identity = BR.getUserIdentity(user_id)
		local multas = BR.getUData(user_id,"BR:multas")
		local mymultas = json.decode(multas) or 0
		local coins = BR.getUData(user_id,"BR:coins") 
		local paypal = BR.getUData(user_id,"BR:paypal")
		local mypaypal = json.decode(paypal) or 0
		if identity then
			return BR.format(parseInt(cash)),BR.format(parseInt(banco)),identity.name,identity.firstname,identity.user_id,identity.registration,identity.age,identity.phone,BR.format(parseInt(mymultas)),BR.format(parseInt(mypaypal)),BR.format(parseInt(coins)),identity.foto
		end
	end
end


function cRP.checkJobs()
	local source = source
	local user_id = BR.getUserId(source)

	local groupv = BR.getUserGroupByType(user_id,"org") or "Desempregado"
	
	local groupname = BR.getGroupTitle(groupv)

	local groupvip = BR.getUserGroupByType(user_id,TypeVip) or "FREE"
	local groupnamevip = BR.getGroupTitle(groupvip)
	if groupname then
		return groupname,groupnamevip
	end
end

delayBau = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for k,v in pairs(active) do
			if type(v) == "number" and v > 0 then
				active[k] = v - 1
			end
		end
		for k,v in pairs(delayBau) do 
			if v> 0 then 
				delayBau[k] = v - 1 
			end 
		end
	end
end)

function cRP.storeItem(itemName,amount,vehname,webhook_bau)
	
	local source = source
	if itemName then
		local user_id = BR.getUserId(source)
		local identity = BR.getUserIdentity(user_id)
		if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then

			if string.match(itemName,"dinheirosujo") then
				if uchests[user_id].type == "car" and ALLOW_DIRTYMONEY_INCAR == false then 
					TriggerClientEvent("Notify",source,"importante","Não pode guardar este item em veículos.",8000)
					return
				end
			end

			local data = BR.getSData(uchests[user_id].chest)
			local items = json.decode(data) or {}
			if items then
				local max_veh = uchests[user_id].chest_max or 50
				if parseInt(amount) > 0 then
					local new_weight = BR.computeItemsWeight(items)+BR.getItemWeight(itemName)*parseInt(amount)
					if new_weight <= parseInt(max_veh) then
						if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then
							delayBau[user_id] = 2
							if BR.tryGetInventoryItem(user_id,itemName,parseInt(amount)) then
								if items[itemName] ~= nil then
									items[itemName].amount = items[itemName].amount + parseInt(amount)
								else
									items[itemName] = { amount = parseInt(amount) }
								end

								PerformHttpRequest(webhook_bau, function(err, text, headers) end, 'POST', json.encode({
									embeds = {
										{     ------------------------------------------------------------
											title = "GUARDOU NO BAU		\n⠀",
											thumbnail = {
												url = imagem
											}, 
											fields = {
												{ 
													name = "``Player``",
													value = "Nome: "..identity.name.." "..identity.firstname.."\nID: "..user_id.."\n"
												},
												{ 
													name = "``Item``",
													value = ""..BR.format(parseInt(amount)).."x "..BR.itemNameList(itemName)..""
												},
												{ 
													name = "``Bau``",
													value = ""..uchests[user_id].chest..""
												}
											}, 
											footer = { 
												text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
												icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
											},
											color = 3066993
										}
									}
								}), { ['Content-Type'] = 'application/json' })

								
							end
						end
					else
						TriggerClientEvent("Notify",source,"negado","<b>Porta-Malas</b> cheio.",8000)
					end
				else
					local inv = BR.getInventory(user_id)
					for k,v in pairs(inv) do
						if itemName == k then
							local new_weight = BR.computeItemsWeight(items)+BR.getItemWeight(itemName)*parseInt(v.amount)
							if new_weight <= parseInt(max_veh) then
								if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then
									delayBau[user_id] = 2
									if BR.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
										if items[itemName] ~= nil then
											items[itemName].amount = items[itemName].amount + parseInt(v.amount)
										else
											items[itemName] = { amount = parseInt(v.amount) }
										end
										PerformHttpRequest(webhook_bau, function(err, text, headers) end, 'POST', json.encode({
											embeds = {
												{     ------------------------------------------------------------
													title = "GUARDOU NO BAU		\n⠀",
													thumbnail = {
														url = imagem
													}, 
													fields = {
														{ 
															name = "``Player``",
															value = "Nome: "..identity.name.." "..identity.firstname.."\nID: "..user_id.."\n"
														},
														{ 
															name = "``Item dsa``",
															value = ""..BR.format(parseInt(v.amount)).."x "..BR.itemNameList(itemName)..""
														},
														{ 
															name = "``Bau``",
															value = ""..uchests[user_id].chest..""
														}
													}, 
													footer = { 
														text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
														icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
													},
													color = 3066993
												}
											}
										}), { ['Content-Type'] = 'application/json' })
									
									end
								end

							else
								TriggerClientEvent("Notify",source,"negado","<b>Porta-Malas</b> cheio.",8000)
							end
						end
					end
				end
				BR.setSData(uchests[user_id].chest,json.encode(items))
				TriggerClientEvent('Creative:UpdateTrunk',source,'updateMochila2')
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.takeItem(itemName,amount,webhook_bau)
	
	local source = source
	if itemName then
		local user_id = BR.getUserId(source)
		local identity = BR.getUserIdentity(user_id)
		if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then
			local data = BR.getSData(uchests[user_id].chest)
			if uchests[user_id].type == "chest" and not BR.hasPermission(user_id, CHESTS[uchests[user_id].chestName].permissao) then 
				TriggerClientEvent("Notify", source, "negado","Você não tem permissão para retirar itens.")
				TriggerClientEvent('Creative:UpdateTrunk',source,'updateMochila2')
				return 
			end
			local items = json.decode(data) or {}
			if items then
				if parseInt(amount) > 0 then
					if items[itemName] ~= nil and items[itemName].amount >= parseInt(amount) then
						if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then
							delayBau[user_id] = 2
							if BR.getInventoryWeight(user_id)+BR.getItemWeight(itemName)*parseInt(amount) <= BR.getInventoryMaxWeight(user_id) then
							
								PerformHttpRequest(webhook_bau, function(err, text, headers) end, 'POST', json.encode({
									embeds = {
										{     ------------------------------------------------------------
											title = "PEGOU NO BAU		\n⠀",
											thumbnail = {
												url = imagem
											}, 
											fields = {
												{ 
													name = "``Player``",
													value = "Nome: "..identity.name.." "..identity.firstname.."\nID: "..user_id.."\n"
												},
												{ 
													name = "``Item``",
													value = ""..BR.format(parseInt(amount)).."x "..BR.itemNameList(itemName)..""
												},
												{ 
													name = "``Bau``",
													value = ""..uchests[user_id].chest..""
												}
											}, 
											footer = { 
												text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
												icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
											},
											color = 15158332
										}
									}
								}), { ['Content-Type'] = 'application/json' })
								BR.giveInventoryItem(user_id,itemName,parseInt(amount))
								items[itemName].amount = items[itemName].amount - parseInt(amount)
								if items[itemName].amount <= 0 then
									items[itemName] = nil
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
							end
						end
					end
				else
					if items[itemName] ~= nil and items[itemName].amount >= parseInt(amount) then
						if user_id and not delayBau[user_id] or delayBau[user_id] <= 0 then
							delayBau[user_id] = 2
							if BR.getInventoryWeight(user_id)+BR.getItemWeight(itemName)*parseInt(items[itemName].amount) <= BR.getInventoryMaxWeight(user_id) then
								BR.giveInventoryItem(user_id,itemName,parseInt(items[itemName].amount))
								PerformHttpRequest(webhook_bau, function(err, text, headers) end, 'POST', json.encode({
									embeds = {
										{     ------------------------------------------------------------
											title = "PEGOU NO BAU		\n⠀",
											thumbnail = {
												url = imagem
											}, 
											fields = {
												{ 
													name = "``Player``",
													value = "Nome: "..identity.name.." "..identity.firstname.."\nID: "..user_id.."\n"
												},
												{ 
													name = "``Item``",
													value = ""..BR.format(parseInt(items[itemName].amount)).."x "..BR.itemNameList(itemName)..""
												},
												{ 
													name = "``Bau``",
													value = ""..uchests[user_id].chest..""
												}
											}, 
											footer = { 
												text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
												icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
											},
											color = 15158332
										}
									}
								}), { ['Content-Type'] = 'application/json' })
								items[itemName] = nil
							else
								TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
							end
						end
					end
				end
				TriggerClientEvent('Creative:UpdateTrunk',source,'updateMochila2')
				BR.setSData(uchests[user_id].chest,json.encode(items))
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.sendItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = BR.getUserId(source)
		local nplayer = BRclient.getNearestPlayer(source,2)
		local nuser_id = BR.getUserId(nplayer)
		local identity = BR.getUserIdentity(user_id)
		local identityy = BR.getUserIdentity(nuser_id)
		if nuser_id and BR.itemIndexList(itemName) and itemName ~= "identidade" and itemName ~= "distintivo"  and parseInt(amount) <= BR.getInventoryItemAmount(user_id,itemName) then
			if parseInt(amount) > 0 then
				if user_id and active[user_id] == 0 or not active[user_id] then
					active[user_id] = 2
					if BR.getInventoryWeight(nuser_id) + BR.getItemWeight(itemName) * amount <= BR.getInventoryMaxWeight(nuser_id) then
						if BR.tryGetInventoryItem(user_id,itemName,amount) then
							BR.giveInventoryItem(nuser_id,itemName,amount)
							BRclient._playAnim(source,true,{"mp_common","givetake1_a"},false)
							TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..BR.format(parseInt(amount)).."x "..BR.itemNameList(itemName).."</b>.",8000)
							TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..BR.format(parseInt(amount)).."x "..BR.itemNameList(itemName).."</b>.",8000)
			
							TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
							TriggerClientEvent("br_core_inventory:Update",nplayer,"updateMochila")

							PerformHttpRequest(log_enviar_item, function(err, text, headers) end, 'POST', json.encode({
								embeds = {
									{ 
										title = "REGISTRO DE ENVIO",
										thumbnail = {
											url = imagem
										}, 
										fields = {
											{ 
												name = "**QUEM ENVIOU:**", 
												value = " "..identity.name.." "..identity.firstname.." ["..user_id.."] "
											},
											{ 
												name = "**ENVIOU:**", 
												value = " "..amount.."x "..BR.itemNameList(itemName).." "
											},
											{ 
												name = "**RECEBEU:**", 
												value = " "..identityy.name.." "..identityy.firstname.." ["..nuser_id.."] "
											}
										}, 
										footer = { 
											text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
											icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
										},
										color = 15914080 
									}
								}
							}), { ['Content-Type'] = 'application/json' })
							return true
						end
					end
				end

			else
				local inv = BR.getInventory(user_id)
				for k,v in pairs(inv) do
					if itemName == k then
						if user_id and active[user_id] == 0 or not active[user_id] then
							active[user_id] = 2
							if BR.getInventoryWeight(nuser_id) + BR.getItemWeight(itemName) * parseInt(v.amount) <= BR.getInventoryMaxWeight(nuser_id) then
								if BR.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
									BR.giveInventoryItem(nuser_id,itemName,parseInt(v.amount))
									BRclient._playAnim(source,true,{"mp_common","givetake1_a"},false)
									TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..BR.format(parseInt(v.amount)).."x "..BR.itemNameList(itemName).."</b>.",8000)
									TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..BR.format(parseInt(v.amount)).."x "..BR.itemNameList(itemName).."</b>.",8000)
									SendWebhookMessage(logenviaritem,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..amount.."x "..itemName.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
									TriggerClientEvent("br_core_inventory:Update",nplayer,"updateMochila")
									return true
								end
							end
						end
					end
				end
			end
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.dropItem(itemName,amount)
	local source = source
	if itemName ~= "identidade" and itemName ~= "distintivo" then
		local user_id = BR.getUserId(source)
		local x,y,z = BRclient.getPosition(source)
		local identity = BR.getUserIdentity(user_id)
		if parseInt(amount) > 0 and BR.tryGetInventoryItem(user_id,itemName,amount) then
			TriggerEvent("DropSystem:create",itemName,amount,x,y,z,3600)
			BRclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
			TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
			return true
		else
			local inv = BR.getInventory(user_id)
			for k,v in pairs(inv) do
				if itemName == k then
					if BR.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
						TriggerEvent("DropSystem:create",itemName,parseInt(v.amount),x,y,z,3600)
				
						BRclient._playAnim(source,true,{"pickup_object","pickup_low"},false)
						
						TriggerClientEvent("br_core_inventory:Update",source,"updateMochila")
						PerformHttpRequest(log_drop_item, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 
									title = "REGISTRO DE DROP",
									thumbnail = {
										url = imagem
									}, 
									fields = {
										{ 
											name = "**QUEM EQUIPOU:**", 
											value = " "..identity.name.." "..identity.firstname.." ["..user_id.."] "
										},
										{ 
											name = "**DROPOU:**", 
											value = " "..v.amount.."x "..BR.itemNameList(itemName).." "
										}
									}, 
									footer = { 
										text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
										icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
									},
									color = 15914080 
								}
							}
						}), { ['Content-Type'] = 'application/json' })
						return true
					end
				end
			end
		end
	end
	return false
end

local pick = {}
local blips = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.useItem(itemName,type,ramount)
	local source = source
	local user_id = BR.getUserId(source)
	local source = source
	local data = BR.getUserAptitudes(user_id)
	UseItemInventory(itemName,type,ramount,user_id,vGARAGE,vHOMES,vTASKBAR,vPLAYER,cRP)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("BR:playerLeave",function(user_id,source)
	local source = source
	active[user_id] = nil
	bandagem[user_id] = nil
	amountUse[user_id] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- vrp_inventory:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("br_core_inventory:Cancel")
AddEventHandler("br_core_inventory:Cancel",function()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		if active[user_id] == nil then
			active[user_id] = 0
		end

		if active[user_id] > 0 then
			active[user_id] = -1
			TriggerClientEvent("progress",source,1500)

			SetTimeout(1000,function()
				BRclient._removeObjects(source)
				vCLIENT.blockButtons(source,false)
				vGARAGE.updateHotwired(source,false)
			end)
		else
			BRclient._removeObjects(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkRadio()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		if BR.getInventoryItemAmount(user_id,"radio") < 1 then
			return true
		end
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkInventory()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		if active[user_id] == nil then
			active[user_id] = 0
		end

		if active[user_id] > 0 then
			return false
		end
		return true
	end
end

cRP.CheckPerm_bau = function(permissa)
	local source = source
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,permissa) then
		return true
	else
		return false
	end
end

function cRP.chestOpen()
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local vehicle,vnetid,placa,vname,lock,banned,trunk = BRclient.vehList(source,7)
		if vehicle then
			if lock == 1 then
				if banned then
					return
				end
				local placa_user_id = BR.getUserByRegistration(placa)
				if placa_user_id then
					vCLIENT.vehicleClientTrunk(-1,vnetid,false)
					TriggerClientEvent("trunkchest:Open",source)
				end
			end
		end
	end
end


-- Data Bases -- 
BR._prepare("warn/insert", "INSERT INTO inventario(user_id, bolsos, bolsosocupados, img, banner) VALUES(@user_id, @bolsos, @bolsosocupados, @img, @banner)")
BR._prepare("warn/pegarinfos", "SELECT * FROM inventario WHERE user_id = @user_id")

BR._prepare("warn/colocarbolsos", "UPDATE inventario SET bolsos = bolsos + @bolsos WHERE user_id = @user_id")
BR._prepare("warn/updateperfil", "UPDATE inventario SET img = @img WHERE user_id = @user_id")
BR._prepare("warn/updateperfil2", "UPDATE inventario SET banner = @banner WHERE user_id = @user_id")

BR._prepare("warn/inventario", [[
    CREATE TABLE IF NOT EXISTS inventario(
        user_id INTEGER,
        bolsos INTEGER,
        bolsosocupados INTEGER,
        img TEXT,
		banner TEXT,
        PRIMARY KEY (`user_id`) USING BTREE
    )
]])


async(function()
    BR.execute("warn/inventario")
end)

AddEventHandler("BR:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = BR.getUserId(source)
    if user_id then
		
        	local infos = BR.query("warn/pegarinfos", {
            	user_id = parseInt(user_id)
        	})

        	if infos[1] == nil then

            BR.query("warn/insert", {
                user_id = parseInt(user_id),
                bolsos = bolsos_inicio,
				bolsosocupados = 0,
                img = imginicial,
				banner = bannerinicial,
            })

        end
    end
end)

-- Sistema de Bolsos --


cRP.BolsosDisponivel = function()
	local source = source
    local user_id = BR.getUserId(source)

	local infos = BR.query("warn/pegarinfos", {
		user_id = parseInt(user_id)
	})

    return infos[1].bolsos
end

cRP.comprarSlot = function()
	local source = source
    local user_id = BR.getUserId(source)

	local infos = BR.query("warn/pegarinfos", {
		user_id = parseInt(user_id)
	})

	if infos[1].bolsos >= bolsos_maximos then
		TriggerClientEvent("Notify",source,"negado","Voce ja tem os bolsos maximos")
	else
		if BR.tryFullPayment(user_id,valor_bolso) then

			BR.query("warn/colocarbolsos", {
				user_id = user_id,
				bolsos = bolsos_order,
			})
		
			TriggerClientEvent("Notify",source,"sucesso","Voce comprou 1x Bolso")
		
		end
	end
end


-- Sistema de Imagens --

cRP.RetornarImagens = function()
	local source = source
    local user_id = BR.getUserId(source)

	local infos = BR.query("warn/pegarinfos", {
		user_id = parseInt(user_id)
	})

    return infos[1].img,infos[1].banner 
end

cRP.updateperfil = function(imglink,bannerlink)
    local source = source
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	BR.query("warn/updateperfil", {
		user_id = parseInt(user_id),
		img = imglink,
	})
	TriggerClientEvent("Notify",source,"sucesso","Voce setou colocou as novas imagens na Identidade")
	return true
end



cRP.updatebanner = function(imglink,bannerlink)
    local source = source
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	BR.query("warn/updateperfil2", {
		user_id = parseInt(user_id),
		banner = imglink,
	})
	TriggerClientEvent("Notify",source,"sucesso","Voce setou colocou as novas imagens na Identidade")
	return true
end

RegisterCommand(comandoSetBolsos,function(source,args)
	local source = source
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id, permissaoSetBolsos) then
		if args[1] then
			local identity2 = BR.getUserIdentity(parseInt(args[1]))
			if args[2] then
				BR.query("warn/colocarbolsos", {
					user_id = parseInt(args[1]),
					bolsos = parseInt(args[2]),
				})

				TriggerClientEvent("Notify",source,"sucesso","Voce colocou "..parseInt(args[2]).."x bolsos no passaporte "..parseInt(args[1]).." ")

				PerformHttpRequest(webhook_SetBolsos, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{     ------------------------------------------------------------
							title = "Log Setbolsos",
							thumbnail = {
								url = imagem
							}, 
							fields = {
								{ 
									name = "Staff que setou\n",
									value = " "..identity.name.." "..identity.firstname.." ["..user_id.."]"
								},
								{ 
									name = "Player que Recebeu\n",
									value = " "..identity2.name.." "..identity2.firstname.." ["..args[1].."]"
								},
								{ 
									name = "Quantidade\n",
									value = " "..args[2].." "
								}
							}, 
							footer = { 
								text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
								icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
							},
							color = 15105570
						}
					}
				}), { ['Content-Type'] = 'application/json' })

			else
				TriggerClientEvent("Notify",source,"negado","Voce nao colocou a quantidade de bolsos")
			end
		else
			TriggerClientEvent("Notify",source,"negado","Voce nao colocou o passaporte")
		end
	else
		TriggerClientEvent("Notify",source,"negado","Voce nao tem Permissao")
	end
end)

cRP.AddBolso = function()

	local source = source
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)

	BR.query("warn/colocarbolsos", {
		user_id = parseInt(user_id),
		bolsos = parseInt(3),
	})


end


cRP.SetBolsos = function()
	local source = source
    local user_id = BR.getUserId(source)

	local infos = BR.query("warn/pegarinfos", {
		user_id = parseInt(user_id)
	})

	if infos[1].bolsos >= bolsos_maximos then
		TriggerClientEvent("Notify",source,"negado","Voce ja tem os bolsos maximos")
	else
		if BR.tryFullPayment(user_id,valor_bolso) then

			BR.query("warn/colocarbolsos", {
				user_id = user_id,
				bolsos = bolsos_order,
			})
		
			TriggerClientEvent("Notify",source,"sucesso","Voce comprou 1x Bolso")
		
		end
	end
end