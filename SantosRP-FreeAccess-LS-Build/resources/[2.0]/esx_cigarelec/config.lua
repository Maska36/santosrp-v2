Config = {}
Config.DrawDistance = 40.0
Config.MaxInService = -1
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'

Config.Zones = {
	NicotineFarm = {
		Pos   = vector3(2037.635, 1070.091, 199.746),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Récolte de Nicotine",
		Type  = 1
	},

	TraitementLiquide = {
		Pos   = vector3(268.304, -638.883, 41.020),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Traitement du Liquide",
		Type  = 1
	},

	TraitementBatterie = {
		Pos   = vector3(1916.608, 582.290, 175.367),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Traitement de Batterie",
		Type  = 1
	},
	
	SellFarm = {
		Pos   = vector3(-678.224, -854.739, 22.073),
		Size  = {x = 3.5, y = 3.5, z = 2.0},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Vente des produits",
		Type  = 1
	},

	CigElecActions = {
    	Pos   = vector3(-683.254, -876.175, 23.499),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Cigarette Electronique",
		Type  = 1
	 },
	  
	VehicleSpawner = {
		Pos   = vector3(-688.549, -885.045, 24.499),
		Size = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Garage véhicule",
		Type  = 36
	},

	VehicleSpawnPoint = {
		Pos   = vector3(-682.505, -885.549, 24.499),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = vector3(-688.549, -878.565, 24.499),
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 150, g = 150, b = 150},
		Name  = "Ranger son véhicule",
		Type  = -1
	}
}

Config.ZonesDeleter = {
	VehicleDeleter = {
		Pos   = vector3(-688.549, -878.565, 24.499),
    	Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 150, g = 150, b = 150},
    	Name  = "Ranger son véhicule",
    	Type  = 36
	}
}