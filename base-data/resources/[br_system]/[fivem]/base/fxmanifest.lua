client_script "@ThnAC/natives.lua"
client_script "@br_core/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }

map 'map.lua'

fx_version 'adamant'
game 'gta5'              