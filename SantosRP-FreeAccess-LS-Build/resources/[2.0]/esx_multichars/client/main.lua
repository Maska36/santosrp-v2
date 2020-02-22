ESX = nil
charLoading = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSO', function (obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if NetworkIsSessionStarted() and not ESX.IsPlayerLoaded() then
            Citizen.Wait(100)
            TriggerServerEvent("esx_multichars:SetupCharacters")
            TriggerEvent("esx_multichars:SetupCharacters")
            TriggerEvent('ToggleHUDUI')
            return
        end
    end
end)

local cam = nil
local cam2 = nil
RegisterNetEvent('esx_multichars:SetupCharacters')
AddEventHandler('esx_multichars:SetupCharacters', function()
    DoScreenFadeOut(10)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SetTimecycleModifier('hud_def_blur')
    FreezeEntityPosition(PlayerPedId(), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 232.160, -480.570, 338.829, 300.00, 0.00, 0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('esx_multichars:SetupUI')
AddEventHandler('esx_multichars:SetupUI', function(Characters)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    SetNuiFocus(true, true)
    DisplayHud(false)
    DisplayRadar(false)
    SendNUIMessage({
        action = "openui",
        characters = Characters,
    })
end)

RegisterNetEvent('esx_multichars:SpawnCharacter')
AddEventHandler('esx_multichars:SpawnCharacter', function(spawn, isnew)
    TriggerServerEvent('es:firstJoinProper')
    TriggerEvent('es:allowedToSpawn')

    SetTimecycleModifier('default')
    local pos = spawn
    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    DisplayHud(false)
    DisplayRadar(false)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 232.160, -480.570, 338.829, 300.00, 0.00, 0.00, 100.00, false, 0)
    PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    Citizen.Wait(900)
    exports.spawnmanager:setAutoSpawn(false)
    TriggerEvent('esx_ambulancejob:multicharacter', source)

    if isnew then
        TriggerEvent('esx_identity:showRegisterIdentity')
    end
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z+200, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
    Citizen.Wait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    --FreezeEntityPosition(PlayerPedId(), false)
    DisplayHud(true)
    ESX.TriggerServerCallback('santos_menuperso:itemCheck', function(hasItem)
        if hasItem then
            DisplayRadar(true)
        end
    end)

    ESX.ShowNotification("~y~Préparation de votre personnage.. Patientez.")
    charLoading = true
    -- Freeze
    if IsEntityVisible(PlayerPedId()) then
        SetEntityVisible(PlayerPedId(), false)
    end

    if not IsPedInAnyVehicle(PlayerPedId()) then
        SetEntityCollision(PlayerPedId(), false)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    SetPlayerInvincible(PlayerId(), true)
    
    Citizen.Wait(5000)

    -- Un-Freeze
    if not IsEntityVisible(PlayerPedId()) then
        SetEntityVisible(PlayerPedId(), true)
    end

    if not IsPedInAnyVehicle(PlayerPedId()) then
        SetEntityCollision(PlayerPedId(), true)
    end
    FreezeEntityPosition(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    ESX.ShowNotification("~g~Personnage prêt ! Bon jeu.")
    charLoading = false

    Citizen.Wait(500)

    SetCamActive(cam, false)
    DestroyCam(cam, true)
    TriggerEvent('ToggleHUDUI')
    TriggerServerEvent('infinity:spawnReady', true)
end)

-- Disable all inputs when char is loading
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if charLoading then
            DisableAllControlActions(0)
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('esx_multichars:ReloadCharacters')
AddEventHandler('esx_multichars:ReloadCharacters', function()
    TriggerServerEvent("esx_multichars:SetupCharacters")
    TriggerEvent("esx_multichars:SetupCharacters")
end)

RegisterNUICallback("CharacterChosen", function(data, cb)
    SetNuiFocus(false,false)
    DoScreenFadeOut(500)
    TriggerServerEvent('esx_multichars:CharacterChosen', data.charid, data.ischar)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    cb("ok")
end)

RegisterNUICallback("DeleteCharacter", function(data, cb)
    SetNuiFocus(false,false)
    DoScreenFadeOut(500)
    TriggerServerEvent('esx_multichars:DeleteCharacter', data.charid)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    cb("ok")
end)