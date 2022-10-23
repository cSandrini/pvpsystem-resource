fx_version 'cerulean'
games {'gta5'}

name 'pvpsystem'
description 'PvP System (1V1, 2V2)'
version '1.5'

server_scripts {
	'config.lua',
	'server.lua'
}

client_scripts {
	'client.lua'
}

ui_page 'NUI/index.html'

files {
    'NUI/*'
}
