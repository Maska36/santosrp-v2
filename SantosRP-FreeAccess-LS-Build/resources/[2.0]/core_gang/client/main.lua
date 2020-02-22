ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastStation, LastPart, LastPartNum = nil, nil, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local gang = 0

Citizen.CreateThread(function()
   while ESX == nil do
      TriggerEvent('esx:getSO', function(obj) ESX = obj end)
      Citizen.Wait(0)
   end

   while ESX.GetPlayerData().org == nil do
      Citizen.Wait(10)
   end

   PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStart', function(resource)
  if resource == GetCurrentResourceName() then
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)

    if ESX.GetPlayerData().org.name == 'ballas' then
      gang = 1
    elseif ESX.GetPlayerData().org.name == 'famillies' then
      gang = 2
    elseif ESX.GetPlayerData().org.name == 'vagos' then
      gang = 3
    elseif ESX.GetPlayerData().org.name == 'cripz' then
      gang = 4
    elseif ESX.GetPlayerData().org.name == 'white' then
      gang = 5
    elseif ESX.GetPlayerData().org.name == 'cosanostra' then
      gang = 6
    elseif ESX.GetPlayerData().org.name == 'sinaloa' then
      gang = 7
    elseif ESX.GetPlayerData().org.name == 'aiglerouge' then
      gang = 8
    elseif ESX.GetPlayerData().org.name == 'nueva' then
      gang = 9
    elseif ESX.GetPlayerData().org.name == 'ms13' then
      gang = 10
    elseif ESX.GetPlayerData().org.name == 'yakuza' then
      gang = 11
    elseif ESX.GetPlayerData().org.name == 'camorra' then
      gang = 12
    end
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer

  if PlayerData.org.name == 'ballas' then
    gang = 1
  elseif PlayerData.org.name == 'famillies' then
    gang = 2
  elseif PlayerData.org.name == 'vagos' then
    gang = 3
  elseif PlayerData.org.name == 'cripz' then
    gang = 4
  elseif PlayerData.org.name == 'white' then
    gang = 5
  elseif PlayerData.org.name == 'cosanostra' then
    gang = 6
  elseif PlayerData.org.name == 'sinaloa' then
    gang = 7
  elseif PlayerData.org.name == 'aiglerouge' then
    gang = 8
  elseif PlayerData.org.name == 'nueva' then
    gang = 9
  elseif PlayerData.org.name == 'ms13' then
    gang = 10
  elseif PlayerData.org.name == 'yakuza' then
    gang = 11
  elseif PlayerData.org.name == 'camorra' then
    gang = 12
  end
end)

RegisterNetEvent('esx:setOrg')
AddEventHandler('esx:setOrg', function(org)
  PlayerData.org = org

  if PlayerData.org.name == 'ballas' then
    gang = 1
  elseif PlayerData.org.name == 'famillies' then
    gang = 2
  elseif PlayerData.org.name == 'vagos' then
    gang = 3
  elseif PlayerData.org.name == 'cripz' then
    gang = 4
  elseif PlayerData.org.name == 'white' then
    gang = 5
  elseif PlayerData.org.name == 'cosanostra' then
    gang = 6
  elseif PlayerData.org.name == 'sinaloa' then
    gang = 7
  elseif PlayerData.org.name == 'aiglerouge' then
    gang = 8
  elseif PlayerData.org.name == 'nueva' then
    gang = 9
  elseif PlayerData.org.name == 'ms13' then
    gang = 10
  elseif PlayerData.org.name == 'yakuza' then
    gang = 11
  elseif PlayerData.org.name == 'camorra' then
    gang = 12
  end
end)

function CreateBlipCircle(coords, text, radius, color, sprite, color2)
  local blip = AddBlipForRadius(coords, radius)
  SetBlipHighDetail(blip, true)
	SetBlipColour(blip, color2)
	SetBlipAlpha (blip, 128)

	blip = AddBlipForCoord(coords)
	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end 

Citizen.CreateThread(function()
   for k,zone in pairs(Config.CircleZones) do
      CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite, zone.color2)
   end
end)

function OpenArmoryMenu()
  TriggerServerEvent('core_gang:setFouille', PlayerData.org.name, true)
  local elements = {}

  table.insert(elements, {label = 'Prendre Armes', value = 'get_weapon'})
  table.insert(elements, {label = 'Déposer Armes', value = 'put_weapon'})
  table.insert(elements, {label = 'Prendre Objets', value = 'get_stock'})
  table.insert(elements, {label = 'Déposer Objets', value = 'put_stock'}) 

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
  {
    css = 'santos',
    title    = "Inventaire",
    align    = 'top-left',
    elements = elements,
  }, function(data, menu)
    if data.current.value == 'get_weapon' then
      OpenGetWeaponMenu()
    elseif data.current.value == 'put_weapon' then
      OpenPutWeaponMenu()
    elseif data.current.value == 'buy_weapons' then
      OpenBuyWeaponsMenu()
    elseif data.current.value == 'put_stock' then
      OpenPutStocksMenu()
    elseif data.current.value == 'get_stock' then
      OpenGetStocksMenu()
    end
  end, function(data, menu)
    TriggerServerEvent('core_gang:setFouille', PlayerData.org.name, false)
    menu.close()
  end)
