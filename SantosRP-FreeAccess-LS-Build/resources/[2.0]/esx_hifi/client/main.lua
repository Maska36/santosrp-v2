ESX = nil

local menuOpen, wasOpen = false, false
local lastEntity, currentAction, currentData

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSO', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx_hifi:place_hifi')
AddEventHandler('esx_hifi:place_hifi', function()
    startAnimation("anim@heists@money_grab@briefcase","put_down_case")
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
    TriggerEvent('esx:spawnObject', 'prop_boombox_01')
end)

RegisterNetEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionData = id
        })

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(100)
                if distance(object) > Config.distance then
                    SendNUIMessage({
                        transactionType = 'stopSound'
                    })
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'stopSound'
        })
    end
end)

RegisterNetEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'volume',
            transactionData = volume
        })
    end
end)

function distance(object)
    local playerPed = PlayerPedId()
    local lCoords = GetEntityCoords(playerPed)
    local distance  = GetDistanceBetweenCoords(lCoords, object, true)
    return distance
end

function OpenhifiMenu()
    menuOpen = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hifi', {
        css = 'santos',
        title   = 'BoomBox',
        align   = 'top-left',
        elements = {
            {label = _U('get_hifi'), value = 'get_hifi'},
            {label = _U('play_music'), value = 'play'},
            {label = _U('volume_music'), value = 'volume'},
            {label = _U('stop_music'), value = 'stop'}
        }
    }, function(data, menu)
        local playerPed = PlayerPedId()
        local lCoords = GetEntityCoords(playerPed)
        if data.current.value == 'get_hifi' then
            ESX.PlayerData = ESX.GetPlayerData()
            local alreadyOne = false
            for i=1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].name == 'hifi' and ESX.PlayerData.inventory[i].count > 0 then
                    alreadyOne = true
                end
            end
            if not alreadyOne then
                NetworkRequestControlOfEntity(currentData)
                menu.close()
                menuOpen = false
                startAnimation("anim@heists@narcotics@trash","pickup")
                Citizen.Wait(700)
                SetEntityAsMissionEntity(currentData,false,true)
                DeleteEntity(currentData)
                ESX.Game.DeleteObject(currentData)
                if not DoesEntityExist(currentData) then
                    TriggerServerEvent('esx_hifi:remove_hifi', lCoords)
                    currentData = nil
                end
                Citizen.Wait(500)
                ClearPedTasks(PlayerPedId())
            else
                menu.close()
                menuOpen = false
                TriggerEvent('esx:showNotification', _U('hifi_alreadyOne'))
            end
        elseif data.current.value == 'play' then
            play(lCoords)
        elseif data.current.value == 'stop' then
            TriggerServerEvent('esx_hifi:stop_music', lCoords)
            menuOpen = false
            menu.close()
        elseif data.current.value == 'volume' then
            setVolume(lCoords)
        end
    end, function(data, menu)
        menuOpen = false
        menu.close()
    end)
end

function setVolume(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume',
        {
            css = 'santos',
            title = _U('set_volume'),
        }, function(data, menu)
            local value = tonumber(data.value)
            if value < 0 or value > 100 then
                ESX.ShowNotification(_U('sound_limit'))
            else
                TriggerServerEvent('esx_hifi:setVolume', value, coords)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end


function play(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
    {
        css = 'santos',
        title = _U('play_id')
    }, function(data, menu)
        TriggerServerEvent('esx_hifi:play_music', data.value, coords)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerCoords = GetEntityCoords(PlayerPedId())

        local object = GetClosestObjectOfType(playerCoords, 3.0, `prop_boombox_01`, false, false, false)

        if DoesEntityExist(object) then
            local closestDistance = -1
            local closestEntity = nil
            local objCoords = GetEntityCoords(object)
            local distance  = #(playerCoords - objCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestDistance = distance
                closestEntity   = object
            end

            if closestDistance ~= -1 and closestDistance <= 1.2 then
                if not menuOpen then
                    if lastEntity ~= closestEntity and not menuOpen then
                        lastEntity = closestEntity
                        currentAction = "music"
                        currentData = closestEntity
                    end
                end
            elseif lastEntity then
                lastEntity = nil
                currentAction = nil
                currentData = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if currentAction then
            ESX.ShowHelpNotification(_U('hifi_help'))
            
            if IsControlJustReleased(0, 38) then
                if currentAction == 'music' then
                    OpenhifiMenu()
                end

                currentAction = nil
            end
        else
            Citizen.Wait(500)
        end
    end
end)

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end