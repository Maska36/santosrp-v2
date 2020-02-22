ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

-- ====================================================================================================================
-- Citizen thread
-- ====================================================================================================================
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSO', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

-- Create blips
Citizen.CreateThread(function()
  for i = 1, #Config.Shops, 1 do
    local shop = Config.Shops[i]

    local blip = AddBlipForCoord(shop.x, shop.y, shop.z - Config.ZDiff)
    SetBlipSprite (blip, Config.BlipSprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour (blip, Config.BlipColour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Pharmacie')
    EndTextCommandSetBlipName(blip)
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local isInMarker, hasExited, letSleep = false, false, true
    local currentStation, currentPart, currentPartNum

    for k,v in pairs(Config.Shops) do
      local distance = GetDistanceBetweenCoords(coords, v, true)
      
      if distance < Config.DrawDistance then
          DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
          letSleep = false
      end

      if distance < Config.MarkerSize.x then
        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Shops', i
      end
    end

    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
      if
        (LastStation and LastPart and LastPartNum) and
        (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
      then
        TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
        hasExited = true
      end

      HasAlreadyEnteredMarker = true
      LastStation             = currentStation
      LastPart                = currentPart
      LastPartNum             = currentPartNum

      TriggerEvent('esx_pharmacy:hasEnteredMarker', currentStation, currentPart, currentPartNum)
    end

    if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_pharmacy:hasExitedMarker', LastStation, LastPart, LastPartNum)
    end

    if letSleep then
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

      if IsControlPressed(0, 38) then
        if CurrentAction == 'pharmacy_shop' then
          OpenShopMenu()
        end
        CurrentAction = nil
      end
    end
  end
end)


-- ====================================================================================================================
-- Event handler
-- ====================================================================================================================
AddEventHandler('esx_pharmacy:hasEnteredMarker', function(station, part, partNum)
  CurrentAction     = 'pharmacy_shop'
  CurrentActionMsg  = _U('press_menu')
  CurrentActionData = {}
end)

AddEventHandler('esx_pharmacy:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

RegisterNetEvent('esx_pharmacy:useKit')
AddEventHandler('esx_pharmacy:useKit', function(itemName, hp_regen)
  local ped    = PlayerPedId()
  local health = GetEntityHealth(ped)
  local max    = GetEntityMaxHealth(ped)

  if health > 0 and health < max then

    TriggerServerEvent('esx_pharmacy:removeItem', itemName)
    ESX.UI.Menu.CloseAll()
    ESX.ShowNotification(_U('use_firstaidkit'))

    health = health + (max / hp_regen)
    if health > max then
      health = max
    end
    SetEntityHealth(ped, health)
  end
end)

RegisterNetEvent('esx_pharmacy:useDefibrillateur')
AddEventHandler('esx_pharmacy:useDefibrillateur', function(itemName)
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

  if closestPlayer == -1 or closestDistance > 3.0 then
    ESX.ShowNotification(_U('no_players'))
  else
    local ped    = GetPlayerPed(closestPlayer)
    local health = GetEntityHealth(ped)

    if health == 0 then
      local playerPed = PlayerPedId()
      Citizen.CreateThread(function()
        ESX.ShowNotification(_U('revive_inprogress'))
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Citizen.Wait(15000)
        ClearPedTasks(playerPed)
        if GetEntityHealth(closestPlayerPed) == 0 then
          TriggerServerEvent('ambujob:revive', GetPlayerServerId(closestPlayer))
          ESX.ShowNotification(_U('revive_complete') .. GetPlayerName(closestPlayer))
          TriggerServerEvent('esx_pharmacy:removeItem', itemName)
        else
          ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('isdead'))
        end
      end)
    else
		  ESX.ShowNotification(GetPlayerName(closestPlayer) .. _U('unconscious'))
    end
  end
end)