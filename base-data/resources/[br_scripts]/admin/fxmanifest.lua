fx_version 'adamant'
game 'gta5'

author 'LUCCA'
contact 'Lucca.#1297'

client_scripts {
	'@br_core/lib/utils.lua',
	'config/config.lua',
	'hansolo/*.lua'
}

server_scripts {
	'@br_core/lib/utils.lua',
	'config/config.lua',
	'skywalker.lua'
}

dependencies {
    'mysql-async'
}