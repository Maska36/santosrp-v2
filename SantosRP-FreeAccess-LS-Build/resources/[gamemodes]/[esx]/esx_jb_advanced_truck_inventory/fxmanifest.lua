fx_version 'adamant'

game 'gta5'

server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'config/config.lua',
  'server/main.lua'
}

client_scripts {
  'config/config.lua',
  'client/main.lua'
}
