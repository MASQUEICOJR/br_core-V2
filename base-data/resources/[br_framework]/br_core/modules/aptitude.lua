local cfg = module("cfg/aptitudes")
local exp_step = 4

local gaptitudes = {}

function BR.defAptitudeGroup(group,title)
	gaptitudes[group] = { _title = title }
end

function BR.defAptitude(group,aptitude,title,init_exp,max_exp)
	local vgroup = gaptitudes[group]
	if vgroup ~= nil then
		vgroup[aptitude] = { title,init_exp,max_exp }
	end
end

function BR.getAptitudeDefinition(group,aptitude)
	local vgroup = gaptitudes[group]
	if vgroup ~= nil and aptitude ~= "_title" then
		return vgroup[aptitude]
	else
		return nil
	end
end

function BR.getAptitudeGroupTitle(group)
	if gaptitudes[group] ~= nil then
		return gaptitudes[group]._title
	else
		return ""
	end
end

function BR.setExp(user_id,group,aptitude,amount)
    local uaptitudes = BR.getUserAptitudes(user_id)
    if uaptitudes ~= nil then
        uaptitudes[group][aptitude] = parseInt(amount)
    end
end


function BR.getUserAptitudes(user_id)
	local data = BR.getUserDataTable(user_id)
	if data ~= nil then
		if data.gaptitudes == nil then
			data.gaptitudes = {}
		end

		for k,v in pairs(gaptitudes) do
			if data.gaptitudes[k] == nil then
				data.gaptitudes[k] = {}
			end

			local group = data.gaptitudes[k]
			for l,w in pairs(v) do
				if l ~= "_title" and group[l] == nil then
					group[l] = w[2]
				end
			end
		end
		return data.gaptitudes
	else
		return nil
	end
end

function BR.varyExp(user_id,group,aptitude,amount)
	local def = BR.getAptitudeDefinition(group,aptitude)
	local uaptitudes = BR.getUserAptitudes(user_id)
	if def ~= nil and uaptitudes ~= nil then
		local exp = uaptitudes[group][aptitude]
		local level = math.floor(BR.expToLevel(exp))

		exp = exp+amount
		if exp < 0 then exp = 0 
		elseif def[3] >= 0 and exp > def[3] then exp = def[3] end

		uaptitudes[group][aptitude] = exp

		local player = BR.getUserSource(user_id)
		if player ~= nil then
			local group_title = BR.getAptitudeGroupTitle(group)
			local aptitude_title = def[1]
			local new_level = math.floor(BR.expToLevel(exp))
			local diff = new_level-level
		end
	end
end

function BR.getExp(user_id,group,aptitude)
	local uaptitudes = BR.getUserAptitudes(user_id)
	if uaptitudes ~= nil then
		local vgroup = uaptitudes[group]
		if vgroup ~= nil then
				return vgroup[aptitude] or 0
			end
		end
	return 0
end

function BR.expToLevel(exp)
	return (math.sqrt(1+8*exp/exp_step)-1)/2
end

for k,v in pairs(cfg.gaptitudes) do
	BR.defAptitudeGroup(k,v._title or "")
	for l,w in pairs(v) do
		if l ~= "_title" then
			BR.defAptitude(k,l,w[1],w[2],w[3])
		end
	end
end