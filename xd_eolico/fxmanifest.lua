
fx_version "bodacious"
game "gta5"
author "UL xD #6485"

ui_page 'web-side/ui.html'

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/*"
}
files {
	'web-side/*.html',
	'web-side/*.css',
	'web-side/*.js'
}
