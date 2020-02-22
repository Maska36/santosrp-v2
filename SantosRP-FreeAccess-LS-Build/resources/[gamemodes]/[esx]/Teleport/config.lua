Config = {}

-- C key by default
Config.actionKey = 26

-- markers AKA Teleporters
Config.zones = {
	WeedEnter = {          --This is the exit where you go to exit the weed warehouse
		x = -1151.0084,
		y = -2035.349,
		z = 13.160,
		w = 2.0,
		h = 1.0,
		visible = false, -- Set this to true to make the marker visible. False to disable it.
		t = 29,          -- This is the marker. You can change it https://docs.fivem.net/game-references/markers
		color = {
			r = 0,
			g = 102,
			b = 0
		}
	},
	WeedExit = {          --This is the exit where you go to exit the weed warehouse
		x = 1066.305,
		y = -3183.464,
		z = -39.16,
		w = 2.0,
		h = 1.0,
		visible = false,
		t = 29,
		color = {
			r = 0,
			g = 102,
			b = 0
		}
	},
	YakuzaEnter = {          --This is the exit where you go to exit the weed warehouse
		x = -1873.575,
		y = 201.797,
		z = 84.0,
		w = 1.2,
		h = 1.0,
		visible = false, -- Set this to true to make the marker visible. False to disable it.
		t = 1,          -- This is the marker. You can change it https://docs.fivem.net/game-references/markers
		color = {
			r = 0,
			g = 0,
			b = 0
		}
	},
	YakuzaExit = {          --This is the exit where you go to exit the weed warehouse
		x = 1004.831,
		y = -2997.507,
		z = -40.0,
		w = 1.2,
		h = 1.0,
		visible = false,
		t = 1,
		color = {
			r = 0,
			g = 0,
			b = 0
		}
	},
	MethEnter = {
		x = 765.144,
		y = -1643.497,
		z = 30.06,
		w = 2.0,
		h = 1.0,		
		visible = false,
		t = 1,
		color = {
			r = 102,
			g = 0,
			b = 0,
		}
	},
	MethExit = {
		x = 996.913,
		y = -3200.625,
		z = -36.393,
		w = 2.0,
		h = 1.0,		
		visible = false,
		t = 1,
		color = {
			r = 102,
			g = 0,
			b = 0
		}
	},
	CokeEnter = {
		x = 2477.168,
		y = -401.725,
		z = 94.816,
		w = 2.0,
		h = 1.0,		
		visible = false,
		t = 1,
		color = {
			r = 102,
			g = 0,
			b = 0
		}
	},
	CokeExit = {
		x = 1088.714,
		y = -3187.481,
		z = -38.993,
		w = 2.0,
		h = 1.0,		
		visible = false,
		t = 1,
		color = {
			r = 102,
			g = 0,
			b = 0
		}
	}
}

-- Landing point, keep the same name as markers
Config.point = {
	WeedEnter = {           --This is where you land when you use the entrance teleport.
		x = 1064.487,
		y = -3183.569,
		z = -39.164,
	},
	
	WeedExit = {           --This is the exit where you go to exit the weed warehouse
		x = -1154.408,
		y = -2031.615,
		z = 13.160,
	},

	YakuzaEnter = {           --This is where you land when you use the entrance teleport.
		x = 978.320,
		y = -3020.312,
		z = -39.64699,
	},

	YakuzaExit = {          --This is the exit where you go to exit the weed warehouse
		x = -1875.077,
		y = 202.996,
		z = 84.0,
	},
	MethEnter = {
		x = 997.9730,
		y = -3198.2941,
		z = -36.393,
	},
	
	MethExit = {
		x = 768.908,
		y = -1643.751,
		z = 30.077,
	},

	CokeEnter = {
		x = 1088.895,
		y = -3189.959, 
		z = -38.993,
	},
	
	CokeExit = {
		x = 2488.197,
		y = -404.0271,
		z = 93.735,
	}
}


-- Automatic teleport list (no need to puseh E key in the marker)
Config.auto = {
	'WeedEnter',
	'WeedExit',
	'CokeEnter',
	'CokeExit',
	'MethEnter',
	'MethExit',
	'YakuzaEnter',
	'YakuzaExit',
}
