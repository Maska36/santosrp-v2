Config = {}
Config.DrawDistance = 8.0
Config.HideRadar = true
Config.AnimTime = 60 

Config.Locale = 'fr'

Config.Zones = {
	Cameras = {
		Pos   = {x = 620.5811, y = -20.75665, z = 81.802},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 0, g = 150, b = 255},
		Type = 27,
	}
}

Config.Locations = {
	{
	bankCamLabel = {label = _U('pacific_standard_bank')},
		bankCameras = {
			{label = _U('bcam'), x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = true},
			{label = _U('bcam2'), x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true},
			{label = _U('bcam3'), x = 261.50, y = 218.08, z = 107.95, r = {x = -25.0, y = 0.0, z = -149.49}, canRotate = true},
			{label = _U('bcam4'), x = 241.64, y = 233.83, z = 111.48, r = {x = -35.0, y = 0.0, z = 120.46}, canRotate = true},
			{label = _U('bcam5'), x = 269.66, y = 223.67, z = 113.23, r = {x = -30.0, y = 0.0, z = 111.29}, canRotate = true},
			{label = _U('bcam6'), x = 261.98, y = 217.92, z = 113.25, r = {x = -40.0, y = 0.0, z = -159.49}, canRotate = true},
			{label = _U('bcam7'), x = 258.44, y = 204.97, z = 113.25, r = {x = -30.0, y = 0.0, z = 10.50}, canRotate = true},
			{label = _U('bcam8'), x = 235.53, y = 227.37, z = 113.23, r = {x = -35.0, y = 0.0, z = -160.29}, canRotate = true},
			{label = _U('bcam9'), x = 254.72, y = 206.06, z = 113.28, r = {x = -35.0, y = 0.0, z = 44.70}, canRotate = true},
			{label = _U('bcam10'), x = 269.89, y = 223.76, z = 106.48, r = {x = -35.0, y = 0.0, z = 112.62}, canRotate = true},
			{label = _U('bcam11'), x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = true}
		},

	policeCamLabel = {label = _U('police_station')},
		policeCameras = {
			{label = _U('pcam'), x = 539.735, y = -64.920, z = 79.212, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true},
			{label = _U('pcam2'), x = 613.700, y = 23.760, z = 78.509, r = {x = -30.0, y = 0.0, z = -100.29}, canRotate = true},
			{label = _U('pcam3'), x = 615.389, y = 27.438, z = 78.509, r = {x = -35.0, y = 0.0, z = -90.46}, canRotate = true},
			{label = _U('pcam4'), x = 616.622, y = 29.554, z = 78.509, r = {x = -25.0, y = 0.0, z = -90.01}, canRotate = true},
			{label = _U('pcam7'), x = 642.587, y = 9.566,  z = 85.383, r = {x = -30.0, y = 0.0, z = -160.50}, canRotate = true}
		},
	}
}
