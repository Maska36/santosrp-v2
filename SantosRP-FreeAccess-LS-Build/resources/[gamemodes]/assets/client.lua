ESX = nil

local shakespeed, isVehicleMoving = 0, false

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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPedInAnyVehicle(PlayerPedId(), true) and GetFollowVehicleCamViewMode() ~= 4 then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            if speed >= 30 then
                shakespeed = speed * 0.030
                if isVehicleMoving == false then
                    ShakeGameplayCam("ROAD_VIBRATION_SHAKE", shakespeed)
                    isVehicleMoving = true
                end
            else
                StopGameplayCamShaking(false)
                isVehicleMoving = false
            end
        else
            if isVehicleMoving == true then
                StopGameplayCamShaking(false)
                isVehicleMoving = false
            end
        end
    end
end)

-- SAFE
local zones = {
    ['35'] = vector3(-797.599, -221.102, 37.079), -- Concessionnaire
    ['36'] = vector3(-348.272, -136.617, 39.009), -- LS Custom
    ['45'] = vector3(614.808, 108.748, 92.872), -- Parking Central
    ['46'] = vector3(630.569, 5.195, 82.772), -- Comico
    ['48'] = vector3(233.142, 368.425, 106.134), -- Auto Ecole
    ['49'] = vector3(247.961, -47.734, 69.941), -- Armurerie
    ['50'] = vector3(307.037, -590.165, 43.292), -- Hopital
    ['80'] = vector3(1643.759, 2530.987, 44.564), -- Prison federal
}

local notifIn = false
local notifOut = false
local veh = false
local closestZone = 1
local distance = 0
     
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if notifIn then
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(2, 37, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 140, true)

            if IsDisabledControlJustPressed(2, 37) then
                SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
            end

            if IsDisabledControlJustPressed(0, 106) then
                SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if ESX and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then
            local PHandle = PlayerPedId()
            local PPos = GetEntityCoords(PHandle)
            local minDistance = 100000

            for k,v in pairs(zones) do
                local dist = #(zones[k] - PPos)
                if dist < minDistance then
                    minDistance = dist
                    closestZone = k
                    distance = tonumber(k)
                end
            end

            local vehs = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
            if vehs and (GetPedInVehicleSeat(vehs, -1) == GetPlayerPed(PlayerId())) and veh == false then    
                SetEntityInvincible(vehs, false)
            elseif vehs and (GetPedInVehicleSeat(vehs, -1) == GetPlayerPed(PlayerId())) and veh == true then
                SetEntityInvincible(vehs, true)
            end

            Citizen.Wait(200)
            
            local dist = #(zones[closestZone] - PPos)
            if dist <= distance then
                if not notifIn then 
                    veh = true              
                    local vehs = GetVehiclePedIsUsing(PHandle, false)
                    if (GetPedInVehicleSeat(vehs, -1) == PHandle) then 
                        SetEntityInvincible(vehs, true)
                    end

                    SetEntityInvincible(PHandle, true)                                                 
                    NetworkSetFriendlyFireOption(false)
                    SetCurrentPedWeapon(PHandle, `WEAPON_UNARMED`, true)
                    ESX.ShowNotification("~g~Vous êtes maintenant en Zone Safe.")
                    notifIn = true
                    notifOut = false
                end
            else
                notifIn = false
                if not notifOut then
                    veh = false
                    local vehs = GetVehiclePedIsUsing(PHandle, false)
                    if (GetPedInVehicleSeat(vehs, -1) == PHandle) then 
                        SetEntityInvincible(vehs, false)
                    end

                    SetEntityInvincible(PHandle, false)
                    NetworkSetFriendlyFireOption(true)
                    ESX.ShowNotification("~r~Vous n'êtes plus en Zone Safe.")
                    notifOut = true
                    notifIn = false
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        SetWeaponDamageModifier(-1553120962, 0.0) 
        Wait(0)
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)

    if ESX then
        -- Remove all ped
        -- local ped = ESX.Game.GetPeds()
        -- if #ped > 3 then
        --     for i=1, #ped, 1 do
        --         if not (IsPedAPlayer(ped[i])) then
        --             -- SetPedPathMayEnterWater(ped, false)
        --             -- SetPedPathPreferToAvoidWater(ped, true)
        --             if not IsPedInAnyVehicle(ped[i], true) or IsEntityInWater(ped[i]) then
        --                 if GetEntityModel(ped[i]) ~= `mp_m_shopkeep_01` then
        --                     DeleteEntity(ped[i])
        --                     RemoveAllPedWeapons(ped[i], true)
        --                 end
        --             end
        --         end
        --     end
        -- end

        Citizen.Wait(2500)
        -- Remove explosed vehicule
        local theveh = ESX.Game.GetVehicles()
        for i=1, #theveh, 1 do
            if GetEntityHealth(theveh[i]) < 1 then
                SetEntityAsMissionEntity(theveh[i], false, false)
                DeleteEntity(theveh[i])
            end
        end
    else
        Citizen.Wait(100)
    end
  end
end)