
fx_version 'cerulean' 
game 'gta5'


ui_page "character-nui/index.html"

files {
	"character-nui/*",
	"character-nui/**/*",
	"character-nui/**/**/*",
}

client_scripts {
	"@br_core/lib/utils.lua",
	"client.lua",
	"config.lua"
}

server_scripts {
	"@br_core/lib/utils.lua",
	"server.lua"
}
                                          