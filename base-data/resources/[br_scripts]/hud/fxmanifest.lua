fx_version 'adamant'
game 'gta5'

ui_page "ui/index.html"

client_scripts {
	"@br_core/lib/utils.lua",
	"uf_cl.lua"
}

server_scripts {
	"@br_core/lib/utils.lua",
	"uf_sv.lua"
}

files {
	"ui/*.html",
	"ui/*.js",
	"ui/*.css",
	"ui/*.otf",
	"ui/*.ttf",
	"ui/dist/loading-bar.css",
	"ui/dist/loading-bar.js",
	"ui/dist/loading-bar.min.css",
	"ui/dist/loading-bar.min.js",
	"ui/svgs/*.svg",
}


              