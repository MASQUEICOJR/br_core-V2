

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BR.prepare('br_orgs/bank/getinfo', 'SELECT bank,bank_historic FROM orgs_info WHERE organization = @organization')
BR.prepare('br_orgs/bank/updateBank', 'UPDATE orgs_info SET bank = @bank, bank_historic = @historic WHERE organization = @organization')
BR.prepare('br_orgs/updateConfigGoals', 'UPDATE orgs_info SET config_goals = @config_goals WHERE organization = @organization')
BR.prepare('br_orgs/myGoals', ' SELECT * FROM orgs_goals WHERE user_id = @user_id and organization = @organization and day = @day and month = @month ')
BR.prepare('br_orgs/updateFarm', 'UPDATE orgs_goals SET step = @step, reward_step = @reward_step WHERE user_id = @user_id AND organization = @organization AND month = @month AND day = @day')
BR.prepare('br_orgs/getDailyFarms', 'SELECT * FROM orgs_goals WHERE organization = @organization and day = @day and month = @month ORDER BY amount DESC')
BR.prepare('br_orgs/addPlayerFarm', 'INSERT IGNORE INTO orgs_goals(organization, user_id, item, amount, day, month) VALUES(@organization, @user_id, @item, @amount, @day, @month) ON DUPLICATE KEY UPDATE amount = amount + @amount;')

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GOALS = {
    cooldown = {}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.getFarms()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    local query = BR.query('br_orgs/getDailyFarms', { organization = user.groupType, day = os.date('%d'), month = os.date('%m') })
    local t = {}
    for i = 1, #query do
        local ply = query[i]
        local ply_identity = getUserIdentity(ply.user_id)
        if not ply_identity then goto next_player end

        local nuser = Organizations.Members[ply.user_id]
        if not nuser then goto next_player end

        t[#t + 1] = {
            name = ('%s %s'):format(ply_identity.name, ply_identity.firstname),
            id = ply.user_id,
            role = Config.Groups[nuser.groupType] and Config.Groups[nuser.groupType].List[nuser.group].prefix or "Desconhecido",
            item = getItemName(ply.item) or ply.item,
            amount = ply.amount,
            status = ply.step > 1,
        }

        :: next_player ::
    end

    return t
end

function RegisterTunnel.getGoals()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    local myGoals = BR.query('br_orgs/myGoals', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m') }) or {}
    local myItems, concluded_items = {}, 0
    for i = 1, #myGoals do
        local goal = myGoals[i]
        
        local valid_goal = Organizations.goalsConfig[user.groupType].info.itens
        if valid_goal[goal.item] then
            local maxItem = valid_goal[goal.item]

            myItems[goal.item] = {
                amount = goal.amount,
                step = goal.step
            }

            if myItems[goal.item].amount >= (maxItem * myItems[goal.item].step) then
                concluded_items = (concluded_items + 1)
            end
        end
    end

    local goalsItens,totalItems = {}, 0
    for item, maxItem in pairs(Organizations.goalsConfig[user.groupType].info.itens) do
        totalItems = (totalItems + 1)

        goalsItens[#goalsItens + 1] = {
            name = getItemName(item),
            item = item,
            quantity = myItems[item] and myItems[item].amount or 0,
            total = myItems[item] and maxItem * myItems[item].step or maxItem
        }
    end

    return {
        goalsReedemed = (concluded_items >= totalItems),
        items = goalsItens
    }
end

function RegisterTunnel.rewardGoal()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local identity = getUserIdentity(user_id)
    if not identity then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    if GOALS.cooldown[user_id] and (GOALS.cooldown[user_id] - os.time()) > 0 then
        return Config.Langs['waitCooldown'](source)
    end
    GOALS.cooldown[user_id] = (os.time() + 5)

    local myGoals = BR.query('br_orgs/myGoals', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m') }) or {}
    if #myGoals <= 0 or not myGoals[1] then
        return
    end

    local concluded_items = 0
    for i = 1, #myGoals do
        local goal = myGoals[i]
        
        local valid_goal = Organizations.goalsConfig[user.groupType].info.itens
        if valid_goal[goal.item] then
            local maxItem = valid_goal[goal.item]

            if goal.amount >= (maxItem * goal.step) then
                concluded_items = (concluded_items + 1)
            end
        end
    end

    local totalItems = 0
    for item, maxItem in pairs(Organizations.goalsConfig[user.groupType].info.itens) do
        totalItems = (totalItems + 1)
    end

    if concluded_items < totalItems then
        return
    end

    local reward_step = myGoals[1].reward_step
    if myGoals[1].step >= 1 then
        reward_step = (reward_step + 1)
    end
    BR.execute('br_orgs/updateFarm', { user_id = user_id, organization = user.groupType, day = os.date('%d'), month = os.date('%m'), reward_step = reward_step, step = (myGoals[1].step + 1) })

    -- PAGAR META
    local query = BR.query('br_orgs/bank/getinfo', { organization = user.groupType })
    if #query == 0 then return end

    local amount = Organizations.goalsConfig[user.groupType].info.defaultReward or 0
    if not amount or not query[1].bank then
        return
    end
    if amount > query[1].bank then
        return Config.Langs['bankNotMoney'](source)
    end

    local bank_value = (query[1].bank - amount)
    local generate_log = BANK:generateLog(json.decode(query[1].bank_historic), {
        name = ('%s %s'):format(identity.name, identity.firstname),
        type = "META DIARIA",
        value = amount,
        date = os.date('%d/%m/%Y %X'),
    })

    BR.execute('br_orgs/bank/updateBank', { organization = user.groupType, bank = bank_value, historic = json.encode(generate_log) })
    BR.giveBankMoney(user_id, amount)

    Config.Langs['rewardedGoal'](source, amount)
    return true
end

function RegisterTunnel.getListGoals()
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end

    local goal = Organizations.goalsConfig[user.groupType].info
    local t  = {}
    for item, amount in pairs(goal.itens) do
        t[#t + 1] = {
            item = item,
            name = getItemName(item) or item,
            amount = amount
        }
    end

    return t
end

function RegisterTunnel.saveGoals(data)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    local hasPermission = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group].leader or false
    if not hasPermission then
        return
    end

    local t = {}
    for index in pairs(data.goals) do
        if not t.info then 
            t.info = {
                defaultReward = data.reward,
                itens = {}
            }
        end

        t.info.itens[data.goals[index].item] = data.goals[index].amount
    end

    if Organizations.goalsConfig[user.groupType] then
        Organizations.goalsConfig[user.groupType] = t
    end

    BR.execute('br_orgs/updateConfigGoals', { organization = user.groupType, config_goals = json.encode(t) })
end

exports('addGoal', function(user_id, item, amount)
    user_id = parseInt(user_id)
    local source = getUserSource(user_id)
    if not source then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if not Organizations.goalsConfig[user.groupType] then return end
    if not Organizations.goalsConfig[user.groupType].info.itens[item] then return end

    BR.execute('br_orgs/addPlayerFarm', { organization = user.groupType, user_id = user_id, item = item, amount = amount, day = os.date('%d'), month = os.date('%m') })
end)