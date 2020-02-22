Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.3
Config.Locale          = 'fr'

Config.Prices = {
	dmv         = 500,
	drive       = 500,
	drive_bike  = 250,
	drive_truck = 800
}

Config.VehicleModels = {
	drive       = 'blista',
	drive_bike  = 'thrust',
	drive_truck = 'pounder'
}

Config.SpeedLimits = {
	residence = 50,
	town      = 80,
	freeway   = 120
}

Config.Zones = {
	DMVSchool = {
		Pos   = vector3(228.782, 373.654, 105.114),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 25
	}
}

Config.SP = {
	VehicleSpawnPoint = {
		Pos   = {x = 211.077, y = 380.887, z = 106.977, h = 317.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	}
}

Config.CheckPoints = {

	{
		Pos = {x = 188.658, y = 363.619, z = 106.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('next_point_speed', Config.SpeedLimits['residence']), 5000)
		end
	},

	{
		Pos = {x = 139.572, y = 359.835, z = 110.588},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 73.888, y = 327.600, z = 111.203},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_for_ped'), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_lets_cont'), 5000)
			end)
		end
	},

	{
		Pos = {x = 35.531, y = 279.975, z = 107.507},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_look_left', Config.SpeedLimits['town']), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_turn_right'), 5000)
			end)
		end
	},

	{
		Pos = {x = 102.152, y = 222.789, z = 106.968},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 179.410, y = 193.801, z = 104.686},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('stop_for_passing'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},

	{
		Pos = {x = 336.311, y = 136.704, z = 102.180},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 374.048, y = 158.433, z = 103.061},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 417.975, y = 276.951, z = 102.993},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			DrawMissionText(_U('hway_time', Config.SpeedLimits['freeway']), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},

	{
		Pos = {x = 406.853, y = 304.562, z = 102.985},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 385.331, y = 310.804, z = 103.205},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 355.533, y = 318.446, z = 103.941},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 288.159, y = 334.082, z = 105.558},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText(_U('in_town_speed', Config.SpeedLimits['town']), 5000)
		end
	},

	{
		Pos = {x = 238.988, y = 350.978, z = 105.595},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('gratz_stay_alert'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},

	{
		Pos = {x = 217.454, y = 373.877, z = 106.417},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			ESX.Game.DeleteVehicle(vehicle)
		end
	}

}
