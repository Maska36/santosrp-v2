
local kodaQTE       			= 0
ESX 			    			= nil
local koda_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_farmoranges:hasEnteredMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	
	if zone == 'CatchOrange' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('carry_for_leaves')
		CurrentActionData = {}
	elseif zone == 'OrangeJuice' then
		if kodaQTE >= 5 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('take_orange_juice')
			CurrentActionData = {}
		end
	elseif zone == 'SellOrangeJuice' then
		if koda_poochQTE >= 1 then
			CurrentAction     = zone
			CurrentActionMsg  = _U('sell_orange_juice')
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('esx_farmoranges:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

	if zone == 'CatchOrange' then
		TriggerServerEvent('esx_farmoranges:stopHarvestKoda')
	elseif zone == 'OrangeJuice' then
	TriggerServerEvent('esx_farmoranges:stopTransformKoda')
	elseif zone == 'SellOrangeJuice' then
		TriggerServerEvent('esx_farmoranges:stopSellKoda')
	end
end)

if Config.ShowBlips then
	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			local blip = AddBlipForCoord(v.Pos)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end

RegisterNetEvent('esx_farmoranges:ReturnInventory')
AddEventHandler('esx_farmoranges:ReturnInventory', function(kodaNbr, kodapNbr, jobName, currentZone)
	kodaQTE			= kodaNbr
	koda_poochQTE	= kodapNbr
	myJob			= jobName
	TriggerEvent('esx_farmoranges:hasEnteredMarker', currentZone)
end)

-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords  = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < Config.DrawDistance then
				letSleep = false

				if Config.MarkerType ~= -1 then
					DrawMarker(Config.MarkerType, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				end

				if distance < Config.ZoneSize.x then
					isInMarker, currentZone = true, k
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerServerEvent('esx_farmoranges:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_farmoranges:hasExitedMarker', lastZone)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				if CurrentAction == 'CatchOrange' then
					TriggerServerEvent('esx_farmoranges:startHarvestKoda')
				elseif CurrentAction == 'OrangeJuice' then
					TriggerServerEvent('esx_farmoranges:startTransformKoda')
				elseif CurrentAction == 'SellOrangeJuice' then
					TriggerServerEvent('esx_farmoranges:startSellKoda')
				end
				
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
