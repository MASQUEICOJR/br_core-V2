local items = {}

local function bvest_choices(args)
  local choices = {}

  choices["Wear"] = {function(player, choice)
    local user_id = BR.getUserId(player)
    if user_id then
      if BR.tryGetInventoryItem(user_id, args[1], 1, true) then -- take vest
        BRclient._setArmour(player, 100)
      end
    end
  end}

  return choices
end

items["bulletproof_vest"] = {"Bulletproof Vest", "A handy protection.", bvest_choices, 1.5}

return items
