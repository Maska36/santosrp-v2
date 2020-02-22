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

  while ESX.GetPlayerData().org == nil do
    Citizen.Wait(10)
  end

  PlayerData = ESX.GetPlayerData()
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

function OpenArmoryMenu(station)
    local elements = {}

    table.insert(elements, {label = _U('get_weapon'), value = 'get_weapon'})
    table.insert(elements, {label = _U('put_weapon'), value = 'put_weapon'})
    table.insert(elements, {label = _U('get_stock'),  value = 'get_stock'})
    table.insert(elements, {label = _U('put_stock'),  value = 'put_stock'}) 

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        css = 'santos',
        title    = _U('armory'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
        if data.current.value == 'get_weapon' then
          OpenGetWeaponMenu()
        elseif  data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        elseif  data.current.value == 'buy_weapons' then
          OpenBuyWeaponsMenu()
        elseif  data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        elseif  data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        end

      end, function(data, menu)
        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = _U('open_armory')
        CurrentActionData = {station = station}
      end)
end

function OpenBloodsActionsMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'bloods_actions',
    {
      css = 'santos',
      title    = 'Bloods',
      align    = 'top-left',
      elements = {
        {label = _U('citizen_interaction'), value = 'citizen_interaction'},
        --{label = _U('object_spawner'),      value = 'object_spawner'},
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            css = 'santos',
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              --{label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
              --{label = _U('fine'),            value = 'fine'}
            },
          },
          function(data2, menu2)
          local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
          if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local action = data2.current.value
              if action == 'identity_card' then
                OpenIdentityCardMenu(closestPlayer)
              elseif action == 'body_search' then
                OpenBodySearchMenu(closestPlayer)
              elseif action == 'drag' then
                TriggerServerEvent('esx_bloodsjob:drag', GetPlayerServerId(closestPlayer))
              elseif action == 'put_in_vehicle' then
                TriggerServerEvent('esx_bloodsjob:putInVehicle', GetPlayerServerId(closestPlayer))
              elseif action == 'out_the_vehicle' then
                  TriggerServerEvent('esx_bloodsjob:OutVehicle', GetPlayerServerId(closestPlayer))
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

function OpenIdentityCardMenu(player)
  ESX.TriggerServerCallback('esx_bloodsjob:getOtherPlayerData', function(data)
    local elements = {}
    local nameLabel = _U('name', data.name)
    local jobLabel, sexLabel, dobLabel, heightLabel, idLabel

    if data.job.grade_label and  data.job.grade_label ~= '' then
      jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
    else
      jobLabel = _U('job', data.job.label)
    end

    if Config.EnableESXIdentity then
      nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

      if data.sex then
        if string.lower(data.sex) == 'm' then
          sexLabel = _U('sex', _U('male'))
        else
          sexLabel = _U('sex', _U('female'))
        end
      else
        sexLabel = _U('sex', _U('unknown'))
      end

      if data.dob then
        dobLabel = _U('dob', data.dob)
      else
        dobLabel = _U('dob', _U('unknown'))
      end

      if data.height then
        heightLabel = _U('height', data.height)
      else
        heightLabel = _U('height', _U('unknown'))
      end

      if data.name then
        idLabel = _U('id', data.name)
      else
        idLabel = _U('id', _U('unknown'))
      end
    end

    local elements = {
      {label = nameLabel},
      {label = jobLabel}
    }

    if Config.EnableESXIdentity then
      table.insert(elements, {label = sexLabel})
      table.insert(elements, {label = dobLabel})
      table.insert(elements, {label = heightLabel})
      table.insert(elements, {label = idLabel})
    end

    if data.drunk then
      table.insert(elements, {label = _U('bac', data.drunk)})
    end

    if data.licenses then
      table.insert(elements, {label = _U('license_label')})

      for i=1, #data.licenses, 1 do
        table.insert(elements, {label = data.licenses[i].label})
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
        css = 'santos',
      title    = _U('citizen_interaction'),
      align    = 'top-left',
      elements = elements
    }, nil, function(data, menu)
      menu.close()
    end)
  end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
  ESX.TriggerServerCallback('esx_bloodsjob:getOtherPlayerData', function(data)
    local elements = {}

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
        table.insert(elements, {
          label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
          value    = 'black_money',
          itemType = 'item_account',
          amount   = data.accounts[i].money
        })

        break
      end
    end

    table.insert(elements, {label = _U('guns_label')})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
        value    = data.weapons[i].name,
        itemType = 'item_weapon',
        amount   = data.weapons[i].ammo
      })
    end

    table.insert(elements, {label = _U('inventory_label')})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
          value    = data.inventory[i].name,
          itemType = 'item_standard',
          amount   = data.inventory[i].count
        })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
        css = 'santos',
      title    = _U('search'),
      align    = 'top-left',
      elements = elements
    }, function(data, menu)
      if data.current.value then
        TriggerServerEvent('esx_bloodsjob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
        OpenBodySearchMenu(player)
      end
    end, function(data, menu)
      menu.close()
    end)
  end, GetPlayerServerId(player))
end

function OpenGetWeaponMenu()
  ESX.TriggerServerCallback('esx_bloodsjob:getArmoryWeapons', function(weapons)
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
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      }, function(data, menu)
        menu.close()

        ESX.TriggerServerCallback('esx_bloodsjob:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)
      end, function(data, menu)
        menu.close()
      end)
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

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',{
      css = 'santos',
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
      menu.close()

      ESX.TriggerServerCallback('esx_bloodsjob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
    end, data.current.value, true)
    end, function(data, menu)
      menu.close()
    end)
end

