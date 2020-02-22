Config = {}
Config.DrawDistance = 40.0
Config.MaxInService = -1
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'

Config.Zones = {
	PepiteDorFarm = {
		Pos   = vector3(2271.170, -544.868, 95.435),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Récolte de pepite d'or",
		Type  = 1
	},

	TraitementLingotDor = {
		Pos   = vector3(1260.295, -1965.913, 43.263),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Traitement de lingot d'or",
		Type  = 1
	},

	SellFarm = {
		Pos   = vector3(-96.328, -806.523, 43.038),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Vente des lingots d'or",
		Type  = 1
	},

	OrpailleursActions = {
		Pos   = vector3(1392.126, 1153.167, 113.443),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Point d'action",
		Type  = 1
	 },
	  
	VehicleSpawner = {
		Pos   = vector3(1373.134, 1152.035, 113.759),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Garage véhicule",
		Type  = 36
	},

	VehicleSpawnPoint = {
		Pos   = vector3(1368.604, 1151.556, 113.759),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = vector3(1360.814, 1140.007, 113.759),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 224, g = 214, b = 16},
		Name  = "Ranger son véhicule",
		Type  = -1
	}
}

Config.ZonesDeleter = {
  VehicleDeleter = {
	Pos   = vector3(1360.814, 1140.007, 113.759),
    Size  = {x = 1.5, y = 1.5, z = 1.5},
	Color = {r = 224, g = 214, b = 16},
    Name  = "Ranger son véhicule",
    Type  = 36
  }
}