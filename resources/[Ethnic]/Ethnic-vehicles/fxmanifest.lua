fx_version 'cerulean'
game 'gta5'

shared_scripts {
    'shared/**.lua',   
}

client_script {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'client/**.lua',
}

server_script {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'server/**.lua',
}

lua54 'yes'