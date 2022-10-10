fx_version "cerulean"
games {"gta5"}

name "pvpsystem"
description "PvP System (1V1, 2V2)"
version "1.2"

dependencies "qb-core"

server_scripts {
	"server.lua"
}

client_script {
	"client.lua"
}

ui_page 'NUI/index.html'

files {
    'NUI/*'
}