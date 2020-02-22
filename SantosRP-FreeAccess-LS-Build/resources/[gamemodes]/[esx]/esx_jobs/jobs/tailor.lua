Config.Jobs.tailor = {
	BlipInfos = {
		Sprite = 366,
		Color = 4
	},
	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "youga2",
			Trailer = "none",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 367.861, y = 351.247, z = 101.824},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_dress_locker"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			GPS = {x = 367.861, y = 351.247, z = 101.824}
		},

		Wool = {
			Pos = {x = 118.155, y = -227.478, z = 53.557},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_wool"),
			Type = "work",
			Item = {
				{
					name = _U("dd_wool"),
					db_name = "wool",
					time = 3,
					max = 40,
					add = 1,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("dd_pickup"),
			GPS = {x = 118.155, y = -227.478, z = 54.557}
		},

		Fabric = {
			Pos = {x = 161.807, y = -258.089, z = 49.399},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_fabric"),
			Type = "work",
			Item = {
				{
					name = _U("dd_fabric"),
					db_name = "fabric",
					time = 5,
					max = 80,
					add = 2,
					remove = 2,
					requires = "wool",
					requires_name = _U("dd_wool"),
					drop = 100
				}
			},
			Hint = _U("dd_makefabric"),
			GPS = {x = 712.92, y = -970.58, z = 29.39}
		},

		Clothe = {
			Pos = {x = 156.105, y = -253.904, z = 49.399},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_clothing"),
			Type = "work",
			Item = {
				{
					name = _U("dd_clothing"),
					db_name = "clothe",
					time = 4,
					max = 40,
					add = 2,
					remove = 2,
					requires = "fabric",
					requires_name = _U("dd_fabric"),
					drop = 100
				}
			},
			Hint = _U("dd_makeclothing"),
			GPS = {x = 156.105, y = -253.904, z = 49.399}
		},

		VehicleSpawner = {
			Pos = {x = 364.770, y = 337.753, z = 102.449},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_veh_button"),
			Caution = 2000,
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		},

		VehicleSpawnPoint = {
			Pos = {x = 366.837, y = 333.132, z = 103.463},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 270.1,
			GPS = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 366.195, y = 345.099, z = 102.310},
			Size = {x = 3.0, y = 3.0, z = 1.0},
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
			Pos = {x = 124.937, y = -223.506, z = 53.557},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U("delivery_point"),
			Type = "delivery",
			Spawner = 1,
			Item = {
				{
					name = _U("delivery"),
					time = 1000,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 15,
					requires = "clothe",
					requires_name = _U("dd_clothing"),
					drop = 100
				}
			},
			Hint = _U("dd_deliver_clothes"),
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		}
	}
}
