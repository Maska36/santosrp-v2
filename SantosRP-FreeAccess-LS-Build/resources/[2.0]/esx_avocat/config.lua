Config = {}
Config.DrawDistance = 40.0
Config.MaxInService = -1
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'

Config.Zones = {
	AvocatActions = {
    	Pos   = vector3(223.530,-439.018, 46.955),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 200, g = 50, b = 50},
		Name  = "Tribunal",
		Type  = 1
	 },
	  
	VehicleSpawner = {
		Pos   = vector3(195.214, -406.092, 45.249),
		Size = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 200, g = 50, b = 50},
		Name  = "Garage véhicule",
		Type  = 36
	},

	VehicleSpawnPoint = {
		Pos   = vector3(187.836, -398.158, 44.129),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 200, g = 50, b = 50},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = vector3(185.591, -403.698, 44.100),
		Size  = {x = 3.0, y = 3.0, z = 3.0},
		Color = {r = 200, g = 50, b = 50},
		Name  = "Ranger son véhicule",
		Type  = -1
	}
}

Config.ZonesDeleter = {
	VehicleDeleter = {
		Pos   = vector3(185.591, -403.698, 44.100),
    	Size  = {x = 3.0, y = 3.0, z = 3.0},
    	Color = {r = 200, g = 50, b = 50},
    	Name  = "Ranger son véhicule",
    	Type  = 36
	}
}