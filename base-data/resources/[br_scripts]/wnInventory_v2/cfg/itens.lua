
local active = {}
local actived = {}
local bandagem = {}
local amountUse = {}
local uchests = {}
local vchests = {}
local syringeTime = {}
local pick = {}
local blips = {}

local miraContagem = 0
local compensadorContagem = 0
local silenciadorContagem = 0
local carregadorContagem = 0
local gripContagem = 0

local Tunnel = module("br_core","lib/Tunnel")
local Proxy = module("br_core","lib/Proxy")
local Tools = module("br_core","lib/Tools")
BR = Proxy.getInterface("BR")
BRclient = Tunnel.getInterface("BR")
local idgens = Tools.newIDGenerator()

UseItemInventory = function(itemName,type,ramount,user_id,vGARAGE,vHOMES,vTASKBAR,vPLAYER,cRP)
    local source = source
	local data = BR.getUserAptitudes(user_id)
    if user_id and ramount ~= nil and parseInt(ramount) >= 0 and not actived[user_id] and actived[user_id] == nil then 
            if type == "usar" then
                if itemName == "bandagem" then
                    vida = BRclient.getHealth(source)
                    if vida > 101 and vida < 400 then
                    
                        if bandagem[user_id] == 0 or not bandagem[user_id] then
                            if BR.tryGetInventoryItem(user_id,"bandagem",1) then
                                actived[user_id] = true
                                BRclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
                                TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                                TriggerClientEvent('cancelando',source,true)
                                TriggerClientEvent("progress",source,20000,"bandagem")
                                SetTimeout(20000,function()
                                    actived[user_id] = nil
                                    bandagem[user_id] = 240
                                    vCLIENT.SetBandagem(source, 99)
                                    TriggerClientEvent('cancelando',source,false)
                                    BRclient._DeletarObjeto(source)
                                    TriggerClientEvent("Notify",source,"sucesso","Bandagem utilizada com sucesso.",8000)
                                end)
                            end
                        else
                            TriggerClientEvent("Notify",source,"importante","Você precisa aguardar <b>"..bandagem[user_id].." segundos</b> para utilizar outra Bandagem.",8000)
                        end
                    else
                        TriggerClientEvent("Notify",source,"negado","Você não pode utilizar de vida cheia ou nocauteado.",8000)
                    end
                elseif itemName == "mochila" then
                    if BR.tryGetInventoryItem(user_id,"mochila",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        BR.varyExp(user_id,"physical","strength",650)
                        TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
                    end

				elseif itemName == "moduloxenon" then
                    TriggerClientEvent('zo_install_mod_xenon',source)	
                elseif itemName == "moduloneon" then
                    TriggerClientEvent('zo_install_mod_neon',source)	
                elseif itemName == "suspensaoar" then
                    TriggerClientEvent('zo_install_suspe_ar',source)	

                elseif itemName == "carregador" then
                    if BR.tryGetInventoryItem(user_id,"carregador",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent('equiparAttachs',source,"carregador")	
                        TriggerClientEvent('cancelando',source,false)
                    end

                elseif itemName == "silenciador" then
                    if BR.tryGetInventoryItem(user_id,"silenciador",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent('equiparAttachs',source,"silenciador")	
                        TriggerClientEvent('cancelando',source,false)
                    end

                elseif itemName == "mira" then
                    if BR.tryGetInventoryItem(user_id,"mira",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent('equiparAttachs',source,"mira")	
                        TriggerClientEvent('cancelando',source,false)
                    end

                elseif itemName == "grip" then
                    if BR.tryGetInventoryItem(user_id,"grip",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent('equiparAttachs',source,"grip")	
                        TriggerClientEvent('cancelando',source,false)
                    end

                elseif itemName == "compensador" then
                    if BR.tryGetInventoryItem(user_id,"compensador",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent('equiparAttachs',source,"compensador")	
                        TriggerClientEvent('cancelando',source,false)
                    end

                elseif itemName == "bolso" then
                    if BR.tryGetInventoryItem(user_id,"bolso",1) then
                        cRP.AddBolso()
                    end

                elseif itemName == "capuz" then
                    if BR.getInventoryItemAmount(user_id,"capuz") >= 1 and BR.tryGetInventoryItem(user_id,"capuz",1) then
                        local nplayer = BRclient.getNearestPlayer(source,2)
                        if nplayer then
                            BRclient.setCapuz(nplayer)
                            BR.closeMenu(nplayer)
                            TriggerClientEvent("Notify",source,"sucesso","Capuz utilizado com sucesso.",8000)
                        end
                    end

                elseif itemName == "cocaina" then
                    if BR.tryGetInventoryItem(user_id,"cocaina",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)

                        BRclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                        TriggerClientEvent("progress",source,5000,"Usando Catuaba")
                        Wait(5000)
                        BRclient._stopAnim(source,false)
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent('energeticos',source,true)
                        TriggerClientEvent("setCocaine",source,10)
                        BRclient.playScreenEffect(source,"RaceTurbo",30)
                        TriggerClientEvent("Notify",source,"sucesso","Voce ficou eletrico.",8000)
                        Wait(30000)
                        TriggerClientEvent('energeticos',source,false)
                        TriggerClientEvent("Notify",source,"aviso","As suas energias acabaram.",8000)
                    end

                elseif itemName == "folhademaconha" then
                    if BR.tryGetInventoryItem(user_id,"folhademaconha",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)

                        BRclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                        TriggerClientEvent("progress",source,5000,"Usando Catuaba")
                        Wait(5000)
                        BRclient._stopAnim(source,false)
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent('energeticos',source,true)
                        TriggerClientEvent("setCocaine",source,10)
                        BRclient.playScreenEffect(source,"RaceTurbo",30)
                        TriggerClientEvent("Notify",source,"sucesso","Voce ficou eletrico.",8000)
                        Wait(30000)
                        TriggerClientEvent('energeticos',source,false)
                        TriggerClientEvent("Notify",source,"aviso","As suas energias acabaram.",8000)
                    end

                elseif itemName == "catuaba" then
                    if BR.tryGetInventoryItem(user_id,"catuaba",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","offstore_catuaba",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Catuaba")
                        Wait(10000)
                        BRclient._DeletarObjeto(source)
                        BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent("setDrunkTime",source,60)
                        TriggerClientEvent("Notify",source,"sucesso","Catuaba utilizada com sucesso.",8000)
                    end

                elseif itemName == "jurupinga" then
                    if BR.tryGetInventoryItem(user_id,"jurupinga",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","offstore_jurupinga",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Jurupinga")
                        Wait(10000)
                        BRclient._DeletarObjeto(source)
                        BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent("setDrunkTime",source,60)
                        TriggerClientEvent("Notify",source,"sucesso","Jurupinga utilizada com sucesso.",8000)
                    end

                elseif itemName == "smirnoff" then
                    if BR.tryGetInventoryItem(user_id,"smirnoff",1) then
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","offstore_smirnoff",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Smirnoff")
                        Wait(10000)
                        BRclient._DeletarObjeto(source)
                        BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",80)
                        BRclient.playScreenEffect(source,"RaceTurbo",80)
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent("setDrunkTime",source,80)
                        TriggerClientEvent("Notify",source,"sucesso","Smirnoff utilizada com sucesso.",8000)
                    end

                elseif itemName == "blacklabel" then
                    if BR.tryGetInventoryItem(user_id,"blacklabel",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo blacklabel")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma blacklabel.",8000)
                        end)
                    end

                elseif itemName == "jackdaniels" then
                    if BR.tryGetInventoryItem(user_id,"jackdaniels",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo jackdaniels")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma jackdaniels.",8000)
                        end)
                    end

                elseif itemName == "royalsalute" then
                    if BR.tryGetInventoryItem(user_id,"royalsalute",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo royalsalute")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma royalsalute.",8000)
                        end)
                    end

                elseif itemName == "corona" then
                    if BR.tryGetInventoryItem(user_id,"corona",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo corona")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma corona.",8000)
                        end)
                    end

                elseif itemName == "heinekin" then
                    if BR.tryGetInventoryItem(user_id,"heinekin",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo heinekin")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma heinekin.",8000)
                        end)
                    end
                
                elseif itemName == "budweiser" then
                    if BR.tryGetInventoryItem(user_id,"budweiser",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo budweiser")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma budweiser.",8000)
                        end)
                    end

                elseif itemName == "brahma" then
                    if BR.tryGetInventoryItem(user_id,"brahma",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo brahma")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma brahma.",8000)
                        end)
                    end

                elseif itemName == "licor43" then
                    if BR.tryGetInventoryItem(user_id,"licor43",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo licor43")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma licor43.",8000)
                        end)
                    end

                elseif itemName == "chandon" then
                    if BR.tryGetInventoryItem(user_id,"chandon",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo chandon")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma chandon.",8000)
                        end)
                    end

                elseif itemName == "51" then
                    if BR.tryGetInventoryItem(user_id,"51",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo 51")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma 51.",8000)
                        end)
                    end

                elseif itemName == "velhobarreiro" then
                    if BR.tryGetInventoryItem(user_id,"velhobarreiro",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo velhobarreiro")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma velhobarreiro.",8000)
                        end)
                    end

                elseif itemName == "bananinha" then
                    if BR.tryGetInventoryItem(user_id,"bananinha",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo bananinha")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma bananinha.",8000)
                        end)
                    end

                elseif itemName == "caipirinha" then
                    if BR.tryGetInventoryItem(user_id,"caipirinha",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo caipirinha")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma caipirinha.",8000)
                        end)
                    end

                elseif itemName == "redbull" then
                    if BR.tryGetInventoryItem(user_id,"redbull",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo redbull")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma redbull.",8000)
                        end)
                    end
                    
                elseif itemName == "redbullmelancia" then
                    if BR.tryGetInventoryItem(user_id,"redbullmelancia",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo redbullmelancia")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma redbullmelancia.",8000)
                        end)
                    end

                elseif itemName == "fontt" then
                    if BR.tryGetInventoryItem(user_id,"fontt",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo fontt")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma fontt.",8000)
                        end)
                    end
                    
                elseif itemName == "tanqueray" then
                    if BR.tryGetInventoryItem(user_id,"tanqueray",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo tanqueray")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma tanqueray.",8000)
                        end)
                    end

                elseif itemName == "itubaina" then
                    if BR.tryGetInventoryItem(user_id,"itubaina",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo itubaina")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma itubaina.",8000)
                        end)
                    end

                
                elseif itemName == "cocacola" then
                    if BR.tryGetInventoryItem(user_id,"cocacola",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo cocacola")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma cocacola.",8000)
                        end)
                    end

                elseif itemName == "fanta" then
                    if BR.tryGetInventoryItem(user_id,"fanta",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo fanta")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma fanta.",8000)
                        end)
                    end
                
                elseif itemName == "fantauva" then
                    if BR.tryGetInventoryItem(user_id,"fantauva",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo fantauva")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma fantauva.",8000)
                        end)
                    end

                elseif itemName == "sprite" then
                    if BR.tryGetInventoryItem(user_id,"sprite",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo sprite")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma sprite.",8000)
                        end)
                    end
                    
                elseif itemName == "aguadecoco" then
                    if BR.tryGetInventoryItem(user_id,"aguadecoco",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo aguadecoco")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            BRclient.playScreenEffect(source,"DrugsTrevorClownsFight",20)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma aguadecoco.",8000)
                        end)
                    end 

                elseif itemName == "agua" then
                    if BR.tryGetInventoryItem(user_id,"agua",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ba_prop_club_water_bottle",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Agua")
                        SetTimeout(10000,function()
                            vthirst = -20
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu uma Agua.",8000)
                        end)
                    end

                elseif itemName == "coco" then
                    if BR.tryGetInventoryItem(user_id,"coco",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","offstore_coco",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Coco")
                        SetTimeout(10000,function()
                            vthirst = -50
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu um Coco.",8000)
                        end)
                    end


                elseif itemName == "cafe" then
                    if BR.tryGetInventoryItem(user_id,"cafe",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_aa_coffee@idle_a","idle_a","mah_frap",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Cafe")
                        SetTimeout(10000,function()
                            vthirst = -35
                            BR.varyThirst(user_id,vthirst)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce bebeu um Cafe.",8000)
                        end)
                    end

                elseif itemName == "donut" then
                    if BR.tryGetInventoryItem(user_id,"donut",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","mah_donut",49,28422)
                        TriggerClientEvent("progress",source,10000,"Comendo Donut")
                        SetTimeout(10000,function()
                            vhunger = -50
                            BR.varyHunger(user_id,vhunger)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce comeu um Donut.",8000)
                        end)
                    end

                elseif itemName == "burger" then
                    if BR.tryGetInventoryItem(user_id,"burger",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","mah_burger",49,28422)
                        TriggerClientEvent("progress",source,10000,"Comendo Burger")
                        SetTimeout(10000,function()
                            vhunger = -50
                            BR.varyHunger(user_id,vhunger)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce comeu um Burger.",8000)
                        end)
                    end

                elseif itemName == "pizza" then
                    if BR.tryGetInventoryItem(user_id,"pizza",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)

                        BRclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","mah_pizza",49,28422)
                        TriggerClientEvent("progress",source,10000,"Comendo Pizza")
                        SetTimeout(10000,function()
                            vhunger = -70
                            BR.varyHunger(user_id,vhunger)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce comeu uma Pizza.",8000)
                        end)
                    end


                elseif itemName == "pipoca" then
                    if BR.tryGetInventoryItem(user_id,"pipoca",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@code_human_wander_drinking@beer@male@base","static","mah_popcorn",49,28422)
                        TriggerClientEvent("progress",source,10000,"Comendo Pipoca")
                        SetTimeout(10000,function()
                            vhunger = -50
                            BR.varyHunger(user_id,vhunger)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce comeu uma Pipoca.",8000)
                        end)
                    end

                elseif itemName == "hotdog" then
                    if BR.tryGetInventoryItem(user_id,"hotdog",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","mah_hotdog",49,28422)
                        TriggerClientEvent("progress",source,10000,"Comendo Hotdog")
                        SetTimeout(10000,function()
                            vhunger = -70
                            BR.varyHunger(user_id,vhunger)
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Voce comeu uma Hotdog.",8000)
                        end)
                    end

                
                elseif itemName == "pneu" then
					if not BRclient.inVehicle(source) then
						local vehicle,vehNet = BRclient.vehList(source,5)
						if vehicle then
							if BR.tryGetInventoryItem(user_id,itemName,1) then
								BRclient.closeInventory(source)
								TriggerClientEvent("emotes",source,'ajoelhar')
								Citizen.Wait(1000)
								TriggerClientEvent("emotes",source,'pneu')
								TriggerClientEvent("progress",source,5000,"Arrumando pneus")
								TriggerClientEvent('arrumarpneus',source)
							end
						end
					end            

                    

                elseif itemName == "energetico" then
                    if BR.tryGetInventoryItem(user_id,"energetico",1) then
                        actived[user_id] = true
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        BRclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","offstore_monster",49,28422)
                        TriggerClientEvent("progress",source,10000,"Bebendo Energetico")
                        SetTimeout(10000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('energeticos',source,true)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Energético utilizado com sucesso.",8000)
                        end)
                        SetTimeout(60000,function()
                            TriggerClientEvent('energeticos',source,false)
                            TriggerClientEvent("Notify",source,"importante","O efeito do energético passou e o coração voltou a bater normalmente.",8000)
                        end)
                    end
                --[[elseif itemName == "lockpick" then
                    local timer_lock = math.random(100)
                    local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = BRclient.vehList(source,7)
                    local policia = BR.getUsersByPermission(policia_perm)
                    if #policia < quantidade_policia_lockpick then
                        TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais no momento para iniciar o roubo.")
                        return true
                    end
                    if BR.hasPermission(user_id,policia_perm) then
                        TriggerEvent("setPlateEveryone",placa)
                        vGARAGE.vehicleClientLock(-1,vnetid,lock)
                        TriggerClientEvent("br_core_sound:source",source,'lock',0.5)
                        return
                    end
                    if BR.getInventoryItemAmount(user_id,"lockpick") >= 1 and BR.tryGetInventoryItem(user_id,"lockpick",1) and vehicle then
                        actived[user_id] = true
                        if BR.hasPermission(user_id,policia_perm) then
                            actived[user_id] = nil
                            TriggerEvent("setPlateEveryone",placa)
                            vGARAGE.vehicleClientLock(-1,vnetid,lock)
                            return
                        end

                        TriggerClientEvent('cancelando',source,true)
                        BRclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                        TriggerClientEvent("progress",source,5000,"Usando LockPick")
                        SetTimeout(5000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._stopAnim(source,false)

                            if timer_lock >= 20 then
                                print(timer_lock)
                                TriggerEvent("setPlateEveryone",placa)
                                vGARAGE.vehicleClientLock(-1,vnetid,lock)
                                TriggerClientEvent("br_core_sound:source",source,'lock',0.5)
                            else
                                print(timer_lock)
                                TriggerClientEvent("Notify",source,"negado","Roubo do veículo falhou e as autoridades foram acionadas.",8000)
                                local policia = BR.getUsersByPermission(policia_perm)
                                local x,y,z = BRclient.getPosition(source)
                                for k,v in pairs(policia) do
                                    local player = BR.getUserSource(parseInt(v))
                                    if player then
                                        async(function()
                                            local id = idgens:gen()
                                            BRclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                                            TriggerClientEvent('chatMessage',player,"911 - ",{64,64,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
                                            pick[id] = BRclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
                                            SetTimeout(20000,function() BRclient.removeBlip(player,pick[id]) idgens:free(id) end)
                                        end)
                                    end
                                end
                            end
                        end)
                    end]]

                elseif itemName == "lockpick" then
                    local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = BRclient.vehList(source,7)
                    --local policia = BR.getUsersByPermission(policia_perm)
                    local policia = BR.getUsersByPermission(mecanico_perm)
                    if #policia < 0 then
                        TriggerClientEvent("Notify",source,"negado","Número insuficiente de policiais no momento para iniciar o roubo!")
                        return true
                    end
                    --if BR.hasPermission(user_id,policia_perm) then
                    if BR.hasPermission(user_id,mecanico_perm) then
                        if BR.tryGetInventoryItem(user_id,"lockpick",1) then
                        vCLIENT.closeInventory(source)
                        TriggerClientEvent("Notify",source,"negado","Membros da policia não podem usar isso, perdeu uma lockpick!")
                       -- TriggerClientEvent("Notify",source,"negado","Lockpick quebrou")
                        TriggerClientEvent('cancelando',source,false)				
                    return true
                    end
                end
                    if BR.getInventoryItemAmount(user_id,"lockpick") >= 1 and BR.tryGetInventoryItem(user_id,"lockpick",1) and vehicle then
                        actived[user_id] = true
                        TriggerClientEvent('cancelando',source,true)
                        vCLIENT.closeInventory(source)
                        BRclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                        local taskResult = vTASKBAR.taskThree(source)                     
                        --BRclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                        TriggerClientEvent("progress",source,2000,"roubando")
                        SetTimeout(2000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._stopAnim(source,false)
                            if taskResult then
                            if math.random(100) >= 0 then
                                TriggerEvent("setPlateEveryone",placa)
                                vGARAGE.vehicleClientLock(-1,vnetid,lock)
                            TriggerClientEvent("br_core_sound:source",source,'lock',0.5)
                            TriggerClientEvent("Notify",source,"sucesso","Roubo bem sucedido!",8000)
                            TriggerClientEvent("Notify",source,"aviso","As autoridades foram acionadas!",8000)
                                local policia = BR.getUsersByPermission(policia_perm)
                                --local policia = BR.getUsersByPermission(mecanico_perm)
                                local x,y,z = BRclient.getPosition(source)
                                for k,v in pairs(policia) do
                                    local player = BR.getUserSource(parseInt(v))
                                    if player then
                                        async(function()
                                            local id = idgens:gen()
                                            BRclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                                            TriggerClientEvent('chatMessage',player,"911 - ",{64,64,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
                                            pick[id] = BRclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
                                            SetTimeout(20000,function() BRclient.removeBlip(player,pick[id]) idgens:free(id) end)
                                        end)
                                    end
                                end
                            else					
                            end
                        else
                            TriggerClientEvent("Notify",source,"negado","Você errou e o roubo falhou, perdeu uma lockpick!",8000)
                            --TriggerClientEvent("Notify",source,"negado","Lockpick quebrou!.",8000)
                            --TriggerClientEvent("Notify",source,"aviso","As autoridades foram acionadas!",8000)
                                --[[local policia = BR.getUsersByPermission(policia_perm)
                                local x,y,z = BRclient.getPosition(source)
                                for k,v in pairs(policia) do
                                    local player = BR.getUserSource(parseInt(v))
                                    if player then
                                        async(function()
                                            local id = idgens:gen()
                                            BRclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
                                            TriggerClientEvent('chatMessage',player,"911 - ",{64,64,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
                                            pick[id] = BRclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
                                            SetTimeout(20000,function() BRclient.removeBlip(player,pick[id]) idgens:free(id) end)
                                        end)
                                    end
                                end]]
                        
                            end
                        end)
                    end

                elseif itemName == "skate" then
                    TriggerClientEvent("skate",source)
                    
                elseif itemName == "repairkit" then
                    if not BRclient.isInVehicle(source) then
                        local vehicle = BRclient.getNearestVehicle(source,3.5)
                        if vehicle then
                            if BR.hasPermission(user_id,mecanico_perm) then
                                --local taskResult = vTASKBAR.taskLockpick(source)
                                --if taskResult then
                                    actived[user_id] = true
                                    TriggerClientEvent('cancelando',source,true)
                                    BRclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                    TriggerClientEvent("progress",source,30000,"Reparando Veiculo")
                                    SetTimeout(30000,function()
                                        actived[user_id] = nil
                                        TriggerClientEvent('cancelando',source,false)
                                        TriggerClientEvent('reparar',source)
                                        BRclient._stopAnim(source,false)
                                    end)
                                --end

                            else
                                if BR.tryGetInventoryItem(user_id,"repairkit",1) then
                                    --local taskResult = vTASKBAR.taskLockpick(source)
                                    --if taskResult then
                                        actived[user_id] = true
                                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                                        TriggerClientEvent('cancelando',source,true)
                                        BRclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                        TriggerClientEvent("progress",source,30000,"Reparando Veiculo")
                                        SetTimeout(30000,function()
                                            actived[user_id] = nil
                                            TriggerClientEvent('cancelando',source,false)
                                            TriggerClientEvent('reparar',source)
                                            BRclient._stopAnim(source,false)
                                        end)
                                    --end
                                end
                            end
                        end
                    end
                
                elseif itemName == "militec" then
                    if not BRclient.isInVehicle(source) then
                        local vehicle = BRclient.getNearestVehicle(source,3.5)
                        if vehicle then
                            if BR.hasPermission(user_id,"mecanico.permission") then
                                actived[user_id] = true
                                TriggerClientEvent('cancelando',source,true)
                                vCLIENT.closeInventory(source)
                                BRclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                TriggerClientEvent("progress",source,30000,"reparando motor")
                                SetTimeout(30000,function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando',source,false)
                                    TriggerClientEvent('repararmotor',source,vehicle)
                                    BRclient._stopAnim(source,false)
                                end)
                            else
                                if BR.tryGetInventoryItem(user_id,"militec",1) then
                                    actived[user_id] = true
                                    TriggerClientEvent('Creative:Update',source,'updateMochila')
                                    TriggerClientEvent('cancelando',source,true)
                                    BRclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                    TriggerClientEvent("progress",source,30000,"reparando motor")
                                    SetTimeout(30000,function()
                                        actived[user_id] = nil
                                        TriggerClientEvent('cancelando',source,false)
                                        TriggerClientEvent('repararmotor',source,vehicle)
                                        BRclient._stopAnim(source,false)
                                    end)
                                end
                            end
                        end
                    end
                
                elseif itemName == "colete" then
                    if BR.tryGetInventoryItem(user_id,"colete",1) then
            
                            BRclient._playAnim(source,false,{{"missfbi3_camcrew","final_loop_guy"}},true)
                            TriggerClientEvent('cancelando',source,true)
                            TriggerClientEvent("progress",source,10000,"Usando Colete")
                            Wait(10000)
                            TriggerClientEvent('cancelando',source,false)
                            BRclient._stopAnim(source,false)
                            BRclient.setArmour(source,100)
                            TriggerClientEvent("Notify",source,"sucesso","Voce usou um colete com sucesso.",8000)
                            TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                    end	
                end
            elseif type == "equipar" then
                if BR.tryGetInventoryItem(user_id,itemName,1) then
                    local weapons = {}
                    local identity = BR.getUserIdentity(user_id)
                    weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
                    BRclient._giveWeapons(source,weapons)
                    PerformHttpRequest(log_equipar_arma, function(err, text, headers) end, 'POST', json.encode({
                        embeds = {
                            { 
                                title = "REGISTRO DE INVENTARIO",
                                thumbnail = {
                                    url = imagem
                                }, 
                                fields = {
                                    { 
                                        name = "**EQUIPOU:**", 
                                        value = "` ["..BR.itemNameList(itemName).."] `"
                                    },
                                    { 
                                        name = "**QUEM EQUIPOU:**", 
                                        value = "` "..identity.name.." "..identity.firstname.." ["..user_id.."] `"
                                    }
                                }, 
                                footer = { 
                                    text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
                                    icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
                                },
                                color = 15914080 
                            }
                        }
                    }), { ['Content-Type'] = 'application/json' })
                    TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                end
            elseif type == "recarregar" then
                local uweapons = BRclient.getWeapons(source)
                local weaponuse = string.gsub(itemName,"wammo|","")
                local identity = BR.getUserIdentity(user_id)
                if uweapons[weaponuse] then				
                    if BR.tryGetInventoryItem(user_id,"wammo|"..weaponuse,parseInt(ramount)) then
                        local weapons = {}
                        weapons[weaponuse] = { ammo = parseInt(ramount) }
                        BRclient._giveWeapons(source,weapons,false)
                        PerformHttpRequest(log_recarregar_arma, function(err, text, headers) end, 'POST', json.encode({
                            embeds = {
                                { 
                                    title = "REGISTRO DE INVENTARIO",
                                    thumbnail = {
                                        url = imagem
                                    }, 
                                    fields = {
                                        { 
                                            name = "**RECARREGOU:**", 
                                            value = "` ["..BR.itemNameList(itemName).."] `"
                                        },
                                        { 
                                            name = "**MUNIÇÃO:**", 
                                            value = "` ["..parseInt(ramount).."] `"
                                        },
                                        { 
                                            name = "**QUEM RECARREGOU:**", 
                                            value = "` "..identity.name.." "..identity.firstname.." ["..user_id.."] `"
                                        }
                                    }, 
                                    footer = { 
                                        text = "Data e hora: " ..os.date("%d/%m/%Y | %H:%M:%S"),
                                        icon_url = "https://www.autoriafacil.com/wp-content/uploads/2019/01/icone-data-hora.png"
                                    },
                                    color = 15914080 
                                }
                            }
                        }), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('br_core_inventory:Update',source,'updateMochila')
                    end
                end
            end
        end
end