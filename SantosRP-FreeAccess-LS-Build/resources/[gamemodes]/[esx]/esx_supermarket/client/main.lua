ESX = nil
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	ESX.TriggerServerCallback('esx_shops:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			if Config.Zones[k] then
				Config.Zones[k].Items = v
			end
		end
	end)
end)

function OpenShopMenu(zone)
	SendNUIMessage({
		message	= "show",
		clear = true
	})
	
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		if item.limit == -1 then
			item.limit = 100
		end

		SendNUIMessage({
			message = "add",
			item = item.item,
			label = item.label,
			item = item.item,
			price = item.price,
			max = item.limit,
			loc = zone
		})
	end
	
	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
			
			SetBlipSprite(blip, 52)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.8)
			SetBlipColour(blip, 43)
			SetBlipAsShortRange(blip, true)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('shops'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				local distance = #(playerCoords - v.Pos[i])

				if distance < Config.DrawDistance then
					letSleep = false

					if Config.Type ~= -1 then
						DrawMarker(Config.Type, v.Pos[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
					end

					if distance < Config.Size.x then
						isInMarker, ShopItems, currentZone = true, v.Items, k
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', LastZone)
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

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil	
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function closeGui()
	SetNuiFocus(false, false)
	SendNUIMessage({message = "hide"})
end

RegisterNUICallback('quit', function(data, cb)
	closeGui()
	cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
	TriggerServerEvent('esx_shops:buyItem', data.item, data.count, data.loc)
	cb('ok')
end)