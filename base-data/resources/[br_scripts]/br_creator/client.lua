local Proxy = module("br_core","lib/Proxy")
local Tunnel = module("br_core","lib/Tunnel")
BR = Proxy.getInterface("BR")

BRSERVER = Tunnel.getInterface(GetCurrentResourceName())

RegisterNetEvent("character:normalSpawn")
RegisterNetEvent("character:characterCreate")

local cam = nil
local freezedOnTop = true
local doStatus = -1
local continuousFadeOutNetwork = false

local isInCharacterMode = false
local currentCharacterMode = { fathersID = 0, mothersID = 0, skinColor = 0, shapeMix = 0.0, eyesColor = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, chinShape = 0, neckWidth = 0, hairModel = 4, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsColor = 0, beardModel = -1, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }
local idNome = ""
local idSobrenome = ""
local idIdade = 0


function f(n)
	n = n + 0.00000
	return n
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
end

local function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

local function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
	local time = 1000
	SetNuiFocus(false,false)
	SetEntityInvincible(PlayerPedId(),false) --mqcu
	SetEntityVisible(PlayerPedId(),false)
	FreezeEntityPosition(PlayerPedId(),true)
	SetPedDiesInWater(PlayerPedId(),false)
	TriggerCamController(doStatus)
	while freezedOnTop do
		time = 5
		if doStatus == 1 then
			SetEntityInvincible(PlayerPedId(),false) --mqcu
			--SetEntityVisible(PlayerPedId(),true)
			FreezeEntityPosition(PlayerPedId(),true)
			SetPedDiesInWater(PlayerPedId(),false)
		elseif doStatus == 2 then
			TriggerCamController(doStatus)
			SetEntityInvincible(PlayerPedId(),false)
			SetEntityVisible(PlayerPedId(),true)
			FreezeEntityPosition(PlayerPedId(),false)
			SetPedDiesInWater(PlayerPedId(),true)
			TriggerCamController(-2)
			freezedOnTop = false
		else
			SetEntityInvincible(PlayerPedId(),false) --mqcu
			SetEntityVisible(PlayerPedId(),false)
			FreezeEntityPosition(PlayerPedId(),true)
		end
		Citizen.Wait(time)
	end
end)

local altura
function TriggerCamController(statusSent)
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end

	if statusSent == -1 then
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
		SetCamRot(cam,-f(90),f(0),f(0),2)
		SetCamActive(cam,true)
		StopCamPointing(cam)
        RenderScriptCams(true,true,0,0,0,0)
    elseif statusSent == 2 then
		local pos = GetEntityCoords(PlayerPedId())
        SetCamCoord(cam,vector3(pos.x,pos.y,f(1000)))
        Wait(1500)
		altura = 1000
		while altura > 50 do
			if altura <= 300 then
				altura = altura - 6
			elseif altura >= 301 and altura <= 700 then
				altura = altura - 4
			else
				altura = altura - 2
			end
			setCamHeight(altura)
			Citizen.Wait(10)
		end
		
		TriggerEvent("flaviin:toggleHud", true)
	elseif statusSent == -2 then
		SetCamActive(cam,false)
		StopCamPointing(cam)
		RenderScriptCams(0,0,0,0,0,0)
		SetFocusEntity(PlayerPedId())
	elseif statusSent == 1 then
		SetCamCoord(cam,vector3(402.6,-997.2,-98.3))
		SetCamRot(cam,f(0),f(0),f(358),15)
		SetCamActive(cam,true)
		RenderScriptCams(true,true,20000000000000000000000000,0,0,0)
	end
end

RegisterNetEvent('ToogleBackCharacter')
AddEventHandler('ToogleBackCharacter', function()
	doStatus = 2
end)

AddEventHandler("character:characterCreate",function()
	doStatus = 1
	SetTimeout(1000,function()
		TriggerCreateCharacter()
	end)
end)

