client_script "@ThnAC/natives.lua"
fx_version "adamant"
games {"gta5"}

description "A middleware for FiveM servers with BREX framework, a trial version aimed at BR."

dependencies{
  "br_core",
  "oxmysql"
}

-- server scripts
server_scripts{ 
  "@br_core/lib/utils.lua",
  "init.lua"
}
