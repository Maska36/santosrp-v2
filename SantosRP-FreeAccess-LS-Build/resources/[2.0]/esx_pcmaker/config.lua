Config = {}
Config.DrawDistance = 40.0
Config.MaxInService = -1
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'

Config.Zones = {
	CircuitFarm = {
		Pos   = vector3(1539.737,1719.870,108.162),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Récolte de Circuit Informatique",
		Type  = 1
	},

	TraitementGPU = {
		Pos   = vector3(-449.979,-48.850,42.51),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Assemblage des Cartes Graphique",
		Type  = 1
	},

	TraitementCM = {
		Pos   = vector3(-536.411,-45.647,40.80),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Assemblage des Cartes Mere",
		Type  = 1
	},
	
	SellFarm = {
		Pos   = vector3(-102.241,-81.034,56.100),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Type  = 1
	},

	PCMakerActions = {
    	Pos   = vector3(-104.627, -69.480, 57.858),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Informaticien",
		Type  = 1
	 },
	  
	VehicleSpawner = {
		Pos   = vector3(-95.940, -72.135, 58.858),
		Size = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 36
	},

	VehicleSpawnPoint = {
		Pos   = vector3(-94.380, -65.073, 56.583),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = vector3(-95.160, -69.484, 56.652),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Ranger son véhicule",
		Type  = -1
	}
}

Config.ZonesDeleter = {
  VehicleDeleter = {
    Pos   = vector3(-95.160, -69.484, 56.652),
    Size  = {x = 1.5, y = 1.5, z = 1.5},
    Color = {r = 136, g = 243, b = 216},
    Name  = "Ranger son véhicule",
    Type  = 36
  }
}