Config = {}

Config.Main = {
    cmd = 'painel', -- Comando para abrir Painel
    cmdAdm = 'paineladm', -- Comando para abrir Painel ADM
    createAutomaticOrganizations = true,
    storeUrl = 'br_core.com.br', -- Link da Sua Loja
    serverLogo = '',
    blackList = 3, -- Tempo de black em dias (3 Dia(s))
    clearChestLogs = 15, -- Logs do Bau limpar automaticamente de 15 em 15 dias. ( Evitar consumo da tabela )
}

Config.defaultPermissions = { 
    invite = { -- Permissao Para Convidar
        name = "Convidar",
        description = "Esta permissao permite vc convidar as pessoas para sua facção."
    },
    demote = { -- Permissao Para Rebaixar
        name = "Rebaixar",
        description = "Essa permissão permite que o cargo selecionado rebaixe um cargo inferior."
    }, 
    promote = { -- Permissao Para Promover
        name = "Promover",
        description = "Essa permissão permite que o cargo selecionado promova um cargo."
    }, 
    dismiss = { -- Permissao Para Rebaixar
        name = "Demitir",
        description = "Essa permissão permite que o cargo selecionado demita um cargo inferior."
    }, 
    withdraw = { -- Permissao Para Sacar Dinheiro
        name = "Sacar dinheiro",
        description = "Permite que esse cargo selecionado possa sacar dinheiro do banco da facção."
    }, 
    deposit = { -- Permissao Para Depositar Dinheiro
        name = "Depositar dinheiro",
        description = "Permite que esse cargo selecionado possa depositar dinheiro no banco da facção."
    }, 
    message = { -- Permissao para Escrever nas anotaçoes
        name = "Escrever anotações",
        description = "Permite que esse cargo selecionado possa escrever anotações."
    },
    alerts = { -- Permissao para enviar alertas
        name = "Escrever Alertas",
        description = "Permite que esse cargo selecionado possa enviar alertas para todos jogadores."
    },
    chat = { -- Permissao para Falar no chat
        name = "Escrever no chat",
        description = "Permite que esse cargo selecionado possa se comunicar no chat da facção"
    },
}

