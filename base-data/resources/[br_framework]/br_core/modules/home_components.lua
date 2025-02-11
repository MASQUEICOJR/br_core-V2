local sanitizes = module("cfg/sanitizes")

local function chest_create(owner_id,stype,sid,cid,config,data,x,y,z,player)
	local chest_enter = function(player,area)
	local user_id = BR.getUserId(player)
	if user_id and (user_id == owner_id or BR.hasPermission(user_id,"policia.permissao")) then
		BR.openChest2(player,"u"..owner_id.."-"..config.name.."home",config.weight,nil,nil,nil)
	end
end

local chest_leave = function(player,area)
	BR.closeMenu(player)
end

local nid = "BR:home:slot"..stype..sid..":chest"
	BR.setArea(player,nid,x,y,z,1,1,chest_enter,chest_leave)
end

local function chest_destroy(owner_id,stype,sid,cid,config,x,y,z,player)
	local nid = "BR:home:slot"..stype..sid..":chest"
	BRclient._removeNamedMarker(player,nid)
	BR.removeArea(player,nid)
end

BR.defHomeComponent("chest",chest_create,chest_destroy)

local function wardrobe_create(owner_id,stype,sid,cid,config,data,x,y,z,player)
	local wardrobe_enter = nil
	wardrobe_enter = function(player,area)
	local user_id = BR.getUserId(player)
	if user_id and user_id == owner_id then
		local udata = BR.getUserDataTable(user_id)

		local menu = { name = "Guarda-Roupas" }

		local udata = BR.getUData(user_id,"BR:home:wardrobe")
		local sets = json.decode(udata)
		if sets == nil then
			sets = {}
		end

		menu["> Salvar"] = { function(player, choice)
			local setname = BR.prompt(player,"Nome:","")
			setname = sanitizeString(setname,sanitizes.text[1],sanitizes.text[2])
			if string.len(setname) > 0 then
				local custom =BRclient.getCustomization(player)
				sets[setname] = custom
				BR.setUData(user_id,"BR:home:wardrobe",json.encode(sets))
				wardrobe_enter(player,area)
			end
		end }

		local choose_set = function(player,choice)
		local custom = sets[choice]
		if custom then
			BRclient._setCustomization(player,custom)
		end
	end

	for k,v in pairs(sets) do
		menu[k] = { choose_set }
	end

	BR.openMenu(player,menu)
    end
end

local wardrobe_leave = function(player,area)
	BR.closeMenu(player)
end

local nid = "BR:home:slot"..stype..sid..":wardrobe"
	BR.setArea(player,nid,x,y,z,1,1,wardrobe_enter,wardrobe_leave)
end

local function wardrobe_destroy(owner_id,stype,sid,cid,config,data,x,y,z,player)
	local nid = "BR:home:slot"..stype..sid..":wardrobe"
	BRclient._removeNamedMarker(player,nid)
	BR.removeArea(player,nid)
end

BR.defHomeComponent("wardrobe",wardrobe_create,wardrobe_destroy)