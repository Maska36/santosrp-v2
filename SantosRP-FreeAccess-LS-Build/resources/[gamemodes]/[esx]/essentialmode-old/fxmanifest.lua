fx_version 'adamant'

game 'gta5'

ui_page 'ui.html'

server_scripts { 
	'config.lua',
	'server/util.lua',
	'server/main.lua',
	'server/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua'
}

client_scripts {
	'client/main.lua'
}

-- NUI Files
files {
	'ui.html',
	'pdown.ttf'
}

exports {
	'getUser'
}

server_exports {
	'getPlayerFromId',
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'addACECommand',
	'canGroupTarget',
	'log',
	'debugMsg',
}