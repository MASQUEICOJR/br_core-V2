local Proxy = require('@br_core.lib.Proxy')
local BR = Proxy.getInterface('BR')

BR = Proxy.getInterface("BR")
BRSERVER = Tunnel.getInterface(GetCurrentResourceName())
BR_idenitidade = {}
Tunnel.bindInterface(GetCurrentResourceName(),BR_idenitidade)


RegisterNetEvent("br_identity:toggle") -- Evento para alternar a visibilidade da identidade

AddEventHandler("br_identity:toggle", function()
    -- Lógica para alternar a visibilidade da identidade no servidor, se necessário
end)

function BR_idenitidade.getInfos()
    local source = source
    local user_id = BR.getUserId(source)
    if user_id then
		local cash = BR.getMoney(user_id)
		local banco = BR.getBankMoney(user_id)
		local identity = BR.getUserIdentity(user_id)

		local org = BR.getUserGroupByType(user_id,"org")
		if org == "" then
			
			org = "Nenhum(a)" end

	
		local parmas = "Não Possui"
		if BR.hasGroup(user_id, "Porte de Armas") then
			parmas = "Sim Possui"
		end
		
        local carry = false
		local staff = BR.getUserGroupByType(user_id,'staff')
		if staff == "" then staff = "Nenhum" end
		

		local vips = {}
		if BR.hasGroup(user_id, "Inicial") then table.insert(vips, { vip = "Inicial" }) end
		if BR.hasGroup(user_id, "Bronze") then table.insert(vips, { vip = "Bronze" }) end
		if BR.hasGroup(user_id, "Prata") then table.insert(vips, { vip = "Prata" }) end
		if BR.hasGroup(user_id, "Ouro") then table.insert(vips, { vip = "Ouro" }) end
		if BR.hasGroup(user_id, "Platina") then table.insert(vips, { vip = "Platina" }) end
		
		if #vips <= 0 then table.insert(vips, { vip = "Nenhum" }) end
		
        -- return BR.format(parseInt(cash)),BR.format(parseInt(banco)),identity.nome,identity.sobrenome,identity.idade,identity.user_id,identity.registro,identity.telefone,org,vips,avatar,json.decode(identity.relacionamento),parmas,staff,string.upper(identity.signo),identity.data_nascimento
		
		if identity then
            return { id = user_id, name = identity.name.."  "..identity.firstname, birth = identity.age, telephone = identity.phone, bank = banco, wallet = cash, org = org , carry = false,staff = staff,  spouse = { name = "" }, vips = vips  }
        end
	end
    return {}
end