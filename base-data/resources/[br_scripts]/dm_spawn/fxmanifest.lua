fx_version "cerulean"
game "gta5"
author "vitordev9"

ui_page "web/index.html"

shared_scripts {
	"@br_core/lib/utils.lua",
	"lib/Tunnel.lua",
}

client_script "client/*"
server_script "server/*"

files {
	"web/*",
	"web/**/*",
}