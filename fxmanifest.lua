fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts { 
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	-- '@es_extended/locale.lua',
	'config.lua',
}

client_scripts {
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}



