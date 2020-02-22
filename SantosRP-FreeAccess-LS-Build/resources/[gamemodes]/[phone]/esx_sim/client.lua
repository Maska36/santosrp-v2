ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local menuIsShowed = false
local hasAlreadyEnteredMarker = false
local isInMarker = false

function ShowSimMenu()
	local elements = {}

	table.insert(elements, {label = 'Acheter un iPhone X <span style="color:green;">$1000', value = 'menuperso_buyphone'})
	table.insert(elements, {label = 'Acheter une carte SIM <span style="color:green;">$20', value = 'menuperso_buysim'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_buysim',
	{
		css = 'santos',
		title    = 'Santos-Mobile',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_buyphone' then
			TriggerServerEvent('BuyPhone')
		elseif data.current.value == 'menuperso_buysim' then
			TriggerServerEvent('BuySIM')
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('esx_sim:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

-- Activate menu when player is inside marker, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local coords = GetEntityCoords(PlayerPedId())
		isInMarker = false

		for i=1, #Config.Zones, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Zones[i], true)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, Config.Zones[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end

			if distance < (Config.ZoneSize.x / 2) then
				isInMarker = true
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour acheter une ~b~SIM~s~.")
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_sim:hasExitedMarker')
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for i=1, #Config.Blip, 1 do
		local blip = AddBlipForCoord(Config.Blip[i])

		SetBlipSprite (blip, 120)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 47)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("Santos-Mobile")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 38) and isInMarker and not menuIsShowed then
			ESX.UI.Menu.CloseAll()
			ShowSimMenu()
		end
	end
end)
