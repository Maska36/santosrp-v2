fx_version 'adamant'

game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/js/script.js',
	'html/js/bootstrap.min.js',
	'html/js/jquery-3.2.1.js',
	'html/css/style.css',
	'html/css/bootstrap.min.css',
	'html/img/logo.png'
}

dependency 'es_extended'