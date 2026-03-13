fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'custom-ui-announcer'
description 'Polished and framework-agnostic NUI announcer for FiveM servers.'
author 'Hugo'
version '1.0.0'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}
