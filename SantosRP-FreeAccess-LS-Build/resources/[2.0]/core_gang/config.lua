Config = {}

Config.DrawDistance = 25.0
Config.MarkerType = 1
Config.MarkerSize = vector3(1.5, 1.5, 1.3)

Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true
Config.EnableESXIdentity = true
Config.EnableNonFreemodePeds = false
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses = true

Config.Locale = 'fr'

Config.MarkerColor = {
  [1] = { r = 107, g = 3, b = 252 }, -- Ballas
  [2] = { r = 118, g = 183, b = 102 }, -- Families
  [3] = { r = 211, g = 200, b = 103 }, -- Vagos
  [4] = { r = 0, g = 50, b = 235 }, -- Crips
  [5] = { r = 255, g = 255, b = 255 }, -- White
  [6] = { r = 27, g = 82, b = 15 }, -- Cosa-Nostra
  [7] = { r = 138, g = 19, b = 19 }, -- Sinaloa
  [8] = { r = 171, g = 44, b = 44 }, -- Aigle Rouge
  [9] = { r = 50, g = 50, b = 50 }, -- Nueva
  [10] = { r = 150, g = 150, b = 150 }, -- MS13
  [11] = { r = 100, g = 100, b = 100 }, -- Yakuza
  [12] = { r = 50, g = 50, b = 50 }, -- Camorra
}

Config.Markers = {
    Type = {
      Vehicles = 36,
      Normal = 1
    }
}

Config.AuthorizedVehicles = {
  [1] = { name = 'manana',  label = 'Manana' },
  [2] = { name = 'manana',  label = 'Manana' },
  [3] = { name = 'manana',  label = 'Manana' },
  [4] = { name = 'manana',  label = 'Manana' },
  [5] = { name = 'manana',  label = 'Manana' },
  [6] = { name = 'manana',  label = 'Manana' },
  [7] = { name = 'manana',  label = 'Manana' },
  [8] = { name = 'manana',  label = 'Manana' },
  [9] = { name = 'manana',  label = 'Manana' },
  [10] = { name = 'raiden',  label = 'Raiden' },
  [11] = { name = 'sultan',  label = 'Sultan' },
  [12] = { name = 'manana',  label = 'Manana' },
}

