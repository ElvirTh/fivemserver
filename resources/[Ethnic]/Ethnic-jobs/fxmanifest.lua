fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'config/sh_*.lua',
}

client_scripts {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'client/**.lua',
}

server_scripts {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'config/sv_*.lua',
    'server/*.lua',
}