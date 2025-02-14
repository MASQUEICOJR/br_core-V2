function BR.getMoney(user_id, moneytype)  
  moneytype = moneytype or 'cash'
  return BR.getPlayerTable(user_id)?.money[moneytype] or 0.0
end

-- set money
function BR.setMoney(user_id, value, moneytype, reason, notify)
  moneytype = moneytype or 'cash'
  local src = BR.getUserSource(user_id)
  local player = BR.getPlayerTable(user_id)
  if not player then
    return false
  end

  player.money[moneytype] = value >= 0 and value or 0
  if notify and reason then
    BR.notify(source, 'Money', reason, 5000, "inform")
  end

  TriggerEvent('BR:PlayerMoneyUpdate', user_id, value, moneytype)
  TriggerClientEvent('BR:client:PlayerMoneyUpdate', src, value, moneytype)  
  return true
end

-- try a payment
-- return true or false (debited if true)
function BR.tryPayment(user_id, amount, reason, notify)
  local money = BR.getMoney(user_id)
  if amount >= 0 and money >= amount then
    return BR.setMoney(user_id, money - amount, 'cash', reason, notify)     
  else
    return false
  end
end

function BR.removeMoney(user_id, amount, moneytype, reason, notify)
  local money = BR.getMoney(user_id, moneytype)
  if money > 0 and amount > 0 and money >= amount then
      return BR.setMoney(user_id, money - amount, moneytype, reason, notify)
  end
  return false
end

-- give money
function BR.giveMoney(user_id, amount, moneytype, reason, notify)
  if amount > 0 then
    local money = BR.getMoney(user_id)
    return BR.setMoney(user_id, money + amount, moneytype, reason, notify)
  end
  return false
end

-- get bank money
function BR.getBankMoney(user_id)
  return BR.getMoney(user_id, 'bank')
end

-- set bank money
function BR.setBankMoney(user_id, value, reason, notify)
 return BR.setMoney(user_id, value, 'bank', reason, notify)
end

-- give bank money
function BR.giveBankMoney(user_id, amount, reason, notify)
  return BR.giveMoney(user_id, amount, 'bank', reason, notify)
end

function BR.removeBankMoney(user_id, amount, reason, notify)
  return BR.removeMoney(user_id, amount, 'bank', reason, notify)
end

-- try a withdraw
-- return true or false (withdrawn if true)
function BR.tryWithdraw(user_id, amount)
  local money = BR.getMoney(user_id, 'bank')
  if amount >= 0 and money >= amount then
    BR.setBankMoney(user_id, money - amount)
    BR.giveMoney(user_id, amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function BR.tryDeposit(user_id, amount)
  if amount >= 0 and BR.tryPayment(user_id, amount) then
    return BR.giveBankMoney(user_id, amount)    
  else
    return false
  end
end

function BR.tryFullPayment(user_id, amount)
  local money = BR.getMoney(user_id)
  if money >= amount then                          -- enough, simple payment
    return BR.tryPayment(user_id, amount)
  else                                             -- not enough, withdraw -> payment
    if BR.tryWithdraw(user_id, amount - money) then -- withdraw to complete amount
      return BR.tryPayment(user_id, amount)
    end
  end

  return false
end
