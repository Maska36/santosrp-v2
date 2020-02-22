local HasAlreadyEnteredMarker, CurrentAction = false
local LastStation, LastPart, LastPartNum, CurrentAction, CurrentActionMsg
local isInPublicMarker = false

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSO', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)


function cleanPlayer(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
    RequestAnimSet(clip)
    while not HasAnimSetLoaded(clip) do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(uniform, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject

        if skin.sex == 0 then
            uniformObject = Config.Uniforms[uniform].male
            setClipset(playerPed, "MOVE_M@POSH@")
        else
            uniformObject = Config.Uniforms[uniform].female
            setClipset(playerPed, "MOVE_F@POSH@")
        end

        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

            if uniform == 'bullet_wear' then
                SetPedArmour(playerPed, 100)
            end
        else
            ESX.ShowNotification(_U('no_outfit'))
        end
  end)
end

function OpenCloakroomMenu()
    local playerPed = PlayerPedId()
    local grade = ESX.PlayerData.job.grade_name

    local elements = {
        { label = _U('citizen_wear'), value = 'citizen_wear'},
        { label = _U('barman_outfit'), uniform = 'barman_outfit'},
        { label = _U('dancer_outfit_1'), uniform = 'dancer_outfit_1'},
        { label = _U('dancer_outfit_2'), uniform = 'dancer_outfit_2'},
        { label = _U('dancer_outfit_3'), uniform = 'dancer_outfit_3'},
        { label = _U('dancer_outfit_4'), uniform = 'dancer_outfit_4'},
        { label = _U('dancer_outfit_5'), uniform = 'dancer_outfit_5'},
        { label = _U('dancer_outfit_6'), uniform = 'dancer_outfit_6'},
        { label = _U('dancer_outfit_7'), uniform = 'dancer_outfit_7'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
        css = 'santos',
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        isBarman = false
        cleanPlayer(playerPed)

        if data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif data.current.value == 'barman_outfit' then
            isBarman = true
        end

        if data.current.uniform then
            setUniform(data.current.uniform, playerPed)
        end
    end, function(data, menu)
        menu.close()
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {}
    end)
end

function OpenVaultMenu(station)
    local elements = {
        {label = _U('get_weapon'), value = 'get_weapon'},
        {label = _U('put_weapon'), value = 'put_weapon'},
        {label = _U('get_object'), value = 'get_stock'},
        {label = _U('put_object'), value = 'put_stock'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault', {
        css = 'santos',
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'get_weapon' then
            OpenGetWeaponMenu()
        elseif data.current.value == 'put_weapon' then
          OpenPutWeaponMenu()
        elseif data.current.value == 'put_stock' then
           OpenPutStocksMenu()
        elseif data.current.value == 'get_stock' then
           OpenGetStocksMenu()
        end
    end,  function(data, menu)
        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {station = station}
    end)
end

function OpenFridgeMenu()
    local elements = {
        {label = _U('get_object'), value = 'get_stock'},
        {label = _U('put_object'), value = 'put_stock'}
    }
    
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge', {
        css = 'santos',
        title    = _U('fridge'),
        align    = 'top-left',
        elements = elements,
    },  function(data, menu)
        if data.current.value == 'put_stock' then
            OpenPutFridgeStocksMenu()
        elseif data.current.value == 'get_stock' then
            OpenGetFridgeStocksMenu()
        end
    end, function(data, menu)
        menu.close()

        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = _U('open_fridge')
        CurrentActionData = {}
    end)
end

function OpenVehicleSpawnerMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
        local vehicle = Config.AuthorizedVehicles[i]
        table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
        css = 'santos',
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        menu.close()

        local model = data.current.value
        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)
        local vehicles = Config.Zones.Vehicles

        if not DoesEntityExist(vehicle) then
            local playerPed = PlayerPedId()

            if Config.MaxInService == -1 then
                ESX.Game.SpawnVehicle(model, {
                    x = vehicles.SpawnPoint.x,
                    y = vehicles.SpawnPoint.y,
                    z = vehicles.SpawnPoint.z
                }, vehicles.Heading, function(vehicle)
                    SetVehicleDirtLevel(vehicle, 0)
                end)
            end
        else
            ESX.ShowNotification(_U('vehicle_out'))
        end
    end,  function(data, menu)
        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}
    end)
end

