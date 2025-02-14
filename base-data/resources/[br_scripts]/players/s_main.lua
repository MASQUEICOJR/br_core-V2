AddEventHandler('ox_inventory:openedInventory', function(playerId)
    local user_id = BR.getUserId(playerId)
    local phys = math.floor( BR.expToLevel( BR.getExp(user_id, "physical", "strength") ) ) * 5
    exports.ox_inventory:SetMaxWeight(playerId, phys * 1000)
end)


