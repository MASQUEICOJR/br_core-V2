function tBR.getNearestVehicles(radius)
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)

	for _,veh in pairs(vehs) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = Vdist(x,y,z,px,py,pz)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end

function tBR.getNearestVehicle(radius)
	local veh
	local vehs = tBR.getNearestVehicles(radius)
	local min = radius+0.0001
	for _veh,dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh 
end

function tBR.ejectVehicle()
	local ped = PlayerPedId()
	if IsPedSittingInAnyVehicle(ped) then
		TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),4160)
	end
end

function tBR.isInVehicle()
	return IsPedSittingInAnyVehicle(PlayerPedId())
end

function tBR.GetVehicleSeat()
    return GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()),-1) == PlayerPedId()
end
local Proxy = module("br_core","lib/Proxy")
local garage = Proxy.getInterface("br_core")

function tBR.vehList(radius)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if not IsPedInAnyVehicle(ped) then
		veh = tBR.getNearestVehicle(radius)
	end
	if IsEntityAVehicle(veh) then
		local lock = GetVehicleDoorLockStatus(veh)
		local trunk = GetVehicleDoorAngleRatio(v,5)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local model = GetEntityModel(veh)
		local vehInfo = garage.getVehicleInfo(model)
		if vehInfo then
			local name = vehInfo.name
			local banned = vehInfo.banido
			local tuning = { GetNumVehicleMods(veh,13),GetNumVehicleMods(veh,12),GetNumVehicleMods(veh,15),GetNumVehicleMods(veh,11),GetNumVehicleMods(veh,16) }
			return veh,VehToNet(veh),GetVehicleNumberPlateText(veh),name,lock,banned,trunk,GetDisplayNameFromVehicleModel(name),GetStreetNameFromHashKey(GetStreetNameAtCoord(x,y,z)),tuning
		end
	end
end
