Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100.0
Config.MarkerColor  = { r = 120, g = 120, b = 240 }

Config.EnableOwnedVehicles = true -- If true then it will set the Vehicle Owner to the Player who bought it.
Config.ResellPercentage    = 50 -- Sets the Resell Percentage | Example: $100 Car will resell for $75
Config.LicenseEnable       = true -- Require people to own a Boating License when buying Vehicles? Requires esx_license
Config.LicensePrice        = 35000 -- Sets the License Price if Config.LicenseEnable is true

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
	    Pos   = { x = 141.4029, y = -3179.5839, z = 4.8575 },
			Size  = { x = 1.5, y = 1.5, z = 1.0 },
			Type  = 1
		},
		ShopInside = { -- Marker for Viewing Vehicles
		    Pos     = { x = 164.8334, y = -3225.9492, z = 4.9075 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 138.4,
				Type    = -1
			},
		ShopOutside = { -- Marker for Purchasing Vehicles
		    Pos     = { x = 93.6759, y = -3235.8391, z = 4.8575 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 90.0,
				Type    = -1
			},
		ResellVehicle = { -- Marker for Selling Vehicles
	   		Pos   = { x = -72599999999999.38537597656, y = -132799999999999.8604736328, z = -09999999999.47477427124977 },
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Type  = 1
		}
}
