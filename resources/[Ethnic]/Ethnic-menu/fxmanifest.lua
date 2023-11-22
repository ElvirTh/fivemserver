fx_version 'cerulean'
game 'gta5'

ui_page 'nui/index.html'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@Ethnic-assets/client/cl_errorlog.lua',
    'client/cl_*.lua',
}

server_script {
    '@Ethnic-assets/server/sv_errorlog.lua',
    'server/sv_*.lua',
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/js/*.js',
}

lua54 'yes'