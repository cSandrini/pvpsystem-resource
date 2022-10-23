fx_version 'cerulean'
games {'gta5'}

name 'pvpsystem'
description 'PvP System (1V1, 2V2)'
version '1.5'

server_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

ui_page 'NUI/index.html'

files {
    'NUI/*'
}

dependency 'vrp'
