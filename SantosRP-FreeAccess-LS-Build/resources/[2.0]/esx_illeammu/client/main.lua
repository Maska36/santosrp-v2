ESX = nil

local PlayerData = {}
local CurrentActionData = {}
local HasAlreadyEnteredMarker = false
local LastStation, LastPart, LastPartNum, CurrentAction, CurrentActionMsg

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

function OpenArmoryMenu(station)
	local elements = {
	    {label = _U('buy_weapons'), value = 'buy_weapons'},
	    {label = _U('get_weapon'), value = 'get_weapon'},
	    {label = _U('put_weapon'), value = 'put_weapon'},
        {label = 'Facture', value = 'billing'},
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
        elseif data.current.value == 'billing' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                title = "Montant de la facture"
            },
            function(data, menu)
                local amount = tonumber(data.value)

                if amount == nil or amount < 0 then
                    ESX.ShowNotification(_U('invalid_amount'))
                else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification("Il n'y à personne a proximité.")
                    else
                        menu.close()
                        TriggerServerEvent('esxb:sendB', GetPlayerServerId(closestPlayer), 'society_illammu', "Armurerie Ilégale", amount)
                    end
                end
            end, function(data, menu)
                menu.close()
            end)
    	elseif data.current.value == 'buy_weapons' then
      		OpenBuyWeaponsMenu(station)
    	elseif data.current.value == 'put_stock' then
      		OpenPutStocksMenu()
    	elseif data.current.value == 'get_stock' then
      		OpenGetStocksMenu()
    	end
  	end,
  	function(data, menu)
    	menu.close()

    	CurrentAction     = 'menu_armory'
    	CurrentActionMsg  = _U('open_armory')
    	CurrentActionData = {station = station}
  	end)
end

function OpenGetWeaponMenu()
  ESX.TriggerServerCallback('esx_illammujob:getArmoryWeapons', function(weapons)
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

        ESX.TriggerServerCallback('esx_illammujob:removeArmoryWeapon', function()
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

      ESX.TriggerServerCallback('esx_illammujob:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value, true)
    end, function(data, menu)
      menu.close()
    end)
end

function OpenBuyWeaponsMenu(station)
  ESX.TriggerServerCallback('esx_illammujob:getArmoryWeapons', function(weapons)
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
        ESX.TriggerServerCallback('esx_illammujob:buy', function(hasEnoughMoney)
          if hasEnoughMoney == true then
            ESX.TriggerServerCallback('esx_illammujob:addArmoryWeapon', function()
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
  ESX.TriggerServerCallback('esx_illammujob:getStockItems', function(items)
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
        align    = 'top-left',
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
          TriggerServerEvent('esx_illammujob:getStockItem', itemName, count)

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
  ESX.TriggerServerCallback('esx_illammujob:getPlayerInventory', function(inventory)
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
          TriggerServerEvent('esx_illammujob:putStockItems', itemName, count)

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

AddEventHandler('esx_illammujob:hasEnteredMarker', function(station, part, partNum)
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

AddEventHandler('esx_illammujob:hasExitedMarker', function(station, part, partNum)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if PlayerData.job and PlayerData.job.name == 'illammu' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local isInMarker, hasExited, letSleep = false, false, true
            local currentStation, currentPart, currentPartNum

            for k,v in pairs(Config.AmmuStations) do

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

                if Config.EnablePlayerManagement and PlayerData.job and PlayerData.job.name == 'illammu' and PlayerData.job.grade_name == 'boss' then
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
                    TriggerEvent('esx_illammujob:hasExitedMarker', LastStation, LastPart, LastPartNum)
                    hasExited = true
                end

                HasAlreadyEnteredMarker = true
                LastStation             = currentStation
                LastPart                = currentPart
                LastPartNum             = currentPartNum

                TriggerEvent('esx_illammujob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
            end

            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_illammujob:hasExitedMarker', LastStation, LastPart, LastPartNum)
            end

            if letSleep then
                Citizen.Wait(500)
            end
        else
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

            if PlayerData.job and PlayerData.job.name == 'illammu' then
                if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'illammu' then
                    if CurrentAction == 'menu_armory' then
                        OpenArmoryMenu(CurrentActionData.station)
                    elseif CurrentAction == 'menu_boss_actions' then
                        ESX.UI.Menu.CloseAll()
                        TriggerEvent('society:openBMenu', 'illammu', function(data, menu)
                            menu.close()
                            CurrentAction     = 'menu_boss_actions'
                            CurrentActionMsg  = _U('open_bossmenu')
                            CurrentActionData = {}
                        end)
                    end

                    CurrentAction = nil
                end
            else
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)