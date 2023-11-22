fx_version 'cerulean'
game 'gta5'

author 'Ethnic'
description 'Voice'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@Ethnic-assets/client/cl_errorlog.lua',
    'client/classes/cl_*.lua',
    'client/cl_*.lua',
}

server_script {
    '@Ethnic-assets/server/sv_errorlog.lua',
    'server/sv_*.lua',
}

dependency 'Ethnic-ui'

lua54 'yes'