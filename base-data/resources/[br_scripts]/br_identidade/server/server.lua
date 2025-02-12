local Tunnel = module("br_core", "lib/Tunnel")
local Proxy = module("br_core", "lib/Proxy")

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
		if BR.hasGroup(user_id, "Diamante") then table.insert(vips, { vip = "Diamante" }) end
		if BR.hasGroup(user_id, "Safira") then table.insert(vips, { vip = "Safira" }) end
		if BR.hasGroup(user_id, "Esmeralda") then table.insert(vips, { vip = "Esmeralda" }) end
		if BR.hasGroup(user_id, "Rubi") then table.insert(vips, { vip = "Rubi" }) end
		if BR.hasGroup(user_id, "RubiPlus") then table.insert(vips, { vip = "RubiPlus" }) end
		if BR.hasGroup(user_id, "Carnaval") then table.insert(vips, { vip = "Carnaval" }) end
		if BR.hasGroup(user_id, "Exclusivo Março") then table.insert(vips, { vip = "Exclusivo Março" }) end
		if BR.hasGroup(user_id, "Exclusivo Maio") then table.insert(vips, { vip = "Exclusivo Maio" }) end
		
		if #vips <= 0 then table.insert(vips, { vip = "Nenhum" }) end
		
        -- return BR.format(parseInt(cash)),BR.format(parseInt(banco)),identity.nome,identity.sobrenome,identity.idade,identity.user_id,identity.registro,identity.telefone,org,vips,avatar,json.decode(identity.relacionamento),parmas,staff,string.upper(identity.signo),identity.data_nascimento
		
		if identity then
            return { id = user_id, name = identity.name.."  "..identity.firstname, birth = identity.age, telephone = identity.phone, bank = banco, wallet = cash, org = org , carry = false,staff = staff,  spouse = { name = "" }, vips = vips  }
        end
	end
    return {}
end