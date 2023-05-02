--===== FiveM Script =========================================
--= drugsale - YUPPZWORKSHOP CFX (Webhook)
--===== Developed By: ========================================
--= YUPPZWORKSHOP CFX
--= Copyright (C) YUPPZWORKSHOP CFX - All Rights Reserved
--= You are not allowed to sell this script or edit
--============================================================

fx_version 'adamant'
game 'gta5'

description 'YUPPz WORKSHOP CFX'

client_scripts {
	'./config.lua',
	'client/main.lua',
}

server_scripts {
	'./config.lua',
	'server/main.lua',
	'@oxmysql/lib/MySQL.lua',
}
