fx_version 'adamant'

game 'gta5'

ui_page 'html/UI.html' 

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua', 
    'config.lua',
    'client/client.lua'
}

server_scripts {  
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}

files {
	'html/UI.html',
    'html/style.css',
    'html/media/font/Bariol_Regular.otf',
    'html/media/font/Vision-Black.otf',
    'html/media/font/Vision-Bold.otf',
    'html/media/font/Vision-Heavy.otf',
    'html/media/img/*.png',
} 
