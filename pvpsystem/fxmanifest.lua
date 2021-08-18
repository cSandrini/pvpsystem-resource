fx_version "cerulean"
games {"gta5"}

name "pvpsystem"
description "PvP System (1V1, 2V2)"
version "1.0"

dependencies "vrp"

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

client_script {
	"@vrp/lib/utils.lua",
	"client.lua"
}
