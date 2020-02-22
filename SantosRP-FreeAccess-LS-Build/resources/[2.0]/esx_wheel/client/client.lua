ESX = nil
local _wheel = nil
local _wheel2 = nil
local _wheel3 = nil
local _lambo = nil
local _isShowCar = false
local _wheelPos = vector3(619.121, 134.318, 92.899)
local _isRolling = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end

    if ESX.IsPlayerLoaded() then
        local model = GetHashKey('vw_prop_vw_luckywheel_02a')
        local model2 = GetHashKey('vw_prop_vw_luckywheel_01a')
        local model3 = GetHashKey('vw_prop_vw_luckylight_on')

        Citizen.CreateThread(function()
            RequestModel(model)
            RequestModel(model2)

            while not HasModelLoaded(model) and not HasModelLoaded(model2) do
                Citizen.Wait(0)
            end

            _wheel = CreateObject(model, 619.121, 134.318, 92.15, false, false, true)
            _wheel2 = CreateObject(model2, 619.121, 134.318, 91.89, false, false, true)
            _wheel3 = CreateObject(model3, 619.121, 134.318, 92.50, false, false, true)
            SetEntityHeading(_wheel, -20.0)
            SetEntityHeading(_wheel2, -20.0)
            SetEntityHeading(_wheel3, -20.0)
            SetModelAsNoLongerNeeded(model)
            SetModelAsNoLongerNeeded(model2)
            SetModelAsNoLongerNeeded(model3)
        end)
    end
end)

-- Create blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(619.121, 134.318, 92.899)

    SetBlipSprite(blip, 617)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 77)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Roue de la Fortune")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("esx_wheel:doRoll")
AddEventHandler("esx_wheel:doRoll", function(_priceIndex) 
    _isRolling = true
    --SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
    SetEntityHeading(_wheel, -20.0)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0
                    
                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            SetEntityHeading(_wheel, -20.0)
            SetEntityRotation(_wheel, 0.0, _y, -20.0, 2, true)
            Citizen.Wait(5)
        end
    end)
end)

RegisterNetEvent("esx_wheel:rollFinished")
AddEventHandler("esx_wheel:rollFinished", function() 
    _isRolling = false
end)

RegisterNetEvent("esx_wheel:winWeap")
AddEventHandler("esx_wheel:winWeap", function()
	local playerPed = PlayerPedId()

    GiveWeaponToPed(playerPed, `WEAPON_COMBATPISTOL`, 150, false, false)
end)

function doRoll()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
        local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
        if IsPedMale(playerPed) then
            _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
        end
        local lib, anim = _lib, 'enter_right_to_baseidle'
        ESX.Streaming.RequestAnimDict(lib, function()
            local _movePos = vector3(618.07708740234,133.53120422363,92.914222717285)
            TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1, -19.0,  0.0)
            local _isMoved = false
            while not _isMoved do
                local coords = GetEntityCoords(PlayerPedId())
                if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                    _isMoved = true
                end
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerServerEvent("esx_wheel:getLucky")
            TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
    end
end

-- Menu Controls
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        local playerCoords  = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - _wheelPos)

        if dist < 1.5 and not _isRolling then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour tenter votre chance à la ~b~Roue de la Fortune~w~ pour ~g~$25000~w~")
            if IsControlJustReleased(0, 38) then
                doRoll()
            end
        else
            Citizen.Wait(500)
        end		
	end
end)