function OpenSocietyActionsMenu()
    local elements = {} 

    table.insert(elements, {label = "Facture", value = 'billing'})
    if (isBarman or ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'viceboss' or ESX.PlayerData.job.grade_name == 'barman') then
        table.insert(elements, {label = _U('crafting'), value = 'menu_crafting'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn_actions', {
        css = 'santos',
        title    = _U('unicorn'),
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local player, distance = ESX.Game.GetClosestPlayer()

        if data.current.value == 'billing' then
            OpenBillingMenu()
        elseif data.current.value == 'menu_crafting' then
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_crafting', {
                title = _U('crafting'),
                align = 'top-left',
                elements = {
                    {label = _U('jagerbomb'),     value = 'jagerbomb'},
                    {label = _U('golem'),         value = 'golem'},
                    {label = _U('whiskycoca'),    value = 'whiskycoca'},
                    {label = _U('vodkaenergy'),   value = 'vodkaenergy'},
                    {label = _U('vodkafruit'),    value = 'vodkafruit'},
                    {label = _U('rhumfruit'),     value = 'rhumfruit'},
                    {label = _U('teqpaf'),        value = 'teqpaf'},
                    {label = _U('rhumcoca'),      value = 'rhumcoca'},
                    {label = _U('mojito'),        value = 'mojito'},
                    {label = _U('mixapero'),      value = 'mixapero'},
                    {label = _U('metreshooter'),  value = 'metreshooter'},
                    {label = _U('jagercerbere'),  value = 'jagercerbere'},
                }
            }, function(data2, menu2)
                TriggerServerEvent('esx_unicornjob:craftingCoktails', data2.current.value)
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBillingMenu()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
        title = _U('billing_amount')
    }, function(data, menu) 
        local amount = tonumber(data.value)
        local player, distance = ESX.Game.GetClosestPlayer()

        if player ~= -1 and distance <= 3.0 then
            menu.close()
            
            if amount == nil then
                ESX.ShowNotification(_U('amount_invalid'))
            else
                TriggerServerEvent('esxb:sendB', GetPlayerServerId(player), 'society_unicorn', _U('billing'), amount)
            end
        else
            ESX.ShowNotification(_U('no_players_nearby'))
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getStockItems', function(items)
        local elements = {}

        for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css = 'santos',
            title    = _U('unicorn_stock'),
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',{
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(_U('invalid_quantity'))
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_unicornjob:getStockItem', itemName, count)
            
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
    ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
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

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css = 'santos',
            title    = _U('inventory'),
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',{
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(_U('invalid_quantity'))
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_unicornjob:putStockItems', itemName, count)

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

function OpenGetFridgeStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getFridgeStockItems', function(items)
        local elements = {}

        for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge_menu', {
            css = 'santos',
            title    = _U('unicorn_fridge_stock'),
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',{
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                ESX.ShowNotification(_U('invalid_quantity'))
                else
                menu2.close()
                menu.close()
                TriggerServerEvent('esx_unicornjob:getFridgeStockItem', itemName, count)
           
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

function OpenPutFridgeStocksMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
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

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge_menu',{
            css = 'santos',
            title    = _U('fridge_inventory'),
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',{
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(_U('invalid_quantity'))
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_unicornjob:putFridgeStockItems', itemName, count)
            
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

