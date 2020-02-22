Config = {}
Config.DrawDistance = 40.0
Config.MaxInService = -1
Config.EnablePlayerManagement = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'

Config.Zones = {
  TabacFarm = {
    Pos   = vector3(2886.972, 4609.456, 46.987),
    Size  = {x = 3.5, y = 3.5, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Récolte de Tabac",
    Type  = 1,
  },

  TraitementTabac = {
    Pos   = vector3(1741.2401123047,-1633.4063720703,111.47246551514),
    Size  = {x = 2.0, y = 2.0, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Traitement de Tabac",
    Type  = 1,
  },

  TraitementCigarette = {
    Pos   = vector3(1147.20703125,-298.58969116211,68.097518920898),
    Size  = {x = 3.5, y = 3.5, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Traitement de Cigarette",
    Type  = 1,
  },

  SellFarm = {
    Pos   = vector3(418.59820556641,61.5185546875,96.977912902832),
    Size  = {x = 3.5, y = 3.5, z = 2.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Vente des produits",
    Type  = 1,
  },

  TabacActions = {
    Pos   = vector3(977.213, -104.036, 73.845),
    Size  = {x = 1.5, y = 1.5, z = 1.5},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Tabac",
    Type  = 1,
  },
    
  VehicleSpawner = {
    Pos   = vector3(970.194,-113.678,74.353),
    Size = {x = 1.5, y = 1.5, z = 1.5},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Garage véhicule",
    Type  = 36
  },

  VehicleSpawnPoint = {
    Pos   = vector3(964.869, -119.276, 73.353),
    Size  = {x = 1.5, y = 1.5, z = 1.5},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Spawn point",
    Type  = -1,
  },

  VehicleDeleter = {
    Pos   = vector3(984.083, -136.764, 73.365),
    Size  = {x = 3.0, y = 3.0, z = 3.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Ranger son véhicule",
    Type  = -1,
  }
}

Config.ZonesDeleter = {
  VehicleDeleter = {
    Pos   = vector3(984.083, -136.764, 73.365),
    Size  = {x = 3.0, y = 3.0, z = 3.0},
    Color = {r = 204, g = 204, b = 0},
    Name  = "Ranger son véhicule",
    Type  = 36
  }
}