ESX = nil
pBreaking = false
local Time = 10 * 1000 -- Time for each stage (ms)

local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
local anim = "machinic_loop_mechandplayer"
local flags = 49

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function disableEngine(vehicle)
	Citizen.CreateThread(function()
		while hotwiring do
			SetVehicleEngineOn(vehicle, false, true, false)
			if not hotwiring then
				break
			end
			Citizen.Wait(0)
		end
	end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

RegisterNetEvent('lockpick:onUse')
AddEventHandler('lockpick:onUse', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    	local vehicle = nil
    	pBreaking = true

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    	end
    
	    if GetVehicleDoorLockStatus(vehicle) == 1 then
			ESX.ShowNotification("~g~La porte n'est pas fermé.")
			pBreaking = false
			return
	    end

		if DoesEntityExist(vehicle) then
			TriggerServerEvent('lockpick:removeKit')
			local sPlates = GetVehicleNumberPlateText(vehicle)

			Citizen.Wait(1000)

			RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
	    	while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
				Citizen.Wait(0)
			end
	    
	    	TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )
	    	
	    	Citizen.CreateThread(function()
				exports['pBars']:startUI(30000, "Crochetage...")

				Citizen.Wait(30000)
				alarmChance = math.random(100)
				if alarmChance <= cfg.alarmPercent then
					TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('Vol de voiture en cours.. Plaque: ' .. sPlates), coords, {
						PlayerCoords = { x = coords.x, y = coords.y, z = coords.z },
					})
		        	Citizen.Wait(2000)
		        	SetVehicleAlarm(vehicle, true)
				    SetVehicleAlarmTimeLeft(vehicle, 30 * 1000)
				    SetVehicleDoorsLocked(vehicle, 1)
				    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
		        	ClearPedTasksImmediately(playerPed)
		        	TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
	      		else
	        		SetVehicleDoorsLocked(vehicle, 1)
			    	SetVehicleDoorsLockedForAllPlayers(vehicle, false)
	        		ClearPedTasksImmediately(playerPed)
	        		TaskEnterVehicle(playerPed, vehicle, 10.0, -1, 1.0, 1, 0)
	      		end
	    	end)	
		end		
  	end
end)	


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if pBreaking then
			local veh = GetVehiclePedIsIn(playerPed, false)
			local vehPos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, "bonnet"))
			if IsPedInAnyVehicle(playerPed, false) then
				ESX.Game.Utils.DrawText3D({ x = vehPos.x, y = vehPos.y, z = vehPos.z }, "Appuyez sur [H] pour crocheter", 2, 1)
				if IsControlJustPressed(0, 304) then
					SetVehicleNeedsToBeHotwired(veh, true)
					hotWire(veh)
        		end
      		end
    	end
  	end
end)

function hotWire(vehicle)
	if IsVehicleNeedsToBeHotwired(vehicle) then
		disableEngine(vehicle)
		hotwiring = true
		pBreaking = false
		loadAnimDict(animDict)
		ClearPedTasks(player_entity)
		TaskPlayAnim(player_entity, animDict, anim, 3.0, 1.0, 2000, flags, -1, 0, 0, 0)
		if hotwiring then
			exports['pBars']:startUI(Time, "Vous essayez de court-circuiter le véhicule...")
			Citizen.Wait(Time+500)
		end
		hotwiring = false
		StopAnimTask(player_entity, animDict, anim, 1.0)
		Citizen.Wait(1000)
		TriggerEvent('EngineToggle:Engine')
		SetVehicleJetEngineOn(vehicle, true)
		RemoveAnimDict(animDict)
		if not Radio then
			SetVehicleRadioEnabled(vehicle, false)
		end
  	end
end

local vehicles = {}

RegisterNetEvent('EngineToggle:Engine')
AddEventHandler('EngineToggle:Engine', function()
	local veh, StateIndex
	for i, vehicle in ipairs(vehicles) do
		if vehicle[1] == GetVehiclePedIsIn(PlayerPedId(), false) then
			veh = vehicle[1]
			StateIndex = i
		end
	end
	Citizen.Wait(1500)
	if IsPedInAnyVehicle(PlayerPedId(), false) then 
		if (GetPedInVehicleSeat(veh, -1) == PlayerPedId()) then
			vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
      		if vehicles[StateIndex][2] then
        		ESX.ShowNotification('La voiture à démarré !')
			end
		end 
  	end 
end)
		
function isPlayerJobPolice()
	for k,v in pairs(ESX.GetPlayerData()) do
		for k,v in pairs(k) do
			print(v)
		end
	end
end