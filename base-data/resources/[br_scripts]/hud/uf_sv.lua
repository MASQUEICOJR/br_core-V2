local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
BR = Proxy.getInterface("BR")
vAZ = {}
Tunnel.bindInterface("mid_hud", vAZ)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- VARIABLES
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- local clockHours = 18
-- local clockMinutes = 0
-- local timeDate = GetGameTimer()
-- local weatherSync = "EXTRASUNNY"
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- THREADGLOBAL
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if GetGameTimer() >= (timeDate + 10000) then
-- 			timeDate = GetGameTimer()
-- 			clockMinutes = clockMinutes + 1

-- 			if clockMinutes >= 60 then
-- 				clockHours = clockHours + 1
-- 				clockMinutes = 0

-- 				if clockHours >= 24 then
-- 					clockHours = 0
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(10000)
-- 	end
-- end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- TEMPO
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("time", function(source,args,rawCommand)
-- 	local user_id = BR.getUserId(source)
-- 	if user_id then
-- 		if BR.hasPermission(user_id,"Admin") then
-- 			if args[1] and args[2] then 
-- 				hours = args[1]
-- 				minutes = args[2]
				
-- 			end	
-- 		end
-- 	end
-- 	TriggerClientEvent("mid_hud:syncTimers",-1,{ minutes,hours,weatherTime })
-- 	Citizen.Wait(10000)
-- end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- PLAYERSPAWN
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- AddEventHandler("BR:playerSpawn",function(user_id,source)
-- 	TriggerClientEvent("mid_hud:syncTimers",source,{ clockMinutes,clockHours,weatherSync })
-- end)