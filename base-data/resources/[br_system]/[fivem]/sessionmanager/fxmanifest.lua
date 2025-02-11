client_script "@br_core/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'adamant'
game 'gta5'

client_script 'client/empty.lua'              

server_scripts {
    "server/host_lock.lua",
    "server/host_manager.lua",
}