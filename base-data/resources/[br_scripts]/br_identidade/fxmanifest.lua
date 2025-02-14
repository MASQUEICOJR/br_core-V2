fx_version 'cerulean'
game 'gta5'
author 'Swellington Soares'
version '1'
lua54 'yes'

ui_page "web/index.html"

client_scripts{
    "@br_core/lib/utils.lua",
    "client/*"
}

server_scripts{
    "@br_core/lib/utils.lua",
    "server/*"
}

files{
    'web/*',
    'web/**/*',
    'web/**/*',
    'web/**/**/*'
}