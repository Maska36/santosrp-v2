fx_version 'adamant'

game 'gta5'

version '1.0.8'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
  'client.lua'
}

dependencies {
	'essentialmode',
	'async'
}