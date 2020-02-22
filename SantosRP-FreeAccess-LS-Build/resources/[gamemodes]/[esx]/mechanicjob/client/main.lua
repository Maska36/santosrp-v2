ESX = nil

local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentlyTowedVehicle, Blips = nil, {}
local isDead, isBusy = false, false
local PlayerData = {}
local CurrentAction, CurrentActionData = nil, {}
local isInMarker = false
local Vehicles = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local JobBlips = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

---------------------------------------------------------------------------------------------------------------------
--------------------------------------- MECHANIC JOB ----------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
function OpenMechanicActionsMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name
	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'},
		{label = "Passer une Annonce", value = 'announce'}
	}

	if Config.EnablePlayerManagement and PlayerData.job and grade == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mechanic_actions') then
		ESX.UI.Menu.CloseAll()
	else
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
			css = "bennys",
			title    = _U('mechanic'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'vehicle_list' then
				local elements = {
					{label = _U('flat_bed'),  value = 'flatbed'},
					{label = _U('tow_truck'), value = 'towtruck2'}
				}

				if Config.EnablePlayerManagement and PlayerData.job and (grade == 'boss' or grade == 'chief' or grade == 'experimente') then
					table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
					css = "bennys",
					title    = _U('service_vehicle'),
					align    = 'top-left',
					elements = elements
				}, function(data1, menu1)
					ESX.Game.SpawnVehicle(data1.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
						local playerPed = PlayerPedId()
						TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					end)
					menu1.close()
				end, function(data1, menu1)
					menu1.close()
				end)
			elseif data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			elseif data.current.value == 'announce' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_annonce',
				{
					title = "Entrez le contenu de l'annonce",
					value = ''
				},
				function (data, menu)
					menu.close()
					local contenu = data.value

					if contenu and contenu ~= "" then
						ContenuReason = contenu
					else
						ContenuReason = "salut"
					end

					if ContenuReason == "" then
						ContenuReason = "salut"
					end

					TriggerServerEvent('mechjob:annonce', ContenuReason)
				end, function (data, menu)
					menu.close()
				end)
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('society:openBMenu', 'mechanic', function(data, menu)
					menu.close()
				end)
			end
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_actions_menu'
			CurrentActionData = {}
		end)
	end
end

