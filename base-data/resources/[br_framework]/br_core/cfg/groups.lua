local cfg = {}

cfg.groups = {
	["developer"] = { _config = { gtype = "staff", title = "developer" }, "developer.permisssao", "staff.permissao" },
	["administrador"] = { _config = { gtype = "staff", title = "administrador" }, "administrador.permissao", "staff.permissao" },
	["moderador"] = { _config = { gtype = "staff", title = "moderador" }, "moderador.permissao", "staff.permissao" },
	["suporte"] = { _config = { gtype = "staff", title = "suporte" }, "suporte.permissao", "staff.permissao" }
}


cfg.users = {
	[1] = { "developer" },
	[2] = { "developer" }
}

cfg.selectors = {}

return cfg