ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastZone
local CurrentAction
local CurrentActionMsg = ''
local CurrentActionData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_illegal_drugs:hasEnteredMarker', function(zone)
	-- FARM
	if zone == 'WeedFarm' then
		CurrentAction     = 'weed_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	elseif zone == 'MethFarm' then
		CurrentAction     = 'meth_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	elseif zone == 'CocaineFarm' then
		CurrentAction     = 'cocaine_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	elseif zone == 'OpiumFarm' then
		CurrentAction     = 'opium_farm'
		CurrentActionMsg  = _U('press_collect')
		CurrentActionData = {zone = zone}
	-- END FARM
	-- TRAITEMENT
	elseif zone == 'WeedTraitement' then
		CurrentAction     = 'weed_traitement'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	elseif zone == 'MethTraitement' then
		CurrentAction     = 'meth_traitement'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	elseif zone == 'CocaineTraitement' then
		CurrentAction     = 'cocaine_traitement'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	elseif zone == 'OpiumTraitement' then
		CurrentAction     = 'opium_traitement'
		CurrentActionMsg  = _U('press_traitement')
		CurrentActionData = {zone = zone}
	-- END TRAITEMENT
	-- SELL
	elseif zone == 'WeedSell' then
		CurrentAction     = 'weed_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	elseif zone == 'MethSell' then
		CurrentAction     = 'meth_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	elseif zone == 'CocaineSell' then
		CurrentAction     = 'cocaine_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	elseif zone == 'OpiumSell' then
		CurrentAction     = 'opium_sell'
		CurrentActionMsg  = _U('press_sell')
		CurrentActionData = {zone = zone}
	-- END SELL
	end
end)

AddEventHandler('esx_illegal_drugs:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	if zone == "WeedFarm" or zone == "MethFarm" or zone == "CocaineFarm" or zone == "OpiumFarm" then
		TriggerServerEvent('esx_illegal_drugs:stopFarm')
	elseif zone == "WeedTraitement" or zone == "MethTraitement" or zone == "CocaineTraitement" or zone == "OpiumTraitement" then
		TriggerServerEvent('esx_illegal_drugs:stopTraitement')
	elseif zone == "WeedSell" or zone == "MethSell" or zone == "CocaineSell" or zone == "OpiumSell" then
		TriggerServerEvent('esx_illegal_drugs:stopSell')
	end

	CurrentAction = nil
end)

-- Enter/Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep, currentZone = false, true

		for k,v in pairs(Config.Zones)  do
	        local distance = #(playerCoords - v.Pos)

	        if distance < Config.DrawDistance then
	            letSleep = false

	            if v.Type ~= -1 then
	                DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
	            end

	            if distance < v.Size.x then
	                isInMarker, currentZone = true, k
	            end
	        end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			TriggerEvent('esx_illegal_drugs:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_illegal_drugs:hasExitedMarker', LastZone)
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
				if CurrentAction == "weed_farm" or CurrentAction == "meth_farm" or CurrentAction == "cocaine_farm" or CurrentAction == "opium_farm" then
					TriggerServerEvent('esx_illegal_drugs:startFarm', CurrentActionData.zone)
				elseif CurrentAction == "weed_traitement" or CurrentAction == "meth_traitement" or CurrentAction == "cocaine_traitement" or CurrentAction == "opium_traitement" then
					TriggerServerEvent('esx_illegal_drugs:startTraitement', CurrentActionData.zone)
				elseif CurrentAction == "weed_sell" or CurrentAction == "meth_sell" or CurrentAction == "cocaine_sell" or CurrentAction == "opium_sell" then
					TriggerServerEvent('esx_illegal_drugs:startSell', CurrentActionData.zone)
				end

				CurrentAction = nil
			end
      	else
        	Citizen.Wait(500)
		end
	end
end)