fx_version 'adamant'

game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

client_scripts {
	'client/client.lua',
	'cfg/cfg.lua'
}