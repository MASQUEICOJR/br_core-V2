local cfg = lib.load('@br_core.cfg.base')
local config = cfg?.loggin_system or 'database'
local webhooks = lib.load('@br_core.webhook') or {}

local function WriteToDatabase(_type, data)
    _type = _type or 'system'
    if type(data) == "table" then data = json.encode(data) end
    BR.insert('BR/addlog', { _type, data })
end

local function WriteToDiscord(name, data)
    local p = promise.new()
    if not webhooks[name] then
        p:reject('Webhook not found to ' .. name)
    else
        if type(data) == "string" then
            PerformHttpRequest(webhooks[name], function(status, _, _, err)                
                p:resolve(status == 200 or status == 204)
            end, 'POST', json.encode({ content = data }), { ["Content-Type"] = "application/json" })
        elseif type(data) == "table" and type(data?.build) == "function" then
            PerformHttpRequest(webhooks[name], function(status)
                p:resolve(status == 200 or status == 204)
            end, 'POST', json.encode({ embeds = { data:build() } }), { ["Content-Type"] = "application/json" })
        elseif type(data) == "table" then
            PerformHttpRequest(webhooks[name], function(status)
                p:resolve(status == 200 or status == 204)
            end, 'POST', json.encode({ embeds = { data } }), { ["Content-Type"] = "application/json" })
        end
    end
    return p
end

function BR.log(name, _type, data)
    if config == 'database' then
        return WriteToDatabase(_type, data)
    elseif config == 'discord' then
        return WriteToDiscord(name, data)
    else
        lib.print.info('LOG', json.encode(data))
    end
end


exports('CreateLog', BR.log)