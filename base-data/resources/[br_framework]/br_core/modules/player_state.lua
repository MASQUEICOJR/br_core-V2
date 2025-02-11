local cfg = module("cfg/player_state")

AddEventHandler("BR:playerSpawn",function(user_id,source,first_spawn)
	local source = source
	local user_id = BR.getUserId(source)
	local data = BR.getUserDataTable(user_id)
	BRclient._setFriendlyFire(source,true)

	if first_spawn then
		if data.colete then
			BRclient.setArmour(source,data.colete)
		end

		if data.customization == nil then
			data.customization = cfg.default_customization
		end

		if data.position then
			BRclient.teleport(source,data.position.x,data.position.y,data.position.z)
		end

		if data.customization then
			BRclient.setCustomization(source,data.customization) 
			if data.weapons then
				BRclient.giveWeapons(source,data.weapons,true)

				if data.health then
					BRclient.setHealth(source,data.health)
					SetTimeout(5000,function()
						if BRclient.isInComa(source) then
							BRclient.killComa(source)
						end
					end)
				end
			end
		else
			if data.weapons then
				BRclient.giveWeapons(source,data.weapons,true)
			end

			if data.health then
				BRclient.setHealth(source,data.health)
			end
		end
	else
		BRclient._setHandcuffed(source,false)

		if not BR.hasPermission(user_id,"mochila.permissao") then
			data.gaptitudes = {}
		end

		if data.customization then
			BRclient._setCustomization(source,data.customization)
		end
	end
		BRclient._playerStateReady(source,true)
end)

function tBR.initPlayerStatus(user_id,source)
	BRclient._playerStateReady(source,true)
end

function tBR.updatePos(x,y,z)
	local user_id = BR.getUserId(source)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		local tmp = BR.getUserTmpTable(user_id)
		if data and (not tmp or not tmp.home_stype) then
			data.position = { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
		end
	end
end

function tBR.updateArmor(armor)
	local user_id = BR.getUserId(source)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			data.colete = armor
		end
	end
end

function tBR.updateWeapons(weapons)
	local user_id = BR.getUserId(source)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			data.weapons = weapons
		end
	end
end

function tBR.updateCustomization(customization)
	local user_id = BR.getUserId(source)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			data.customization = customization
		end
	end
end

function tBR.updateHealth(health)
	local user_id = BR.getUserId(source)
	if user_id then
		local data = BR.getUserDataTable(user_id)
		if data then
			data.health = health
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MALA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trymala")
AddEventHandler("trymala",function(nveh)
	TriggerClientEvent("syncmala",-1,nveh)
end)