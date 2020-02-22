local PlayerData, CurrentActionData = {}, {}
local HasAlreadyEnteredMarker, hasAlreadyJoined, isInShopMenu = false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
ESX = nil

--- esx_vehicleshop funtions
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}
local CurrentVehicleData      = nil

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
    Categories = categories
  end)

  ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
    Vehicles = vehicles
  end)
end)

function DeleteKatalogVehicles ()
  while #LastVehicles > 0 do
    local vehicle = LastVehicles[1]
    ESX.Game.DeleteVehicle(vehicle)
    table.remove(LastVehicles, 1)
  end
end

----markers
AddEventHandler('esx_qalle_bilpriser:hasEnteredMarker', function(part)
  if part == 'Katalog' then
    CurrentAction     = 'cars_menu'
    CurrentActionMsg  = _U('press_e')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_qalle_bilpriser:hasExitedMarker', function(part)
  CurrentAction = nil
end)

function OpenShopMenu()
  IsInShopMenu = true

  ESX.UI.Menu.CloseAll()

  local playerPed = PlayerPedId()

  FreezeEntityPosition(playerPed, true)
  SetEntityVisible(playerPed, false)
  SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)

  local vehiclesByCategory = {}
  local elements           = {}
  local firstVehicleData   = nil

  for i=1, #Categories, 1 do
    vehiclesByCategory[Categories[i].name] = {}
  end

  for i=1, #Vehicles, 1 do
    table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
  end

  for i=1, #Categories, 1 do
    local category         = Categories[i]
    local categoryVehicles = vehiclesByCategory[category.name]
    local options          = {}
    local pricee           = {}

    for j=1, #categoryVehicles, 1 do
      local vehicle = categoryVehicles[j]

      if i == 1 and j == 1 then
        firstVehicleData = vehicle
      end

      table.insert(options, ('%s'):format(vehicle.name))
      table.insert(pricee, ('<span style="color:green;">$%s</span>'):format(math.floor(vehicle.price * Config.Price)))
    end

    table.insert(elements, {
      name    = category.name,
      categories = category.label.." : ",
      labell   = pricee,
      value   = 0,
      type    = 'slider',
      max     = #Categories[i],
      options = options
    })
  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_shop',
    {
      css = 'santos',
      title    = 'Concessionnaire - Catalogue',
      align    = 'top-left',
      elements = elements,
    },
    function (data, menu)
      local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

      ESX.ShowNotification(_U('contact_dealer') .. vehicleData.price * Config.Price .. _U('currency'))

    end,
    function (data, menu)

      menu.close()

        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)

      DeleteKatalogVehicles()

      local playerPed = PlayerPedId()

      CurrentAction     = 'shop_menu'
      CurrentActionMsg  = 'shop menu'
      CurrentActionData = {}

        FreezeEntityPosition(playerPed, false)

        SetEntityCoords(playerPed, Config.Zones.Katalog.Pos.x, Config.Zones.Katalog.Pos.y, Config.Zones.Katalog.Pos.z)
        SetEntityVisible(playerPed, true)

      IsInShopMenu = false

    end,
    function (data, menu)
      local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
      local playerPed   = PlayerPedId()

      DeleteKatalogVehicles()

      ESX.Game.SpawnLocalVehicle(vehicleData.model, {
        x = Config.Zones.ShopInside.Pos.x,
        y = Config.Zones.ShopInside.Pos.y,
        z = Config.Zones.ShopInside.Pos.z
      }, Config.Zones.ShopInside.Heading, function(vehicle)
        table.insert(LastVehicles, vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        FreezeEntityPosition(vehicle, true)
        SetModelAsNoLongerNeeded(firstVehicleData.model)
      end)
    end
  )

  DeleteKatalogVehicles()

  ESX.Game.SpawnLocalVehicle(firstVehicleData.model, {
    x = Config.Zones.ShopInside.Pos.x,
    y = Config.Zones.ShopInside.Pos.y,
    z = Config.Zones.ShopInside.Pos.z
  }, Config.Zones.ShopInside.Heading, function(vehicle)
    table.insert(LastVehicles, vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    FreezeEntityPosition(vehicle, true)
    SetModelAsNoLongerNeeded(firstVehicleData.model)
  end)
end


-- Key controls
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)

    if CurrentAction then
      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlJustReleased(0, 38) then
        local playerPed = PlayerPedId()
        if CurrentAction == 'cars_menu' then
          OpenShopMenu()
        end

        CurrentAction = nil
      end
    else
      Citizen.Wait(500)
    end
  end
end)

-- Display markers
Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(0)

    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local isInMarker, hasExited, letSleep = false, false, true
    local currentPart

    for k,v in pairs(Config.Zones) do
      local distance = GetDistanceBetweenCoords(coords, v.Pos, true)
      if v.Type ~= -1 and distance < Config.DrawDistance then
        DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
        letSleep = false
      end

      if distance < Config.MarkerSize.x then
        isInMarker, currentPart = true, k
      end
    end

    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and LastPart ~= currentPart) then
      if(LastPart and LastPart ~= currentPart) then
        TriggerEvent('esx_qalle_bilpriser:hasExitedMarker', LastPart)
        hasExited = true
      end

      HasAlreadyEnteredMarker = true
      LastPart                = currentPart

      TriggerEvent('esx_qalle_bilpriser:hasEnteredMarker', currentPart)
    end

    if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_qalle_bilpriser:hasExitedMarker', LastPart)
    end

    if letSleep then
      Citizen.Wait(500)
    end
  end
end)