fx_version 'adamant'

game 'gta5'

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/server.lua',
}

exports {
	'getMaxMods',
	'GeneratePlate',
	'SetVehicleMaxMods',
	'VehSpawn'
}

dependency 'es_extended'

disable_lazy_natives 'yes'