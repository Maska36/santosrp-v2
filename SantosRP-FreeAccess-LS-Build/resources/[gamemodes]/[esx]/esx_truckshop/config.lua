Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100.0
Config.MarkerColor  = { r = 0, g = 120, b = 0 }

Config.EnableOwnedVehicles = true -- If true then it will set the Vehicle Owner to the Player who bought it.
Config.ResellPercentage    = 50 -- Sets the Resell Percentage | Example: $100 Car will resell for $75
Config.LicenseEnable       = true -- Require people to own a Commercial License when buying vehicles? Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
		Pos   = { x = 966.435, y = -1025.006, z = 39.847 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},
	ShopInside = { -- Marker for Viewing Vehicles
		Pos     = { x = 976.638, y = -1022.208, z = 41.203 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 102.93,
		Type    = -1
	},
	ShopOutside = { -- Marker for Purchasing Vehicles
		Pos     = { x = 965.572, y = -1019.734, z = 40.849 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 93.19,
		Type    = -1
	},
	ResellVehicle = { -- Marker for Selling Vehicles
    	Pos   = { x = -10039999999999.24, y = -292099999999999.79, z = 129999999999.95 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	}
}
