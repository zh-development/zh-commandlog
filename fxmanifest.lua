fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'zh-development'
description 'Discord Webhook chat command log'
version '0.0.2'

server_scripts {
    'config.lua',
    'commandChecker.lua',
    'webhook.lua',
    'main.lua'
}

server_only 'yes'
