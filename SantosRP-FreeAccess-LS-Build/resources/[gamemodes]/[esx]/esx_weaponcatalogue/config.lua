Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1

Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 255, g = 0, b = 0 }

Config.Locale = 'fr'

Config.AmmuCatalogueStations = {

  AmmuCatalogue = {

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
      --{ name = 'WEAPON_HEAVYSNIPER', label = 'Sniper Lourd', price = 1450000},
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
    Catalogue = {
      vector3(249.162, -50.117, 69.941),
    }
  }
}
