isInInventory = false
ESX = nil
strengthValue = nil
staminaValue = nil
shootingValue = nil
drivingValue = nil
drugsValue = nil
Faketimer = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
            openInventory()
        end
    end
end)


function round(num, numDecimalPlaces)
    local mult = 10^(2)
    return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('stadus_skills:sendPlayerSkills')
AddEventHandler('stadus_skills:sendPlayerSkills', function(stamina, strength, driving, shooting, drugs)
    strengthValue = strength
    staminaValue = stamina
    shootingValue = shooting
    drivingValue = driving
    drugsValue = drugs

    if staminaValue > "1" then
        StatSetInt("MP0_STAMINA", round(stamina), true)
        StatSetInt('MP0_LUNG_CAPACITY', round(stamina), true)
    end
    StatSetInt("MP0_STRENGTH", round(strength), true)
    StatSetInt('MP0_WHEELIE_ABILITY', round(driving), true)
    StatSetInt('MP0_DRIVING_ABILITY', round(driving), true)
end)

function openInventory()
    loadPlayerInventory()
    isInInventory = true

    ESX.TriggerServerCallback('stadus_skills:getSkills', function(stamina, strength, driving, shooting, drugs)
        strengthValue = strength
        staminaValue = stamina
        shootingValue = shooting
        drivingValue = driving
        drugsValue = drugs

        SendNUIMessage({
            action = "display",
            type = "normal",
            stamina = staminaValue,
            strength = strengthValue,
            driving = drivingValue,
            shooting = shootingValue,
            drugs = drugsValue
        })
    end)
    
    SetNuiFocus(true, true)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({ action = "hide" })
    SetNuiFocus(false, false)
end

RegisterNUICallback("NUIFocusOff",function()
    closeInventory()
end)

RegisterNUICallback("GetNearPlayers", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true

            table.insert(elements,{label = GetPlayerName(players[i]), player = GetPlayerServerId(players[i])})
        end
    end

    if not foundPlayers then
        ESX.ShowNotification(_U("player_nearby"))
    else
        SendNUIMessage({ action = "nearPlayers",  foundAny = foundPlayers, players = elements, item = data.item })
    end

    cb("ok")
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("esx:useItem", data.item.name)

    if shouldCloseInventory(data.item.name) then
         closeInventory()
    else
        Citizen.Wait(250)
        loadPlayerInventory()
    end

    cb("ok")
end)

RegisterNUICallback("DropItem", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
        ESX.Streaming.RequestAnimDict(dict)
        TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
        Citizen.Wait(1000)
        TriggerServerEvent("esx:removeAnInventoryItem", data.item.type, data.item.name, data.number)
    end

    Wait(250)
    loadPlayerInventory()

    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            if GetPlayerServerId(players[i]) == data.player then
                foundPlayer = true
            end
        end
    end

    if foundPlayer then
        local count = tonumber(data.number)

        if data.item.type == "item_weapon" then
            count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
        end

        TriggerServerEvent("esx:GiveAnInventoryItem", data.player, data.item.type, data.item.name, count)
        Wait(250)
        loadPlayerInventory()
    else
        ESX.ShowNotification(_U("player_nearby"))
    end
    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

function loadPlayerInventory()
    ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
        items = {}
        inventory = data.inventory
        accounts = data.accounts
        money = data.money
        weapons = data.weapons

        if Config.IncludeCash and money and money > 0 then
            moneyData = {
                label = _U("cash"),
                name = "cash",
                type = "item_money",
                count = money,
                usable = false,
                rare = false,
                limit = -1,
                canRemove = true
            }

            table.insert(items, moneyData)
        end

        if Config.IncludeAccounts and accounts then
            for key, value in pairs(accounts) do
                if not shouldSkipAccount(accounts[key].name) then
                    local canDrop = accounts[key].name ~= "bank"

                    if accounts[key].money > 0 then
                        accountData = {
                            label = accounts[key].label,
                            count = accounts[key].money,
                            type = "item_account",
                            name = accounts[key].name,
                            usable = false,
                            rare = false,
                            limit = -1,
                            canRemove = canDrop
                        }
                        table.insert(items, accountData)
                    end
                end
            end
        end

        if inventory then
            for key, value in pairs(inventory) do
                if inventory[key].count <= 0 then
                    inventory[key] = nil
                else
                    inventory[key].type = "item_standard"
                    table.insert(items, inventory[key])
                end
            end
        end

        if Config.IncludeWeapons and weapons then
            for key, value in pairs(weapons) do
                local weaponHash = GetHashKey(weapons[key].name)
                local playerPed = PlayerPedId()
                if weapons[key].name ~= "WEAPON_UNARMED" then
                    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    table.insert(items,
                    {
                        label = weapons[key].label,
                        count = ammo,
                        limit = -1,
                        type = "item_weapon",
                        name = weapons[key].name,
                        usable = false,
                        rare = false,
                        canRemove = true
                    })
                end
            end
        end

        SendNUIMessage({ action = "setItems", itemList = items })
    end, GetPlayerServerId(PlayerId()))
end

Citizen.CreateThread(function()
    while true do
        if isInInventory then
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 166, true) -- Job
            DisableControlAction(0, 167, true) -- Job

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        else
            Citizen.Wait(500)
        end
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            local speed = GetEntitySpeed(vehicle) * 3.6
            if speed > 50 then
              if Faketimer >= 250 then
                TriggerServerEvent('stadus_skills:addDriving', GetPlayerServerId(PlayerId()), (math.random() + 0))
                Faketimer = 0
              end
          end
        end
        if Faketimer >= 500 then
          Faketimer = 0
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function() -- Thread for  timer
    while true do 
        Citizen.Wait(1000)
        Faketimer = Faketimer + 1 
    end 
end)