AddEventHandler("character:normalSpawn",function(firstspawn)
    if firstspawn then
		TriggerCamController(-1)
        Wait(7000)
		EndFade()
		doStatus = 2
		TriggerCamController(doStatus)
	else
        TriggerCamController(-1)
        Wait(7000)
		TriggerEvent("br_core:ToogleLoginMenu")
	end
end) 

function TriggerCreateCharacter()
	TriggerEvent('flaviin:toggleHud', false)
	TriggerEvent('notify:toogle', false)
	TriggerEvent('chat:toogle', false)
	TriggerEvent('shortcuts:terms', false)
	TriggerCamController(-1)
	isInCharacterMode = true
	StartFade()
	continuousFadeOutNetwork = true
	TriggerCamController(-2)
	changeGender("mp_m_freemode_01")
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()

	SetEntityCoordsNoOffset(PlayerPedId(),402.55,-996.37,-99.01,true,true,true)
	SetEntityHeading(PlayerPedId(),f(180))
	TriggerCamController(doStatus)
	SetEntityVisible(PlayerPedId(), false)

	Citizen.Wait(5000)
	EndFade()
	
	SetNuiFocus(isInCharacterMode,isInCharacterMode)
	SendNUIMessage({ whitelisted = true, id = (BRSERVER.getUserId() or 0) })

	SetEntityCoordsNoOffset(PlayerPedId(),402.55,-996.37,-99.01,true,true,true)
	SetEntityHeading(PlayerPedId(),f(180))
end

RegisterNUICallback('finishWhitelist', function(data, cb)
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	
	SetEntityVisible(PlayerPedId(), true)
	SetNuiFocus(isInCharacterMode,isInCharacterMode)
	SendNUIMessage({ whitelisted = false, CharacterMode = isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = not isInCharacterMode })

	BRSERVER._finishWhitelist(data)
end)

function refreshDefaultCharacter()
	SetPedDefaultComponentVariation(PlayerPedId())
	ClearAllPedProps(PlayerPedId())
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		--[ MASCULINO ]--
		SetPedComponentVariation(PlayerPedId(),1,0,0,2) --MASCARA
        SetPedComponentVariation(PlayerPedId(),3,0,0,2) --MAOS
        SetPedComponentVariation(PlayerPedId(),4,165,0,1) --CALCA
        SetPedComponentVariation(PlayerPedId(),6,16,0,1) --SAPATOS
        SetPedComponentVariation(PlayerPedId(),7,0,0,2) --ACESSORIOS
        SetPedComponentVariation(PlayerPedId(),8,15,0,2) --BLUSA
        SetPedComponentVariation(PlayerPedId(),9,-1,0,1) --COLETE
        SetPedComponentVariation(PlayerPedId(),11,458,0,1) --JAQUETA
        SetPedPropIndex(PlayerPedId(),6,-1,0)
        SetPedPropIndex(PlayerPedId(),0,-1,0)
	else
		--[ FEMININO ]--
		SetPedComponentVariation(PlayerPedId(),1,0,0,2) --MASCARA
        SetPedComponentVariation(PlayerPedId(),3,14,0,1) --MAOS 
        SetPedComponentVariation(PlayerPedId(),4,173,0,1) --CALCA
        SetPedComponentVariation(PlayerPedId(),6,5,1,1) --SAPATOS 
        SetPedComponentVariation(PlayerPedId(),7,0,0,0) --ACESSORIOS
        SetPedComponentVariation(PlayerPedId(),8,7,0,1) --BLUSA
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2) --COLETE
        SetPedComponentVariation(PlayerPedId(),11,525,0,1) --JAQUETA
		SetPedPropIndex(PlayerPedId(),0,-1,0,2)
		SetPedPropIndex(PlayerPedId(),6,-1,0,2)
	end
end

function changeGender(model)
	local mhash = GetHashKey(model)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		SetPlayerModel(PlayerId(),mhash)
		SetPedCanRagdoll(PlayerPedId(), false)
		SetPedMaxHealth(PlayerPedId(),300)
		SetEntityHealth(PlayerPedId(),300)
		SetModelAsNoLongerNeeded(mhash)
	end
end

