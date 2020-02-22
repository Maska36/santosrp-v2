ESX = nil
local hasAlreadyEnteredMarker, lastZone = false, nil
local currentAction, currentActionData = nil, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowAnnounceMenu()
	local elements = {}

	table.insert(elements, {label = 'Publier une Annonce <span style="color:green;">$250', value = 'menuperso_publishann'})
	table.insert(elements, {label = 'Publier une Annonce Anonyme <span style="color:green;">$500', value = 'menuperso_publishannano'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_publish_announces',
	{
		css = 'santos',
		title    = 'LifeInvader - Annonce',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == "menuperso_publishann" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_notif', {
				title = "Entrez le contenu de l'annonce",
				value = ''
				},
				function (data1, menu1)
					menu1.close()

					local contenu = data1.value

					if contenu and contenu ~= "" then
						ContenuReason = contenu
					else
						ContenuReason = "salut"
					end

					if ContenuReason == "" then
						ContenuReason = "salut"
					end

					TriggerServerEvent('esx_ann:annonce', ContenuReason, false)
				end,
				function (data1, menu1)
					menu1.close()
				end)
		elseif data.current.value == "menuperso_publishannano" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_notif', {
				title = "Entrez le contenu de l'annonce",
				value = ''
				},
				function (data1, menu1)
					menu1.close()
					local contenu = data1.value

					if contenu and contenu ~= "" then
						ContenuReason = contenu
					else
						ContenuReason = "salut"
					end

					if ContenuReason == "" then
						ContenuReason = "salut"
					end

					TriggerServerEvent('esx_ann:annonce', ContenuReason, true)
				end,
				function (data1, menu1)
					menu1.close()
				end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()

		currentAction = 'ann_menu'
		currentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_ann:hasEnteredMarker', function(zone)
	currentAction     = 'ann_menu'
	currentActionData = {zone = zone}
end)

AddEventHandler('esx_ann:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	currentAction = nil
end)

-- Activate menu when player is inside marker, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true

		local distance = #(playerCoords - Config.Zones.Pos)

		if distance < Config.DrawDistance then
			letSleep = false

			if Config.MarkerType ~= -1 then
				DrawMarker(Config.MarkerType, Config.Zones.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end

			if distance < Config.ZoneSize.x then
					isInMarker, currentZone = true, k
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker = true
			lastZone = currentZone
			TriggerEvent('esx_ann:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_ann:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.Pos)

	SetBlipSprite(blip, 269)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 1)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Publier une Annonce")
	EndTextCommandSetBlipName(blip)
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction then 
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour publier une ~b~annonce~s~.")

			if IsControlJustReleased(0, 38) then
				if currentAction == 'ann_menu' then
					ShowAnnounceMenu()
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
