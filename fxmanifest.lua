name "mustache-"
author "mustache_dom"
description " by mustache dom"
fx_version "cerulean"
game "gta5"
version  '1.0.0'
ui_page 'web/build/index.html'
client_scripts {
	'client/**.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
	'init.lua',
}

lua54 'yes'

files {
  'Modules/**/**/**/**.lua',
  'injector.lua',
  'settings.lua',
}