RegisterNUICallback('notify', function(data, cb)
	TriggerEvent('Notify', data.type, data.message, 5)
end)

RegisterNUICallback('changeGender', function(data,cb)
	if tonumber(data.sex) == 1 then
		print(data.sex)
		changeGender("mp_m_freemode_01")
	else
		print(data.sex)
		changeGender("mp_f_freemode_01")
	end
end)

RegisterNUICallback('verify', function(data, cb)
	if BRSERVER.checkWhitelist() then
		cb({ whitelisted = true })
	end
end)

RegisterNUICallback('cDone',function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('BackPart1', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('cDonePart2', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = isInCharacterMode })
end)

RegisterNUICallback('BackPart2', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('cDoneSave',function(data,cb)
	StartFade()
	isInCharacterMode = false
	SetNuiFocus(isInCharacterMode,isInCharacterMode)
	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = isInCharacterMode })

	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		--[ MASCULINO ]--
		SetPedComponentVariation(PlayerPedId(),1,0,0,2) --MASCARA
        SetPedComponentVariation(PlayerPedId(),3,0,0,2) --MAOS
        SetPedComponentVariation(PlayerPedId(),4,165,0,1) --CALCA
        SetPedComponentVariation(PlayerPedId(),6,16,0,1) --SAPATOS
        SetPedComponentVariation(PlayerPedId(),7,0,0,2) --ACESSORIOS
        SetPedComponentVariation(PlayerPedId(),8,15,0,2) --BLUSA
        SetPedComponentVariation(PlayerPedId(),9,-1,0,1) --COLETE
        SetPedComponentVariation(PlayerPedId(),11,458,0,1) --JAQUETA
        SetPedPropIndex(PlayerPedId(),6,-1,0)
        SetPedPropIndex(PlayerPedId(),0,-1,0)
	else
		--[ FEMININO ]--
		SetPedComponentVariation(PlayerPedId(),1,0,0,2) --MASCARA
        SetPedComponentVariation(PlayerPedId(),3,14,0,1) --MAOS 
        SetPedComponentVariation(PlayerPedId(),4,173,0,1) --CALCA
        SetPedComponentVariation(PlayerPedId(),6,5,1,1) --SAPATOS 
        SetPedComponentVariation(PlayerPedId(),7,0,0,0) --ACESSORIOS
        SetPedComponentVariation(PlayerPedId(),8,7,0,1) --BLUSA
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2) --COLETE
        SetPedComponentVariation(PlayerPedId(),11,525,0,1) --JAQUETA
		SetPedPropIndex(PlayerPedId(),0,-1,0,2)
		SetPedPropIndex(PlayerPedId(),6,-1,0,2)
	end
	SetEntityCoordsNoOffset(PlayerPedId(),-1654.02,-1001.36,13.01,true,true,true)
	SetEntityHeading(PlayerPedId(),f(158.62))

	continuousFadeOutNetwork = false

	TriggerServerEvent("character:finishedCharacter",currentCharacterMode, BR.getCustomization())
	loadCutSine()
end)

RegisterNUICallback('cChangeHeading',function(data,cb)
	SetEntityHeading(PlayerPedId(),f(data.camRotation))
	cb('ok')
end)

RegisterNUICallback('UpdateSkinOptions',function(data,cb)
	currentCharacterMode.fathersID = data.fathersID
	currentCharacterMode.mothersID = data.mothersID
	currentCharacterMode.skinColor = data.skinColor
	currentCharacterMode.shapeMix = data.shapeMix
	idNome = data.idNome
	idSobrenome = data.idSobrenome
	idIdade = data.idIdade
	TaskUpdateSkinOptions()
	cb('ok')
end)

function TaskUpdateSkinOptions()
	local data = currentCharacterMode
	SetPedHeadBlendData(PlayerPedId(),data.fathersID,data.mothersID,0,data.skinColor,0,0,f(data.shapeMix),0,0,false)
end

