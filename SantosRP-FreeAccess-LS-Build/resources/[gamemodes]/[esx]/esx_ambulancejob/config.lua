Config                            = {}

Config.DrawDistance               = 40.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 255, g = 20, b = 0, a = 100, rotate = true }

Config.ReviveReward               = 0  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?

Config.Locale                     = 'fr'

Config.EarlyRespawnTimer          = 60000 * 5  -- time til respawn is available
Config.BleedoutTimer              = 60000 * 10 -- time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(300.018, -579.175, 43.260), heading = 48.5 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(298.996, -584.676, 43.260),
			sprite = 61,
			scale  = 0.8,
			color  = 1
		},

		AmbulanceActions = {
			vector3(317.155,-601.656,42.292)
		},

		Pharmacies = {
			vector3(345.089,-576.847,42.281)
		},

		Vehicles = {
			{
				Spawner = vector3(297.101, -605.159, 43.320),
				InsideShop = vector3(289.147,-603.819,43.175),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 20, b = 0, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(289.147,-603.819,43.175), heading = 90.6, radius = 4.0 },
					{ coords = vector3(289.147,-603.819,43.175), heading = 90.6, radius = 4.0 },
					{ coords = vector3(289.147,-603.819,43.175), heading = 90.6, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(341.078, -581.727, 74.165),
				InsideShop = vector3(352.024, -587.765, 74.165),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 20, b = 0, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.024, -587.765, 74.165), heading = 142.7, radius = 10.0 },
					{ coords = vector3(352.024, -587.765, 74.165), heading = 142.7, radius = 10.0 }
				}
			}
		}
	}
}

Config.AuthorizedVehicles = {
	car = {
		ambulance = {
			{ model = 'ambulance', label = 'Ambulance Van', price = 500},
			{ model = 'dodgeEMS', label = 'Dodge EMS', price = 700},
		},

		doctor = {
			{ model = 'ambulance', label = 'Ambulance Van', price = 450},
			{ model = 'dodgeEMS', label = 'Dodge EMS', price = 700},
		},

		chief_doctor = {
			{ model = 'ambulance', label = 'Ambulance Van', price = 300},
			{ model = 'dodgeEMS', label = 'Dodge EMS', price = 700},
		},

		boss = {
			{ model = 'ambulance', label = 'Ambulance Van', price = 200},
			{ model = 'dodgeEMS', label = 'Dodge EMS', price = 700},
		}
	},

	helicopter = {
		ambulance = {},

		doctor = {
			{ model = 'polmav', label = 'Ambulance Maverick', price = 15000 }
		},

		chief_doctor = {
			{ model = 'polmav', label = 'Ambulance Maverick', price = 15000 },
			{ model = 'seasparrow', label = 'Sea Sparrow', price = 30000 }
		},

		boss = {
			{ model = 'polmav', label = 'Ambulance Maverick', price = 1000 },
			{ model = 'seasparrow', label = 'Sea Sparrow', price = 25000 }
		}
	}
}
