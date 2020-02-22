Config = {}
Config.Locale = 'fr'

Config.DoorList = {
	{
		objName = `prop_strip_door_01`,
		objCoords  = vector3(127.9552, -1298.503, 29.41962),
		objYaw = 30.0,
		textCoords = vector3(128.4552, -1298.003, 29.91962),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2,
		size = 1
	},
	{
		objName = `prop_gate_prison_01`,
		objCoords  = vector3(1799.6, 2616.9, 44.6),
		textCoords = vector3(1795.89, 2617.29, 47.4),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 1
	},
 	{
		objName = `prop_gate_prison_01`,
		objCoords  = vector3(1830.1, 2703.49, 44.4),
		textCoords = vector3(1830.89, 2699.70, 47.4),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 1
	},
 	{
		objName = `prop_gate_prison_01`,
		objCoords  = vector3(1835.2, 2689.1, 44.4),
		textCoords = vector3(1833.75, 2692.48, 47.4),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 1
	},
	{
		objName = `lr_prop_supermod_door_01`,
		objCoords  = vector3(-205.6828, -1310.683, 30.29572),
		textCoords  = vector3(-205.6828, -1310.683, 31.69),
		authorizedJobs = { 'mechanic' },
		locked = true,
		distance = 5,
		size = 2
	},
	{
		textCoords = vector3(-2342.8 , 3266.3, 33.5),
		authorizedJobs = { 'interpol' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_ct_doorr`,
				objYaw = 240.0,
				objCoords = vector3(-2342.8, 3265.5, 32.8)
			},

			{
				objName = `v_ilev_ct_doorl`,
				objYaw = -300.0,
				objCoords = vector3(-2340.8, 3267.5, 32.8)
			}
		}
	},
	{
		textCoords = vector3(637.653, 2.138, 83.300), -- Entrée comico
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = `int_vinewood_police_door_l`,
				objYaw = 69.7,
				objCoords = vector3(637.488, 0.770, 82.786)
			},
			{
				objName = `int_vinewood_police_door_l`,
				objYaw = 69.7,
				objCoords = vector3(638.1617, 2.797115, 82.78697)
			}
		}
	},
	{
		objName = `v_ilev_roc_door2`, -- To Vestiaire
		objYaw = 70.0,
		objCoords  = vector3(619.755, 4.259, 82.775),
		textCoords = vector3(619.755, 4.259, 83.375),
		authorizedJobs = { 'police' },
		locked = true	
	},
	{
		objName = `v_ilev_ph_cellgate`, -- To Cellules
		objYaw = -20.0,
		objCoords  = vector3(613.921, -2.149, 82.780),
		textCoords = vector3(613.621, -2.149, 82.990),
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = `v_ilev_ph_gendoor002`, -- To Captain Office
		objYaw = -20.0,
		objCoords  = vector3(619.552, -4.319, 82.780),
		textCoords = vector3(619.552, -4.319, 83.380),
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = `v_ilev_arm_secdoor`, -- Armurerie
		objYaw = 160.0,
		objCoords  = vector3(618.968, -18.639, 82.777),
		textCoords = vector3(618.968, -18.639, 83.377),
		authorizedJobs = { 'police' },
		locked = true
	},
	{
		objName = `v_ilev_ph_gendoor003`, -- Captain Office
		objYaw = -110.0,
		objCoords  = vector3(624.572, -15.741, 82.778),
		textCoords = vector3(624.572, -15.741, 83.378),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Cells
	--
	-- Main Cells
	{
		objName = `v_ilev_ph_cellgate`,
		objYaw = 160.0,
		objCoords  = vector3(612.408, -11.341, 82.782),
		textCoords = vector3(613.008, -11.641, 82.982),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 1
	{
		objName = `v_ilev_ph_cellgate`,
		objYaw = 160.0,
		objCoords  = vector3(608.567, -10.120, 82.782),
		textCoords = vector3(609.167, -10.120, 82.982),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 2
	{
		objName = `v_ilev_ph_cellgate`,
		objYaw = 160.0,
		objCoords  = vector3(604.719, -8.754, 82.781),
		textCoords = vector3(605.319, -8.754, 82.981),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 3
	{
		objName = `v_ilev_ph_cellgate`,
		objYaw = 160.0,
		objCoords  = vector3(600.871, -7.321, 82.783),
		textCoords = vector3(601.471, -7.321, 82.983),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To Back
	{
		objName = `v_ilev_gtdoor`,
		objYaw = 160.0,
		objCoords  = vector3(617.20,32.64,76.9),
		textCoords = vector3(617.515,32.603,77.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Fédéral
	{
		objName = `v_ilev_gtdoor`,
		objYaw = 0.0,
		objCoords  = vector3(1691.5347900391,2566.6315917969,45.596248626709),
		textCoords = vector3(1691.5347900391,2566.6315917969,46.096248626709),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Sandy Shores
	--

	-- Hallway to roof
	{
		textCoords = vector3(460.7, -990.80, 31.4),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 3,
		doors = {
			{
				objName = `v_ilev_ph_gendoor006`,
				objYaw = -90.0,
				objCoords  = vector3(460.5, -991.6, 30.8)
			},

			{
				objName = `v_ilev_ph_gendoor006`,
				objYaw = 90.0,
				objCoords  = vector3(460.9, -989.99, 30.8)
			}
		}
	},

	-- Entrance
	{
		objName = `v_ilev_ph_gendoor006`,
		objYaw = 0,
		objCoords  = vector3(465.5, -996.2, 30.8),
		textCoords = vector3(465.5, -996.2, 30.8),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Entrance
	{
		objName = `v_ilev_shrfdoor`,
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_shrf2door`,
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = `v_ilev_shrf2door`,
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = `prop_gate_prison_01`,
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = `prop_gate_prison_01`,
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},
	-- double door étage
	{
		textCoords = vector3(443.006, -993.30, 31.4),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_ph_gendoor006`,
				objYaw = 90.0,
				objCoords  = vector3(442.940, -992.50, 30.689),
			},

			{
				objName = `v_ilev_ph_gendoor006`,
				objYaw = 270.0,
				objCoords  = vector3(443.206, -993.40, 30.689),
			}
		}
	},

	-- Ammu Nation
	{
		textCoords = vector3(811.8779, -2148.27, 29.96892),
		authorizedJobs = { 'ammu' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_gc_door04`,
				objYaw = 0.0,
				objCoords  = vector3(813.1779, -2148.27, 29.76892),
			},

			{
				objName = `v_ilev_gc_door03`,
				objYaw = 180.0,
				objCoords  = vector3(810.5769, -2148.27, 29.76892),
			}
		}
	},

	-- Derriere Bank 
	{
		textCoords = vector3(259.2432, 203.2052, 106.8049),
		authorizedJobs = { 'banker' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `hei_prop_hei_bankdoor_new`,
				objYaw = 160.0,
				objCoords  = vector3(260.6432, 203.2052, 106.4049),
			},

			{
				objName = `hei_prop_hei_bankdoor_new`,
				objYaw = -20.0,
				objCoords  = vector3(258.2022, 204.1005, 106.4049),
			}
		}
	},

	-- Devant Bank 
	{
		textCoords = vector3(232.0054, 215.2584, 106.8049),
		authorizedJobs = { 'banker' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `hei_prop_hei_bankdoor_new`,
				objYaw = 115.0,
				objCoords  = vector3(232.72, 213.88, 106.4),
			},

			{
				objName = `hei_prop_hei_bankdoor_new`,
				objYaw = -65.0,
				objCoords  = vector3(231.62, 216.23, 106.4),
			}
		}
	},
	{
		objName = `v_ilev_fib_door1`,
		objCoords  = vector3(-32.00, -1102.47, 27.08362),
		textCoords = vector3(-32.00, -1102.47, 27.08362),
		authorizedJobs = { 'cardealer' },
		locked = true,
		distance = 2.5,
		size = 1
	},
	{
		objName = `v_ilev_fib_door1`,
		objCoords  = vector3(-33.77, -1108.24, 27.08362),
		textCoords = vector3(-33.87, -1108.24, 27.08362),
		authorizedJobs = { 'cardealer' },
		locked = true,
		distance = 2.5,
		size = 1
	},
	-- Derriere CarDealer
	{
		textCoords = vector3(-59.89302, -1093.952, 27.28362),
		authorizedJobs = { 'cardealer' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_csr_door_r`,
				objYaw = -110.0,
				objCoords  = vector3(-60.54582, -1094.749, 26.88872),
			},

			{
				objName = `v_ilev_csr_door_l`,
				objYaw = -110.0,
				objCoords  = vector3(-59.89302, -1092.952, 26.88362),
			}
		}
	},

	-- Devant CarDealer
	{
		textCoords = vector3(-38.33113, -1108.873, 27.2198),
		authorizedJobs = { 'cardealer' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = `v_ilev_csr_door_r`,
				objYaw = -20.0,
				objCoords  = vector3(-37.33113, -1108.873, 26.7198),
			},

			{
				objName = `v_ilev_csr_door_l`,
				objYaw = -20.0,
				objCoords  = vector3(-39.13366, -1108.218, 26.7198),
			}
		}
	}
}