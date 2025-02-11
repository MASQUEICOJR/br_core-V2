local cfg = module("cfg/inventory")
local Proxy  = module("br_core", "lib/Proxy")
local garage = Proxy.getInterface("br_core")
local itemlist = {
	-- só tem dois itens criados, o resto é arma
	["mochila"] = { index = "mochila", nome = "Mochila", type = "usar", tipo = "utilitarios", desc = "Mochila serve para voce poder carregar mais itens na sua mochila" },
	["dinheiro"] = { index = "dinheiro", nome = "dinheiro", type = "usar", tipo = "utilitarios", desc = "Dinheiro em notas vivas" },

	["wbody|WEAPON_SNSPISTOL"] = { index = "fajuta", nome = "HK P7M10", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" }, 
	["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "Five Seven", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|WEAPON_SPECIALCARBINE"] = { index = "g3", nome = "G36", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },  
	["wbody|WEAPON_ASSAULTSMG"] = { index = "mtar", nome = "Mtar", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" }, 
	["wbody|WEAPON_MICROSMG"] = { index = "uzi", nome = "Uzi", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },  
	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak47", nome = "AK-47", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" }, 
	["wbody|WEAPON_MILITARYRIFLE"] = { index = "mili", nome = "Rifle VEPR", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" }, 
	["wammo|WEAPON_SNSPISTOL"] = { index = "m-fajuta", nome = "M - HK P7M10", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a HK P7M10"},
	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-five", nome = "M - Five Seven", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a Five Seven"},
	["wammo|WEAPON_SPECIALCARBINE"] = { index = "m-g3", nome = "M - G3", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a G3"},
	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-mtar", nome = "M - MTAR", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a MTAR"},
	["wammo|WEAPON_MICROSMG"] = { index = "m-uzi", nome = "M - UZI", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a UZI"},
	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak", nome = "M - AK47", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a AK47"},
	["wammo|WEAPON_MILITARYRIFLE"] = { index = "m-mili", nome = "M - VEPR", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar a VEPR"},
	["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|WEAPON_COMBATPDW"] = { index = "sig", nome = "Sig Sauer", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "m4a1", nome = "M4A1", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" }, 
	["wbody|WEAPON_NIGHTSTICK"] = { index = "nightstick", nome = "Cassetete", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar", tipo = "arma", desc = "Apenas uma Arma" },
	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas", type = "equipar", tipo = "arma", tipo = "arma", desc = "E usado para pular de locais altos" },
	["wbody|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Galão de Gasolina", type = "equipar", tipo = "arma", tipo = "arma", desc = "Pode ser usado para abastecer carros" },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar", tipo = "arma", tipo = "arma", desc = "Este item e usado para apagar incendios" },
	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Grifo", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado", type = "equipar", tipo = "arma", desc = "Apenas uma Arma Branca" },
	["wammo|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Combustível", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar o Galao"},
	["wammo|WEAPON_FIREEXTINGUISHER"] = { index = "espuma", nome = "espuma", type = "recarregar", tipo = "muni", desc = "Usado para Recarregar o Extintor"},

}

function BR.EnviarItens()
	return itemlist
end

function BR.itemNameList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].nome
	end
end

function BR.itemIndexList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].index
	end
end

function BR.itemTypeList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].type
	end
end

function BR.itemTipoList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].tipo
	end
end

function BR.itemDescList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].desc
	end
end

function BR.itemBodyList(item)
	if itemlist[item] ~= nil then
		return itemlist[item]
	end
end

