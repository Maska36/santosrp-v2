fx_version 'adamant'

game 'gta5'

version '1.1.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',

	'jobs/chronopost.lua',
	'jobs/fisherman.lua',
	'jobs/fueler.lua',
	'jobs/lumberjack.lua',
	'jobs/slaughterer.lua',
	'jobs/tailor.lua',

	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',

	'jobs/chronopost.lua',
	'jobs/fisherman.lua',
	'jobs/fueler.lua',
	'jobs/lumberjack.lua',
	'jobs/slaughterer.lua',
	'jobs/tailor.lua',

	'client/main.lua'
}

dependencies {
	'es_extended',
	'esx_addonaccount',
	'skinchanger',
	'esx_skin'
}


	-- 'client/jobs/chronopost.lua',
	-- 'client/jobs/fisherman.lua',
	-- 'client/jobs/fueler.lua',
	-- 'client/jobs/lumberjack.lua',
	-- 'client/jobs/slaughterer.lua',
	-- 'client/jobs/tailor.lua',