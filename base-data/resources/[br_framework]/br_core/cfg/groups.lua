local cfg = {}

cfg.groups = {
	["founder"] = {
		_config = {
			gtype = "staff",
			title = "founder"
		},
		"manager.permission",
		"staff.permission"
	}
}


cfg.users = {
	[1] = { "founder" }
}

cfg.selectors = {}

return cfg