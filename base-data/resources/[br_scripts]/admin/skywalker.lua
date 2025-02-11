local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
BR = Proxy.getInterface("BR")
BRclient = Tunnel.getInterface("BR")

BRidd = {}
Tunnel.bindInterface("br_core_admin",BRidd)
Proxy.addInterface("br_core_admin",BRidd)
IDDclient = Tunnel.getInterface("br_core_admin")

RegisterCommand('anunciar',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") then
        local mensagem = BR.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("NotifyAdm",-1,identity.name,mensagem)
    end
end)

RegisterCommand('anuncio',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	if BR.tryPayment(user_id,5000) then
        local mensagem = BR.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("NotifyPol",-1,identity.name,mensagem)
    end
end)

RegisterCommand('callback',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"chat.permissao") then
        if args[1] then
        	local id = BR.getUserSource(parseInt(args[1]))
            local mensagem = BR.prompt(source,"Mensagem:","")
            if mensagem == "" then
                return
            end
            TriggerClientEvent("NotifyAdmCallback",id,identity.name,mensagem)
        end
    end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP FACS
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADA
RegisterCommand('addvermelhos',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"lidervermelhos.permissao") then
		if args[1] then
			--SendWebhookMessage(webhookfac,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..parseInt(args[1]).." \n[GRUPO]: VERMELHOS "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			BR.addUserGroup(parseInt(args[1]),"VERMELHOS")
			TriggerClientEvent("Notify",source,"sucesso","Você <b>setou</b> o ID <b>"..parseInt(args[1]).."</b> como <b>VERMELHOS</b>.")
			TriggerClientEvent("br_core_sound:source",source,'message',0.5)
		end
	end
end)

RegisterCommand('removevermelhos',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"lidervermelhos.permissao") then
		if args[1] then
			--SendWebhookMessage(webhookfac,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..parseInt(args[1]).." \n[GRUPO]: VERMELHOS "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			BR.removeUserGroup(parseInt(args[1]),"VERMELHOS")
			TriggerClientEvent("Notify",source,"negado","Você <b>removeu</b> o ID <b>"..parseInt(args[1]).."</b> da <b>VERMELHOS</b>.")
			TriggerClientEvent("br_core_sound:source",source,'message',0.5)
		end
	end
end)

RegisterCommand('svon',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		Citizen.CreateThread(function()
			PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({
				content = '||@everyone <@&882047959913603091>||',
				embeds = {
					{
						title = ":green_circle: SERVIDOR ONLINE :green_circle:",
						thumbnail = {
							url = "https://i.imgur.com/5VZpg0G.png"
						},
						image = {
							url = "https://media.tenor.com/images/13263ea207733d88b4a3c86f343dc56b/tenor.gif"
						},
						description = '_ _\n**Conectar no console (F8):**\nconnect vicecity.com.br\n\n**IP do TeamSpeak:**\nvicecity.com.br\n\n**Atualizações:**\n<#902935064428568636>\n\n**Tutorial TokoVoip:**\n<#882862490172661780>\n\nO servidor encontra-se **online**!',
						color = 8978660, -- Se quiser mudar a cor é aqui⠀
						footer = {
							text = "Atenciosamente equipe VICE CITY©",
							icon_url = "https://i.imgur.com/5VZpg0G.png"
						},
					}
				}
			}), { ['Content-Type'] = 'application/json' })
		end)
	end
end)

RegisterCommand('renomear',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)

    if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id, "moderador.permissao") or BR.hasPermission(user_id, "administrador.permissao") or BR.hasPermission(user_id, "manager.permission") then
        local idjogador = BR.prompt(source, "Qual id do jogador?", "")
        local nome = BR.prompt(source, "Novo nome", "")
        local firstname = BR.prompt(source, "Novo sobrenome", "")
        local idade = BR.prompt(source, "Nova idade", "")
		local nuidentity = BR.getUserIdentity(parseInt(idjogador))

        BR.execute("BR/update_user_identity",{
            user_id = idjogador,
            firstname = firstname,
            name = nome,
            age = idade,
            registration = nuidentity.registration,
            phone = nuidentity.phone
		})

		PerformHttpRequest(config.Rename, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{ 	------------------------------------------------------------
					title = "REGISTRO DE ALTERAÇÃO IDENTIDADE⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = config.webhookIcon
					},
					fields = {
						{
							name = "**COLABORADOR DA EQUIPE:**",
							value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
						},
						{
							name = "**NOVOS DADOS DO RG:**",
							value = "**["..BR.format(parseInt(idjogador)).."][ Nome: "..nome.." ][ Sobrenome: "..firstname.." ][ Idade: "..idade.." ]**\n⠀"
						}
					},
					footer = {
						text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
						icon_url = config.webhookIcon
					},
					color = config.webhookColor
				}
			}
		}), { ['Content-Type'] = 'application/json' })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- /mochila
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('backpack',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BRclient.getHealth(source) > 101 then
		if user_id then
			TriggerClientEvent("setmochila",source,args[1],args[2])
		end
	end
end)

local player_customs = {}
RegisterCommand('vroupas',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
	local custom = BRclient.getCustomization(source)

    if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id, "moderador.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
        if player_customs[source] then
            player_customs[source] = nil
            BRclient._removeDiv(source,"customization")
        else
			local content = ""

            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br/>"
            end

            player_customs[source] = true
            BRclient._setDiv(source,"customization",".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }",content)
        end
    end
end)

-----------------------------
--VROUPAS2
-----------------------------
function IsNumber( numero )
    return tonumber(numero) ~= nil
end

