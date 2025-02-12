identity = {}
local Tunnel = module("br_core", "lib/Tunnel")
local Proxy = module("br_core", "lib/Proxy")
BR = Proxy.getInterface("BR")
Tunnel.bindInterface(GetCurrentResourceName(), identity)
BRSERVER = Tunnel.getInterface(GetCurrentResourceName())


RegisterKeyMapping("rg", "Identidade", "keyboard", "F11")


RegisterNetEvent('br_identity:hide', function()
	identity.hidden = false
	SendNUIMessage({ action = "close" })
end)


RegisterCommand("rg", function()
	if GetEntityHealth(PlayerPedId()) > 101 then
		if not identity.hidden then
			identity.hidden = true
			SendNUIMessage({ action = "open" , info = BRSERVER.getInfos()})
			TriggerEvent('br_hud:toggle', false)
		else
			identity.hidden = false
			SendNUIMessage({ action = "close" })
			TriggerEvent('br_hud:toggle', true)
		end
	end
end)


