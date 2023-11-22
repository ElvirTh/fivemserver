fx_version 'cerulean'
game 'gta5'

author 'Ethnic Collective (.gg/Ethnic-coll)'
description 'Admin Menu'

ui_page "nui/index.html"

shared_scripts {
    'shared/sh_config.lua',
    'locale.lua',
    'locales/en.lua', -- Change this to your desired language.
}

client_scripts {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    '@Ethnic-inventory/shared/sh_config.lua',
    '@Ethnic-inventory/shared/sh_items.lua',
    'client/**/cl_*.lua',
    'entityhashes/entity.lua',
    'shared/sh_commands.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    'server/sv_*.lua',
}

files {
    "nui/index.html",
    "nui/js/**.js",
    "nui/css/**.css",
    "nui/webfonts/*.css",
    "nui/webfonts/*.otf",
    "nui/webfonts/*.ttf",
    "nui/webfonts/*.woff2",
}

exports {
    'CreateLog',
    'ToggleDev',
}

server_exports {
    'CreateLog'
} 

dependencies {
    'oxmysql',
}

lua54 'yes'