local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    TaskMoveNetworkByName(ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = PlayerPedId()
    RequestTaskMoveNetworkStateTransition(ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        if not keyPressed then
            if (IsControlPressed(1, 29) or IsControlPressed(2, 29)) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Citizen.Wait(200)
                if not (IsControlPressed(1, 29) or IsControlPressed(2, 29)) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while (IsControlPressed(1, 29) or IsControlPressed(2, 29)) do
                        Citizen.Wait(50)
                    end
                end
            elseif ((IsControlPressed(1, 29) or IsControlPressed(2, 29)) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        else
            Citizen.Wait(500)
        end

        if keyPressed then
            if not (IsControlPressed(1, 29) or IsControlPressed(2, 29)) then
                keyPressed = false
            end
        end

        if IsTaskMoveNetworkActive(PlayerPedId()) and not mp_pointing then
            stopPointing()
        end

        if IsTaskMoveNetworkActive(PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = PlayerPedId()
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)
                nn,blocked,coords,coords = GetRaycastResult(ray)

                SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
                SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
                SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
                SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)
