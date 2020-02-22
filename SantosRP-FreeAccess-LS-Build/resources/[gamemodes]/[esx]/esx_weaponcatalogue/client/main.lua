local PlayerData, CurrentActionData, HandcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function OpenCatalogueWeaponsMenu()
  local elements = {}

  for i=1, #Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedWeapons, 1 do
    local weapon = Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedWeapons[i]
    table.insert(elements, {label = weapon.label .. ' <span style="color:green;">$'..math.floor(weapon.price * 1.25).."</span>", value = weapon.name, price = weapon.price})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weapon_cata', {
      css = 'ammunation',
      title    = "Catalogue des Armes",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
    end, function(data, menu)
      menu.close()
    end)
end

function OpenCatalogueMunitionsMenu()
  local elements = {}

  for i=1, #Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedAmmos, 1 do
    local Ammos = Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedAmmos[i]
    table.insert(elements, {label = Ammos.label .. ' <span style="color:green;">$'..math.floor(Ammos.price * 1.25).."</span>", value = Ammos.name, price = Ammos.price})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'muni_cata', {
      css = 'ammunation',
      title    = "Catalogue des Munitions",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
    end, function(data, menu)
      menu.close()
    end)
end


function OpenCatalogueAcceMenu()
  local elements = {}

  for i=1, #Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedAccessories, 1 do
    local Accessories = Config.AmmuCatalogueStations['AmmuCatalogue'].AuthorizedAccessories[i]
    table.insert(elements, {label = Accessories.label .. ' <span style="color:green;">$'..math.floor(Accessories.price * 1.25).."</span>", value = Accessories.name, price = Accessories.price})
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'acce_cata', {
      css = 'ammunation',
      title    = "Catalogue des Accessoires",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
    end, function(data, menu)
      menu.close()
    end)
end


function OpenCatalogueMenu()
  local elements = {}

  table.insert(elements, {label = 'Catalogue des Armes', value = 'weapon_cata'})
  table.insert(elements, {label = 'Catalogue des Munitions', value = 'muni_cata'})
  table.insert(elements, {label = 'Catalogue des Accessoires', value = 'acce_cata'})

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_catalogue_weapons', {
      css = 'ammunation',
      title    = "Catalogue Armurerie",
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
      if data.current.value == 'weapon_cata' then
        OpenCatalogueWeaponsMenu()
      elseif data.current.value == 'muni_cata' then 
        OpenCatalogueMunitionsMenu()
      elseif data.current.value == 'acce_cata' then 
        OpenCatalogueAcceMenu()
      end
    end, function(data, menu)
      menu.close()
    end)
end

AddEventHandler('esx_weaponscatalogue:hasEnteredMarker', function(station, part, partNum)
  if part == 'Catalogue' then
    CurrentAction     = 'menu_catalogue'
    CurrentActionMsg  = _U('open_catalogue')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_weaponscatalogue:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
      local isInMarker, hasExited, letSleep = false, false, true
      local currentStation, currentPart, currentPartNum

      for k,v in pairs(Config.AmmuCatalogueStations) do
        for i=1, #v.Catalogue, 1 do
          local distance = GetDistanceBetweenCoords(coords, v.Catalogue[i], true)

          if distance < Config.DrawDistance then
            DrawMarker(20, v.Catalogue[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
            letSleep = false
          end

          if distance < Config.MarkerSize.x then
            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Catalogue', i
          end
        end
      end

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
        if
          (LastStation and LastPart and LastPartNum) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_weaponscatalogue:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_weaponscatalogue:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_weaponscatalogue:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

      if letSleep then
        Citizen.Wait(500)
      end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if CurrentAction then
      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlJustReleased(0, 38) then
        if CurrentAction == 'menu_catalogue' then
          OpenCatalogueMenu()
        end

        CurrentAction = nil
      end
    end
  end
end)