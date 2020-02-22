Config                            = {}
Config.DrawDistance               = 40.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'fr'

Config.Zones = {
	RaisinFarm = {
		Pos   = vector3(-1809.662, 2210.119, 89.681),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Récolte de raisin",
		Type  = 1
	},

	TraitementVin = {
		Pos   = vector3(-53.116, 1903.248, 194.361),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Traitement du Vin",
		Type  = 1
	},

	TraitementJus = {
		Pos   = vector3(811.337, 2179.402, 51.388),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Traitement du Jus de raisin",
		Type  = 1
	},
	
	SellFarm = {
		Pos   = vector3(-158.737, -54.651, 53.396),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Vente des produits",
		Type  = 1
	},

	VigneronActions = {
		Pos   = vector3(-1912.372, 2072.8010, 139.387),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Point d'action",
		Type  = 1
	 },
	  
	VehicleSpawner = {
		Pos   = vector3(-1889.653, 2050.071, 140.985),
		Size = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Garage véhicule",
		Type  = 36
	},

	VehicleSpawnPoint = {
		Pos   = vector3(-1903.984,  2058.367, 140.722),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = vector3(-1913.550, 2030.590, 140.738),
		Size  = {x = 3.0, y = 3.0, z = 3.0},
		Color = {r = 144, g = 66, b = 245},
		Name  = "Ranger son véhicule",
		Type  = -1
	}
}

Config.ZonesDeleter = {
  VehicleDeleter = {
	Pos   = vector3(-1913.550, 2030.590, 140.738),
    Size  = {x = 3.0, y = 3.0, z = 3.0},
	Color = {r = 144, g = 66, b = 245},
    Name  = "Ranger son véhicule",
    Type  = 36
  }
}