RegisterCommand('vroupas2', function(source, args, rawCommand)
    local user_id = BR.getUserId(source)
    local custom = BRclient.getCustomization(source)
    if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id, "moderador.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
          if player_customs[source] then
            player_customs[source] = nil
            BRclient._removeDiv(source,"customization")
        else 
            local content = ""
            for k, v in pairs(custom) do
                if (IsNumber(k) and k <= 11) or k == "p0" or k == "p1" or k == "p2" or k == "p6" or k == "p7" then
                    if IsNumber(k) then
                        content = content .. '[' .. k .. '] = {' 
                    else
                        content = content .. '["' ..k..'"] = {'
                    end
                    local contador = 1
                    for y, x in pairs(v) do
                        if contador < #v then
                            content  = content .. x .. ',' 
                        else
                            content = content .. x 
                        end
                        contador = contador + 1
                    end
                    content = content .. "},\n"
                end
            end
            player_customs[source] = true
            BRclient.prompt(source, 'vRoupas: ', content)
        end
    end
end)
RegisterCommand('estoque',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"manager.permission") then
		if args[1] and args[2] then

			PerformHttpRequest(config.Stock, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 	------------------------------------------------------------
						title = "REGISTRO DE ALTERAÇÃO DE ESTOQUE⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
						thumbnail = {
							url = config.webhookIcon
						},
						fields = {
							{
								name = "**COLABORADOR DA EQUIPE:**",
								value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
							},
							{
								name = "**MODIFICAÇÃO DE ESTOQUE:**",
								value = "**[ Modelo: "..args[1].." ][ Quantidade: "..BR.format(parseInt(args[2])).." ]**\n⠀"
							}
						},
						footer = {
							text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
							icon_url = config.webhookIcon
						},
						color = config.webhookColor
					}
				}
			}), { ['Content-Type'] = 'application/json' })

            BR.execute("losanjos/set_estoque",{ vehicle = args[1], quantidade = args[2] })
            TriggerClientEvent("Notify",source,"sucesso","Voce colocou mais <b>"..args[2].."</b> no estoque, para o carro <b>"..args[1].."</b>.")
        end
    end
end)

RegisterCommand('arma',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
    if user_id then
        if args[1] then
            if BR.hasPermission(user_id,"manager.permission") then
            	BRclient.giveWeapons(source,{[args[1]] = { ammo = 500 }})
				TriggerClientEvent("Notify",source,"amarelo","Você pergou a arma "..args[1])
			end
        end
    end
end)

RegisterCommand('gender',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
    if user_id then
       print(getGenderImage(user_id))
    end
end)

function getGenderImage(id)
	local valor = 0
	local datatable = BR.query("system/getoff", {user = id})
    local data = json.decode(datatable[1].dvalue)
	if data.customization then
		for k,v in pairs(data.customization) do
			if k == "modelhash" then
				valor = v
				break
			end
		end
    end
    if valor == 1885233650 then
		return 'https://media.discordapp.net/attachments/759739881420750878/905454932176539658/male.png?width=676&height=676'
    elseif valor == -1667301416 then
        return 'https://media.discordapp.net/attachments/759739881420750878/905454937356501052/FemalePink.png'
    else
		return 'https://media.discordapp.net/attachments/759739881420750878/905455190814121994/8b59095911922f0575457a0e0a9388ec-animal-macaco-bonito-plana.png'
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('clearinv',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local player = BR.getUserSource(user_id)
    if BR.hasPermission(user_id,"manager.permission") then
        local tuser_id = tonumber(args[1])
        local tplayer = BR.getUserSource(tonumber(tuser_id))
        local tplayerID = BR.getUserId (tonumber(tplayer))
            if tplayerID ~= nil then
				local ndata = BR.getUserDataTable(tplayerID)
				if ndata ~= nil then
					if ndata.inventorys ~= nil then
						for k,v in pairs(ndata.inventorys) do
							if BR.tryGetInventoryItem(tplayerID,v.item,v.amount) then
							end
						end
					end
				end
				local identity = BR.getUserIdentity(tplayerID)
                TriggerClientEvent("Notify",source,"sucesso","Limpou inventario do <id>"..identity.name.." "..identity.firstname.."</b>.")
            else
                TriggerClientEvent("Notify",source,"negado","O usuário não foi encontrado ou está offline.")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD CAR
-----------------------------------------------------------------------------------------------------------------------------------------
BR._prepare("creative/get_vehicle","SELECT * FROM user_vehicles WHERE user_id = @user_id")
BR._prepare("creative/rem_vehicle","DELETE FROM user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/get_vehicles","SELECT * FROM user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/set_update_vehicles","UPDATE user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/set_detido","UPDATE user_vehicles SET detido = @detido, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/set_ipva","UPDATE user_vehicles SET ipva = @ipva WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/move_vehicle","UPDATE user_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
BR._prepare("creative/add_vehicle","INSERT IGNORE INTO user_vehicles(user_id,vehicle,ipva) VALUES(@user_id,@vehicle,@ipva)")
BR._prepare("creative/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM user_vehicles WHERE user_id = @user_id")
BR._prepare("creative/rem_srv_data","DELETE FROM srv_data WHERE dkey = @dkey")
BR._prepare("creative/get_estoque","SELECT * FROM vrp_estoque WHERE vehicle = @vehicle")
BR._prepare("creative/set_estoque","UPDATE vrp_estoque SET quantidade = @quantidade WHERE vehicle = @vehicle")
BR._prepare("creative/get_users","SELECT * FROM users WHERE id = @user_id")

RegisterCommand('addcar',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local nplayer = BR.getUserId(parseInt(args[2]))
    if BR.hasPermission(user_id,"managers.permissao") or BR.hasPermission(user_id,"managers.permissao") then
        if args[1] and args[2] then
            local nuser_id = BR.getUserId(nplayer)
            local identity = BR.getUserIdentity(user_id)
            local identitynu = BR.getUserIdentity(nuser_id)
            BR.execute("creative/add_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) }) 
            --BR.execute("creative/set_ipva",{ user_id = parseInt(args[2]), vehicle = args[1], ipva = parseInt(os.time()) })
            TriggerClientEvent("Notify",source,"sucesso","Voce adicionou o veículo <b>"..args[1].."</b> para o Passaporte: <b>"..parseInt(args[2]).."</b>.") 
        end
    end
end)

RegisterCommand('remcar',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	local nplayer = BR.getUserId(parseInt(args[2]))

    if BR.hasPermission(user_id,"manager.permission") then
        if args[1] and args[2] then
            local nuser_id = BR.getUserId(nplayer)
			local identitynu = BR.getUserIdentity(nuser_id)

            BR.execute("creative/rem_vehicle",{ user_id = parseInt(args[2]), vehicle = args[1] })
            BR.execute("creative/rem_srv_data",{ dkey = 'gloves:'..parseInt(args[2])..':'..tostring(args[1]) })
            BR.execute("creative/rem_srv_data",{ dkey = 'custom:u'..parseInt(args[2])..'veh_'..tostring(args[1]) })
            TriggerClientEvent("Notify",source,"sucesso","Voce removeu o veículo <b>"..args[1].."</b> do Passaporte: <b>"..parseInt(args[2]).."</b>.")

			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[REMOVEU]: "..args[1].." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "addcar")
        end
    end
end)

RegisterCommand('uncuff',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if user_id then
		if BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
			TriggerClientEvent("admcuff",source)
		end
	end
end)

RegisterCommand('deattach',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if user_id then
		if BR.hasPermission(user_id,"manager.permission") then
			TriggerClientEvent("deattach",source)
		end
	end
end)

RegisterCommand('limpararea',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local x,y,z = BRclient.getPosition(source)
    if BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
        TriggerClientEvent("syncarea",-1,x,y,z)
    end
end)

RegisterCommand('apagao',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if user_id ~= nil then
        local player = BR.getUserSource(user_id)
        if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") and args[1] ~= nil then
            local cond = tonumber(args[1])
            --TriggerEvent("cloud:setApagao",cond)
            TriggerClientEvent("cloud:setApagao",-1,cond)
        end
    end
end)

RegisterCommand('raios', function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if user_id ~= nil then
        local player = BR.getUserSource(user_id)
        if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios",-1,vezes)
        end
    end
end)

RegisterCommand('skin',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if BR.hasPermission(user_id,"ajodljasdabdajkldnals") then
        if parseInt(args[1]) then
            local nplayer = BR.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu",nplayer,args[2])
                TriggerClientEvent("Notify",source,"sucesso","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.")
            end
        end
    end
end)

RegisterCommand('debug',function(source, args, rawCommand)
	local user_id = BR.getUserId(source)
	if user_id ~= nil then
		local player = BR.getUserSource(user_id)
		if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
			TriggerClientEvent("ToggleDebug",player)
		end
	end
end)

RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	
	TriggerClientEvent("syncreparar",-1,nveh)
end)


RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
    TriggerClientEvent("syncdeleteobj",-1,index)
end)

