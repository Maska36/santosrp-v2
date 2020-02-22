ESX = nil

local PlayerData = {}
local CurrentActionData, HandcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
  end

  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function SetVehicleMaxMods(vehicle)
  local props = {
    modEngine       = 2,
    modBrakes       = 2,
    modTransmission = 2,
    modSuspension   = 3,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenCloakroomMenu()
	local elements = {
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = _U('ammu_wear'), value = 'ammu_wear'}
	}

	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        css = 'ammunation',
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
      },

        function(data, menu)

      menu.close()

      --Taken from SuperCoolNinja
      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = `mp_m_freemode_01`
          else
            model = `mp_f_freemode_01`
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end

      if data.current.value == 'ammu_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
          local model = nil

          if skin.sex == 0 then
            model = `mp_m_freemode_01`
          else
            model = `mp_f_freemode_01`
          end

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(1)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)

          TriggerEvent('skinchanger:loadSkin', skin)
          TriggerEvent('esx:restoreLoadout')
        end)
      end


      if data.current.value == 'ammu_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then

          local model = `s_m_y_sheriff_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = `s_f_y_sheriff_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'lieutenant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = `s_m_y_swat_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = `s_m_y_swat_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end

      if data.current.value == 'commandant_wear' then

        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

        if skin.sex == 0 then
          local model = `s_m_y_swat_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
      else
          local model = `s_m_y_swat_01`

          RequestModel(model)
          while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
          end

          SetPlayerModel(PlayerId(), model)
          SetModelAsNoLongerNeeded(model)
          end

        end)
      end


      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )

end

function OpenArmoryMenu(station)
	local elements = {
	    {label = _U('buy_weapons'), value = 'buy_weapons'},
	    {label = "Acheter des Accessoires", value = 'buy_accessories'},
	    {label = "Acheter des Munitions", value = 'buy_ammo'},
	    {label = "Vendre PPA", value = 'buy_ppa'},
	    {label = "Passer une annonce", value = 'annonce'},
	    {label = _U('get_weapon'), value = 'get_weapon'},
	    {label = _U('put_weapon'), value = 'put_weapon'},
	    {label = 'Prendre Item',  value = 'get_stock'},
		  {label = 'Deposer Item',  value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
	{
		  css = 'ammunation',
		  title    = _U('armory'),
    	align    = 'top-left',
    	elements = elements,
  	},
  	function(data, menu)
    	if data.current.value == 'get_weapon' then
      		OpenGetWeaponMenu()
    	elseif data.current.value == 'put_weapon' then
      		OpenPutWeaponMenu()
    	elseif data.current.value == 'buy_weapons' then
      		OpenBuyWeaponsMenu(station)
    	elseif data.current.value == 'buy_accessories' then
      		OpenBuyAccessoriesMenu(station)
    	elseif data.current.value == 'buy_ammo' then
      		OpenBuyAmmosMenu(station)
    	elseif data.current.value == 'annonce' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'annonce', {
          title = "Entrez le contenu de l'annonce",
          value = ''
          },
          function (data, menu)
            menu.close()
            local contenu = data.value

            if contenu and contenu ~= "" then
              ContenuReason = contenu
            else
              ContenuReason = "salut"
            end

            if ContenuReason == "" then
              ContenuReason = "salut"
            end

            TriggerServerEvent('esx_ammujob:annonce', ContenuReason)
          end,
          function (data, menu)
            menu.close()
          end)
    	elseif data.current.value == 'put_stock' then
      		OpenPutStocksMenu()
    	elseif data.current.value == 'get_stock' then
      		OpenGetStocksMenu()
    	elseif data.current.value == 'buy_ppa' then
      		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      		if closestPlayer ~= -1 and closestDistance <= 3.0 then
      			OpenBuyPPAMenu(closestPlayer)
      		else
      			ESX.ShowNotification("Il n'y a personne à proximité")
      		end
    	end
  	end,
  	function(data, menu)
    	menu.close()

    	CurrentAction     = 'menu_armory'
    	CurrentActionMsg  = _U('open_armory')
    	CurrentActionData = {station = station}
  	end)
end

function OpenVehicleSpawnerMenu(station, partNum)
  ESX.UI.Menu.CloseAll()
    local vehicles = Config.AmmuStations[station].Vehicles
    local elements = {}
    local playerPed = PlayerPedId()

    for i=1, #Config.AmmuStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.AmmuStations[station].AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        css = 'ammunation',
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        menu.close()
        local model = data.current.value
        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then
            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              SetVehicleMaxMods(vehicle)
            end)
          ESX.ShowNotification(_U('vehicle_out'))
        end
      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, partNum = partNum}
      end)
end

function OpenAmmuActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'ammu_actions',
    {
      css = 'ammunation',
      title    = 'Ammu-Nation',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'}
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then
        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            css = 'ammunation',
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = 'Facture', value = 'billing'}
            },
          },
          function(data2, menu2)
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then
              if data2.current.value == 'billing' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                  title = "Entrez un montant"
                }, function(data, menu)
                  local amount = tonumber(data.value)

                  if amount == nil or amount < 0 then
                    ESX.ShowNotification("~r~Montant invalide")
                  else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                      ESX.ShowNotification("~r~Il n'y a personne à proximité")
                    else
                      menu.close()
                      TriggerServerEvent('esxb:sendB', GetPlayerServerId(closestPlayer), 'society_ammu', "Armurerie", amount)
                    end
                  end
                end, function(data, menu)
                  menu.close()
                end)
              end
            else
              ESX.ShowNotification(_U('no_players_nearby'))
            end

          end,
          function(data2, menu2)
            menu2.close()
          end)
      end
    end,
    function(data, menu)
      menu.close()
    end)
end

-- Create blips
Citizen.CreateThread(function()
  local Ammuu = Config.AmmuStations.Ammu 
  local blip = AddBlipForCoord(Ammuu.Blip.Pos)

  SetBlipSprite (blip, Ammuu.Blip.Sprite)
  SetBlipDisplay(blip, Ammuu.Blip.Display)
  SetBlipScale  (blip, Ammuu.Blip.Scale)
  SetBlipColour (blip, Ammuu.Blip.Colour)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Ammu-Nation")
  EndTextCommandSetBlipName(blip)
end)

function OpenGetWeaponMenu()
  ESX.TriggerServerCallback('esx_ammujob:getArmoryWeapons', function(weapons)
    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 and ESX.GetWeaponLabel(weapons[i].name) ~= nil then
        table.insert(elements, {
			label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
			value = weapons[i].name
        })
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        css = 'ammunation',
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      }, function(data, menu)
        menu.close()

        ESX.TriggerServerCallback('esx_ammujob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)
      end, function(data, menu)
        menu.close()
      end )
  end)
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

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',{
      css = 'ammunation',
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
      menu.close()

      ESX.TriggerServerCallback('esx_ammujob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value, true)
    end, function(data, menu)
      menu.close()
    end)
end

function OpenBuyAccessoriesMenu(station)
  local elements = {}

  for i=1, #Config.AmmuStations[station].AuthorizedAccessories, 1 do
    local accessorie = Config.AmmuStations[station].AuthorizedAccessories[i]

    table.insert(elements, {label = accessorie.label .. ' $' .. accessorie.price, value = accessorie.name, price = accessorie.price})
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_accessories',
      {
        css = 'ammunation',
        title    = "Acheter des Accessoires",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        TriggerServerEvent('esx_ammujob:buyItem', data.current.value, data.current.price)
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenBuyAmmosMenu(station)
  local elements = {}

  for i=1, #Config.AmmuStations[station].AuthorizedAmmos, 1 do
    local ammo = Config.AmmuStations[station].AuthorizedAmmos[i]

    table.insert(elements, {label = ammo.label .. ' $' .. ammo.price, value = ammo.name, price = ammo.price})
  end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_ammos',
      {
        css = 'ammunation',
        title    = "Acheter des Munitions",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        TriggerServerEvent('esx_ammujob:buyAmmos', data.current.value, data.current.price)
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenBuyPPAMenu(player)
  local elements = {}
  table.insert(elements, {label = 'PPA $15000', value = "weapon", price = 15000})

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_ppa',
      {
        css = 'ammunation',
        title    = "Acheter un PPA",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        if data.current.value == "weapon" then
          TriggerServerEvent('esx_ammujob:buyPPA', GetPlayerServerId(player), data.current.value, data.current.price)
        end
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenBuyWeaponsMenu(station)
  ESX.TriggerServerCallback('esx_ammujob:getArmoryWeapons', function(weapons)
    local elements = {}

    for i=1, #Config.AmmuStations[station].AuthorizedWeapons, 1 do

      local weapon = Config.AmmuStations[station].AuthorizedWeapons[i]
      local count  = 0

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. weapon.label .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons', {
        css = 'ammunation',
        title    = _U('buy_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      }, function(data, menu)
        ESX.TriggerServerCallback('esx_ammujob:buy', function(hasEnoughMoney)
          if hasEnoughMoney == true then
            ESX.TriggerServerCallback('esx_ammujob:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value, true)
          else
            ESX.ShowNotification(_U('not_enough_money'))
          end
        end, data.current.price)
      end, function(data, menu)
        menu.close()
      end)
  end)
end

function OpenGetStocksMenu()
  ESX.TriggerServerCallback('esx_ammujob:getStockItems', function(items)
    local elements = {}

    for i=1, #items, 1 do
      if items[i].count > 0 then 
        table.insert(elements, {
          label = 'x' .. items[i].count .. ' ' .. items[i].label,
          value = items[i].name
        })
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        css = 'ammunation',
        title    = 'Ammu stock',
        elements = elements
      },
      function(data, menu)
      local itemName = data.current.value

      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
        title = _U('quantity')
      }, function(data2, menu2)
        local count = tonumber(data2.value)

        if count == nil then
          ESX.ShowNotification(_U('quantity_invalid'))
        else
          menu2.close()
          menu.close()
          TriggerServerEvent('esx_ammujob:getStockItem', itemName, count)

          Citizen.Wait(300)
          OpenGetStocksMenu()
        end
      end, function(data2, menu2)
        menu2.close()
      end)
    end, function(data, menu)
      menu.close()
    end)
  end)
end

function OpenPutStocksMenu()
  ESX.TriggerServerCallback('esx_ammujob:getPlayerInventory', function(inventory)
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

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',{
        css = 'ammunation',
        title    = _U('inventory'),
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
      local itemName = data.current.value

      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
        title = _U('quantity')
      }, function(data2, menu2)
        local count = tonumber(data2.value)

        if count == nil then
          ESX.ShowNotification(_U('quantity_invalid'))
        else
          menu2.close()
          menu.close()
          TriggerServerEvent('esx_ammujob:putStockItems', itemName, count)

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

AddEventHandler('esx_ammujob:hasEnteredMarker', function(station, part, partNum)
  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  elseif part == 'Vehicles' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = _U('vehicle_spawner')
    CurrentActionData = {station = station, partNum = partNum}
  elseif part == 'VehicleDeleter' then
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then
      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end
    end
  elseif part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_ammujob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_ammujob:hasEnteredEntityZone', function(entity)
  local playerPed = PlayerPedId()

  if PlayerData.job ~= nil and PlayerData.job.name == 'ammu' and IsPedOnFoot(playerPed) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('remove_prop')
    CurrentActionData = {entity = entity}
  end

  if GetEntityModel(entity) == `p_ld_stinger_s` then
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed, false) then
      local vehicle = GetVehiclePedIsIn(playerPed)

      for i=0, 7, 1 do
        SetVehicleTyreBurst(vehicle, i, true, 1000)
      end
    end
  end
end)

AddEventHandler('esx_ammujob:hasExitedEntityZone', function(entity)
  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end
end)

Citizen.CreateThread(function()
  local playerPed
  local targetPed

  while true do
    Citizen.Wait(1)

    if IsHandcuffed then
      playerPed = PlayerPedId()

      if dragStatus.isDragged then
        targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

        -- undrag if target is in an vehicle
        if not IsPedSittingInAnyVehicle(targetPed) then
          AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        else
          dragStatus.isDragged = false
          DetachEntity(playerPed, true, false)
        end

        if IsPedDeadOrDying(targetPed, true) then
          dragStatus.isDragged = false
          DetachEntity(playerPed, true, false)
        end

      else
        DetachEntity(playerPed, true, false)
      end
    else
      Citizen.Wait(500)
    end
  end
end)

RegisterNetEvent('esx_ammujob:putInVehicle')
AddEventHandler('esx_ammujob:putInVehicle', function()
  local playerPed = PlayerPedId()
  local coords = GetEntityCoords(playerPed)

  if not IsHandcuffed then
    return
  end

  if IsAnyVehicleNearPoint(coords, 5.0) then
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

    if DoesEntityExist(vehicle) then
      local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle, i) then
          freeSeat = i
          break
        end
      end

      if freeSeat then
        TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
        dragStatus.isDragged = false
      end
    end
  end
end)

RegisterNetEvent('esx_ammujob:OutVehicle')
AddEventHandler('esx_ammujob:OutVehicle', function(t)
  local playerPed = PlayerPedId()

  if not IsPedSittingInAnyVehicle(playerPed) then
    return
  end

  local vehicle = GetVehiclePedIsIn(playerPed, false)
  TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = PlayerPedId()
    if IsHandcuffed then
      DisableControlAction(0, 1, true) -- Disable pan
      DisableControlAction(0, 2, true) -- Disable tilt
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 32, true) -- W
      DisableControlAction(0, 34, true) -- A
      DisableControlAction(0, 31, true) -- S
      DisableControlAction(0, 30, true) -- D

      DisableControlAction(0, 45, true) -- Reload
      DisableControlAction(0, 22, true) -- Jump
      DisableControlAction(0, 44, true) -- Cover
      DisableControlAction(0, 37, true) -- Select Weapon
      DisableControlAction(0, 23, true) -- Also 'enter'?

      DisableControlAction(0, 288,  true) -- Disable phone
      DisableControlAction(0, 289, true) -- Inventory
      DisableControlAction(0, 170, true) -- Animations
      DisableControlAction(0, 167, true) -- Job

      DisableControlAction(0, 0, true) -- Disable changing view
      DisableControlAction(0, 26, true) -- Disable looking behind
      DisableControlAction(0, 73, true) -- Disable clearing animation
      DisableControlAction(2, 199, true) -- Disable pause screen

      DisableControlAction(0, 59, true) -- Disable steering in vehicle
      DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
      DisableControlAction(0, 72, true) -- Disable reversing in vehicle

      DisableControlAction(2, 36, true) -- Disable going stealth

      DisableControlAction(0, 47, true)  -- Disable weapon
      DisableControlAction(0, 264, true) -- Disable melee
      DisableControlAction(0, 257, true) -- Disable melee
      DisableControlAction(0, 140, true) -- Disable melee
      DisableControlAction(0, 141, true) -- Disable melee
      DisableControlAction(0, 142, true) -- Disable melee
      DisableControlAction(0, 143, true) -- Disable melee
      DisableControlAction(0, 75, true)  -- Disable exit vehicle
      DisableControlAction(27, 75, true) -- Disable exit vehicle

      if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
        ESX.Streaming.RequestAnimDict('mp_arresting', function()
          TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
        end)
      end
    else
      Citizen.Wait(500)
    end
  end
end)

-- Display markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if PlayerData.job and PlayerData.job.name == 'ammu' then

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
      local isInMarker, hasExited, letSleep = false, false, true
      local currentStation, currentPart, currentPartNum

      for k,v in pairs(Config.AmmuStations) do

        for i=1, #v.Cloakrooms, 1 do
          local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

          if distance < Config.DrawDistance then
            DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
            letSleep = false
          end

          if distance < Config.MarkerSize.x then
            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
          end
        end

        for i=1, #v.Armories, 1 do
          local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

          if distance < Config.DrawDistance then
            DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
            letSleep = false
          end

          if distance < Config.MarkerSize.x then
            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
          end
        end

        for i=1, #v.Vehicles, 1 do
          local distance = GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner, true)

          if distance < Config.DrawDistance then
            DrawMarker(36, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
            letSleep = false
          end

          if distance < Config.MarkerSize.x then
            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          local distance = GetDistanceBetweenCoords(coords, v.VehicleDeleters[i], true)

          if distance < Config.DrawDistance then
            DrawMarker(36, v.VehicleDeleters[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
            letSleep = false
          end

          if distance < Config.MarkerSize.x then
            isInMarker, currentStation, currentPart, currentPartNum = true, k, 'VehicleDeleters', i
          end
        end

        if Config.EnablePlayerManagement and PlayerData.job and PlayerData.job.name == 'ammu' and PlayerData.job.grade_name == 'boss' then
          for i=1, #v.BossActions, 1 do
            local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

            if distance < Config.DrawDistance then
              DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
              letSleep = false
            end

            if distance < Config.MarkerSize.x then
              isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
            end
          end
        end
      end

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
        if
          (LastStation and LastPart and LastPartNum) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('esx_ammujob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_ammujob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_ammujob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

      if letSleep then
        Citizen.Wait(500)
      end

    else
      Citizen.Wait(500)
    end
  end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
  local trackedEntities = {
    `prop_roadcone02a`,
    `prop_barrier_work05`,
    `p_ld_stinger_s`,
    `prop_boxpile_07d`,
    `hei_prop_cash_crate_half_full`
  }

  while true do
    Citizen.Wait(500)

    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    local closestDistance = -1
    local closestEntity   = nil

    for i=1, #trackedEntities, 1 do
      local object = GetClosestObjectOfType(ccoords, 3.0, trackedEntities[i], false, false, false)

      if DoesEntityExist(object) then
        local objCoords = GetEntityCoords(object)
        local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

        if closestDistance == -1 or closestDistance > distance then
          closestDistance = distance
          closestEntity   = object
        end
      end
    end

    if closestDistance ~= -1 and closestDistance <= 3.0 then
      if LastEntity ~= closestEntity then
        TriggerEvent('esx_ammujob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end
    else
      if LastEntity ~= nil then
        TriggerEvent('esx_ammujob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if CurrentAction then
      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlJustReleased(0,  38) and PlayerData.job and PlayerData.job.name == 'ammu' then
        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        elseif CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        elseif CurrentAction == 'delete_vehicle' then
          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        elseif CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('society:openBMenu', 'ammu', function(data, menu)
            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}
          end)
        elseif CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
      end
    else
      Citizen.Wait(500)
    end

    if IsControlPressed(0,  167) and not isDead and PlayerData.job and PlayerData.job.name == 'ammu' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'ammu_actions') then
      OpenAmmuActionsMenu()
    end
  end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
  if Config.EnableHandcuffTimer and HandcuffTimer.active then
    ESX.ClearTimeout(HandcuffTimer.task)
  end

  HandcuffTimer.active = true

  HandcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
    ESX.ShowNotification(_U('unrestrained_timer'))
    TriggerEvent('esx_ammujob:unrestrain')
    HandcuffTimer.active = false
  end)
end