fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

dependencies {
    'ox_lib',
    "feather-menu"
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
}

client_script "client.lua"
server_script "server.lua"

files {
    "client/*.lua",
    "**/shared.lua",
    "**/client.lua",
}
