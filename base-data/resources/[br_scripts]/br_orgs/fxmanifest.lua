fx_version 'cerulean'
game 'gta5'
lua54 'yes'


author 'RomeraSCR'
description 'BR Organizations'
version '1.0.0'

ui_page 'ui/index.html'

shared_scripts {
    '@br_core/lib/utils.lua',
    'lib/**',
    'config.lua',
}

files {
    'ui/*.html',
    'ui/src/*.css',
    'ui/src/*.js',
    'ui/assets/*.png',
    'ui/assets/images/*.png'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/modules/*.lua',
}  

client_scripts {
    'client/*.lua',
    'client/modules/*.lua',
}  