function OpenGetStocksMenu()
  ESX.TriggerServerCallback('esx_bloodsjob:getStockItems', function(items)
    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {
        label = 'x' .. items[i].count .. ' ' .. items[i].label, 
        value = items[i].name
      })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',{
        css = 'santos',
        title    = _U('bloods_stock'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)
        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          }, function(data2, menu2)
            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_bloodsjob:getStockItem', itemName, count)
 
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
  ESX.TriggerServerCallback('esx_bloodsjob:getPlayerInventory', function(inventory)
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
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        css = 'santos',
        title    = _U('inventory'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)
        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',{
            title = _U('quantity')
          }, function(data2, menu2)
            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('quantity_invalid'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_bloodsjob:putStockItems', itemName, count)

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

RegisterNetEvent('esx:setOrg')
AddEventHandler('esx:setOrg', function(org)
  PlayerData.org = org
end)

AddEventHandler('esx_bloodsjob:hasEnteredMarker', function(station, part, partNum)
  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  elseif part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = _U('open_bossmenu')
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_bloodsjob:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('esx_bloodsjob:hasEnteredEntityZone', function(entity)
  local playerPed = PlayerPedId()

  if PlayerData.org and PlayerData.org.name == 'bloods' and IsPedOnFoot(playerPed) then
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

AddEventHandler('esx_bloodsjob:hasExitedEntityZone', function(entity)
  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end
end)

RegisterNetEvent('esx_bloodsjob:handcuff')
AddEventHandler('esx_bloodsjob:handcuff', function()
  IsHandcuffed    = not IsHandcuffed
  local playerPed = PlayerPedId()

  Citizen.CreateThread(function()
    if IsHandcuffed then

      RequestAnimDict('mp_arresting')
      while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

      SetEnableHandcuffs(playerPed, true)
      DisablePlayerFiring(playerPed, true)
      SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true) -- unarm player
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed, true)
      DisplayRadar(false)

      if Config.EnableHandcuffTimer then
        if HandcuffTimer.active then
          ESX.ClearTimeout(HandcuffTimer.task)
        end

        StartHandcuffTimer()
      end
    else
      if Config.EnableHandcuffTimer and HandcuffTimer.active then
        ESX.ClearTimeout(HandcuffTimer.task)
      end

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      DisablePlayerFiring(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed, true)
      FreezeEntityPosition(playerPed, false)
      DisplayRadar(true)
    end
  end)
end)

RegisterNetEvent('esx_bloodsjob:unrestrain')
AddEventHandler('esx_bloodsjob:unrestrain', function()
  if IsHandcuffed then
    local playerPed = PlayerPedId()
    IsHandcuffed = false

    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)

    -- end timer
    if Config.EnableHandcuffTimer and HandcuffTimer.active then
      ESX.ClearTimeout(HandcuffTimer.task)
    end
  end
end)

RegisterNetEvent('esx_bloodsjob:drag')
AddEventHandler('esx_bloodsjob:drag', function(guyId)
  if not IsHandcuffed then
    return
  end

  dragStatus.isDragged = not dragStatus.isDragged
  dragStatus.GuyId = guyId
end)

Citizen.CreateThread(function()
  local playerPed
  local targetPed

  while true do
    Citizen.Wait(1)

    if IsHandcuffed then
      playerPed = PlayerPedId()

      if dragStatus.isDragged then
        targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.GuyId))

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

RegisterNetEvent('esx_bloodsjob:putInVehicle')
AddEventHandler('esx_bloodsjob:putInVehicle', function()
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

RegisterNetEvent('esx_bloodsjob:OutVehicle')
AddEventHandler('esx_bloodsjob:OutVehicle', function(t)
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

    if PlayerData.org ~= nil and PlayerData.org.name == 'bloods' then

      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
      local isInMarker, hasExited, letSleep = false, false, true
      local currentStation, currentPart, currentPartNum

      for k,v in pairs(Config.BloodsStations) do
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

        if Config.EnablePlayerManagement and PlayerData.org ~= nil and PlayerData.org.name == 'bloods' and PlayerData.org.grade_name == 'boss' then
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
          TriggerEvent('esx_bloodsjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('esx_bloodsjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_bloodsjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

      if letSleep then
        Citizen.Wait(500)
      end

    else
      Citizen.Wait(500)
    end
  end
end)

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
      local object = GetClosestObjectOfType(coords, 3.0, trackedEntities[i], false, false, false)

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
        TriggerEvent('esx_bloodsjob:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end
    else
      if LastEntity then
        TriggerEvent('esx_bloodsjob:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if CurrentAction ~= nil then
      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlPressed(0,  38) and PlayerData.org ~= nil and PlayerData.org.name == 'bloods' then
        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        elseif CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('esx_society:openBossOrgMenu', 'bloods', function(data, menu)
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
    end

    if IsControlPressed(0,  168) and PlayerData.org ~= nil and PlayerData.org.name == 'bloods' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'bloods_actions') then
      OpenBloodsActionsMenu()
    end
  end
end)

AddEventHandler('playerSpawned', function(spawn)
  isDead = false
  TriggerEvent('esx_bloodsjob:unrestrain')

  if not hasAlreadyJoined then
    TriggerServerEvent('esx_bloodsjob:spawned')
  end
  hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
  isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
  if resource == GetCurrentResourceName() then
    TriggerEvent('esx_bloodsjob:unrestrain')

    if Config.EnableHandcuffTimer and HandcuffTimer.active then
      ESX.ClearTimeout(HandcuffTimer.task)
    end
  end
end)

function StartHandcuffTimer()
  if Config.EnableHandcuffTimer and HandcuffTimer.active then
    ESX.ClearTimeout(HandcuffTimer.task)
  end

  HandcuffTimer.active = true

  HandcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
    ESX.ShowNotification(_U('unrestrained_timer'))
    TriggerEvent('esx_bloodsjob:unrestrain')
    HandcuffTimer.active = false
  end)
end