BR.items = {}
function BR.defInventoryItem(idname,name,weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	BR.items[idname] = item
end

function BR.computeItemName(item,args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function BR.computeItemWeight(item,args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function BR.parseItem(idname)
	return splitString(idname,"|")
end

function BR.getItemDefinition(idname)
	local args = BR.parseItem(idname)
	local item = BR.items[args[1]]
	if item then
		return BR.computeItemName(item,args),BR.computeItemWeight(item,args)
	end
	return nil,nil
end

function BR.getItemWeight(idname)
	local args = BR.parseItem(idname)
	local item = BR.items[args[1]]
	if item then
		return BR.computeItemWeight(item,args)
	end
	return 0
end

function BR.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = BR.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

BR.prepare("warn/pegarinfos", "SELECT * FROM wnInventory WHERE user_id = @user_id")
BR.prepare("warn/updatebolsos", "UPDATE wnInventory SET bolsosocupados = @bolsosocupados WHERE user_id = @user_id")



function BR.giveInventoryItem(user_id,idname,amount)
    local source = BR.getUserSource(parseInt(user_id))
    local amount = parseInt(amount)
    local data = BR.getUserDataTable(user_id)
    if data and amount > 0 then
        local entry = data.inventory[idname]
        if entry then
            entry.amount = entry.amount + amount
        else
            data.inventory[idname] = { amount = amount }
        end
    end 
    TriggerClientEvent("itensNotify",source,"sucesso",""..amount.."x "..idname.."",""..BR.itemIndexList(idname).."") 
end

--e essa 

function BR.tryGetInventoryItem(user_id,idname,amount)
    local source = BR.getUserSource(parseInt(user_id))
    local amount = parseInt(amount)
    local data = BR.getUserDataTable(user_id)
    if data and amount > 0 then
        TriggerClientEvent("itensNotify",source,"negado",""..amount.."x "..idname.."",""..BR.itemIndexList(idname).."") 
        local entry = data.inventory[idname]
        if entry and entry.amount >= amount then
            entry.amount = entry.amount - amount

            if entry.amount <= 0 then
                data.inventory[idname] = nil
            end
            return true
        end
    end
    return false
end



function BR.RetirarBolso(user_id,idname,amount)
    local source = BR.getUserSource(parseInt(user_id))
    local amount = parseInt(amount)
    local data = BR.getUserDataTable(user_id)
    if data and amount > 0 then
        TriggerClientEvent("itensNotify",source,"negado",""..amount.."x "..idname.."",""..BR.itemIndexList(idname).."") 
        local entry = data.inventory[idname]
        if entry and entry.amount >= amount then
            entry.amount = entry.amount - amount

            if entry.amount <= 0 then
                data.inventory[idname] = nil
            end
            return true
        end
    end
    return false
end

function BR.getInventoryItemAmount(user_id,idname)
	local data = BR.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function BR.getInventory(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function BR.getInventoryWeight(user_id)
	local data = BR.getUserDataTable(user_id)
	if data and data.inventory then
		return BR.computeItemsWeight(data.inventory)
	end
	return 0
end

function BR.getInventoryMaxWeight(user_id)
	return math.floor(BR.expToLevel(BR.getExp(user_id,"physical","strength")))*3
end

function BR.clearInventory(user_id)
    local data = BR.getUserDataTable(user_id)
    if data then
        data.inventory = {}
    end
end

RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory",function()
    local source = source
    local user_id = BR.getUserId(source)
    if user_id then
        local data = BR.getUserDataTable(user_id)
        if data then
            data.inventory = {}
        end

        BR.setMoney(user_id,0)
        BRclient._clearWeapons(source)
        BRclient._setHandcuffed(source,false)

        if not BR.hasPermission(user_id,"mochila.permissao") then
            BR.setExp(user_id,"physical","strength",20)
        end
    end
end)

AddEventHandler("BR:playerJoin", function(user_id,source,name)
	local data = BR.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)

function BR.vehicleGlobal()
	return garage.getVehList()
end

function BR.vehicleName(vname)
	return garage.getVehicleModel(vname)
end

function BR.vehicleChest(vname)
	return garage.getVehicleTrunk(vname)
end

function BR.vehiclePrice(vname)
	return garage.getVehiclePrice(vname)
end

function BR.vehicleType(vname)
	return garage.getVehicleType(vname)
end

