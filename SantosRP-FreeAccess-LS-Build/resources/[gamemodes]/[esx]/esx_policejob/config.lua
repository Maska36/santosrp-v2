Config                            = {}

Config.DrawDistance = 100.0
Config.MarkerType = 1
Config.MarkerSize = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true
Config.EnableESXIdentity = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds = false -- turn this on if you want custom peds
Config.EnableLicenses = true -- enable if you're using esx_license

Config.EnableHandcuffTimer = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer = 10 * 60000 -- 10 mins

Config.ArrestDistance = 3.0

Config.EnableJobBlip = true -- enable blips for cops on duty, requires esx_society
Config.EnableCustomPeds = false -- enable custom peds in cloak room? See Config.CustomPeds below to customize peds

Config.EnableESXService = false -- enable esx service?
Config.MaxInService = -1

Config.Locale                     = 'fr'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Coords  = vector3(637.54,1.95,82.7),
			Sprite  = 60,
			Display = 4,
			Scale   = 0.8,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(619.6226, 13.93226, 82.77786)
		},

		PoliceMenu = {
			vector3(622.730, -3.669, 81.778)
		},

		Armories = {
			vector3(626.4866, -23.30062, 82.77972)
		},

		Vehicles = {
			{
				Spawner = vector3(535.80,-33.74,70.64),
				InsideShop = vector3(532.644,-28.134,70.63),
				SpawnPoints = {
					{ coords = vector3(535.46,-27.67,70.63), heading = -150.0, radius = 6.0 },
					{ coords = vector3(531.09,-30.68,70.63), heading = -150.0, radius = 6.0 },
					{ coords = vector3(535.78,-40.85,70.79), heading = -150.0, radius = 6.0 },
					{ coords = vector3(541.47,-39.05,70.74), heading = -150.0, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(572.325,11.936,103.230),
				InsideShop = vector3(579.669,12.428,103.233),
				SpawnPoints = {
					{ coords = vector3(579.669,12.428,103.233), heading = 92.6, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(631.0932, -13.00895, 82.77872)
		},

		ToRoof = {
			vector3(630.7753, 11.18897, 90.23703)
		},

		ToNotRoof = {
			vector3(565.68194580078,4.9324645996094,103.23313140869)
		}
	}
}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 150 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 80 }
	},

	officer = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	sergeant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 7000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 7000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	lieutenant = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 7000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	chef = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 7000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},

	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1000 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 5000 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 70000 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 500 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{ model = 'policeold2', label = 'Police Interceptor', price = 200 },
		{ model = 'police', label = 'Police Buffalo', price = 200 },
		{ model = 'fbi', label = 'Buffalo Banalisée', price = 200 },
		{ model = 'police4', label = 'Poilice BAC', price = 200 },
		{ model = 'stanier', label = 'Stanier Banalisée', price = 200 },
	},

	recruit = {
	},

	officer = {
		{ model = 'police2', label = 'Police McLaren', price = 2000 }
	},

	sergeant = {
		{ model = 'policet', label = 'Police Transporter', price = 1850 },
		{ model = 'policeb', label = 'Police Moto', price = 3050 },
		{ model = 'police2', label = 'Police McLaren', price = 2000 }
	},

	intendent = {
		{ model = 'police2', label = 'Police McLaren', price = 2000 },
		{ model = 'riot', label = 'Police Riot', price = 7000 },
		{ model = 'fbi2', label = 'FIB SUV', price = 6000 }
	},

	lieutenant = {
		{ model = 'policet', label = 'Police Transporter', price = 1850 },
		{ model = 'policeb', label = 'Police Moto', price = 3050 },
		{ model = 'police2', label = 'Police McLaren', price = 2000 },
		{ model = 'riot', label = 'Police Riot', price = 7000 },
		{ model = 'fbi2', label = 'FIB SUV', price = 6000 }
	},

	chef = {
		{ model = 'policet', label = 'Police Transporter', price = 1850 },
		{ model = 'policeb', label = 'Police Moto', price = 3050 },
		{ model = 'police2', label = 'Police McLaren', price = 2000 },
		{ model = 'riot', label = 'Police Riot', price = 7000 },
		{ model = 'fbi2', label = 'FIB SUV', price = 6000 }
	},

	boss = {
		{ model = 'police3', label = 'Police McLaren Supreme', price = 2000 },
		{ model = 'police2', label = 'Police McLaren', price = 800 },
		{ model = 'policet', label = 'Police Transporter', price = 1850 },
		{ model = 'policeb', label = 'Police Moto', price = 3050 },
		{ model = 'riot', label = 'Police Riot', price = 7000 },
		{ model = 'fbi2', label = 'FIB SUV', price = 6000 }
	}
}

Config.AuthorizedHelicopters = {
	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {},

	lieutenant = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 20000 }
	},

	chef = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 15000 }
	},

	boss = {
		{ model = 'polmav', label = 'Police Maverick', livery = 0, price = 10000 }
	}
}

Config.CustomPeds = {
	shared = {
		{label = 'Sheriff Ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		{label = 'Police Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	intendent = {},

	lieutenant = {},

	chef = {},

	boss = {
		{label = 'SWAT Ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = 46,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	officer = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	sergeant = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 1,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 1,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	intendent = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 2,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 2,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	lieutenant = {-- currently the same as intendent
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 2,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 2,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	chef = {
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 3,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 3,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	boss = {-- currently the same as chef
		male = {
			tshirt_1 = 58,  tshirt_2 = 0,
			torso_1 = 55,   torso_2 = 0,
			decals_1 = 8,   decals_2 = 3,
			arms = 41,
			pants_1 = 25,   pants_2 = 0,
			shoes_1 = 25,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		},
		female = {
			tshirt_1 = 35,  tshirt_2 = 0,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 7,   decals_2 = 3,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = -1,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	bullet_wear = {
		male = {
			bproof_1 = 11,  bproof_2 = 1
		},
		female = {
			bproof_1 = 13,  bproof_2 = 1
		}
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1
		}
	}
}