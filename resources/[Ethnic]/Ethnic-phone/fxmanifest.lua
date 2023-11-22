fx_version 'cerulean'
game 'gta5'

author 'Ethnic Collective'
description 'Phone'

client_script {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'config/sh_*.lua',
    'client/*.lua',
}

server_script {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'config/sh_*.lua',
    'config/sv_*.lua',
    'server/*.lua',
}

lua54 'yes'