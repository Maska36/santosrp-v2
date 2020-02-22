ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastZone
local CurrentAction
local CurrentActionMsg = ''
local CurrentActionData = {}
local JobBlips = {}

Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    	Citizen.Wait(0)
  	end

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    deleteBlips()
    blips()
end)

function OpenCloakroomMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tabac_actions',
    {
        css = 'santos',
        title    = _U('cloakroom'),
        align    = 'top-left',
        elements = {
            {label = _U('tabac_clothes_civil'), value = 'citizen_wear'},
            {label = _U('tabac_clothes_tabac'), value = 'tabac_wear'},
        },
    },
    function(data, menu)
        menu.close()

        if data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif data.current.value == 'pcmaker_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function OpenTabacActionsMenu()
    local elements = {
        {label = _U('cloakroom'), value = 'cloakroom'},
        {label = _U('deposit_stock'), value = 'put_stock'}
    }

    if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
        table.insert(elements, {label = _U('take_stock'), value = 'get_stock'})
    end

    if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
        table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tabac_actions',
    {
        css = 'santos',
        title    = 'Tabac',
        align    = 'top-left',
        elements = elements
    },
    function(data, menu)
        if data.current.value == 'cloakroom' then
            OpenCloakroomMenu()
        elseif data.current.value == 'put_stock' then
            OpenPutStocksMenu()
        elseif data.current.value == 'get_stock' then
            OpenGetStocksMenu()
        elseif data.current.value == 'boss_actions' then
            TriggerEvent('society:openBMenu', 'tabac', function(data, menu)
                menu.close()
            end)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function OpenVehicleSpawnerMenu()
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = 'Véhicule de Travail',  value = 'bison3'},
        {label = 'Véhicule de Travail #2',  value = 'mule'},
    }
        
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
    {
        css = 'santos',
        title    = _U('veh_menu'),
        align    = 'top-left',
        elements = elements,
    },
    function(data, menu)
        menu.close()

        local model = data.current.value
        ESX.Game.SpawnVehicle(model, Config.Zones.VehicleSpawnPoint.Pos, 56.326, function(vehicle)
            local playerPed = PlayerPedId()
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        end)
    end,
    function(data, menu)
        menu.close()
    end)
end


function OpenGetStocksMenu()
    ESX.TriggerServerCallback('esx_tabac:getStockItems', function(items)
        local elements = {}

        for i=1, #items, 1 do
            if items[i].count > 0 then
                table.insert(elements, {
                    label = 'x' .. items[i].count .. ' ' .. items[i].label,
                    value = items[i].name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
        {
            css = 'santos',
            title    = 'Inventaire',
            align    = 'top-left',
            elements = elements
        },
        function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
            {
                title = _U('quantity')
            },
            function(data2, menu2)
                local count = tonumber(data2.value)

                if count > 0 then
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_tabac:getStockItem', itemName, count)
                    Citizen.Wait(300)
                    OpenGetStocksMenu()
                else
                    ESX.ShowNotification(_U('quantity_invalid'))
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback('esx_tabac:getPlayerInventory', function(inventory)
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
            title    = 'Inventaire',
            align    = 'top-left',
            elements = elements
        },
        function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',{
                title = _U('quantity')
            },
            function(data2, menu2)
                local count = tonumber(data2.value)

                if count > 0 then
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_tabac:putStockItems', itemName, count)
                    Citizen.Wait(300)
                    OpenPutStocksMenu()
                else
                    ESX.ShowNotification(_U('quantity_invalid'))
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            menu.close()
        end)
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    blips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    deleteBlips()
    blips()
end)

AddEventHandler('esx_tabac:hasEnteredMarker', function(zone)
    if zone == 'TabacFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'tabac_harvest'
        CurrentActionMsg  = _U('press_collect')
        CurrentActionData = {zone= zone}
    elseif zone == 'TraitementTabac' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'tabac_traitement'
        CurrentActionMsg  = _U('press_traitement')
        CurrentActionData = {zone= zone}
    elseif zone == 'TraitementCigarette' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'cigarette_traitement'
        CurrentActionMsg  = _U('press_traitement')
        CurrentActionData = {zone= zone}
    elseif zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'farm_resell'
        CurrentActionMsg  = _U('press_sell')
        CurrentActionData = {zone = zone}
    elseif zone == 'TabacActions' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'tabac_actions_menu'
        CurrentActionMsg  = _U('press_to_open')
        CurrentActionData = {}
    elseif zone == 'VehicleSpawner' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        CurrentAction     = 'vehicle_spawner_menu'
        CurrentActionMsg  = _U('spawn_veh')
        CurrentActionData = {}
    elseif zone == 'VehicleDeleter' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle, distance = ESX.Game.GetClosestVehicle({ x = coords.x, y = coords.y, z = coords.z })
            if distance ~= -1 and distance <= 1.0 then
                CurrentAction     = 'delete_vehicle'
                CurrentActionMsg  = _U('store_veh')
                CurrentActionData = {vehicle = vehicle}
            end
        end
    end
end)