RegisterNUICallback('UpdateFaceOptions',function(data,cb)
	currentCharacterMode.eyesColor = data.eyesColor
	currentCharacterMode.eyebrowsHeight = data.eyebrowsHeight
	currentCharacterMode.eyebrowsWidth = data.eyebrowsWidth
	currentCharacterMode.noseWidth = data.noseWidth
	currentCharacterMode.noseHeight = data.noseHeight
	currentCharacterMode.noseLength = data.noseLength
	currentCharacterMode.noseBridge = data.noseBridge
	currentCharacterMode.noseTip = data.noseTip
	currentCharacterMode.noseShift = data.noseShift
	currentCharacterMode.cheekboneHeight = data.cheekboneHeight
	currentCharacterMode.cheekboneWidth = data.cheekboneWidth
	currentCharacterMode.cheeksWidth = data.cheeksWidth
	currentCharacterMode.lips = data.lips
	currentCharacterMode.jawWidth = data.jawWidth
	currentCharacterMode.jawHeight = data.jawHeight
	currentCharacterMode.chinLength = data.chinLength
	currentCharacterMode.chinPosition = data.chinPosition
	currentCharacterMode.chinWidth = data.chinWidth
	currentCharacterMode.chinShape = data.chinShape
	currentCharacterMode.neckWidth = data.neckWidth
	TaskUpdateFaceOptions()
	cb('ok')
end)

function TaskUpdateFaceOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	-- Olhos
	SetPedEyeColor(ped,data.eyesColor)
	-- Sobrancelha
	SetPedFaceFeature(ped,6,data.eyebrowsHeight)
	SetPedFaceFeature(ped,7,data.eyebrowsWidth)
	-- Nariz
	SetPedFaceFeature(ped,0,data.noseWidth)
	SetPedFaceFeature(ped,1,data.noseHeight)
	SetPedFaceFeature(ped,2,data.noseLength)
	SetPedFaceFeature(ped,3,data.noseBridge)
	SetPedFaceFeature(ped,4,data.noseTip)
	SetPedFaceFeature(ped,5,data.noseShift)
	-- Bochechas
	SetPedFaceFeature(ped,8,data.cheekboneHeight)
	SetPedFaceFeature(ped,9,data.cheekboneWidth)
	SetPedFaceFeature(ped,10,data.cheeksWidth)
	-- Boca/Mandibula
	SetPedFaceFeature(ped,12,data.lips)
	SetPedFaceFeature(ped,13,data.jawWidth)
	SetPedFaceFeature(ped,14,data.jawHeight)
	-- Queixo
	SetPedFaceFeature(ped,15,data.chinLength)
	SetPedFaceFeature(ped,16,data.chinPosition)
	SetPedFaceFeature(ped,17,data.chinWidth)
	SetPedFaceFeature(ped,18,data.chinShape)
	-- Pescoço
	SetPedFaceFeature(ped,19,data.neckWidth)
end

RegisterNUICallback('UpdateHeadOptions',function(data,cb)
	currentCharacterMode.hairModel = data.hairModel
	currentCharacterMode.firstHairColor = data.firstHairColor
	currentCharacterMode.secondHairColor = data.secondHairColor
	currentCharacterMode.eyebrowsModel = data.eyebrowsModel
	currentCharacterMode.eyebrowsColor = data.eyebrowsColor
	currentCharacterMode.beardModel = data.beardModel
	currentCharacterMode.beardColor = data.beardColor
	currentCharacterMode.chestModel = data.chestModel
	currentCharacterMode.chestColor = data.chestColor
	currentCharacterMode.blushModel = data.blushModel
	currentCharacterMode.blushColor = data.blushColor
	currentCharacterMode.lipstickModel = data.lipstickModel
	currentCharacterMode.lipstickColor = data.lipstickColor
	currentCharacterMode.blemishesModel = data.blemishesModel
	currentCharacterMode.ageingModel = data.ageingModel
	currentCharacterMode.complexionModel = data.complexionModel
	currentCharacterMode.sundamageModel = data.sundamageModel
	currentCharacterMode.frecklesModel = data.frecklesModel
	currentCharacterMode.makeupModel = data.makeupModel
	TaskUpdateHeadOptions()
	cb('ok')
end)


function TaskUpdateHeadOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	-- Cabelo
	SetPedComponentVariation(ped,2,data.hairModel,0,0)
	SetPedHairColor(ped,data.firstHairColor,data.secondHairColor)
	-- Sobracelha
	SetPedHeadOverlay(ped,2,data.eyebrowsModel,0.99)
	SetPedHeadOverlayColor(ped,2,1,data.eyebrowsColor,data.eyebrowsColor)
	-- Barba
	SetPedHeadOverlay(ped,1,data.beardModel,0.99)
	SetPedHeadOverlayColor(ped,1,1,data.beardColor,data.beardColor)
	-- Pelo Corporal
	SetPedHeadOverlay(ped,10,data.chestModel,0.99)
	SetPedHeadOverlayColor(ped,10,1,data.chestColor,data.chestColor)
	-- Blush
	SetPedHeadOverlay(ped,5,data.blushModel,0.99)
	SetPedHeadOverlayColor(ped,5,2,data.blushColor,data.blushColor)
	-- Battom
	SetPedHeadOverlay(ped,8,data.lipstickModel,0.99)
	SetPedHeadOverlayColor(ped,8,2,data.lipstickColor,data.lipstickColor)
	-- Manchas
	SetPedHeadOverlay(ped,0,data.blemishesModel,0.99)
	SetPedHeadOverlayColor(ped,0,0,0,0)
	-- Envelhecimento
	SetPedHeadOverlay(ped,3,data.ageingModel,0.99)
	SetPedHeadOverlayColor(ped,3,0,0,0)
	-- Aspecto
	SetPedHeadOverlay(ped,6,data.complexionModel,0.99)
	SetPedHeadOverlayColor(ped,6,0,0,0)
	-- Pele
	SetPedHeadOverlay(ped,7,data.sundamageModel,0.99)
	SetPedHeadOverlayColor(ped,7,0,0,0)
	-- Sardas
	SetPedHeadOverlay(ped,9,data.frecklesModel,0.99)
	SetPedHeadOverlayColor(ped,9,0,0,0)
	-- Maquiagem
	SetPedHeadOverlay(ped,4,data.makeupModel,0.99)
	SetPedHeadOverlayColor(ped,4,0,0,0)
end

function loadCutSine()
	DoScreenFadeOut(1000)
	Wait(500)
	RequestCollisionAtCoord(PlayerPedId(),-1170.57, -1644.02, 4.38)
	SetEntityCoords(PlayerPedId(), -1170.57, -1644.02, 4.38, false, false, false, true)
	DoScreenFadeOut(1000)

	Wait(2000)
	TriggerCamController(-1)
	doStatus = 2
	TriggerCamController(doStatus)

	Wait(1000)
	RequestCollisionAtCoord(PlayerPedId(),-1638.71, -2738.75, 13.94)
	SetEntityCoords(PlayerPedId(), -1638.71, -2738.75, 13.94, false, false, false, true)

	Wait(1000)
	RequestCollisionAtCoord(PlayerPedId(),-1037.67,-2736.49,13.77)
	SetEntityCoords(PlayerPedId(), -1037.67,-2736.49,13.77, false, false, false, true)

	Wait(2000)
	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Citizen.Wait(0)
	end

	DoScreenFadeOut(1000)
	Wait(1000)
	ShutdownLoadingScreen()
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end

	Wait(1000)
	local coords = config.creator.spawloc
	local x, y, z = coords.x, coords.y, coords.z

	RequestCollisionAtCoord(PlayerPedId(), x, y, z)
	SetEntityCoordsNoOffset(PlayerPedId(), x, y, z, true, true, false)

	EndFade()
	Wait(1000)
	DoScreenFadeIn(1000)

	TriggerEvent('flaviin:toggleHud', true)
	TriggerEvent('notify:toogle', true)
	TriggerEvent('chat:toogle', true)
	TriggerEvent('shortcuts:terms', true)
	DisplayRadar(true)
end
