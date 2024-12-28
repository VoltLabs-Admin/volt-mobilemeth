fx_version 'cerulean'
game 'gta5'

author 'Nevairi | VoltLabs'
description 'Mobile Meth Lab Script with ox_lib and Minigames'
version '1.0.0'

lua54 'yes'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    '@ox_lib/init.lua', -- Ensure ox_lib is loaded
    'config.lua',
    'items.lua'
}

dependencies {
    'ox_lib'
}
