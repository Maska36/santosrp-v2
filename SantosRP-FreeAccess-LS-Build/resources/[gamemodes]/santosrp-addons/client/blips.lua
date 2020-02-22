local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},
  --{title="Territoire Bloods", colour=59, id=303, x = 103.18, y = -1938.48, z = 20.80},
  --{title="Territoire Vagos", colour=46, id=303, x = 337.97, y = -2042.59, z = 21.25},
  --{title="Territoire Famille Vizini", colour=40, id=303, x = 1518.319, y = 2202.037, z = 78.71},
  --{title="Territoire Yakuza", colour=40, id=303, x = -1873.575, y = 201.797, z = 84.29},
  {title="Dojo", colour=1, id=311, x = 299.941, y = 197.089, z = 104.310},
  {title="Cinéma", colour=1, id=135, x = 343.987, y = 174.237, z = 103.023},
  {title="Circuit de course", colour=1, id=315, x = 1175.875, y = 2372.905, z = 57.604},
  --{title="Territoire Families", colour=25, id=303, x = -179.95, y = -1598.48, z = 34.34},
}
      
Citizen.CreateThread(function()
  for _, info in pairs(blips) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.8)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end
end)