end

function OpenGetWeaponMenu()
  ESX.TriggerServerCallback('esx_'..PlayerData.org.name..'job:getArmoryWeapons', function(weapons)
    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {
          label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), 
          value = weapons[i].name
        })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',{
        css = 'santos',
        title    = "Prendre Arme",
        align    = 'top-left',
        elements = elements,
      }, function(data, menu)
        menu.close()

        ESX.TriggerServerCallback('esx_'..PlayerData.org.name..'job:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, PlayerData.org.name, data.current.value)
      end, function(data, menu)
        menu.close()
      end)
  end, PlayerData.org.name)
end

function OpenPutWeaponMenu()
  local elements   = {}
  local playerPed  = PlayerPedId()
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do
    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      table.insert(elements, {
        label = weaponList[i].label,
        value = weaponList[i].name
      })
    end
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',{
      css = 'santos',
      title    = "Déposer Arme",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
      menu.close()

      ESX.TriggerServerCallback('esx_'..PlayerData.org.name..'job:addArmoryWeapon', function()
        OpenPutWeaponMenu()
    end, PlayerData.org.name, data.current.value)
    end, function(data, menu)
      menu.close()
    end)
end

function OpenGetStocksMenu()
  ESX.TriggerServerCallback('esx_'..PlayerData.org.name..'job:getStockItems', function(items)
    local elements = {}

    for i=1, #items, 1 do
      if items[i].count > 0 then 
         table.insert(elements, {
           label = 'x' .. items[i].count .. ' ' .. items[i].label, 
           value = items[i].name
         })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',{
        css = 'santos',
        title    = "Inventaire",
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)
        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = "Quantité"
          }, function(data2, menu2)
            local count = tonumber(data2.value)

            if count > 0 then
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_'..PlayerData.org.name..'job:getStockItem', PlayerData.org.name, itemName, count)
 
              Citizen.Wait(300)
              OpenGetStocksMenu()
            else
              ESX.ShowNotification('Quantité invalide')
            end
          end, function(data2, menu2)
            menu2.close()
          end)
      end, function(data, menu)
        menu.close()
      end)
  end, PlayerData.org.name)
end

function OpenPutStocksMenu()
   ESX.TriggerServerCallback('esx_'..PlayerData.org.name..'job:getPlayerInventory', function(inventory)
      local elements = {}

      for i=1, #inventory.items, 1 do
         local item = inventory.items[i]

         if item.count > 0 then
            table.insert(elements, {
               label = item.label .. ' x' .. item.count,
               type = 'item_standard',
               value = item.name
            })
         end
      end

   ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
   {
      css = 'santos',
      title    = "Inventaire",
      align    = 'top-left',
      elements = elements
   }, function(data, menu)
      local itemName = data.current.value

      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',{
         title = "Quantité"
      }, function(data2, menu2)
         local count = tonumber(data2.value)

         if count == nil then
            ESX.ShowNotification("~r~Quantité invalide")
         else
            menu2.close()
            menu.close()
            TriggerServerEvent('esx_'..PlayerData.org.name..'job:putStockItems', PlayerData.org.name, itemName, count)

            Citizen.Wait(300)
            OpenPutStocksMenu()
         end
      end, function(data2, menu2)
         menu2.close()
      end)
   end, function(data, menu)
      menu.close()
   end)
  end)
end

function OpenVehicleSpawnerMenu()
  local vehicles = Config.GangStations.Gang.Vehicles

  ESX.UI.Menu.CloseAll()

  local elements = {}

  local vehicle = Config.AuthorizedVehicles[gang]
  table.insert(elements, {label = vehicle.label, value = vehicle.name})

   ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
   {
      css = 'garage',
      title    = 'Véhicule',
      align    = 'top-left',
      elements = elements,
   }, function(data, menu)
      menu.close()
      local model = data.current.value
      local vehicle = GetClosestVehicle(vehicles[gang].SpawnPoint.x,  vehicles[gang].SpawnPoint.y,  vehicles[gang].SpawnPoint.z,  3.0,  0,  71)
      
      if not DoesEntityExist(vehicle) then
         local playerPed = PlayerPedId()

          ESX.Game.SpawnVehicle(model, { x = vehicles[gang].SpawnPoint.x, y = vehicles[gang].SpawnPoint.y, z = vehicles[gang].SpawnPoint.z }, vehicles[gang].Heading, function(vehicle)
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleCustomPrimaryColour(vehicle, Config.MarkerColor[gang].r, Config.MarkerColor[gang].g, Config.MarkerColor[gang].b)

            local plat = PlayerData.org.name

            SetVehicleNumberPlateText(vehicle, plat)
          end)
      else
        ESX.ShowNotification('Il y a déjà un véhicule de sorti.')
      end
   end, function(data, menu)
      menu.close()
   end)
