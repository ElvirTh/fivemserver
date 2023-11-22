fx_version 'cerulean'
game 'gta5'

lua54 'yes'

ui_page 'nui/index.html'

client_script {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-polyzone/client/cl_main.lua',
    '@Ethnic-polyzone/client/BoxZone.lua',
    '@Ethnic-polyzone/client/EntityZone.lua',
    '@Ethnic-polyzone/client/CircleZone.lua',
    '@Ethnic-polyzone/client/ComboZone.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'shared/sh_*.lua',
    'shared/cl_*.lua',
    'config/cl_*.lua',
    'client/*.lua',
}

server_script {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'shared/sh_*.lua',
    'server/*.lua',
}

files {
    'nui/index.html',
    'nui/images/*.png',
    'nui/images/**/*.png',
    'nui/images/*.jpg',
    'nui/images/**/*.jpg',
    'nui/images/*.svg',
    'nui/images/**/*.svg',
    'nui/sounds/*.ogg',
    'nui/fonts/*.woff',
    'nui/fonts/*.woff2',
    'nui/fonts/*.ttf',
    'nui/fonts/*.otf',
    'nui/css/*.css',
    'nui/js/*.js',
    'nui/Apps/**/*.html',
    'nui/Apps/**/css/*.css',
    'nui/Apps/**/js/*.js',
}