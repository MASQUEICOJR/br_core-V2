




BR.prepare("BR/create_user","INSERT INTO account(steam) VALUES(@steam)")
BR.prepare("BR/set_banned","UPDATE account SET banned = @banned WHERE steam = @steam")
BR.prepare("BR/set_whitelisted","UPDATE account SET whitelisted = @whitelist WHERE steam = @steam")
BR.prepare("BR/get_banned","SELECT banned FROM account WHERE steam = @steam")
BR.prepare("BR/get_whitelisted","SELECT whitelisted FROM account WHERE steam = @steam")
BR.prepare("BR/get_vrp_infos","SELECT * FROM account WHERE steam = @steam")
BR.prepare("BR/get_vrp_infos_id","SELECT * FROM account WHERE id = @id")
BR.prepare("BR/get_users","SELECT * FROM account WHERE id = @id")
BR.prepare("BR/get_vrp_registration","SELECT id FROM account WHERE registration = @registration")
BR.prepare("BR/get_vrp_phone","SELECT id FROM account WHERE phone = @phone")
BR.prepare("BR/get_characters","SELECT * FROM account WHERE steam = @steam and deleted = 0")
BR.prepare("BR/create_characters","INSERT INTO account(steam) VALUES(@steam)")
BR.prepare("BR/remove_characters","UPDATE account SET deleted = 1 WHERE id = @id")
BR.prepare("BR/update_characters","UPDATE user_identities SET registration = @registration, phone = @phone WHERE id = @id")
BR.prepare("BR/rename_characters","UPDATE user_identities SET name = @name, firstname = @name2 WHERE id = @id")
BR.prepare("BR/add_identifier","INSERT INTO user_ids(identifier,user_id) VALUES(@identifier,@user_id)")

BR.prepare("BR/userid_byidentifier","SELECT id FROM account WHERE steam = @identifier")
BR.prepare("BR/identifier_byuserid","SELECT steam FROM account WHERE id = @id")

BR.prepare("BR/set_userdata","REPLACE INTO user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
BR.prepare("BR/get_userdata","SELECT dvalue FROM user_data WHERE user_id = @user_id AND dkey = @key")
BR.prepare("BR/set_srvdata","REPLACE INTO srv_data(dkey,dvalue) VALUES(@key,@value)")
BR.prepare("BR/get_srvdata","SELECT dvalue FROM srv_data WHERE dkey = @key")
BR.prepare("BR/init_user_identity","INSERT INTO user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")


BR.prepare("BR/update_ip","UPDATE account SET ip = @ip WHERE id = @uid")
BR.prepare("BR/update_login","UPDATE account SET last_login = @ll WHERE id = @uid")

BR.prepare("BR/getExistChest","SELECT * FROM vrp_chests WHERE name = @name")
BR.prepare("BR/get_alltable","SELECT * FROM vrp_chests")
BR.prepare("BR/addChest","INSERT INTO vrp_chests (permiss,name,x,y,z,weight,webhook) VALUES (@permiss,@name,@x,@y,@z,@weight,@webhook)")

