BR.prepare("BR/money_init_user","INSERT IGNORE INTO user_moneys(user_id,bank) VALUES(@user_id,@bank)")
BR.prepare("BR/get_money","SELECT bank FROM user_moneys WHERE user_id = @user_id")
BR.prepare("BR/set_money","UPDATE user_moneys SET bank = @bank WHERE user_id = @user_id")

function BR.tryPayment(user_id,amount)
	if amount >= 0 then
		if BR.getInventoryItemAmount(user_id,"cartaodebito") >= 1 then
			if amount >= 0 and BR.getInventoryItemAmount(user_id,"dollars") >= amount then
				BR.tryGetInventoryItem(user_id,"dollars",amount)
				return true
			else
				local money = BR.getBankMoney(user_id)
				if amount >= 0 and money >= amount then
					BR.setBankMoney(user_id,money-amount)
					return true
				else
					return false
				end
			end
		else
			if amount >= 0 and BR.getInventoryItemAmount(user_id,"dollars") >= amount then
				BR.tryGetInventoryItem(user_id,"dollars",amount)
				return true
			else
				return false
			end
		end
	end
	return false
end

function BR.giveDinheirama(user_id,amount)
	if amount >= 0 then
		BR.giveInventoryItem(user_id,"dollars",amount)
	end
end

function BR.getMoney(user_id)
	return BR.getInventoryItemAmount(user_id,"dollars")
end

function BR.getBankMoney(user_id)
	local tmp = BR.getUserTmpTable(user_id)
	if tmp then
		return tmp.bank or 0
	else
		return 0
	end
end

function BR.setBankMoney(user_id,value)
	local tmp = BR.getUserTmpTable(user_id)
	if tmp then
		tmp.bank = value
	end
end

function BR.giveBankMoney(user_id,amount)
	if amount >= 0 then
		local money = BR.getBankMoney(user_id)
		BR.setBankMoney(user_id,money+amount)
	end
end

function BR.tryWithdraw(user_id,amount)
	local money = BR.getBankMoney(user_id)
	if amount >= 0 and money >= amount then
		BR.setBankMoney(user_id,money-amount)
		BR.giveInventoryItem(user_id,"dollars",amount)
		return true
	else
		return false
	end
end

function BR.tryDeposit(user_id,amount)
	if amount >= 0 and BR.tryGetInventoryItem(user_id,"dollars",amount) then
		BR.giveBankMoney(user_id,amount)
		return true
	else
		return false
	end
end

-- AddEventHandler("BR:playerJoin",function(user_id,source,name)
-- 	BR.execute("BR/money_init_user",{ user_id = user_id, bank = 5000 })
-- 	local tmp = BR.getUserTmpTable(user_id)
-- 	if tmp then
-- 		local rows = BR.query("BR/get_money",{ user_id = user_id })
-- 		if #rows > 0 then
-- 			tmp.bank = rows[1].bank
-- 		end
-- 	end
-- end)

function BR.MoneyInit(user_id,source,name)
	BR.execute("BR/money_init_user",{ user_id = user_id, bank = 5000 })
	local tmp = BR.getUserTmpTable(user_id)
	if tmp then
		local rows = BR.query("BR/get_money",{ user_id = user_id })
		if #rows > 0 then
			tmp.bank = rows[1].bank
		end
	end
end

RegisterCommand('savedb',function(source,args,rawCommand)
	local source = source
	local user_id = BR.getUserId(source)
	if user_id then
		local tmp = BR.getUserTmpTable(user_id)
		if tmp and tmp.bank then
			BR.execute("BR/set_money",{ user_id = user_id, bank = tmp.bank })
		end
		TriggerClientEvent("save:database",source)
		TriggerClientEvent("Notify",source,"aviso","Você salvou todo o conteúdo temporário de sua database.")
	end
end)

AddEventHandler("BR:playerLeave",function(user_id,source)
	local tmp = BR.getUserTmpTable(user_id)
	if tmp and tmp.bank then
		BR.execute("BR/set_money",{ user_id = user_id, bank = tmp.bank })
	end
end)

AddEventHandler("BR:save",function()
	for k,v in pairs(BR.user_tmp_tables) do
		if v.bank then
			BR.execute("BR/set_money",{ user_id = k, bank = v.bank })
		end
	end
end)