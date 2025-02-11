
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD THIRST/
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(80000)
		for k,v in pairs(BR.users) do
			BR.downgradeThirst(v,2)
			BR.downgradeHunger(v,1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDAGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.upgradeThirst(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.thirst == nil then
			data.thirst = 100
		else
			data.thirst = data.thirst + amount
			if data.thirst >= 100 then
				data.thirst = 100
			end
		end

		TriggerClientEvent("statusThirst",source,data.thirst)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.upgradeHunger(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.hunger == nil then
			data.hunger = 100
		else
			data.hunger = data.hunger + amount
			if data.hunger >= 100 then
				data.hunger = 100
			end
		end

		TriggerClientEvent("statusHunger",source,data.hunger)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADETHIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.downgradeThirst(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.thirst == nil then
			data.thirst = 100
		else
			data.thirst = data.thirst - amount
			if data.thirst <= 0 then
				data.thirst = 0
			end
		end

		TriggerClientEvent("statusThirst",source,data.thirst)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADEHUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.downgradeHunger(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.hunger == nil then
			data.hunger = 100
		else
			data.hunger = data.hunger - amount
			if data.hunger <= 0 then
				data.hunger = 0
			end
		end

		TriggerClientEvent("statusHunger",source,data.hunger)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.upgradeStress(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.stress == nil then
			data.stress = amount
		else
			data.stress = data.stress + amount
			if data.stress >= 100 then
				data.stress = 100
			end
		end

		TriggerClientEvent("statusStress",source,data.stress)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
function BR.downgradeStress(user_id,amount)
	local source = BR.getUserSource(user_id)
	local data = BR.getUserDataTable(user_id)
	if data then
		if data.stress == nil then
			data.stress = amount
		else
			data.stress = data.stress - amount
			if data.stress <= 0 then
				data.stress = 0
			end
		end

		TriggerClientEvent("statusStress",source,data.stress)
	end
end

