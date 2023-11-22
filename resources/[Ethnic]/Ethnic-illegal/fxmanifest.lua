fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'shared/sh_*.lua'
}

client_scripts {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-inventory/shared/sh_config.lua',
    '@Ethnic-inventory/shared/sh_items.lua',
    'client/*.lua',
}

server_scripts {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-inventory/shared/sh_config.lua',
    '@Ethnic-inventory/shared/sh_items.lua',
    'server/*.lua',
}