RegisterCommand('fix',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)

	local vehicle = BRclient.getNearestVehicle(source,11)
	if vehicle then
		if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then

			PerformHttpRequest(config.Fix, function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{ 	------------------------------------------------------------
						title = "REGISTRO DE FIX⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
						thumbnail = {
							url = config.webhookIcon
						},
						fields = {
							{
								name = "**COLABORADOR DA EQUIPE:**",
								value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
							}
						},
						footer = {
							text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
							icon_url = config.webhookIcon
						},
						color = config.webhookColor
					}
				}
			}), { ['Content-Type'] = 'application/json' })

			TriggerClientEvent('reparar',source)
		end
	end
end)

RegisterCommand('god',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)

    if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then
        if args[1] then
			local nplayer = BR.getUserSource(parseInt(args[1]))
			if nplayer then
				local nuser_id = BR.getUserId(nplayer)
				local identity2 = BR.getUserIdentity(nuser_id)

				TriggerClientEvent("resetBleeding",nplayer)
                TriggerClientEvent("resetDiagnostic",nplayer)

                BRclient.killGod(nplayer)
				BRclient.setHealth(nplayer,400)
				TriggerClientEvent("nuioff",nplayer)
				BR.setThirst(args[1],100)
				BR.setHunger(args[1],100)

				BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ALVO]: "..args[1].." "..identity2.name.." "..identity2.firstname.." \n[USOU GOD] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "god")
            end
		else


			TriggerClientEvent("resetBleeding",source)
            TriggerClientEvent("resetDiagnostic",source)

            BRclient.killGod(source)
			BRclient.setHealth(source,400)
			TriggerClientEvent("nuioff",source)
			BR.setThirst(user_id,100)
			BR.setHunger(user_id,100)

			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[USOU GOD] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "god")
        end
    end
end)

RegisterCommand('godall',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
    	local users = BR.getUsers()
        for k,v in pairs(users) do
            local id = BR.getUserSource(parseInt(k))
            if id then
				TriggerClientEvent("nuioff",id)
            	TriggerClientEvent("resetBleeding",id)
            	TriggerClientEvent("resetDiagnostic",id)
            	BRclient.killGod(id)
				BRclient.setHealth(id,400)
            end
		end

		PerformHttpRequest(config.Revive, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{
					title = "REGISTRO DE REVIVER TODOS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = config.webhookIcon
					},
					fields = {
						{
							name = "**COLABORADOR DA EQUIPE:**",
							value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
						}
					},
					footer = {
						text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
						icon_url = config.webhookIcon
					},
					color = config.webhookColor
				}
			}
		}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterCommand('hash',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"manager.permission") then
		TriggerClientEvent('vehash',source)
	end
end)

RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		TriggerClientEvent('vehtuning',source)
	end
end)

RegisterCommand('wl',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao") or BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"aprovador-wl.permissao") then
		if args[1] then
            BR.setWhitelisted(args[1],true)
            TriggerClientEvent("Notify",source,"sucesso","Você aprovou o passaporte <b>"..args[1].."</b> na whitelist.")

			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ADICIONOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "wl")
        end
    end
end)

RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			BR.setWhitelisted(args[1],false)
			TriggerClientEvent("Notify",source,"sucesso","Você retirou o passaporte <b>"..args[1].."</b> da whitelist.")
			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "wl")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			local id = BR.getUserSource(parseInt(args[1]))
			if id then
				local motivo = BR.prompt(source,"Digite um motivo:","")
				if motivo or motivo ~= "" then
					BR.kick(id,"Você foi expulso da cidade. Motivo: "..motivo)
					TriggerClientEvent("Notify",source,"sucesso","Voce kickou o passaporte <b>"..args[1].."</b> da cidade.")
					BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[KICKOU]: "..args[1].." \n[MOTIVO]: "..motivo..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "kick")
				else
					TriggerClientEvent("Notify",source,"negado","Você deve específicar um motivo.")
				end
			end
		end
	end
end)

RegisterCommand('kickall',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)

    if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
        local users = BR.getUsers()
        for k,v in pairs(users) do
            local id = BR.getUserSource(parseInt(k))
            if id then
                BR.kick(id,"Você foi vitima do terremoto.")
            end
		end

		PerformHttpRequest(config.Kick, function(err, text, headers) end, 'POST', json.encode({
			embeds = {
				{
					title = "REGISTRO DE KICKAR TODOS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
					thumbnail = {
						url = config.webhookIcon
					},
					fields = {
						{
							name = "**COLABORADOR DA EQUIPE:**",
							value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
						}
					},
					footer = {
						text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
						icon_url = config.webhookIcon
					},
					color = config.webhookColor
				}
			}
		}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterCommand('kickbugados',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if BR.hasPermission(user_id,"admin.permissao")then
        TriggerClientEvent('MQCU:bugado',-1)
    end
end)

RegisterServerEvent("MQCU:bugado")
AddEventHandler("MQCU:bugado",function()
    local user_id = BR.getUserId(source)
    if user_id == nil then
        local identifiers = GetPlayerIdentifiers(source)
        DropPlayer(source,"Hoje não.")
        identifiers = json.encode(identifiers)
        print("Player bugado encontrado: "..identifiers)
    end
end)

RegisterCommand("kicksrc",function(source,args,command)
  local user_id = BR.getUserId(source)
  if user_id then
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
      DropPlayer(args[1],"VOCE FOI KIKADO!")
    end
  end
end)

local webhookbansrc = "WEBHOOKAQUI"
RegisterCommand('bansrc',function(source,args,command)
  local user_id = BR.getUserId(source)
  if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
    local nsource = args[1]
    if(nsource)then
      local identifiers = {}
      local qtd = GetNumPlayerIdentifiers(nsource)
      for i=0,qtd do
        local idf = GetPlayerIdentifier(nsource,i)
        table.insert(identifiers,idf)
      end
      local nuser_id = BR.getUserIdByIdentifiers(identifiers)
      if(nuser_id)then
        print("[/bansrc] Player Banido com sucesso!  user_id: "..user_id)
        BR.setBanned(nuser_id,true)
        local msg = "User_id: "..nuser_id.."  banido pelo /bansrc"
        PerformHttpRequest(webhookbansrc, function(err, text, headers) end, 'POST', json.encode({content = msg}), { ['Content-Type'] = 'application/json' })
      else
        print("[/bansrc] user_id não encontrado!")
        print("[/bansrc] identifiers:\t",table.concat(identifiers,"\t").."\n")
        local msg = "user_id não localizado: "..table.concat(identifiers,"\t")
        PerformHttpRequest(webhookbansrc, function(err, text, headers) end, 'POST', json.encode({content = msg}), { ['Content-Type'] = 'application/json' })
      end
      DropPlayer(nsource, "[MQCU] Deu ruim pae...")
      print("[/bansrc] Source Kickada com sucesso!")
    end
  end
end)

BR._prepare("admin/get_license","SELECT steam FROM users WHERE id = @id")

function GetDiscordF(uid)
	local license = BR.query("admin/get_license",{ id = uid })
	iteration = 0
	count = 1
	local discord = "Não encontrado"
	while iteration < #license do
		iteration = iteration + 1
		discord = license[iteration].steam
	end
	local string1 = discord:gsub("discord:","")
	return string1
end


RegisterCommand('ban',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			local motivo = BR.prompt(source,"Digite um motivo:","")
			if motivo or motivo ~= "" then
				local nplayer = BR.getUserSource(parseInt(args[1]))
				BR.setBanned(args[1], true)
				local alvo = ""
				BR.kick(nplayer,"Você foi banido da cidade! [ Mais informações em: discord.gg/vicecity ]")
				alvo = "ID: ` "..args[1].." ` \nDISCORD: <@"..GetDiscordF(args[1])..">"
				TriggerClientEvent("Notify",source,"sucesso","Voce baniu o passaporte <b>"..args[1].."</b> da cidade.")
				BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[BANIU]: "..args[1].." \n[MOTIVO]: "..motivo..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "ban")
				PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{
						title = "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ **__NOVO BANIMENTO__** _ _ _ _ _ _ _ _",
						thumbnail = {
						url = "https://i.imgur.com/4rKUI93.png"
						},
						fields = {
							{
								name = "**STAFF:**",
								value = "` "..identity.name.." "..identity.firstname.." `   `"..user_id.."` "
							},
							{
								name = "**ALVO:**",
								value = alvo
							},
							{
								name = "**Motivo:**",
								value = "` "..motivo.." `"
							},
						},
						footer = {
							text = os.date("\nData: %d/%m/%Y - %H:%M:%S"),
							icon_url = "https://i.imgur.com/dNALubw.png"
						},
						color = 15914080
					}
				}
				}), { ['Content-Type'] = 'application/json' })
			else
				TriggerClientEvent("Notify",source,"negado","Você deve específicar um motivo.")
			end

		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			BR.setBanned(parseInt(args[1]),false)
			TriggerClientEvent("Notify",source,"sucesso","Voce desbaniu o passaporte <b>"..args[1].."</b> da cidade.")
			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "unban")

				PerformHttpRequest("", function(err, text, headers) end, 'POST', json.encode({
				embeds = {
					{
						title = "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ **__REMOVEU BANIMENTO__** _ _ _ _ _ _ _ _",
						thumbnail = {
						url = "https://i.imgur.com/4rKUI93.png"
						},
						fields = {
							{
								name = "**STAFF:**",
								value = "` "..identity.name.." "..identity.firstname.." `   `"..user_id.."` "
							},
							{
								name = "**ALVO:**",
								value = "` "..args[1].." ` "
							},
						},
						footer = {
							text = os.date("\nData: %d/%m/%Y - %H:%M:%S"),
							icon_url = "https://i.imgur.com/dNALubw.png"
						},
						color = 15914080
					}
				}
				}), { ['Content-Type'] = 'application/json' })
		end
	end