end

AddEventHandler('core_gang:hasEnteredMarker', function(zone)
   if zone == 'Armories' then
      CurrentAction = 'menu_armory'
      CurrentActionMsg = 'Appyuez sur ~INPUT_CONTEXT~ pour accéder au coffre fort.'
      CurrentActionData = {}
   elseif zone == 'Vehicles' then
      CurrentAction = 'menu_vehicle_spawner'
      CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir un véhicule.'
      CurrentActionData = {zone = zone}
   elseif zone == 'VehicleDeleters' then
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)

      if IsPedInAnyVehicle(playerPed,  false) then
        local vehicle, distance = ESX.Game.GetClosestVehicle({ x = coords.x, y = coords.y, z = coords.z })

        if DoesEntityExist(vehicle) then
          if distance ~= -1 and distance <= 1.0 then
            CurrentAction     = 'delete_vehicle'
            CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
            CurrentActionData = {vehicle = vehicle}
          end
        end
      end
   elseif zone == 'BossActions' then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu.'
      CurrentActionData = {}
   end
end)

AddEventHandler('core_gang:hasExitedMarker', function()
   ESX.UI.Menu.CloseAll()
   CurrentAction = nil
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if PlayerData.org ~= nil and PlayerData.org.name ~= 'santos' then
      local playerCoords = GetEntityCoords(PlayerPedId())
      local isInMarker, letSleep, currentPart, currentPartNum = false, true, nil, nil

      for k,v in pairs(Config.GangStations.Gang) do
        if k ~= "Vehicles" then
          local distance = #(playerCoords - v[gang])

          if distance < Config.DrawDistance then
            letSleep = false

            if k ~= "VehicleDeleters" then
              DrawMarker(Config.Markers.Type.Normal, v[gang], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor[gang].r, Config.MarkerColor[gang].g, Config.MarkerColor[gang].b, 100, false, true, 2, false, false, false, false)
            else
              if IsPedInAnyVehicle(PlayerPedId(), false) then
                DrawMarker(Config.Markers.Type.Vehicles, v[gang], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor[gang].r, Config.MarkerColor[gang].g, Config.MarkerColor[gang].b, 100, false, true, 2, false, false, false, false)
              end
            end

            if distance < Config.MarkerSize.x then
              isInMarker, currentZone = true, k
            end
          end
        else
          local distance = #(playerCoords - v[gang].Spawner)

          if distance < Config.DrawDistance then
            letSleep = false

            DrawMarker(Config.Markers.Type.Vehicles, v[gang].Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor[gang].r, Config.MarkerColor[gang].g, Config.MarkerColor[gang].b, 100, false, true, 2, false, false, false, false)

            if distance < Config.MarkerSize.x then
              isInMarker, currentZone = true, k
            end
          end
        end
      end

      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker, LastZone = true, currentZone
        TriggerEvent('core_gang:hasEnteredMarker', currentZone)
      end

      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('core_gang:hasExitedMarker')
      end

      if letSleep then
        Citizen.Wait(500)
      end
    end
   end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(180000)
    if PlayerData.org and PlayerData.org.name ~= "santos" then
      TriggerServerEvent('core_gang:setFouille', PlayerData.org.name, false)
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if CurrentAction then
      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlPressed(0, 38) and PlayerData.org and PlayerData.org.name ~= "santos" then
        if CurrentAction == 'menu_armory' then
          ESX.TriggerServerCallback('core_gang:checkArmory', function(taken)
            if (not taken) then
              OpenArmoryMenu()
            else
              ESX.ShowNotification("~r~Quelqu'un regarde déja le coffre.")
            end
          end, PlayerData.org.name)
        elseif CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu()
        elseif CurrentAction == 'delete_vehicle' then
          local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
          local hash = GetEntityModel(vehicle)  
               
          if hash == `raiden` or hash == `manana` then
            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
          else
            ESX.ShowNotification("~r~Impossible de ranger ce véhicule")
          end
        elseif CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('esx_society:openBossOrgMenu', PlayerData.org.name, function(data, menu)
            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = 'Appyuez sur ~INPUT_CONTEXT~ pour ouvrir le menu.'
            CurrentActionData = {}
          end)
        end

        CurrentAction = nil
      end
    else
      Citizen.Wait(500)
    end
  end
end)