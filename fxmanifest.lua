fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'TRClassic#0001, Mycroft, Benzo, Converter: Atu.#7878'
description 'LumberJack Job For QB-Core, Converted to ESX.... Modified by Atu.#7878'
version '2.0.2'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

dependencies {
    'PolyZone',
    'es_extended',
    'qtarget'
}