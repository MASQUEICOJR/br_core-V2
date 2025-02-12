-- PREPARES
BR.prepare("br_orgs/getChestLogs", "SELECT * FROM orgs_logs WHERE organization = @organization ORDER BY expire_at DESC LIMIT 150")
BR.prepare("br_orgs/addChestLog", "INSERT INTO orgs_logs (organization, user_id, role, name, description, date, expire_at) VALUES(@organization, @id, @role, @name, @message, @time, @expire_at)")

-- CACHE LOGS
local chestLogCache = {}
local chestLogCacheAdd = {}

-- TUNNELS
function RegisterTunnel.getLogs()
    local source = source
    local user_id = getUserId(source)
    local t = {}

    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    if chestLogCache[user.groupType] then
        t = chestLogCache[user.groupType]
        return t
    end

    local query = BR.query('br_orgs/getChestLogs', { organization = user.groupType })
    for i = 1, #query do
        t[#t + 1] = {
            name = query[i].name,
            id = query[i].user_id,
            role = query[i].role,
            message = query[i].description,
            time = query[i].date,
            expire_at = query[i].expire_at
        }
    end

    chestLogCache[user.groupType] = t
    return t
end

-- EXPORTS
exports('addLogChest', function(user_id, action, item, amount)
    user_id = parseInt(user_id)

    local user = Organizations.Members[user_id]
    if not user then return end

    local identity = getUserIdentity(user_id)
    if not identity then return end

    local logEntry = {
        id = user_id,
        name = ('%s %s'):format(identity.name, identity.firstname),
        role = Config.Groups[user.groupType].List[user.group].prefix,
        message = ('%s %dx %s'):format(action == 'withdraw' and 'Retirou' or 'Guardou', amount, item),
        time = os.date('%d/%m/%Y %X'),
        expire_at = os.time() + (Config.Main.clearChestLogs * 86400)
    }


    if not chestLogCache[user.groupType] then
        chestLogCache[user.groupType] = {}
    end

    if not chestLogCacheAdd[user.groupType] then
        chestLogCacheAdd[user.groupType] = {}
    end

    table.insert(chestLogCache[user.groupType], logEntry)
    table.insert(chestLogCacheAdd[user.groupType], logEntry)
end)

-- SYNC DATABASE
local function syncChestLogsWithDatabase()
    for groupType, logs in pairs(chestLogCacheAdd) do
        print(json.encode(logs))
        for _, log in ipairs(logs) do
            log.organization = groupType
            BR.execute('br_orgs/addChestLog', log)
        end
        chestLogCacheAdd[groupType] = {}
    end
end

-- -- CREATE CACHE
-- local function createCache()
--     for _, user in pairs(Organizations.Members) do
--         local logs = BR.query('br_orgs/getChestLogs', { organization = user.groupType })
--         if logs then
--             print(json.encode(logs))
--             chestLogCache[user.groupType] = logs
--             print(('^2[%s] ^0Logs puxada com sucesso.'):format(GetCurrentResourceName():upper()))
--         end
--     end
-- end

-- -- MAIN THREAD
-- CreateThread(function()
--     Wait(1000)
--     print(('^2[%s] ^0Puxando logs no banco de dados!'):format(GetCurrentResourceName():upper()))
--     createCache()
-- end)

-- SAVE CACHE ON STOP
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print(('^2[%s] ^0Salvando logs no banco de dados!'):format(GetCurrentResourceName():upper()))
        syncChestLogsWithDatabase()
    end
end)    