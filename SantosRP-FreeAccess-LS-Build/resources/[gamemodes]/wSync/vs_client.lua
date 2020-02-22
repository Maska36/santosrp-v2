CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        --SetArtificialLightsState(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
        SetDeepOceanScaler(0.0)
    end
end)

-- Citizen.CreateThread(function()
-- 	RequestScriptAudioBank("ICE_FOOTSTEPS", false)
-- 	RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
-- 	RequestNamedPtfxAsset("core_snow")
-- 	while not HasNamedPtfxAssetLoaded("core_snow") do
-- 		Citizen.Wait(100)
-- 	end
--     local showHelp = true
--     local loaded = false
--     while true do
--         Citizen.Wait(0) -- prevent crashing
--         if IsNextWeatherType('XMAS') then -- check for xmas weather type
--             N_0xc54a08c85ae4d410(3.0)
--             SetForceVehicleTrails(true)
--             SetForcePedFootstepsTracks(true)
--             if not loaded then
--                 UseParticleFxAssetNextCall("core_snow")
--                 loaded = true
--             end
--         else
--             -- disable frozen water effect
--             if loaded then N_0xc54a08c85ae4d410(0.0) end
--             loaded = false
--             RemoveNamedPtfxAsset("core_snow")
--             ReleaseNamedScriptAudioBank("ICE_FOOTSTEPS")
--             ReleaseNamedScriptAudioBank("SNOW_FOOTSTEPS")
--             SetForceVehicleTrails(false)
--             SetForcePedFootstepsTracks(false)
--         end
--     end
-- end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)