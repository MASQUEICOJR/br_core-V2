
fx_version 'bodacious'
game 'gta5'


ui_page "nui/index.html"

client_scripts {
	"@br_core/lib/utils.lua",
	"cfg/config.lua",
	"client.lua"
}

server_scripts {
	"@br_core/lib/utils.lua",
	"cfg/config.lua",
	"cfg/itens.lua",
	"server.lua",
}

files {
	"cfg/config.lua",
	"nui/index.html",
	"nui/script.js",
	"nui/style.css",
	"nui/Azonix.otf",
	"nui/images/*",
	"nui/assets/*",
}