function OpenMechanicHarvestMenu()
	local grade = PlayerData.job.grade_name
	if Config.EnablePlayerManagement and PlayerData.job.name == 'mechanic' then
		local elements = {
			{label = _U('gas_can'), value = 'gazbottle'},
			{label = _U('repair_tools'), value = 'fixtool'},
			{label = _U('body_work_tools'), value = 'carotool'}
		}

		if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mechanic_harvest') then
			ESX.UI.Menu.CloseAll()
		else
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
				css = "bennys",
				title    = _U('harvest'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				menu.close()
				TriggerServerEvent('mechjob:startHarvest', data.current.value)
			end, function(data, menu)
				menu.close()
				CurrentAction     = 'mechanic_harvest_menu'
				CurrentActionData = {}
			end)
		end
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMechanicCraftMenu()
	if Config.EnablePlayerManagement and PlayerData.job.name == 'mechanic' then
		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
			css = "bennys",
			title    = _U('craft'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value == 'blow_pipe' then
				TriggerServerEvent('mechjob:startCraft')
			elseif data.current.value == 'fix_kit' then
				TriggerServerEvent('mechjob:startCraft2')
			elseif data.current.value == 'caro_kit' then
				TriggerServerEvent('mechjob:startCraft3')
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'mechanic_craft_menu'
			CurrentActionData = {}
		end)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('mechjob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css = "bennys",
			title    = _U('mechanic_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count ~= nil then
					menu2.close()
					menu.close()
					TriggerServerEvent('mechjob:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('mechjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css = "bennys",
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count ~= nil then
					menu2.close()
					menu.close()
					TriggerServerEvent('mechjob:putStockItems', itemName, count)

					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('mechjob:onHijack')
AddEventHandler('mechjob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local chance = math.random(100)
		local alarm  = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if chance <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end
	end
end)

RegisterNetEvent('mechjob:onCarokit')
AddEventHandler('mechjob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('mechjob:onFixkit')
AddEventHandler('mechjob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('mechjob:hasEnteredMarker')
AddEventHandler('mechjob:hasEnteredMarker', function(zone)
	if zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionData = {}
	elseif zone == 'Garage' then
		CurrentAction     = 'mechanic_harvest_menu'
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionData = {}
	elseif zone == 'ls1' and IsPedInAnyVehicle(PlayerPedId(), false) then
		CurrentAction     = 'ls_custom'
		CurrentActionData = {}
	elseif zone == 'ls2' and IsPedInAnyVehicle(PlayerPedId(), false) then
		CurrentAction     = 'ls_custom'
		CurrentActionData = {}
	elseif zone == 'ls3' and IsPedInAnyVehicle(PlayerPedId(), false) then
		CurrentAction     = 'ls_custom'
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' and IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		CurrentAction     = 'delete_vehicle'
		CurrentActionData = {vehicle = vehicle}
	end
end)

RegisterNetEvent('mechjob:hasExitedMarker')
AddEventHandler('mechjob:hasExitedMarker', function(zone)
	if zone == 'Craft' then
		TriggerServerEvent('mechjob:stopCraft')
		TriggerServerEvent('mechjob:stopCraft2')
		TriggerServerEvent('mechjob:stopCraft3')
	elseif zone == 'Garage' then
		TriggerServerEvent('mechjob:stopHarvest')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	DeleteJobBlips()
	CreateJobBlips()
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_mechanic'),
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7inrp_mechanicjobZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhinrp_mechanicjobDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMinrp_mechanicjobIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuinrp_mechanicjobZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Blip.Pos.x, Config.Blip.Pos.y, Config.Blip.Pos.z)
	SetBlipSprite (blip, Config.Blip.Sprite)
	SetBlipDisplay(blip, Config.Blip.Display)
	SetBlipScale  (blip, Config.Blip.Scale)
	SetBlipColour (blip, Config.Blip.Colour)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

-- Display enter job marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		-- PREVENT FREE TUNING IS LS CUSTOM // THIS IS HERE FOR OTIMIZATION ONLY
		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 166, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if PlayerData.job and PlayerData.job.name == 'mechanic' then

			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil
			
			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('mechjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('mechjob:hasExitedMarker', LastZone)
			end

		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('mechjob:removeSpecialContact', 'mechanic')
	end
end)

-- Display markers
Citizen.CreateThread(function()
	local playerPed = PlayerPedId()
	while true do
		Citizen.Wait(10)

		if PlayerData.job and PlayerData.job.name == 'mechanic' then
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true

			for k,v in pairs(Config.Zones) do
				if (v.Type ~= -1) and (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					ESX.ShowHelpNotification(v.Text)
					letSleep = false
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'mechanic' then
				if CurrentAction == 'mechanic_actions_menu' then
					OpenMechanicActionsMenu()
				elseif CurrentAction == 'mechanic_harvest_menu' then
					OpenMechanicHarvestMenu()
				elseif CurrentAction == 'mechanic_craft_menu' then
					OpenMechanicCraftMenu()
				elseif CurrentAction == 'ls_custom' and IsPedInAnyVehicle(PlayerPedId(), false) then
					OpenLSAction()
				elseif CurrentAction == 'delete_vehicle' and IsPedInAnyVehicle(PlayerPedId(), false) then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end
			end
			if IsControlJustReleased(0, 200) and PlayerData.job and PlayerData.job.name == 'mechanic' then
				lsMenuIsShowed = false
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'mechanic' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mecha_actions') then
	      OpenMechaActionsMenu()
	    end
	end
end)

function OpenMechaActionsMenu()
  	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mecha_actions',
    {
		css      = 'bennys',
		title    = 'Benny\'s',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'}
      	},
    },
    function(data, menu)
		if data.current.value == 'citizen_interaction' then
        	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
         	{
            	css = 'bennys',
            	title    = _U('citizen_interaction'),
            	align    = 'top-left',
            	elements = {
              		{label = 'Facture', value = 'billing'}
            	},
          	},
          	function(data2, menu2)
            	local player, distance = ESX.Game.GetClosestPlayer()

            	if distance ~= -1 and distance <= 3.0 then
              		if data2.current.value == 'billing' then
	                	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing',
	                	{
	                  		title = "Entrez un montant"
	                	}, function(data, menu)
	                  		local amount = tonumber(data.value)

		                  	if amount == nil or amount < 0 then
		                    	ESX.ShowNotification("~r~Montant invalide")
		                  	else
	                    		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	                    		if closestPlayer == -1 or closestDistance > 3.0 then
	                      			ESX.ShowNotification(_U('no_players_nearby'))
	                    		else
	                      			menu.close()
	                      			TriggerServerEvent('esxb:sendB', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
	                    		end
	                  		end
	                	end, function(data, menu)
	                  		menu.close()
	                	end)
              		end
            	else
              		ESX.ShowNotification(_U('no_players_nearby'))
            	end
			end, function(data2, menu2)
            	menu2.close()
          	end)
      	elseif data.current.value == 'vehicle_interaction' then
        	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
        	{
            	css = 'bennys',
            	title    = _U('vehicle_interaction'),
            	align    = 'top-left',
            	elements = {
            		{label = "Laver véhicule", value = 'lav'},
            		{label = "Remorquer véhicule", value = 'rem'}
            	},
          	}, function(data2, menu2)
          		if data2.current.value == 'lav' then
					local playerPed = PlayerPedId()
					local vehicle = ESX.Game.GetVehicleInDirection()
					local coords = GetEntityCoords(playerPed)

					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification('~r~Vous devez être en-dehors du véhicule!')
						return
					end

					if DoesEntityExist(vehicle) then
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
						Citizen.CreateThread(function()
							Citizen.Wait(10000)

							SetVehicleDirtLevel(vehicle, 0)
							ClearPedTasksImmediately(playerPed)

							ESX.ShowNotification('~g~Véhicule lavé')
							isBusy = false
						end)
					else
						ESX.ShowNotification('~r~Il n\'y a aucun véhicule à proximité.')
					end
          		elseif data2.current.value == 'rem' then
					local playerPed = PlayerPedId()
          			local vehicle = GetVehiclePedIsIn(playerPed, true)
					local towmodel = GetHashKey("flatbed")
					local isVehicleTow = IsVehicleModel(vehicle, towmodel)

					if isVehicleTow then
						local targetVehicle = ESX.Game.GetVehicleInDirection()

						if CurrentlyTowedVehicle == nil then
							if targetVehicle ~= 0 then
								if not IsPedInAnyVehicle(playerPed, true) then
									if vehicle ~= targetVehicle then
										AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
										CurrentlyTowedVehicle = targetVehicle
										ESX.ShowNotification(_U('vehicle_success_attached'))
									else
										ESX.ShowNotification("Vous ne pouvez pas remorquer votre véhicule !")
									end
								end
							else
								ESX.ShowNotification('~r~Il n\'y a aucun véhicule à proximité.')
							end
						else
							AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
							DetachEntity(CurrentlyTowedVehicle, true, true)
							CurrentlyTowedVehicle = nil
							ESX.ShowNotification("Véhicule saisi avec succès !")
						end
					end
				end
          	end, function(data2, menu2)
            	menu2.close()
          	end)
      	end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLSAction()
	if IsControlJustReleased(0, 38) and not lsMenuIsShowed then
		if ((PlayerData.job ~= nil and PlayerData.job.name == 'mechanic') or Config.IsMechanicJobOnly == false) then
			lsMenuIsShowed = true

			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			FreezeEntityPosition(vehicle, true)
			FreezeEntityPosition(PlayerPedId(), true)

			myCar = ESX.Game.GetVehicleProperties(vehicle)

			ESX.UI.Menu.CloseAll()
			GetAction({value = 'main'})
		end
	end

	if isInLSMarker and not hasAlreadyEnteredMarker then
		hasAlreadyEnteredMarker = true
	end
	if not isInLSMarker and hasAlreadyEnteredMarker then
		hasAlreadyEnteredMarker = false
	end
end

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

---------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------LSCUSTOM--------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	ESX.TriggerServerCallback('mechjob:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
  	CreateJobBlips()
end)

function IsJobTrue()
  if PlayerData ~= nil then
    local IsJobTrue = false
    if PlayerData.job and PlayerData.job.name == 'mechanic' then
      IsJobTrue = true
    end
    return IsJobTrue
  end
end

function CreateJobBlips()
    if IsJobTrue() then               
		local blip = AddBlipForCoord(Config.Zones.Garage.Pos.x, Config.Zones.Garage.Pos.y, Config.Zones.Garage.Pos.z)

		SetBlipSprite (blip, 446)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte Outils")
		EndTextCommandSetBlipName(blip)

		table.insert(JobBlips, blip)
		CreateJobBlips2()
    end 
end

function CreateJobBlips2()
	if IsJobTrue() then
		local blip2 = AddBlipForCoord(Config.Zones.Craft.Pos.x, Config.Zones.Craft.Pos.y, Config.Zones.Craft.Pos.z)

    	SetBlipSprite (blip, 446)
  	 	SetBlipDisplay(blip, 4)
  	  	SetBlipScale  (blip, 0.8)
  	  	SetBlipColour (blip, 5)
    	SetBlipAsShortRange(blip2, true)

    	BeginTextCommandSetBlipName("STRING")
    	AddTextComponentString("Craft Outils")

    	EndTextCommandSetBlipName(blip2)
    	table.insert(JobBlips, blip2)
  	end
end

function DeleteJobBlips()
  if JobBlips[1] ~= nil then
    for i=1, #JobBlips, 1 do
      RemoveBlip(JobBlips[i])
      JobBlips[i] = nil
    end
  end
end

RegisterNetEvent('mechjob:installMod')
AddEventHandler('mechjob:installMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	myCar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('mechjob:refreshOwnedVehicle', myCar)
end)

RegisterNetEvent('mechjob:cancelInstallMod')
AddEventHandler('mechjob:cancelInstallMod', function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

function OpenLSMenu(elems, menuName, menuTitle, parent)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		css = "bennys",
		title    = menuTitle,
		align    = 'top-left',
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end

		for k,v in pairs(Config.Menus) do
			if k == data.current.modType or isRimMod then
				if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
					ESX.ShowNotification(_U('already_own', data.current.label))
					TriggerEvent('mechjob:installMod')
				else
					local vehiclePrice = 80000
					for i=1, #Vehicles, 1 do
						if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
							vehiclePrice = Vehicles[i].price
							break
						end
					end

					if isRimMod then
						price = math.floor(vehiclePrice * data.current.price / 100)
						TriggerServerEvent("mechjob:buyMod", price)
					elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
						price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 100)
						TriggerServerEvent("mechjob:buyMod", price)
					elseif v.modType == 17 then
						price = math.floor(vehiclePrice * v.price[1] / 100)
						TriggerServerEvent("mechjob:buyMod", price)
					else
						price = math.floor(vehiclePrice * v.price / 100)
						TriggerServerEvent("mechjob:buyMod", price)
					end
				end
				menu.close()
				found = true
				break
			end
		end
		if not found then
			GetAction(data.current)
		end
	end, function(data, menu) -- on cancel
		menu.close()
		TriggerEvent('mechjob:cancelInstallMod')

		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDoorsShut(vehicle, false)

		if parent == nil then
			lsMenuIsShowed = false
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			FreezeEntityPosition(vehicle, false)
			FreezeEntityPosition(PlayerPedId(), false)
			myCar = {}
		end
	end, function(data, menu) -- on change
		UpdateMods(data.current)
	end)
end

function UpdateMods(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	
	if data.modType then
		local props = {}
		
		if data.wheelType then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end
		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
	end
end

function GetAction(data)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)
	FreezeEntityPosition(vehicle, true)
	FreezeEntityPosition(PlayerPedId(), true)

	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 80000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end

	for k,v in pairs(Config.Menus) do
		if data.value == k then
			menuName  = k
			menuTitle = v.label
			parent    = v.parent

			if v.modType then

				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
				elseif v.modType == 17 then
					table.insert(elements, {label = " " .. _U('no_turbo'), modType = k, modNum = false})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetHornName(j) .. ' <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetPlatesName(j) .. ' <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- NEON
					local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						price = math.floor(vehiclePrice * v.price / 100)
						_label = _U('neon') .. ' <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 100)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then -- RESPRAYS
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(vehiclePrice * v.price / 100)
						_label = colors[j].label .. ' <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetWindowName(j) .. ' <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level', j+1) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price[j+1] / 100)
							_label = _U('level', j+1) .. ' <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo <span style="color:green;">$' .. math.floor(vehiclePrice * v.price[1] / 100) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				elseif v.modType == 48 then -- Livery
					local _label = ''
					local modCount = tonumber(GetNumVehicleMods(vehicle, 48) or 0) + tonumber(GetVehicleLiveryCount(vehicle) or 0)
					for j = 1, modCount, 1 do
						if j == currentMods[k] then
							_label = _U('stickers') .. ' ' .. j .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = _U('stickers') .. ' ' .. j .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName ~= nil then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent)
end


--------------------------------------------------------------------------------------------------------------------------------
--------------------------- CAR LIFT -------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

local elevatorProp = nil
local elevatorUp = false
local elevatorDown = false
local elevatorBaseX = -223.5853
local elevatorBaseY = -1327.158
local elevatorBaseZ = 29.8


function deleteObject(object)
	return DeleteObject(object)
end

function createObject(model, x, y, z)
	RequestModel(model)
	while (not HasModelLoaded(model)) do
		Citizen.Wait(10)
	end
	return CreateObject(model, x, y, z, true, true, false)
end

function spawnProp(propName, x, y, z)
	local model = GetHashKey(propName)
	
	if IsModelValid(model) then
		local pos = GetEntityCoords(PlayerPedId(), true)
	
		local forward = 5.0
		local heading = GetEntityHeading(PlayerPedId())
		local xVector = forward * math.sin(math.rad(heading)) * -1.0
		local yVector = forward * math.cos(math.rad(heading))
		
		elevatorProp = createObject(model, x, y, z)
		local propNetId = ObjToNet(elevatorProp)
		SetNetworkIdExistsOnAllMachines(propNetId, true)
		NetworkSetNetworkIdDynamic(propNetId, true)
		SetNetworkIdCanMigrate(propNetId, false)
		
		SetEntityLodDist(elevatorProp, 0xFFFF)
		SetEntityCollision(elevatorProp, true, true)
		FreezeEntityPosition(elevatorProp, true)
		SetEntityCoords(elevatorProp, x, y, z, false, false, false, false) -- Patch un bug pour certains props.
	end
end

function Main()
	if not garage_menu then 
		ESX.UI.Menu.CloseAll()
	else
		local elements = {}

		table.insert(elements, {label = 'Allumer la machine', value = 'allmach'})
		table.insert(elements, {label = 'Éteindre la machine', value = 'eteimach'})
		table.insert(elements, {label = 'Lever', value = 'lever'})
		table.insert(elements, {label = 'Descendre', value = 'descendre'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainmenu', {
	    	css = 'bennys',
			title    = "Benny's",
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == "allmach" then
				spawnProp("nacelle", elevatorBaseX, elevatorBaseY, elevatorBaseZ)
			elseif data.current.value == "eteimach" then
				DeleteObject(elevatorProp)
			elseif data.current.value == "lever" then
				if elevatorProp ~= nil then
					elevatorDown = false
					elevatorUp = true
				end
			elseif data.current.value == "descendre" then
				if elevatorProp ~= nil then
					elevatorUp = false
					elevatorDown = true
				end
			end
		end, function(data, menu)
			menu.close()
			garage_menu = false
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		local elevatorCoords = GetEntityCoords(elevatorProp, false)
		
		if elevatorUp then
			if elevatorCoords.z < 31.8 then
				elevatorBaseZ = elevatorBaseZ + 0.01
				SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
			end
		elseif elevatorDown then
			if elevatorCoords.z > 29.8 then
				elevatorBaseZ = elevatorBaseZ - 0.01
				SetEntityCoords(elevatorProp, elevatorBaseX, elevatorBaseY, elevatorBaseZ, false, false, false, false)
			end
		end
		
		if GetDistanceBetweenCoords(Config.Zones.CarLift.Pos.x, Config.Zones.CarLift.Pos.y, Config.Zones.CarLift.Pos.z, GetEntityCoords(PlayerPedId(), false).x, GetEntityCoords(PlayerPedId(), false).y, GetEntityCoords(PlayerPedId(), false).z - 1) < Config.DrawDistance and PlayerData.job.name == 'mechanic' then
			if IsControlJustReleased(1, 51) then
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
				garage_menu = not garage_menu
				Main()
			end
		else
			Citizen.Wait(500)
		end
		
        if garage_menu then
			DisableControlAction(1, 22, true)
			DisableControlAction(1, 0, true)
			DisableControlAction(1, 27, true)
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 20, true)
			
			DisableControlAction(1, 187, true)
			
			DisableControlAction(1, 80, true)
			DisableControlAction(1, 95, true)
			DisableControlAction(1, 96, true)
			DisableControlAction(1, 97, true)
			DisableControlAction(1, 98, true)
			
			DisableControlAction(1, 81, true)
			DisableControlAction(1, 82, true)
			DisableControlAction(1, 83, true)
			DisableControlAction(1, 84, true)
			DisableControlAction(1, 85, true)
			
			DisableControlAction(1, 74, true)
			SetCinematicButtonActive(false)
        end
    end
end)
