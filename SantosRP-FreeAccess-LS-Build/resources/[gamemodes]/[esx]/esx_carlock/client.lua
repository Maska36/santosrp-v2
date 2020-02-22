ESX = nil

local dict = "anim@mp_player_intmenu@key_fob@"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

   	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
   	end

   	while ESX.GetPlayerData().org == nil do
      	Citizen.Wait(10)
   	end

   	ESX.PlayerData = ESX.GetPlayerData()
   	ESX.Streaming.RequestAnimDict(dict)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setOrg')
AddEventHandler('esx:setOrg', function(org)
	ESX.PlayerData.org = org
end)

Citizen.CreateThread(function()
	while true do
    	Citizen.Wait(0)
    	if IsControlJustPressed(1, 303) then
			if ESX then
				local coords = GetEntityCoords(PlayerPedId())
				local hasAlreadyLocked = false
				local cars = ESX.Game.GetVehiclesInArea(coords, 3)
				local carstrie, cars_dist = {}, {}
				local notowned = 0
				
				if #cars > 0 then
					for j=1, #cars, 1 do
						local coordscar = GetEntityCoords(cars[j])
						local distance = #(coordscar - coords)
						
						table.insert(cars_dist, {cars[j], distance})
					end

					for k=1, #cars_dist, 1 do
						local z = -1
						local distance, car = 999
						
						for l=1, #cars_dist, 1 do
							if cars_dist[l][2] < distance then
								distance = cars_dist[l][2]
								car = cars_dist[l][1]
								z = l
							end
						end
					
						if z ~= -1 then
							table.remove(cars_dist, z)
							table.insert(carstrie, car)
						end
					end

					for i=1, #carstrie, 1 do
						local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))

						if string.find(plate, "WORK") then
							if ESX.PlayerData.job and ESX.PlayerData.job.name ~= "chomeur" and hasAlreadyLocked ~= true then
								local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
								vehicleLabel = GetLabelText(vehicleLabel)
								local lock = GetVehicleDoorLockStatus(carstrie[i])
							
								if lock == 1 or lock == 0 then
									SetVehicleDoorShut(carstrie[i], 0, false)
									SetVehicleDoorShut(carstrie[i], 1, false)
									SetVehicleDoorShut(carstrie[i], 2, false)
									SetVehicleDoorShut(carstrie[i], 3, false)
									SetVehicleDoorsLocked(carstrie[i], 2)
									PlayVehicleDoorCloseSound(carstrie[i], 1)
									ESX.ShowNotification('Vous avez fermé votre ~r~véhicule~s~ !')
									
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									hasAlreadyLocked = true
								elseif lock == 2 then
									SetVehicleDoorsLocked(carstrie[i], 1)
									PlayVehicleDoorOpenSound(carstrie[i], 0)
									ESX.ShowNotification('Vous avez ouvert votre ~g~véhicule~s~ !')
									
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
								
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									hasAlreadyLocked = true
								end
							end
						elseif string.find(plate, ESX.PlayerData.org.name) then
							if ESX.PlayerData.org and ESX.PlayerData.org.name == string.match(plate, ESX.PlayerData.org.name) and hasAlreadyLocked ~= true then
								local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
								vehicleLabel = GetLabelText(vehicleLabel)
								local lock = GetVehicleDoorLockStatus(carstrie[i])
								
								if lock == 1 or lock == 0 then
									SetVehicleDoorShut(carstrie[i], 0, false)
									SetVehicleDoorShut(carstrie[i], 1, false)
									SetVehicleDoorShut(carstrie[i], 2, false)
									SetVehicleDoorShut(carstrie[i], 3, false)
									SetVehicleDoorsLocked(carstrie[i], 2)
									PlayVehicleDoorCloseSound(carstrie[i], 1)
									ESX.ShowNotification('Vous avez fermé votre ~r~véhicule~s~ !')
									
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
									
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									hasAlreadyLocked = true
								elseif lock == 2 then
									SetVehicleDoorsLocked(carstrie[i], 1)
									PlayVehicleDoorOpenSound(carstrie[i], 0)
									ESX.ShowNotification('Vous avez ouvert votre ~g~véhicule~s~ !')
									
									if not IsPedInAnyVehicle(PlayerPedId(), true) then
										TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									end
								
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 2)
									Citizen.Wait(150)
									SetVehicleLights(carstrie[i], 0)
									hasAlreadyLocked = true
								end
							end
						else
							ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owned)
								if owned and hasAlreadyLocked ~= true then
									local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
									vehicleLabel = GetLabelText(vehicleLabel)
									local lock = GetVehicleDoorLockStatus(carstrie[i])
										
									if lock == 1 or lock == 0 then
										SetVehicleDoorShut(carstrie[i], 0, false)
										SetVehicleDoorShut(carstrie[i], 1, false)
										SetVehicleDoorShut(carstrie[i], 2, false)
										SetVehicleDoorShut(carstrie[i], 3, false)
										SetVehicleDoorsLocked(carstrie[i], 2)
										PlayVehicleDoorCloseSound(carstrie[i], 1)
										ESX.ShowNotification('Vous avez fermé votre ~r~véhicule~s~ !')
											
										if not IsPedInAnyVehicle(PlayerPedId(), true) then
											TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
										end
											
										SetVehicleLights(carstrie[i], 2)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 0)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 2)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 0)
										hasAlreadyLocked = true
									elseif lock == 2 then
										SetVehicleDoorsLocked(carstrie[i], 1)
										PlayVehicleDoorOpenSound(carstrie[i], 0)
										ESX.ShowNotification('Vous avez ouvert votre ~g~véhicule~s~ !')
										
										if not IsPedInAnyVehicle(PlayerPedId(), true) then
											TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
										end

										SetVehicleLights(carstrie[i], 2)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 0)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 2)
										Citizen.Wait(150)
										SetVehicleLights(carstrie[i], 0)
										hasAlreadyLocked = true
									end
								else
									notowned = notowned + 1
								end
							end, plate)
						end
					end
				else
					Citizen.Wait(500)
				end
				Citizen.Wait(500)
			else
				Citizen.Wait(500)
			end
		end
  	end
end)