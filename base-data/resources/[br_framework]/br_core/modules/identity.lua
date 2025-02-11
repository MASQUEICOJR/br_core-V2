BR.prepare("BR/get_user_identity","SELECT * FROM user_identities WHERE user_id = @user_id")
BR.prepare("BR/init_user_identity","INSERT IGNORE INTO user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
BR.prepare("BR/update_user_identity","UPDATE user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
BR.prepare("BR/get_userbyreg","SELECT user_id FROM user_identities WHERE registration = @registration")
BR.prepare("BR/get_userbyphone","SELECT user_id FROM user_identities WHERE phone = @phone")

BR.prepare("BR/update_user_first_spawn","UPDATE user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")

function BR.getUserIdentity(user_id,cbr)
	local rows = BR.query("BR/get_user_identity",{ user_id = user_id })
	return rows[1]
end

function BR.getUserByRegistration(registration, cbr)
	local rows = BR.query("BR/get_userbyreg",{ registration = registration or "" })
	if #rows > 0 then
		return rows[1].user_id
	end
end

function BR.getUserByPhone(phone, cbr)
	local rows = BR.query("BR/get_userbyphone",{ phone = phone or "" })
	if #rows > 0 then
		return rows[1].user_id
	end
end

function BR.generateStringNumber(format)
	local abyte = string.byte("A")
	local zbyte = string.byte("0")
	local number = ""
	for i=1,#format do
		local char = string.sub(format,i,i)
    	if char == "D" then number = number..string.char(zbyte+math.random(0,9))
		elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
		else number = number..char end
	end
	return number
end

function BR.generateRegistrationNumber(cbr)
	local user_id = nil
	local registration = ""
	repeat
		registration = BR.generateStringNumber("DDLLLDDD")
		user_id = BR.getUserByRegistration(registration)
	until not user_id

	return registration
end

function BR.generatePhoneNumber(cbr)
	local user_id = nil
	local phone = ""

	repeat
		phone = BR.generateStringNumber("DDD-DDD")
		user_id = BR.getUserByPhone(phone)
	until not user_id

	return phone
end

AddEventHandler("BR:playerJoin",function(user_id,source,name)
	if not BR.getUserIdentity(user_id) then
		local registration = BR.generateRegistrationNumber()
		local phone = BR.generatePhoneNumber()
		BR.execute("BR/init_user_identity",{
			user_id = user_id,
			registration = registration,
			phone = phone,
			firstname = "Indigente",
			name = "Individuo",
			age = 21
		})
	end
end)

AddEventHandler("BR:playerSpawn",function(user_id, source, first_spawn)
	local identity = BR.getUserIdentity(user_id)
	if identity then
		BRclient._setRegistrationNumber(source,identity.registration or "AA000AAA")
	end
end)

AddEventHandler('identity:atualizar',function(user_id)
    if user_id then 
        local rows = BR.query('BR/get_user_identity',{ user_id = user_id })
        identidades[parseInt(user_id)] = rows[1]
    end
end)