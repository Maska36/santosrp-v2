fx_version 'adamant'

game 'gta5'

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'server.lua'
}

dependency 'es_extended'