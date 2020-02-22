fx_version 'adamant'

game 'gta5'

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/iransans.otf',
	
	'html/img/blindfold.png',
	'html/img/boombox.png',
	'html/img/bread.png',
	'html/img/close.png',
	'html/img/croquettes.png',
	'html/img/gps.png',
	'html/img/logo.png',
	'html/img/plus.png',
	'html/img/phone.png',
	'html/img/minus.png',
	'html/img/lockpick.png',
	'html/img/water.png'
}

ui_page 'html/ui.html'

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/fa.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/fa.lua',
	'config.lua',
	'server/main.lua'
}

dependency 'es_extended'
