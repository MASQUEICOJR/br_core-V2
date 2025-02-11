client_script "@ThnAC/natives.lua"
client_script "@br_core/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version "adamant"
game "gta5"

ui_page_preload 'yes'

ui_page "nui/index.html"

files {
	"nui/**",
}

client_scripts {
	"@br_core/lib/utils.lua",
	"client_config.lua",
	"client.lua"
} 

server_script {
	"@br_core/lib/utils.lua",
	"server_config.lua",
	"server.lua"
}

              