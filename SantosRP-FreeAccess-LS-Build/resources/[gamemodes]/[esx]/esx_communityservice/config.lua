Config = {}

-- # Locale to be used. You can create your own by simple copying the 'en' and translating the values.
Config.Locale = 'fr'

-- # By how many services a player's community service gets extended if he tries to escape
Config.ServiceExtensionOnEscape = 3

-- # Don't change this unless you know what you are doing.
Config.ServiceLocation = {x =  1674.824, y = 2588.047, z = 45.585}

-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation = {x = 637.427, y = -2.157, z = 82.786}


-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1666.0244140625,2592.3930664063,45.587215423584) },
	{ type = "cleaning", coords = vector3(1668.2589111328,2592.2521972656,45.586891174316) },
	{ type = "cleaning", coords = vector3(1674.6947021484,2593.5229492188,45.585597991943) },
	{ type = "cleaning", coords = vector3(1674.3298339844,2583.1630859375,45.586097717285) },
	{ type = "cleaning", coords = vector3(1668.1531982422,2579.0256347656,45.587028503418) },
	{ type = "cleaning", coords = vector3(1668.3447265625,2588.2648925781,45.586990356445) },
	{ type = "cleaning", coords = vector3(1668.9609375,2584.0,45.586933135986) },
	{ type = "cleaning", coords = vector3(1665.9034423828,2585.5053710938,45.587390899658) }
}



Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 119, ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 120,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}
