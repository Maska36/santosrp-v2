hypnonema_url 'https://thiago-dev.github.io/fivem-hypnonema'

-- If you want to see a custom splash screen / poster
hypnonema_poster_url 'https://i.imgur.com/Cau2AfG.png'

-- The command someone needs to enter for opening the menu
-- Hint: no spaces, no special characters!
hypnonema_command_name 'hypnonema'

-- Only change if you know what you are doing!
hypnonema_db_connString "Filename=hypnonema.db;Flush=true"

-- Whether logging is enabled or not
hypnonema_logging_enabled 'false'

-- The sync interval in ms
hypnonema_sync_interval '5000'

fx_version 'adamant'

game 'gta5'

ui_page 'client/html/index.html'
client_script 'client/Hypnonema.Client.net.dll'
server_script 'server/Hypnonema.Server.net.dll'

files {
    'client/Newtonsoft.Json.dll',
    'client/Hypnonema.Shared.dll',
    'client/html/index.html',
    'client/html/styles.css',
    'client/html/bg.png',
    'client/html/*.js'
}

clr_disable_task_scheduler 'yes'