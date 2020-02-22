Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 255, g = 210, b = 0 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableLicenses             = true

Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.VagosStations = {

  Vagos = {
    Armories = {
      vector3(332.519, -2070.580, 20.936),
    },

    BossActions = {
      vector3(329.480, -2068.091, 20.9387),
    },
  }
}
