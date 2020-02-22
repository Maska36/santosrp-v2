fx_version 'adamant'

game 'gta5'

description 'ES Extended'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',

	'locale.lua',
	'locales/fr.lua',

	'config.lua',
	'config.weapons.lua',

	'server/common.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

client_scripts {
	'locale.lua',
	'locales/fr.lua',

	'config.lua',
	'config.weapons.lua',

	'client/common.lua',
	'client/entityiter.lua',	
	'client/functions.lua',	
	'client/wrapper.lua',	
	'client/main.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',	
	'client/modules/streaming.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

ui_page 'html/ui.html'

files {
	'locale.js',
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',

	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',	
	'html/fonts/signpainter.ttf',

	'html/img/accounts/bank.png',
	'html/img/accounts/money.png',	
	'html/img/accounts/black_money.png',	
	'html/img/accounts/society_money.png',
}

exports {
	'getSO'
}

server_exports {
	'getSO'
}

dependencies {
	'mysql-async',
	'essentialmode',
	'esplugin_mysql',
	'async'
}
