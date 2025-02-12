local cfg = {}

cfg.groups = {

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- STAFF
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["developer"] = { _config = { gtype = "staff", title = "developer" }, "developer.permisssao", "staff.permissao" },
	["administrador"] = { _config = { gtype = "staff", title = "administrador" }, "administrador.permissao", "staff.permissao" },
	["moderador"] = { _config = { gtype = "staff", title = "moderador" }, "moderador.permissao", "staff.permissao" },
	["suporte"] = { _config = { gtype = "staff", title = "suporte" }, "suporte.permissao", "staff.permissao" },
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- HOSPITAL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["Diretor"] = { _config = { gtype = "org", salario = 27000, ptr = true, orgName = "Hospital" },"dv.permissao", "unizk.permissao" },
	["Vice Diretor"] = { _config = { gtype = "org", salario = 25000, ptr = true, orgName = "Hospital"},"dv.permissao", "unizk.permissao" },
	["Gestao"] = { _config = { gtype = "org", salario = 23000, ptr = true, orgName = "Hospital"},"dv.permissao", "unizk.permissao" },
	["Psicologo"] = { _config = { gtype = "org", salario = 20000, ptr = true, orgName = "Hospital"},"dv.permissao", "unizk.permissao" },
	["Medico"] = { _config = { gtype = "org", salario = 17000, ptr = true, orgName = "Hospital"},"dv.permissao", "unizk.permissao" },
	["Enfermeiro"] = { _config = { gtype = "org", salario = 15000, ptr = true, orgName = "Hospital"}, "unizk.permissao" },
	["Paramedico"] = { _config = { gtype = "org", salario = 10000, ptr = true, orgName = "Hospital"}, "unizk.permissao" },
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- JUDICIARIO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["Ministro"] = { _config = { gtype = "org", salario = 20000, ptr = true, orgName = "Judiciario"}, "judiciario.permissao" },
	["Juiz"] = { _config = { gtype = "org", salario = 10000, ptr = nil, orgName = "Judiciario"}, "judiciario.permissao" },
	["Desembargador"] = { _config = { gtype = "org", salario = 10000, orgName = "Judiciario"}, "judiciario.permissao" },
	["Promotor"] = { _config = { gtype = "org", salario = 8000, ptr = nil, orgName = "Judiciario"}, "judiciario.permissao" },
	["Advogado"] = { _config = { gtype = "org", salario = 5000, ptr = nil, orgName = "Judiciario"}, "judiciario.permissao" },
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA TATICA
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["ComandoTatica"] = { _config = { gtype = "org", salario = 17000, ptr = true, orgName = "Tatica" }, "policia.permissao", "tatica", "baupolicialider", "player.blips","disparo", "portasolicia", "algemar", "countpolicia" },
	["SubComandoTatica"] = { _config = { gtype = "org", salario = 18000, ptr = true, orgName = "Tatica" }, "policia.permissao", "tatica", "baupolicialider", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["SupervisorTatica"] = { _config = { gtype = "org", salario = 17000, ptr = true, orgName = "Tatica" }, "policia.permissao", "tatica", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["EliteTatica"] = { _config = { gtype = "org", salario = 17000, ptr = true, orgName = "Tatica" }, "policia.permissao", "tatica", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["EstagiarioTatica"] = { _config = { gtype = "org", salario = 17000, ptr = true, orgName = "Tatica" }, "policia.permissao", "tatica", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- POLICIA CIVIL
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["DelegadoGeral"] = { _config = { gtype = "org", salario = 25000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "baupoliciacivillider", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["ComandanteCore"] = { _config = { gtype = "org", salario = 25000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "baupoliciacivillider", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["SubComandanteCore"] = { _config = { gtype = "org", salario = 20000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "baupoliciacivillider", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Delegado"] = { _config = { gtype = "org", salario = 15000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Core"] = { _config = { gtype = "org", salario = 15000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "policia.radio", "portasolicia", "algemar", "countpolicia" },
	["Perito"] = { _config = { gtype = "org", salario = 12000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Escrivao"] = { _config = { gtype = "org", salario = 10000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Investigador"] = { _config = { gtype = "org", salario = 8000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Agente"] = { _config = { gtype = "org", salario = 6000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },
	["Recruta"] = { _config = { gtype = "org", salario = 4000, ptr = true, orgName = "PoliciaCivil" }, "policiacivil", "player.blips", "disparo", "portasolicia", "algemar", "countpolicia"  },

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  /groupadd 1 "lider bloods"
-- ARMAS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--MAFIA01--
	["Lider [MAFIA01]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Mafia01", orgType = "Armas"}, "perm.mafia01", "perm.lidermafia01", "perm.arma", "perm.ilegal", "perm.baumafia01"},
	["Sub-Lider [MAFIA01]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Mafia01", orgType = "Armas" }, "perm.lidermafia01", "perm.mafia01", "perm.arma", "perm.ilegal", "perm.baumafia01"},
	["Gerente [MAFIA01]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Mafia01", orgType = "Armas" }, "perm.mafia01", "perm.arma", "perm.ilegal", "perm.baumafia01"},
	["Membro [MAFIA01]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Mafia01", orgType = "Armas" }, "perm.mafia01", "perm.arma", "perm.ilegal", "perm.baumafia01"},
	["Novato [MAFIA01]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Mafia01", orgType = "Armas" }, "perm.mafia01", "perm.arma", "perm.ilegal"},

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MUNIÇÃO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--YAKUZA--
	["Lider [YAKUZA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Yakuza", orgType = "Municao"}, "perm.yakuza", "perm.lideryakuza", "perm.muni", "perm.ilegal", "perm.bauyakuza"},
	["Sub-Lider [YAKUZA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Yakuza", orgType = "Municao"}, "perm.lideryakuza", "perm.yakuza", "perm.muni", "perm.ilegal", "perm.bauyakuza"},
	["Gerente [YAKUZA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Yakuza", orgType = "Municao"}, "perm.yakuza", "perm.muni", "perm.ilegal", "perm.bauyakuza"},
	["Membro [YAKUZA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Yakuza", orgType = "Municao"}, "perm.yakuza", "perm.muni", "perm.ilegal", "perm.bauyakuza"},
	["Novato [YAKUZA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Yakuza", orgType = "Municao"}, "perm.yakuza", "perm.muni", "perm.ilegal"},

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DESMANCHE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--FURIOUS--
	["Lider [FURIOUS]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Furious", orgType = "Desmanche"}, "perm.furious", "perm.liderfurious", "perm.gerentefurious", "perm.desmanche", "perm.ilegal", "perm.baufurious"},
	["Sub-Lider [FURIOUS]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Furious", orgType = "Desmanche"}, "perm.liderfurious", "perm.gerentefurious", "perm.furious", "perm.desmanche", "perm.ilegal", "perm.baufurious"},
	["Gerente [FURIOUS]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Furious", orgType = "Desmanche"}, "perm.gerentefurious", "perm.furious", "perm.desmanche", "perm.ilegal", "perm.baufurious"},
	["Membro [FURIOUS]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Furious", orgType = "Desmanche"}, "perm.furious", "perm.desmanche", "perm.ilegal", "perm.baufurious"},
	["Novato [FURIOUS]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Furious", orgType = "Desmanche"}, "perm.furious", "perm.desmanche", "perm.ilegal"},

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- LAVAGEM
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--VANILLA--
	["Lider [VANILLA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Vanilla", orgType = "Lavagem"}, "perm.lidervanilla", "perm.vanilla", "perm.lavagem", "perm.ilegal", "perm.bauvanilla"},
	["Sub-Lider [VANILLA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Vanilla",orgType = "Lavagem"}, "perm.lidervanilla", "perm.vanilla", "perm.lavagem", "perm.ilegal", "perm.bauvanilla"},	
	["Gerente [VANILLA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Vanilla",orgType = "Lavagem"}, "perm.vanilla", "perm.lavagem", "perm.ilegal", "perm.bauvanilla"},
	["Membro [VANILLA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Vanilla",orgType = "Lavagem"}, "perm.vanilla", "perm.lavagem", "perm.ilegal", "perm.bauvanilla"},
	["Novato [VANILLA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Vanilla",orgType = "Lavagem"}, "perm.vanilla", "perm.lavagem", "perm.ilegal"},

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DROGAS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--CANADA--
	["Lider [CANADA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Canada", orgType = "Drogas"}, "perm.canada", "perm.lidercanada", "perm.drogas", "perm.ilegal", "perm.maconha", "perm.baucanada"},
	["Sub-Lider [CANADA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Canada", orgType = "Drogas"}, "perm.lidercanada", "perm.canada", "perm.drogas", "perm.ilegal", "perm.maconha", "perm.baucanada"},
	["Gerente [CANADA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Canada", orgType = "Drogas"}, "perm.canada", "perm.drogas", "perm.ilegal", "perm.maconha", "perm.baucanada"},
	["Membro [CANADA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Canada", orgType = "Drogas"}, "perm.canada", "perm.drogas", "perm.ilegal", "perm.maconha", "perm.baucanada"},
	["Novato [CANADA]"] = { _config = { gtype = "org", salario = nil, ptr = nil, orgName = "Canada", orgType = "Drogas"}, "perm.canada", "perm.drogas", "perm.maconha", "perm.ilegal"},

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- MECANICA
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	["Lider [MECANICA]"] = { _config = { gtype = "org", salario = 3500, ptr = nil, orgName = "Mecanica" }, "dv.permissao", "perm.mecanica", "perm.lidermecanica", "perm.tunar", "perm.baumecanica"},
	["Sub-Lider [MECANICA]"] = { _config = { gtype = "org", salario = 3000, ptr = nil, orgName = "Mecanica" }, "perm.mecanica", "perm.tunar", "perm.baumecanica"},
	["Gerente [MECANICA]"] = { _config = { gtype = "org", salario = 2500, ptr = nil, orgName = "Mecanica" }, "perm.mecanica", "perm.tunar", "perm.baumecanica"},
	["Membro [MECANICA]"] = { _config = { gtype = "org", salario = 2000, ptr = nil, orgName = "Mecanica" }, "perm.mecanica", "perm.tunar", "perm.baumecanica"},
	["Novato [MECANICA]"] = { _config = { gtype = "org", salario = 1500, ptr = nil, orgName = "Mecanica" }, "perm.mecanica", "perm.tunar"},


}


cfg.users = {
	[1] = { "developer" },
	[2] = { "developer" }
}

cfg.selectors = {}

return cfg