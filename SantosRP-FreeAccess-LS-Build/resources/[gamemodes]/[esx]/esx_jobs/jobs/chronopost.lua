Config.Jobs.chrono = {

	BlipInfos = {
		Sprite = 477,
		Color = 4
	},

	Vehicles = {
		Truck = {
			Spawner = 1,
			Hash = "mule3",
			Trailer = "none",
			HasCaution = true
		}
	},

	Zones = {

		CloakRoom = {
			Pos = {x = 53.771, y = 115.089, z = 78.187},
			Size = {x = 2.0, y = 2.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = "Vestiaire de chronopost",
			Type = "cloakroom",
			Hint = "Appuyez sur ~INPUT_PICKUP~ pour prendre votre service."
		},

		Palette = {
			Pos = {x = 62.640, y = 126.950, z = 78.206},
			Size = {x = 8.0, y = 8.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = "Entrepot de palettes",
			Type = "work",
			Item = {
				{
					name = "Palette",
					db_name = "palette",
					time = 3,
					max = 18,
					add = 2,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = "Appuyez sur ~INPUT_PICKUP~ pour récupérer des palettes."
		},

		Colis = {
			Pos = {x = -353.726, y = -225.243, z = 36.289},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = "Centre de tri colis",
			Type = "work",
			Item = {
				{
					name = _U("lj_cutwood"),
					db_name = "colis",
					time = 4,
					max = 25,
					add = 5,
					remove = 2,
					requires = "palette",
					requires_name = "palette",
					drop = 100
				}
			},
			Hint = "Appuyez sur ~INPUT_PICKUP~ pour commencer le tri."
		},

		VehicleSpawner = {
			Pos = {x = 71.026, y = 108.716, z = 78.195},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_veh_button"),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = {x = 72.624, y = 120.202, z = 78.181},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			GPS = 0,
			Heading = 264.40
		},

		VehicleDeletePoint = {
			Pos = {x = 65.992, y = 117.459, z = 78.159},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("return_vh"),
			Type = "vehdelete",
			Hint = _U("return_vh_button"),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = -250.574, y = -249.250, z = 35.518},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U("delivery_point"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				{
					name = _U("delivery"),
					time = 1,
					remove = 5,
					max = 100,
					price = 40,
					requires = "colis",
					requires_name = "colis",
					drop = 100
				}
			},
			Hint = "Appuyez sur ~INPUT_PICKUP~ pour livrer les colis."
		}
	}
}