end) 

RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id, "lider-corretor.permissao") or BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then

		BRclient.toggleNoclip(source)
		local identity = BR.getUserIdentity(user_id)
		BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[USOU NC] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "noclip")
	end
end)

RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		local fcoords = BR.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		BRclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)

RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		local x,y,z = BRclient.getPosition(source)
		BR.prompt(source,"Cordenadas:","['x'] = "..tD(x)..", ['y'] = "..tD(y)..", ['z'] = "..tD(z))
	end
end)

RegisterCommand('cds2',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		local x,y,z = BRclient.getPosition(source)
		BR.prompt(source,"Cordenadas:",tD(x)..", "..tD(y)..", "..tD(z))
	end
end)

RegisterCommand('cds3',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		local x,y,z = BRclient.getPosition(source)
		BR.prompt(source,"Cordenadas:","{name='ATM', id=277, x="..tD(x)..", y="..tD(y)..", z="..tD(z).."},")
	end
end)

RegisterCommand('cds4',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		local x,y,z = BRclient.getPosition(source)
		BR.prompt(source,"Cordenadas:","x = "..tD(x)..", y = "..tD(y)..", z = "..tD(z))
	end
end)

RegisterCommand('reselect',function(source,args,rawCommand)
	local source = source
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if user_id then
			BR.rejoinServer(source)
			Citizen.Wait(1000)
			TriggerClientEvent("spawn:setupChars",source)
		end
	end
end)

--[[RegisterCommand('group',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	local nplayer = BR.getUserSource(parseInt(args[1]))
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] and args[2] then
			BR.addUserGroup(parseInt(args[1]),args[2])
			TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")

			BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "group")

			TriggerClientEvent("oc_gps:coords", nplayer)
		end
	end
end)]]

-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNGROUP ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
BR.prepare("system/getoff","SELECT dvalue FROM user_data WHERE dkey = 'BR:datatable' and user_id = @user")


