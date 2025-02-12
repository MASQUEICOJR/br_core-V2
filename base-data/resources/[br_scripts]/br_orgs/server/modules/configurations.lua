
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TUNNELS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RegisterTunnel.getPermissions(role)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    return Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][role] or {}
end

function RegisterTunnel.updatePermissions(role_id, perms)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    local hasPermission = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group].leader or false
    if not hasPermission then
        return
    end

    if Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][role_id] then
        Organizations.Permissions[user.groupType][role_id] = perms
    end

    BR.execute('br_orgs/UpdatePermissions', { organization = user.groupType, permissions = json.encode(Organizations.Permissions[user.groupType]) })

    return true
end

function RegisterTunnel.updateConfig(data)
    local source = source
    local user_id = getUserId(source)
    if not user_id then return end

    local user = Organizations.Members[user_id]
    if not user then return end

    local hasPermission = Organizations.Permissions[user.groupType] and Organizations.Permissions[user.groupType][user.group].leader or false
    if not hasPermission then
        return
    end

    BR.execute('br_orgs/updateFacInfo', { organization = user.groupType, logo = data.logo, discord = data.discord })

    return true
end