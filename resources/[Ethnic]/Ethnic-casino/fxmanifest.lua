fx_version 'cerulean'
game "gta5"

author "Kane @ .gg/Ethnic-coll"
description "Casino Wheel"

shared_scripts {
	"shared/sh_*.lua",
}

client_scripts {
	'@Ethnic-polyzone/client/cl_main.lua',
	'@Ethnic-polyzone/client/BoxZone.lua',
	'@Ethnic-polyzone/client/ComboZone.lua',
	"client/**.lua",
}

server_script {
	"shared/sv_*.lua",
	"server/**.lua",
}

lua54 'yes'