RegisterCommand('ungroup',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"moderador.permissao") then
        if args[1] and args[2] then
			if checkSetGroup(user_id, args[2]) then
				local nplayer = BR.getUserSource(parseInt(args[1]))
				if nplayer then
					BR.removeUserGroup(parseInt(args[1]),args[2])
					TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
					SendWebhookMessage(webhookgroup,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DE-SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				else
					local datatable = BR.query("system/getoff", {user = args[1]})
					local data = json.decode(datatable[1].dvalue)
					if data.groups then
						data.groups[args[2]] = nil
					end
					BR.setUData(parseInt(args[1]),"BR:datatable",json.encode(data))
					TriggerClientEvent("Notify",source,"sucesso","Voce removeu o passaporte <b>"..parseInt(args[1]).."</b> do grupo <b>"..args[2].."</b>.")
					SendWebhookMessage(webhookgroup,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DE-SETOU]: "..args[1].." \n[GRUPO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end
			else 
				TriggerClientEvent("Notify",source,"negado","Você não pode remover um grupo maior que o seu.")
			end
        end
    end
end)

local hierarquia = {
	'manager','administrador','moderador','suporte'
}

function SendWebhookMessage(webhook,message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

function checkSetGroup(user_id, group)
	local userGroup = BR.getUserGroupByTypeIndex(user_id,'staff')
	local iuser, igroup = 0, 0
	print(userGroup)
	if userGroup then 
		for i in ipairs(hierarquia) do 
			if igroup == 0 and hierarquia[i] == group then 
				igroup = #hierarquia-i
			end 
			if iuser == 0 and hierarquia[i] == userGroup then 
				iuser = #hierarquia-i
			end
		end
	end
	print(iuser, igroup)
	return iuser >= igroup
end

local webhookgroup = ''

RegisterCommand('group',function(source,args,rawCommand)
	if source == 0 then
		if args[1] and args[2] then
			local nplayer = BR.getUserSource(parseInt(args[1]))
			if nplayer then
				BR.addUserGroup(parseInt(args[1]),args[2])
				print("[ONLINE] Voce setou o passaporte "..parseInt(args[1]).." no grupo "..args[2]..".")
			else
				local datatable = BR.query("system/getoff", {user = args[1]})
				local data = json.decode(datatable[1].dvalue)
				if data.groups then
					data.groups[args[2]] = true
				end
				BR.setUData(parseInt(args[1]),"BR:datatable",json.encode(data))
				
				print("[OFFLINE] Voce setou o passaporte "..parseInt(args[1]).." no grupo "..args[2]..".")
			end
		end
	else
		local user_id = BR.getUserId(source)
		local identity = BR.getUserIdentity(user_id)
		if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao")  then
			if args[1] and args[2] then
				if checkSetGroup(user_id, args[2]) then 
					local nplayer = BR.getUserSource(parseInt(args[1]))
					if nplayer then
						BR.addUserGroup(parseInt(args[1]),args[2])
						TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
						SendWebhookMessage(webhookgroup,"```prolog\n[ID]: "..tostring(user_id).." "..tostring(identity.name).." "..tostring(identity.firstname).." \n[SETOU]: "..tostring(args[1]).." \n[GRUPO]: "..tostring(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					else
						local datatable = BR.query("system/getoff", {user = args[1]})
						local data = json.decode(datatable[1].dvalue)
						if data.groups then
							data.groups[args[2]] = true
						end
						BR.setUData(parseInt(args[1]),"BR:datatable",json.encode(data))
						TriggerClientEvent("Notify",source,"sucesso","Voce setou o passaporte <b>"..parseInt(args[1]).."</b> no grupo <b>"..args[2].."</b>.")
						SendWebhookMessage(webhookgroup,"```prolog\n[ID]: "..tostring(user_id).." "..tostring(identity.name).." "..tostring(identity.firstname).." \n[SETOU]: "..tostring(args[1]).." \n[GRUPO]: "..tostring(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					end
				else 
					TriggerClientEvent("Notify",source,"negado","Você não pode setar um grupo maior que o seu.")
				end
			end
		end
	end
end)

RegisterCommand('anunciar',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
    if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") then
        local mensagem = BR.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("Notify",-1,'aviso',mensagem..'<br><br>Enviado por: '..tostring(identity.name), 15000)
    end
end)

local webhooktag = ''

RegisterCommand('anuncio',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id, 'policia.permissao') and BR.tryPayment(user_id,5000) then
        local mensagem = BR.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
		if mensagem:find('<%w+%s.+>') then 
			SendWebhookMessage(webhooktag,"```prolog\n[ID]: "..tostring(user_id).." "..tostring(identity.name).." "..tostring(identity.firstname).." \n[ENVIOU UMA MENSAGEM COM TAG]: "..mensagem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			return
		end
		TriggerClientEvent("Notify",-1,'amarelo',mensagem..'<br><br>Enviado por: '..tostring(identity.name), 15000)
    end
end)

RegisterCommand('festinha',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if BR.hasPermission(user_id,"manager.permission") then
        local identity = BR.getUserIdentity(user_id)
        local mensagem = BR.prompt(source,"Mensagem:","")
        if mensagem == "" then
            return
        end
        BRclient.setDiv(-1,"festinha"," @keyframes blinking {    0%{ background-color: #ff3d50; border: 2px solid #871924; opacity: 0.8; } 25%{ background-color: #d22d99; border: 2px solid #901f69; opacity: 0.8; } 50%{ background-color: #55d66b; border: 2px solid #126620; opacity: 0.8; } 75%{ background-color: #22e5e0; border: 2px solid #15928f; opacity: 0.8; } 100%{ background-color: #222291; border: 2px solid #6565f2; opacity: 0.8; }  } .div_festinha { font-size: 11px; font-family: arial; color: rgba(255, 255, 255,1); padding: 30px; top: 10%; right: 7%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; animation: blinking 1s infinite; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Festeiro(a): "..identity.name.." "..identity.firstname)
        SetTimeout(10000,function()
            BRclient.removeDiv(-1,"festinha")
        end)
    end
end)

RegisterCommand('status',function(source,args,rawCommand)
    local onlinePlayers = GetNumPlayerIndices()
    local policia = BR.getUsersByPermission("policia.permissao")
    local paramedico = BR.getUsersByPermission("paramedico.permissao")
    local mec = BR.getUsersByPermission("reparo.permissao")
    local bandidos = BR.getUsersByPermission("ilegal.permissao")
    local staff = BR.getUsersByPermission("suporte.permissao")
    local user_id = BR.getUserId(source)        
	TriggerClientEvent("Notify",source,"amarelo",
	"<bold><b>Jogadores</b>: <b>"..onlinePlayers..
	"<br>Bandidos</b>: <b>"..#bandidos..
	"<br>Suporte</b>: <b>"..#staff..
	"<br>Policiais</b>: <b>"..#policia..
	"<br>Paramédicos</b>: <b>"..#paramedico..
	"<br>Mecânicos</b>:  <b>"..#mec..
	"</b></bold>.",9000)
end)

RegisterCommand('limparinv',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
     if BR.hasPermission(user_id,"suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") then
		BR.clearInventory(user_id)
		TriggerClientEvent("Notify",source,"sucesso","Você <b>limpou seu inventário</b> com sucesso!")
    end
end)

RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			local tplayer = BR.getUserSource(parseInt(args[1]))
			local x,y,z = BRclient.getPosition(source)
			if tplayer then

				BRclient.teleport(tplayer,x,y,z)

				local identity = BR.getUserIdentity(user_id)
				local identity2 = BR.getUserIdentity(BR.getUserId(tplayer))
				BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ALVO]: "..args[1].." "..identity2.name.." "..identity2.firstname.." \n[TELEPORTOU PARA SI] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "tptome")
			end
		end
	end
end)

RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		if args[1] then
			local tplayer = BR.getUserSource(parseInt(args[1]))
			if tplayer then

				BRclient.teleport(source,BRclient.getPosition(tplayer))

				local identity = BR.getUserIdentity(user_id)
				local identity2 = BR.getUserIdentity(BR.getUserId(tplayer))
				BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ALVO]: "..args[1].." "..identity2.name.." "..identity2.firstname.." \n[TELEPORTOU PARA ELE] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "tpto")
			end
		end
	end
end)

RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)

	if BR.hasPermission(user_id, "suporte.permissao") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"manager.permission") then

		TriggerClientEvent('tptoway',source)
		local identity = BR.getUserIdentity(user_id)
		local x,y,z = BRclient.getPosition(source)
		BR.log("```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[TELEPORTOU PARA COORDS] "..tD(x)..", "..tD(y)..", "..tD(z).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```", "tpway")
	end
end)

-----------------------------------------------------------------
-- SPAWNAR ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
local qtdAmmunition = 250
local itemlist = {
    ["WEAPON_PISTOL_MK2"] = { arg = "fiveseven" },
    ["WEAPON_ASSAULTSMG"] = { arg = "21" },
	["WEAPON_RAYPISTOL"] = { arg = "raio" },
    ["WEAPON_ASSAULTRIFLE"] = { arg = "ak103" },
    ["WEAPON_PROXMINE"] = { arg = "zk1" },
    ["WEAPON_RPG"] = { arg = "zk2" },
	["WEAPON_MINIGUN"] = { arg = "zk3" },
	["WEAPON_RAYPISTOL"] = { arg = "zk4" } 
}

RegisterCommand('arma',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if BR.hasPermission(user_id,"manager.permission") then
        if args[1] then
            for k,v in pairs(itemlist) do
                if v.arg == args[1] then
                    result = k
                    BRclient.giveWeapons(source,{[result] = { ammo = qtdAmmunition }})
                end
            end
        end
    end
end)

RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"manager.permission") then
		TriggerClientEvent('delnpcs',source)
	end
end)

RegisterCommand('pon',function(source,args,rawCommand)
    local user_id = BR.getUserId(source)
    if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao") then
        local users = BR.getUsers()
        local players = ""
		local quantidade = 0

        for k,v in pairs(users) do
            if k ~= #users then
                players = players
			end

            players = players.." "..k
            quantidade = quantidade + 1
		end

        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{255,160,0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{255,160,0},players)
    end
end)

function BRidd.getPermissao()
	local source = source
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao") then
		return true
	else
		return false
	end
end

RegisterCommand('ids',function(source,args,rawCommand)
	local source = source
	local user_id = BR.getUserId(source)
	if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"moderador.permissao") or BR.hasPermission(user_id,"suporte.permissao") then
		TriggerClientEvent("mostrarid",source)
	end
end)

function BRidd.logID()
	local source = source
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	local x,y,z = BRclient.getPosition(source)

	PerformHttpRequest(config.Corno, function(err, text, headers) end, 'POST', json.encode({
		embeds = {
			{
				title = "REGISTRO DE ID VISIVEL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
				thumbnail = {
				url = config.webhookIcon
				},
				fields = {
					{
						name = "**COLABORADOR DA EQUIPE:**",
						value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]\n⠀"
					},
					{
						name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**",
						value = "⠀"
					}
				},
				footer = {
					text = "DIAMOND"..os.date("%d/%m/%Y |: %H:%M:%S"),
					icon_url = config.webhookIcon
				},
				color = config.webhookColor
			}
		}
	}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('staff',function(source,args,rawCommand)
	local user_id = BR.getUserId(source)
	local identity = BR.getUserIdentity(user_id)
	local cargo = nil
	local status = nil

	if BR.hasPermission(user_id,"manager.permission") then
		cargo = "Manager"
		status = "Saiu do modo administrativo."
		BR.addUserGroup(user_id,"off-manager")
		TriggerClientEvent("Notify",source,"negado","<b>[MANAGER]</b> OFF.")
		TriggerEvent('eblips:remove',source)

	elseif BR.hasPermission(user_id,"off-manager.permission") then
		cargo = "Manager"
		status = "Entrou no modo administrativo."
		BR.addUserGroup(user_id,"manager")
		TriggerClientEvent("Notify",source,"sucesso","<b>[MANAGER]</b> ON.")

		TriggerEvent('eblips:add',{ name = "Staff", src = source, color = 83 })

	elseif BR.hasPermission(user_id,"administrador.permissao") then
		cargo = "Administrador"
		status = "Saiu do modo administrativo."
		BR.addUserGroup(user_id,"off-administrador")
		TriggerClientEvent("Notify",source,"negado","<b>[ADMINISTRADOR]</b> OFF.")
		TriggerEvent('eblips:remove',source)

	elseif BR.hasPermission(user_id,"off-administrador.permissao") then
		cargo = "Administrador"
		status = "Entrou no modo administrativo."
		BR.addUserGroup(user_id,"administrador")
		TriggerClientEvent("Notify",source,"sucesso","<b>[ADMINISTRADOR]</b> ON.")
		TriggerEvent('eblips:add',{ name = "Staff", src = source, color = 83 })

	elseif BR.hasPermission(user_id,"moderador.permissao") then
		cargo = "Moderador"
		status = "Saiu do modo administrativo."
		BR.addUserGroup(user_id,"off-moderador")
		TriggerClientEvent("Notify",source,"negado","<b>[MODERADOR]</b> OFF.")
		TriggerEvent('eblips:remove',source)

	elseif BR.hasPermission(user_id,"off-moderador.permissao") then
		cargo = "Moderador"
		status = "Entrou no modo administrativo."
		BR.addUserGroup(user_id,"moderador")
		TriggerClientEvent("Notify",source,"sucesso","<b>[MODERADOR]</b> ON.")
		TriggerEvent('eblips:add',{ name = "Staff", src = source, color = 83 })

	elseif BR.hasPermission(user_id,"suporte.permissao") then
		cargo = "Suporte"
		status = "Saiu do modo administrativo."
		BR.addUserGroup(user_id,"off-suporte")
		TriggerClientEvent("Notify",source,"negado","<b>[SUPORTE]</b> OFF.")
		TriggerEvent('eblips:remove',source)

	elseif BR.hasPermission(user_id,"off-suporte.permissao") then
		cargo = "Suporte"
		status = "Entrou no modo administrativo."
		BR.addUserGroup(user_id,"suporte")
		TriggerClientEvent("Notify",source,"sucesso","<b>[SUPORTE]</b> ON.")
		TriggerEvent('eblips:add',{ name = "Staff", src = source, color = 83 })

	end
	--[[PerformHttpRequest(config.Status, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                title = "REGISTRO ADMINISTRATIVO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                thumbnail = {
                    url = config.webhookIcon
                },
                fields = {
                    {
                        name = "**IDENTIFICAÇÃO: "..identity.name.." "..identity.firstname.."** [**"..user_id.."**]",
                        value = "⠀"
					},
					{
                        name = "**CARGO: **"..cargo,
						value = "⠀",
						inline = true
					},
					{
                        name = "**STATUS: **"..status,
						value = "⠀",
						inline = true
                    }
                },
                footer = {
                    text = config.webhookBottomText..os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = config.webhookIcon
                },
                color = config.webhookColor
            }
        }
    }), { ['Content-Type'] = 'application/json' })]]
end)

local plan = {}

RegisterCommand("plano", function(source,args)
	local source = source
	local user_id = BR.getUserId(source)
	if args[1] == "add" then
		if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
			if BR.getUserSource(tonumber(args[2])) then
				if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
					local consulta = BR.getUData(tonumber(args[2]),"BR:plano")
					local resultado = json.decode(consulta) or {}
					resultado.tempo = (resultado.tempo or 0)+tonumber(args[3])*1440
					plan[BR.getUserId(source)] = resultado.tempo
					BR.setUData(tonumber(args[2]), "BR:plano", json.encode(resultado))
				end
			end
		end
	elseif args[1] == "info" then
		local consulta = BR.getUData(BR.getUserId(source),"BR:plano")
		local resultado = json.decode(consulta) or {}

		resultado.tempo = resultado.tempo or 0
		resultado = resultado.tempo/1440 or 0

		TriggerClientEvent("Notify",source,"amarelo","<b>Dias Restantes:</b> "..math.ceil(resultado))
	end
end)

function BRidd.getId(sourceplayer)
	local user_id = BR.getUserId(sourceplayer)
	return user_id
end

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end

local run = {}

RegisterCommand("vip", function(source,args)
	local source = source
	local user_id = BR.getUserId(source)
	local nuser_id = parseInt(args[2])
	if args[1] == "add" then
		local vip = args[3]
		if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
			if vip == "ultimate" then
				BR.addUserGroup(nuser_id,"ultimate")
				TriggerClientEvent("Notify", source, "sucesso","ID "..args[1].." setado de Ultimate pass.")
				if BR.getUserSource(tonumber(args[2])) then
					if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
						local consulta = BR.getUData(tonumber(args[2]),"BR:vip")
						local resultado = json.decode(consulta) or {}
						resultado.tempo = (resultado.tempo or 0)+tonumber(args[4])*1440
						run[BR.getUserId(source)] = resultado.tempo
						BR.setUData(tonumber(args[2]), "BR:vip", json.encode(resultado))
					end
				end
			elseif 	vip == "platina" then
				BR.addUserGroup(nuser_id,"platinum")
				TriggerClientEvent("Notify", source, "sucesso","ID "..args[1].." setado de Platina pass.")
				if BR.getUserSource(tonumber(args[2])) then
					if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
						local consulta = BR.getUData(tonumber(args[2]),"BR:vip")
						local resultado = json.decode(consulta) or {}
						resultado.tempo = (resultado.tempo or 0)+tonumber(args[4])*1440
						run[BR.getUserId(source)] = resultado.tempo
						BR.setUData(tonumber(args[2]), "BR:vip", json.encode(resultado))
					end
				end
			elseif 	vip == "ouro" then
				BR.addUserGroup(nuser_id,"gold")
				TriggerClientEvent("Notify", source, "sucesso","ID "..args[1].." setado de Ouro pass.")
				if BR.getUserSource(tonumber(args[2])) then
					if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
						local consulta = BR.getUData(tonumber(args[2]),"BR:vip")
						local resultado = json.decode(consulta) or {}
						resultado.tempo = (resultado.tempo or 0)+tonumber(args[4])*1440
						run[BR.getUserId(source)] = resultado.tempo
						BR.setUData(tonumber(args[2]), "BR:vip", json.encode(resultado))
					end
				end
			elseif 	vip == "standard" then
				BR.addUserGroup(nuser_id,"standard")
				TriggerClientEvent("Notify", source, "sucesso","ID "..args[1].." setado de Standard pass.")
				if BR.getUserSource(tonumber(args[2])) then
					if BR.hasPermission(user_id,"manager.permission") or BR.hasPermission(user_id,"administrador.permissao") then
						local consulta = BR.getUData(tonumber(args[2]),"BR:vip")
						local resultado = json.decode(consulta) or {}
						resultado.tempo = (resultado.tempo or 0)+tonumber(args[4])*1440
						run[BR.getUserId(source)] = resultado.tempo
						BR.setUData(tonumber(args[2]), "BR:vip", json.encode(resultado))
					end
				end

			end
		end
	elseif args[1] == "rem" then
		if BR.getUserSource(tonumber(args[2])) then
			if BR.hasPermission(BR.getUserId(source),"manager.permission") or BR.hasPermission(BR.getUserId(source),"administrador.permissao") then
				local consulta = BR.getUData(tonumber(args[2]),"BR:vip")
				local resultado = json.decode(consulta) or {}
				resultado.tempo = (resultado.tempo or 0)-tonumber(args[3])*1440
				if resultado.tempo < 0 then resultado.tempo = 0 end
				run[BR.getUserId(source)] = resultado.tempo
				BR.setUData(tonumber(args[2]), "BR:vip", json.encode(resultado))
			end
		end
	elseif args[1] == "status" then
		local user_id = BR.getUserId(source)
		local consulta = BR.getUData(BR.getUserId(source),"BR:vip")
		local resultado = json.decode(consulta) or {}
		local pass = ""

		if BR.hasPermission(user_id,"ultimate.permissao") then
			pass = "Ultimate"
		elseif BR.hasPermission(user_id,"platina.permissao") then
			pass = "Platina"
		elseif BR.hasPermission(user_id,"ouro.permissao") then
			pass = "Ouro"
		elseif BR.hasPermission(user_id,"standard.permissao") then
			pass = "Standard"
		end

		resultado.tempo = resultado.tempo or 0
		resultado = resultado.tempo/1440 or 0

		TriggerClientEvent("Notify",source,"amarelo","<b>Pass:</b> "..pass.." | <b>Dias Restantes:</b> "..math.ceil(resultado))
	end
end)

RegisterCommand('bvida',function(source,rawCommand)
	local user_id = BR.getUserId(source)
	BRclient._setCustomization(source,BRclient.getCustomization(source))
	BR.removeCloak(source)
	TriggerEvent("barbershop:init",user_id)
end)

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end