AddEventHandler('esx_tabac:hasExitedMarker', function(zone)
    ESX.UI.Menu.CloseAll()
    if zone == 'TabacFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        TriggerServerEvent('esx_tabac:stopHarvest')
    elseif (zone == 'TraitementTabac' or zone == 'TraitementCigarette') and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        TriggerServerEvent('esx_tabac:stopTransform')
    elseif zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        TriggerServerEvent('esx_tabac:stopSell')
    end

    CurrentAction = nil
end)

function deleteBlips()
    if JobBlips[1] ~= nil then
        for i=1, #JobBlips, 1 do
        RemoveBlip(JobBlips[i])
        JobBlips[i] = nil
        end
    end
end

-- Create Blips
function blips()
   if PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
        -- local blip = AddBlipForCoord(Config.Zones.PCMakerActions.Pos)
        -- SetBlipSprite (blip, 85)
        -- SetBlipDisplay(blip, 4)
        -- SetBlipScale(blip, 0.8)
        -- SetBlipColour (blip, 19)
        -- SetBlipAsShortRange(blip, true)

        -- BeginTextCommandSetBlipName("STRING")
        -- AddTextComponentString("Informaticien")
        -- EndTextCommandSetBlipName(blip)

        for k,v in pairs(Config.Zones)do
            if v.Type == 1 then
                local blip2 = AddBlipForCoord(v.Pos)

                SetBlipSprite (blip2, 79)
                SetBlipDisplay(blip2, 4)
                SetBlipScale(blip, 0.8)
                SetBlipColour (blip2, 2)
                SetBlipAsShortRange(blip2, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Name)
                EndTextCommandSetBlipName(blip2)
                table.insert(JobBlips, blip2)
            end
        end
    end
end

-- function CreateJobBlips2()
--   if IsJobTrue() then
--     local blip2 = AddBlipForCoord(Config.Blip.Pos.x, Config.Blip.Pos.y, Config.Blip.Pos.z)

--     SetBlipSprite (blip2, Config.Blip.Sprite)
--     SetBlipDisplay(blip2, Config.Blip.Display)
--     SetBlipScale  (blip2, Config.Blip.Scale)
--     SetBlipColour (blip2, Config.Blip.Colour)
--     SetBlipAsShortRange(blip2, true)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(_U('hospital'))
--     EndTextCommandSetBlipName(blip2)
--     table.insert(JobBlips, blip2)
--     CreateJobBlips3()
--   end
-- end

-- function CreateJobBlips3()
--   if IsJobTrue() then
--     local blips3 = AddBlipForCoord(Config.ResellBlip.Pos.x, Config.ResellBlip.Pos.y, Config.ResellBlip.Pos.z)

--     SetBlipSprite (blips3, Config.ResellBlip.Sprite)
--     SetBlipDisplay(blips3, Config.ResellBlip.Display)
--     SetBlipScale  (blips3, Config.ResellBlip.Scale)
--     SetBlipColour (blips3, Config.ResellBlip.Colour)
--     SetBlipAsShortRange(blips3, true)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(Config.ResellBlip.Name)
--     EndTextCommandSetBlipName(blips3)
--     table.insert(JobBlips, blips3)
--   end
-- end

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isInMarker, letSleep, currentZone = false, true

            for k,v in pairs(Config.Zones)  do
                local distance = #(playerCoords - v.Pos)

                if distance < Config.DrawDistance then
                   letSleep = false

                   for k2,v2 in pairs(Config.ZonesDeleter) do
                      if v2.Type ~= -1 and IsPedInAnyVehicle(PlayerPedId(), false) then
                         DrawMarker(v2.Type, v2.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v2.Size.x, v2.Size.y, v2.Size.z, v2.Color.r, v2.Color.g, v2.Color.b, 100, false, true, 2, false, false, false, false)
                      end
                   end
                   if v.Type ~= -1 then
                      DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                   end

                   if distance < v.Size.x then
                      isInMarker, currentZone = true, k
                   end
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker, LastZone = true, currentZone
                TriggerEvent('esx_tabac:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_tabac:hasExitedMarker', LastZone)
            end

            if letSleep then
                Citizen.Wait(500)
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

            if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'tabac' then
                if CurrentAction == 'tabac_harvest' then
                    TriggerServerEvent('esx_tabac:startHarvest', CurrentActionData.zone)
                elseif CurrentAction == 'tabac_traitement' then
                    TriggerServerEvent('esx_tabac:startTransform', CurrentActionData.zone)
                elseif CurrentAction == 'cigarette_traitement' then
                    TriggerServerEvent('esx_tabac:startTransform', CurrentActionData.zone)
                elseif CurrentAction == 'farm_resell' then
                    TriggerServerEvent('esx_tabac:startSell', CurrentActionData.zone)
                elseif CurrentAction == 'tabac_actions_menu' then
                    OpenTabacActionsMenu()
                elseif CurrentAction == 'vehicle_spawner_menu' then
                    OpenVehicleSpawnerMenu()
                elseif CurrentAction == 'delete_vehicle' then
                    ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
                end

                CurrentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)