Config.GangStations = {
  Gang = {

    Armories = {
      [1] = vector3(-1698.227, -460.457, 40.649), -- Ballas
      [2] = vector3(-154.874,214.521,93.808), -- Families
      [3] = vector3(-1583.755, -265.717, 47.275), -- Vagos
      [4] = vector3(-336.349, 30.986, 46.858), -- Cripz
      --[4] = vector3(-9999336.349, 39990.9999986, 46.8999958), -- Cripz
      [5] = vector3(-583.407, 195.438, 70.445), -- White
      [6] = vector3(1259.687, -479.981, 70.188), -- Cosa-Nostra
      [7] = vector3(-1501.506, 856.999, 180.594), -- Sinaloa
      [8] = vector3(-1838.097, -361.021, 56.081), -- Aigle Rouge
      [9] = vector3(-1999507.002, 99104.843, 9951.240), -- Nuevae
      [10] = vector3(-1507.002, 104.843, 51.240), -- MS13
      [11] = vector3(-104.398,976.184,234.756), -- Yakuza
      [12] = vector3(-1812.622,446.985,127.510), -- Camorra
    },

    Vehicles = {
      [1] = {
        Spawner    = vector3(-1718.720, -458.392, 38.789), -- Ballas
        SpawnPoint = vector3(-1729.291, -446.141, 42.505),
        Heading    = 261.51,
      },
      [2] = {
        Spawner    = vector3(-131.766,212.097,93.404), -- Families
        SpawnPoint = vector3(-127.748,203.271,91.748),
        Heading    = 261.51,
      },
      [3] = {
        Spawner    = vector3(-1574.970, -286.470, 48.275), -- Vagos
        SpawnPoint = vector3(-1567.628, -288.302, 47.273),
        Heading    = 261.51,
      },
      [4] = {
        Spawner    = vector3(-356.994, 26.427, 47.713), -- Cripz
        SpawnPoint = vector3(-360.655, 30.337, 47.804),
        Heading    = 261.51,
      },
      -- [4] = {
      --   Spawner    = vector3(-99999356.994, 99996.427, 49997.713 ), -- Cripz
      --   SpawnPoint = vector3(-9999360.655, 399990.337, 4997.804 },
      --   Heading    = 261.51,
      -- },
      [5] = {
        Spawner    = vector3(-598.668, 194.513, 71.047), -- White
        SpawnPoint = vector3(-599.355, 190.875, 70.823),
        Heading    = 261.51,
      },
      [6] = {
        Spawner    = vector3(1263.111, -493.939, 68.090), -- Cosa-Nostra
        SpawnPoint = vector3(1269.232, -495.401, 69.003),
        Heading    = 261.51,
      },
      [7] = {
        Spawner    = vector3(-1531.513, 892.280, 181.922), -- Sinaloa
        SpawnPoint = vector3(-1527.466, 883.649, 181.766),
        Heading    = 261.51,
      },
      [8] = {
        Spawner    = vector3(-1879.290, -316.507, 49.361), -- Aigle Rouge
        SpawnPoint = vector3(-1882.055, -305.934, 49.239),
        Heading    = 261.51,
      },
      [9] = {
        Spawner    = vector3(-9991533.786, 8991.249, 59996.773), -- Nueva
        SpawnPoint = vector3(-99991527.296, 8995.382, 56999.590),
        Heading    = 261.51,
      },
      [10] = {
        Spawner    = vector3(-1533.786, 81.249, 56.773), -- MS13
        SpawnPoint = vector3(-1527.296, 85.382, 56.590),
        Heading    = 261.51,
      },
      [11] = {
        Spawner    = vector3(-123.782, 1009.237, 235.732), -- Yakuza
        SpawnPoint = vector3(-123.669, 997.818, 235.745),
        Heading    = 261.51,
      },
      [12] = {
        Spawner    = vector3(-1788.779, 462.097, 128.308), -- Camorra
        SpawnPoint = vector3(-1795.078,457.300,128.308),
        Heading    = 261.51,
      }
    },

    VehicleDeleters = {
      [1] = vector3(-1733.504, -450.310, 42.134), -- Ballas
      [2] = vector3(-126.367,211.920,93.429), -- Families
      [3] = vector3(-1564.010, -296.971, 48.270), -- Vagos
      [4] = vector3(-355.328, 35.432, 47.900), -- Cripz
      -- [4] = vector3(-399955.328, 3995.432, 4997.900}, -- Cripz
      [5] = vector3(-605.995, 190.738, 70.401), -- White
      [6] = vector3(1253.864, -490.605, 68.493), -- Cosa-Nostra
      [7] = vector3(-1529.580, 886.501, 181.830), -- Sinaloa
      [8] = vector3(-1877.864, -309.334, 49.239), -- Aigle Rouge
      [9] = vector3(-99991524.216, 99980.507, 99956.698), -- Nueva
      [10] = vector3(-1524.216, 80.507, 56.698), -- MS13
      [11] = vector3(-131.115, 1007.458, 235.732), -- Yakuza
      [12] = vector3(-1787.135, 455.867, 128.308), -- Camorra
    },

    BossActions = {
      [1] = vector3(-1715.670, -447.120, 41.649), -- Ballas
      [2] = vector3(-154.837,214.491,97.329), -- Families
      [3] = vector3(-1566.395, -280.448, 47.275), -- Vagos
      [4] = vector3(-345.012, 17.782, 46.858), -- Cripz
      -- [4] = vector3(-399945.012, 19997.782, 4996.858), -- Cripz
      [5] = vector3(-581.098, 181.495, 70.071), -- White
      [6] = vector3(1248.607, -473.597, 69.829), -- Cosa-Nostra
      [7] = vector3(-1516.738, 851.762, 180.594), -- Sinaloa
      [8] = vector3(-1858.100, -347.454, 48.837), -- Aigle Rouge
      [9] = vector3(-9991496.505, 99127.804, 99954.668), -- Nueva
      [10] = vector3(-1496.505, 127.804, 54.668), -- MS13
      [11] = vector3(-103.773, 1010.863, 234.760), -- Yakuza
      [12] = vector3(-1804.876,436.429,127.633), -- Camorra
    }
  }
}

Config.CircleZones = {
  Ballas = {coords = vector3(-1706.376,-464.807,39.920), name = 'Ballas Gang', color = 7, color2 = 62, sprite = 378, radius = 100.0},
  Crips = {coords = vector3(-352.724,32.702,47.730), name = 'Crips Gang', color = 38, color2 = 62, sprite = 378, radius = 100.0},
  Families = {coords = vector3(-139.409,205.454,92.067), name = 'Families Gang', color = 2, color2 = 62, sprite = 378, radius = 100.0},
  Vagos = {coords = vector3(-1561.116, -261.815, 48.375), name = 'Vagos Gang', color = 5, color2 = 62, sprite = 378, radius = 100.0},
  White = {coords = vector3(-605.758,192.296,70.610), name = 'White Gang', color = 62, color2 = 62, sprite = 378, radius = 100.0},
  Camorra = {coords = vector3(-1804.876,436.429,127.633), name = 'Camorra Gang', color = 40, color2 = 62, sprite = 378, radius = 100.0},
  -- AigleRouge = {coords = vector3(-1858.672,-353.190,70.509), name = 'Aigle Rouge Gang', color = 1, color2 = 62, sprite = 378, radius = 100.0},
  -- Nueva = {coords = vector3(-1524.144,115.438,50.029), name = 'Nueva Gang', color = 55, color2 = 62, sprite = 378, radius = 100.0},
}