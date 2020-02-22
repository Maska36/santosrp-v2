ESX = nil
local hasAlreadyEnteredMarker, lastZone = false, nil
local currentAction, currentActionData = nil, {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenJobListingMenu(zone)
	local elements = {}

	table.insert(elements, {label = '🕒 Chronopost', job = 'chrono'	})
	--table.insert(elements, {label = '🔪 Abatteur', job = 'slaughterer'})
	--table.insert(elements, {label = '🎣 Pêcheur', job = 'fisherman'})
	table.insert(elements, {label = '⛽ Raffineur', job = 'fueler'})
	table.insert(elements, {label = '🌲 Bucheron', job = 'lumberjack'})
	table.insert(elements, {label = '✂️ Couturier', job = 'tailor'})
	table.insert(elements, {label = '👦🏽 Chomeur - Sans Emploi', job = 'chomeur'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'joblisting', {
    	css = 'poleemploi',
		title    = "Pôle Emploi",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_joblisting:setJob', data.current.job)
		ESX.ShowNotification(_U('new_job'))
		menu.close()
	end, function(data, menu)
		menu.close()

		currentAction = 'job_menu'
		currentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_joblisting:hasEnteredMarker', function(zone)
	currentAction     = 'job_menu'
	currentActionData = {zone = zone}
end)

AddEventHandler('esx_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	currentAction = nil
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		local blip = AddBlipForCoord(v.Pos)

		SetBlipSprite(blip, 407)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("Pôle Emploi")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true, nil

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < Config.DrawDistance then
				letSleep = false

				if Config.MarkerType ~= -1 then
					DrawMarker(Config.MarkerType, v.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
				end

				if distance < Config.ZoneSize.x then 
					isInMarker, currentZone = true, k
				end
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerEvent('esx_joblisting:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_joblisting:hasExitedMarker', lastZone)
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

		if currentAction then
			ESX.ShowHelpNotification(_U('access_job_center'))
			
			if IsControlJustReleased(0, 38) then
				if currentAction == 'job_menu' then
					OpenJobListingMenu()
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
