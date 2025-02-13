RegisterNetEvent("br_core:playerSpawned")
AddEventHandler("br_core:playerSpawned", function()
    local playerId = GetPlayerServerId(PlayerId())
    local playerName = GetPlayerName(PlayerId())
    
    -- Envia para o servidor os dados do jogador ao spawnar
    TriggerServerEvent("br_core:playerJoined", playerId, playerName)
end)

-- Captura o evento nativo playerSpawned
AddEventHandler("playerSpawned", function()
    TriggerEvent("br_core:playerSpawned")
end)


local registration_number = "00AAA000"

function tBR.setRegistrationNumber(registration)
	registration_number = registration
end

function tBR.getRegistrationNumber()
	return registration_number
end
