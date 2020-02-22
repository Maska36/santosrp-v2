fx_version 'adamant'

game 'gta5'

client_script 'anti-cheat.net.dll'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

clr_disable_task_scheduler 'yes'