Config.Groups = {

    -- Continue com a mesma estrutura para cada zona até o zona 40

    ['Mafia01'] = { --------------ARMAS----------------
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                     ['pecadearma'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                     ['mola'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['Lider [MAFIA01]'] = { prefix = 'Lider', tier = 1 },
            ['Sub-Lider [MAFIA01]'] = { prefix = 'Gerente', tier = 2 },
            ['Gerente [MAFIA01]'] = { prefix = 'Membro', tier = 3 },
            ['Membro [MAFIA01]'] = { prefix = 'Membro', tier = 4 },
            ['Novato [MAFIA01]'] = { prefix = 'Membro', tier = 5 },
        }
    },

    ['Yakuza'] = { ---------------- MUNICAO -------------------
    Config = {
        Salary = { -- SALARIO FAC
            active = false, -- Se vai esta ativo ou nao
            amount = 50000, -- Valor que vai receber
            time = 10, -- tempo em tempo que vai receber salario em minuto(s)
        },

        Goals = { -- METAS
            defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
            itens = {
                ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
            }
        }
    },

    List = {
        ['Lider [YAKUZA]'] = { prefix = 'Lider', tier = 1 },
        ['Sub-Lider [YAKUZA]'] = { prefix = 'Gerente', tier = 2 },
        ['Gerente [YAKUZA]'] = { prefix = 'Membro', tier = 3 },
        ['Membro [YAKUZA]'] = { prefix = 'Membro', tier = 4 },
        ['Novato [YAKUZA]'] = { prefix = 'Membro', tier = 5 },
        }
    },

    ['Furious'] = { -------------DESMANCHE---------------
    Config = {
        Salary = { -- SALARIO FAC
            active = false, -- Se vai esta ativo ou nao
            amount = 50000, -- Valor que vai receber
            time = 10, -- tempo em tempo que vai receber salario em minuto(s)
        },

        Goals = { -- METAS
            defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
            itens = {
                ['opio'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
            }
        }
    },

        List = {
            ['Lider [FURIOUS]'] = { prefix = 'Lider', tier = 1 },
            ['Sub-Lider [FURIOUS]'] = { prefix = 'Gerente', tier = 2 },
            ['Gerente [FURIOUS]'] = { prefix = 'Membro', tier = 3 },
            ['Membro [FURIOUS]'] = { prefix = 'Membro', tier = 4 },
            ['Novato [FURIOUS]'] = { prefix = 'Membro', tier = 5 },
        }
    },

    ['Vanilla'] = { --------------LAVAGEM--------------------------
    Config = {
        Salary = { -- SALARIO FAC
            active = false, -- Se vai esta ativo ou nao
            amount = 50000, -- Valor que vai receber
            time = 10, -- tempo em tempo que vai receber salario em minuto(s)
        },

        Goals = { -- METAS
            defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
            itens = {
                ['dietilamida'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                ['nitratoamonia'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
            }
        }
    },

        List = {
            ['Lider [VANILLA]'] = { prefix = 'Lider', tier = 1 },
            ['Sub-Lider [VANILLA]'] = { prefix = 'Gerente', tier = 2 },
            ['Gerente [VANILLA]'] = { prefix = 'Membro', tier = 3 },
            ['Membro [VANILLA]'] = { prefix = 'Membro', tier = 4 },
            ['Novato [VANILLA]'] = { prefix = 'Membro', tier = 5 },
        }
    },

    ['Canada'] = { --------------DROGAS----------------
    Config = {
        Salary = { -- SALARIO FAC
            active = false, -- Se vai esta ativo ou nao
            amount = 50000, -- Valor que vai receber
            time = 10, -- tempo em tempo que vai receber salario em minuto(s)
        },

        Goals = { -- METAS
            defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
            itens = {
                ['pecadearma'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                ['mola'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
            }
        }
    },

        List = {
            ['Lider [CANADA]'] = { prefix = 'Lider', tier = 1 },
            ['Sub-Lider [CANADA]'] = { prefix = 'Gerente', tier = 2 },
            ['Gerente [CANADA]'] = { prefix = 'Membro', tier = 3 },
            ['Membro [CANADA]'] = { prefix = 'Membro', tier = 4 },
            ['Novato [CANADA]'] = { prefix = 'Membro', tier = 5 },
        }
    },

    ['Mecanica'] = { --------------MECANICA----------------
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    -- ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['Lider [MECANICA]'] = { prefix = 'Lider', tier = 1 },
            ['Sub-Lider [MECANICA]'] = { prefix = 'Sub-Lider', tier = 2 },
            ['Gerente [MECANICA]'] = { prefix = 'Gerente', tier = 3 },
            ['Membro [MECANICA]'] = { prefix = 'Membro', tier = 4 },
            ['Novato [MECANICA]'] = { prefix = 'Novato', tier = 5 },
        }
    },

    ['Hospital'] = {
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    -- ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },
        List = {
            ['Diretor'] = { prefix = 'Diretor', tier = 1 },
            ['Vice Diretor'] = { prefix = 'Vice Diretor', tier = 2 },
            ['Gestao'] = { prefix = 'Gestao', tier = 4 },
            ['Psicologo'] = { prefix = 'Psicologo', tier = 5 },
            ['Medico'] = { prefix = 'Medico', tier = 6 },
            ['Enfermeiro'] = { prefix = 'Enfermeiro', tier = 7 },
            ['Paramedico'] = { prefix = 'Paramedico', tier = 8 },
        }
    },

    ['hpilegal'] = {
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    ['aminoacidotirosina'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                    ['alcaloide'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                    ['ampola'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['Diretorhpilegal'] = {
                prefix = 'Diretor',
                tier = 1
            },
            ['Gerentehpilegal'] = {
                prefix = 'Gerente',
                tier = 2
            },
            ['Membrohpilegal'] = {
                prefix = 'Membro',
                tier = 3
            },
        }
    },

    ['Pearls'] = {
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['donoPearls'] = {
                prefix = 'Dono',
                tier = 1
            },
            ['gerentePearls'] = {
                prefix = 'Gerente',
                tier = 2
            },
            ['supervisorPearls'] = {
                prefix = 'Supervisor',
                tier = 3
            },
            ['funcionarioPearls'] = {
                prefix = 'Funcionario',
                tier = 4
            },
        }
    },

    ['Vip'] = {
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    -- ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['Prata'] = {
                prefix = 'Prata',
                tier = 1
            },
        }
    },

    ['Policia'] = {
        Config = {
            Salary = { -- SALARIO FAC
                active = false, -- Se vai esta ativo ou nao
                amount = 50000, -- Valor que vai receber
                time = 10, -- tempo em tempo que vai receber salario em minuto(s)
            },

            Goals = { -- METAS
                defaultReward = 300, -- Valor Padrão da recompensa ( obs Lider consegue alterar in-game )
                itens = {
                    -- ['polvora'] = 50, -- Quantidade Padrão da recompensa ( obs Lider consegue alterar in-game )
                }
            }
        },

        List = {
            ['Comandante'] = { prefix = 'Comandante', tier = 1 },
            ['Subcmd'] = { prefix = 'Sub Comandante', tier = 2 },
            ['Major'] = { prefix = 'Major', tier = 3 },
            ['Capitao'] = { prefix = 'Capitao', tier = 4 },
            ['1Tenente'] = { prefix = '1Tenente', tier = 5 },
            ['2Tenente'] = { prefix = '2Tenente', tier = 6 },
            ['Subtenente'] = { prefix = 'Subtenente', tier = 7 },
            ['1Sargento'] = { prefix = '1Sargento', tier = 8 },
            ['2Sargento'] = { prefix = '2Sargento', tier = 9 },
            ['3Sargento'] = { prefix = '3Sargento', tier = 10 },
            ['Cabo'] = { prefix = 'Cabo', tier = 11 },
            ['Soldado'] = { prefix = 'Soldado', tier = 12 },
            ['Recruta'] = { prefix = 'Recruta', tier = 13 },
        }
    },

}

Config.Langs = {
    ['offlinePlayer'] = function(source) TriggerClientEvent("Notify", source,"negado","Este jogador não está online.",5000) end,
    ['alreadyFaction'] = function(source) TriggerClientEvent("Notify", source,"negado","Este jogador já esta em uma organização.",5000)  end,
    ['alreadyBlacklist'] = function(source) TriggerClientEvent("Notify", source,"negado","Você está na black-list, não pode receber convites.",5000)  end,
    ['alreadyUserBlacklist'] = function(source) TriggerClientEvent("Notify",source,"negado","Este jogador está em black-list.",5000)  end,
    ['sendInvite'] = function(source) TriggerClientEvent("Notify",source,"sucesso","Você enviou o convite.",5000)  end,
    ['acceptInvite'] = function(source) TriggerClientEvent("Notify",source,"sucesso","Você aceitou o convite.",5000) end,
    ['acceptedInvite'] = function(source, ply_id) TriggerClientEvent("Notify",source,"sucesso","O "..ply_id.." aceitou o convite. ",5000) end,
    ['bestTier'] = function(source) TriggerClientEvent("Notify",source,"negado","Você não pode fazer isso com alguem com um cargo igual ou maior que o seu.",5000)   end,
    ['youPromoved'] = function(source) TriggerClientEvent("Notify",source,"sucesso","Você foi promovido.",5000)  end,
    ['youPromovedUser'] = function(source, ply_id, group) TriggerClientEvent("Notify",source,"sucesso","Você promoveu o ID: "..ply_id.." para "..group..".",5000) end,
    ['youDemote'] = function(source) TriggerClientEvent("Notify",source,"sucesso","Você foi rebaixado.",5000)  end,
    ['youDemoteUser'] = function(source, ply_id, group) TriggerClientEvent("Notify",source,"sucesso","Você rebaixou o ID: "..ply_id.." para ".. group ..".",5000) end,
    ['youDismiss'] = function(source) TriggerClientEvent("Notify",source,"sucesso","Você foi demitido de sua organização .",5000)  end,
    ['youDismissUser'] = function(source, ply_id) TriggerClientEvent("Notify", source,"sucesso","Você demitiu o ID "..ply_id.." .",5000)  end,
    ['waitCooldown'] = function(source) TriggerClientEvent("Notify",source,"negado","Aguarde para fazer isso..",5000) end,
    ['bankNotMoney'] = function(source) TriggerClientEvent("Notify",source,"negado","O Banco da organização não possui essa quantia.",5000)  end,
    ['rewardedGoal'] = function(source, amount) TriggerClientEvent("Notify",source,"sucesso","Você resgatou sua meta diaria e recebeu <b>R$ "..amount.."</b> por isso.",5000) end,
    ['notPermission'] = function(source) TriggerClientEvent("Notify",source,"negado","Você não possui permissão.",5000)  end,
    ['notMoneyDeposit'] = function(source) TriggerClientEvent("Notify",source,"negado","Você não possui dinheiro para depositar.",5000)  end

}

if SERVER then
    -- CUSTOM QUERYS
    BR.prepare('br_orgs/GetUsersGroup', " SELECT user_id,dvalue FROM user_data WHERE dkey = 'BR:datatable' ")
    BR.prepare("br_orgs/getUserGroup", "SELECT user_id,dvalue FROM user_data WHERE dkey = 'BR:datatable' and user_id = @user_id")
    BR.prepare("br_orgs/updateUserGroup", "UPDATE user_data SET dvalue = @dvalue WHERE user_id = @user_id and dkey = 'BR:datatable'")

    -- CAPTURAR GRUPOS COM JOGADOR OFFLINE
    function getUserGroups(user_id)
        local rows = BR.query("br_orgs/getUserGroup", { user_id = user_id })
        local data = json.decode(rows[1].dvalue) or {}

        if #rows == 0 then 
            return 
        end

        return data.groups
    end

    -- SETAR GRUPO COM JOGADOR OFFLINE
    function updateUserGroups(user_id, groups)
        local rows = BR.query("br_orgs/getUserGroup", { user_id = user_id })
        local data = json.decode(rows[1].dvalue) or {}

        if #rows == 0 then 
            return 
        end

        if not groups then
            groups = {}
        end

        data.groups = groups

        BR.execute("br_orgs/updateUserGroup", { user_id = user_id, dvalue = json.encode(data) })
    end

    -- PEGAR DINHEIRO DO BANCO DO JOGADOR
    function getBankMoney(user_id)
        return BR.getBankMoney(user_id)
    end

    -- IDENTIDADE
    function getUserIdentity(user_id)
        local identity = BR.getUserIdentity(user_id)
        if identity.nome then
            identity.name = identity.nome
            identity.firstname = identity.sobrenome
        end

        if identity.name2 then
            identity.firstname = identity.name2
        end

        return identity
    end

    function getUserSource(user_id)
        return BR.getUserSource(user_id)
    end

    function getUserId(source)
        return BR.getUserId(source)
    end

    function getUsers()
        --user_id,source
        return BR.getUsers()
    end

    function getUserMyGroups(user_id)
        return BR.getUserGroups(user_id)
    end

    function hasGroup(user_id, group)
        return BR.hasGroup(user_id, group)
    end

    function addUserGroup(user_id, group)
        return BR.addUserGroup(user_id, group)
    end

    function tryFullPayment(user_id, amount)
        return BR.tryFullPayment(user_id, amount)
    end

    function giveBankMoney(user_id, amount)
        if user_id and amount and tonumber(amount) then 
            return BR.giveBankMoney(user_id, amount)
        end
    end

    function getBankMoney(user_id)
        return BR.getBankMoney(user_id)
    end

    function getItemName(item)
        return BR.getItemName(item) or item
    end

    function request(source, text, time)
        return BR.request(source, text, time)
    end

    function removeUserGroup(user_id, group)
        return BR.removeUserGroup(user_id, group)
    end

    -- REMOVER BLACKLIST
    RegisterCommand('blacklist', function(source,args)
        local user_id = getUserId(source)
        if not user_id then return end

        local ply_id = tonumber(args[1])
        if not ply_id then return end

        if BR.hasPermission(user_id,"administrador.permissao") or BR.hasPermission(user_id,"developer.permissao") then
            TriggerClientEvent("Notify", source, "sucesso","Você removeu a blacklist do ID: "..ply_id..".",5000) 
            BLACKLIST:remUser(ply_id)
        end
    end)

    AddEventHandler('BR:playerSpawn', function(user_id, source)
        TriggerEvent('br_orgs:playerSpawn', user_id, source)
    end)

    AddEventHandler('BR:playerLeave', function(user_id)
        TriggerEvent('br_orgs:playerLeave', user_id)
    end)
end


--[[ 
    Como Utilizar EXPORT de Guardar / Retirar Item no Bau:
    ( Colocar Esse EXPORT na função de retirar/guardar item de seu inventario)
    
    user_id: user_id, -- ID Do Jogador,
    action: withdraw or deposit, -- Ação que foi feita Retirou/Depositou
    item: item, -- Spawn do item que foi retirado/guardado.
    amount: quantidade, -- Quantidade do item que foi depositada/retirada

    EXPORT: 
    exports.br_orgs:addLogChest(user_id, action, item, amount)
]]

--[[ 
    Como Utilizar EXPORT De METAS DIARIAS:
    ( Colocar esse EXPORT na função de Guardar Itens no Armazem ou Coletar Itens no Farm )

    user_id: user_id, -- ID Do Jogador,
    item: item, -- Spawn do item que foi guardado/farmado.
    amount: quantidade, -- Quantidade do item que foi guardada/farmada.

    EXPORT: 
    exports.br_orgs:addGoal(user_id, item, amount)
]]