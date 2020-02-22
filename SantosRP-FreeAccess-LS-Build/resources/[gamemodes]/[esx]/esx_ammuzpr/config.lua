Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1

Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 255, g = 0, b = 0 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableLicenses             = false

Config.EnableSocietyOwnedVehicles = false

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale = 'fr'

Config.AmmuStations = {

  Ammu = {

    Blip = {
      Pos     = vector3(244.298, -45.243, 69.940),
      Sprite  = 567,
      Display = 4,
      Scale   = 0.8,
      Colour  = 75,
    },

    AuthorizedWeapons = {
    -- https://wiki.gtanet.work/index.php?title=Weapons_Models
      { name = 'WEAPON_KNIFE', label = 'Couteau', price = 18000 },
      { name = 'WEAPON_PISTOL', label = 'Pistolet', price = 90000 },
      { name = 'WEAPON_PISTOL50', label = 'Pistolet .50', price = 93000 },
      { name = 'WEAPON_APPISTOL', label = 'Pistolet AP', price = 98000 },
      { name = 'WEAPON_BAT', label = 'Batte de Baseball', price = 20000 },
      --{ name = 'WEAPON_COMPACTRIFLE', label = 'Mitraillette Compact', price = 210000 },
      { name = 'GADGET_PARACHUTE', label = 'Parachute', price = 4500 },
      { name = 'WEAPON_COMBATPISTOL', label = 'Pistolet de Combat', price = 110000 },
      --{ name = 'WEAPON_MICROSMG', label = 'Mitraillette UZI', price = 150000 },
      { name = 'WEAPON_CROWBAR', label = 'Pied de Biche', price = 12000 },
      { name = 'WEAPON_BOTTLE', label = 'Bouteille en verre', price = 6100 },
      { name = 'WEAPON_HAMMER', label = 'Marteau', price = 7400 },
      { name = 'WEAPON_GOLFCLUB', label = 'Club de Golf', price = 3000 },
      { name = 'WEAPON_DAGGER', label = 'Poignard', price = 9100 },
      { name = 'WEAPON_HATCHET', label = 'Hache', price = 10050 },
      { name = 'WEAPON_MACHETE', label = 'Machette', price = 13000 },
      { name = 'WEAPON_SWITCHBLADE', label = 'Couteau-Suisse', price = 19000 },
      { name = 'WEAPON_KNUCKLE', label = 'Poing Américain', price = 28000 },
      { name = 'WEAPON_FLAREGUN', label = 'Pistolet de Détresse', price = 17000},
      { name = 'WEAPON_MUSKET', label = 'Mousquet', price = 450000},
      --{ name = 'WEAPON_ADVANCEDRIFLE', label = 'Fusil Avancé', price = 850000},
      { name = 'WEAPON_SNIPERRIFLE', label = 'Sniper', price = 1050000},
      { name = 'WEAPON_HEAVYSNIPER', label = 'Sniper Lourd', price = 1450000},
    },

    AuthorizedAccessories = {
      { name = 'grip', label = 'Poignée', price = 24000 },
      { name = 'flashlight', label = 'Lampe', price = 8000 },
      { name = 'silencieux', label = 'Silencieux', price = 36000 },
      { name = 'SmallArmor', label = 'Kevlar Léger', price = 12000 },
      { name = 'MedArmor', label = 'Kevlar Moyen', price = 36000 },
      { name = 'HeavyArmor', label = 'Kevlar Lourd', price = 72000 },
    },

    AuthorizedAmmos = {
      { name = 'pAmmo', label = 'Boite de munitons Pistolet', price = 4000 },
      { name = 'mgAmmo', label = 'Boite de munitions SMG', price = 8000 },
      { name = 'arAmmo', label = 'Boite de munitions FA', price = 12000 },
      { name = 'sgAmmo', label = 'Boite de munitions Shotgun', price = 16000 },
    },

	  AuthorizedVehicles = {
		  { name = 'osiris', label = 'Osiris' },
		  { name = 'patriot', label = 'Patriot' },
		  { name = 'vacca', label = 'Vacca' },
	  },

    Armories = {
      vector3(253.991, -51.252, 69.941),
    },

    Catalogue = {
      vector3(249.162, -50.117, 69.941),
    },

    Cloakrooms = {
      vector3(1999913.30500793457, -319999909.3337402344, 6.0060696601868),
    },
  
  
    Vehicles = {
      {
        Spawner    = vector3(240.541, -39.381, 69.772),
        SpawnPoint = vector3(231.827, -31.543, 69.718),
        Heading    = 90.00,
      }
    },

    Helicopters = {
      {
        Spawner    = vector3(1999913.30500793457, -319999909.3337402344, 6.0060696601868),
        SpawnPoint = vector3(19999912.94457244873, -319999902.5942382813, 6.0050659179688),
        Heading    = 0.0,
      }
    },

    VehicleDeleters = {
      vector3(238.615,- 34.654, 69.728),
    },

    BossActions = {
      vector3(255.122, -46.566, 69.941),
    }
  }
}
