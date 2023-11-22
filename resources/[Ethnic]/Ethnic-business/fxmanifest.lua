fx_version 'cerulean'
game 'gta5'


shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    '@Ethnic-assets/client/cl_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    '@Ethnic-inventory/shared/sh_items.lua',
    'client/cl_*.lua',
}
   
server_scripts {
    '@Ethnic-assets/server/sv_errorlog.lua',
    '@Ethnic-base/shared/sh_shared.lua',
    '@Ethnic-inventory/shared/sh_items.lua',
    'server/sv_*.lua',
}

lua54 'yes'