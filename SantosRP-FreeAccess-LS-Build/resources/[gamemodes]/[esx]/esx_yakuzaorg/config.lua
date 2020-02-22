Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 0, g = 255, b = 150 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableLicenses             = true

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.YakuzaStations = {
  Yakuza = {
    Armories = {
      vector3(959.283, -3013.499, -39.507),
    },

    BossActions = {
      vector3(964.982, -3003.471, -39.707),
    },
  }
}