function OpenGetWeaponMenu()
    ESX.TriggerServerCallback('esx_unicornjob:getVaultWeapons', function(weapons)
        local elements = {}

        for i=1, #weapons, 1 do
            if weapons[i].count > 0 and ESX.GetWeaponLabel(weapons[i].name) ~= nil then
                table.insert(elements, {
                    label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
                    value = weapons[i].name
                })
            end
        end

        ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'vault_get_weapon', {
            css = 'santos',
            title    = _U('get_weapon_menu'),
            align    = 'top-left',
            elements = elements,
        }, function(data, menu)
            menu.close()

            ESX.TriggerServerCallback('esx_unicornjob:removeVaultWeapon', function()
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

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault_put_weapon', {
        css = 'santos',
        title    = _U('put_weapon_menu'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        menu.close()

        ESX.TriggerServerCallback('esx_unicornjob:addVaultWeapon', function()
            OpenPutWeaponMenu()
        end, data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenShopMenu(zone)
    local elements = {}
    for i=1, #Config.Zones[zone].Items, 1 do
        local item = Config.Zones[zone].Items[i]
        table.insert(elements, {
            label     = item.label .. ' - <span style="color:red;">$' .. item.price .. ' </span>',
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn_shop', {
        css = 'santos',
        title    = _U('shop'),
        elements = elements
    },
    function(data, menu)
        TriggerServerEvent('esx_unicornjob:buyItem', data.current.value, data.current.price, data.current.realLabel)
    end, function(data, menu)
         menu.close()
    end)
end

AddEventHandler('esx_unicornjob:hasEnteredMarker', function(station, part, partNum)
    if part == 'BossActions' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'viceboss' or ESX.PlayerData.job.grade_name == 'barman' then
        CurrentAction     = 'menu_boss_actions'
        CurrentActionMsg  = _U('open_bossmenu')
        CurrentActionData = {}
    elseif part == 'Cloakrooms' then
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = _U('open_cloackroom')
        CurrentActionData = {}
    elseif part == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = _U('open_vault')
        CurrentActionData = {station = station}
    elseif part == 'Fridge' then
        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = _U('open_fridge')
        CurrentActionData = {}
    elseif part == 'Flacons' or part == 'NoAlcool' or part == 'Apero' or part == 'Ice' then
        CurrentAction     = 'menu_shop'
        CurrentActionMsg  = _U('shop_menu')
        CurrentActionData = {zone = zone}
    elseif part == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {station = station, part = part, partNum = partNum}
    elseif part == 'VehicleDeleters' then
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed,  false)

            CurrentAction     = 'delete_vehicle'
            CurrentActionMsg  = _U('store_vehicle')
            CurrentActionData = {vehicle = vehicle}
        end
    end
end)

AddEventHandler('esx_unicornjob:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

-- Create blips
Citizen.CreateThread(function()
    local blipMarker = Config.Blips.Blip
    local blip = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blip, blipMarker.Sprite)
    SetBlipDisplay(blip, blipMarker.Display)
    SetBlipScale  (blip, blipMarker.Scale)
    SetBlipColour (blip, blipMarker.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(_U('map_blip'))
    EndTextCommandSetBlipName(blip)
end)

-- Draw markers and more
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local isInMarker, hasExited, letSleep = false, false, true
            local currentStation

            for k,v in pairs(Config.Zones) do
                local distance = #(playerCoords - v.Pos)

                if distance < Config.DrawDistance then
                    DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, true, false, false, false)
                    letSleep = false

                    if distance < v.Size.x then
                        isInMarker, currentStation = k, true
                    end
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastStation ~= currentStation) then
                HasAlreadyEnteredMarker = true
                LastStation = currentStation
                TriggerEvent('esx_policejob:hasEnteredMarker', currentStation)
            end

            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_unicornjob:hasExitedMarker', LastStation)
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

            if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then

                if CurrentAction == 'menu_cloakroom' then
                    OpenCloakroomMenu()
                elseif CurrentAction == 'menu_vault' then
                    OpenVaultMenu()
                elseif CurrentAction == 'menu_fridge' then
                    OpenFridgeMenu()
                elseif CurrentAction == 'menu_shop' then
                    OpenShopMenu(CurrentActionData.zone)
                elseif CurrentAction == 'menu_vehicle_spawner' then
                    OpenVehicleSpawnerMenu()
                elseif CurrentAction == 'delete_vehicle' then
                    ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                elseif CurrentAction == 'menu_boss_actions' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'viceboss' or ESX.PlayerData.job.grade_name == 'barman'  then
                    ESX.UI.Menu.CloseAll()

                    TriggerEvent('society:openBMenu', 'unicorn', function(data, menu)
                        menu.close()
                        CurrentAction     = 'menu_boss_actions'
                        CurrentActionMsg  = _U('open_bossmenu')
                        CurrentActionData = {}
                    end, {wash = true})
                end

                CurrentAction = nil
            end
        end

        if IsControlJustReleased(0,  167) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'unicorn_actions') then
            OpenSocietyActionsMenu()
        end
    end
end)


-----------------------
----- TELEPORTERS -----

function teleportMarkers(position)
    SetEntityCoords(PlayerPedId(), position.x, position.y, position.z)
end

-- Show top left hint
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hintIsShowed == true then
            ESX.ShowHelpNotification(hintToDisplay)
        else
            Citizen.Wait(500)
        end
    end
end)

-- Display teleport markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then
            local coords = GetEntityCoords(PlayerPedId())

            for k,v in pairs(Config.TeleportZones) do
                if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
  while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then
            local coords      = GetEntityCoords(PlayerPedId())
            local position    = nil
            local zone        = nil

            for k,v in pairs(Config.TeleportZones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInPublicMarker = true
                    position = v.Teleport
                    zone = v
                    break
                else
                    isInPublicMarker  = false
                end
            end

            if IsControlJustReleased(0, 38) and isInPublicMarker then
                teleportMarkers(position)
            end

            -- hide or show top left zone hints
            if isInPublicMarker then
                hintToDisplay = zone.Hint
                hintIsShowed = true
            else
                if not isInMarker then
                    hintToDisplay = "no hint to display"
                    hintIsShowed = false
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)