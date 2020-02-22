ESX = nil
local isDead = false
local isAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('statued:set', 'hunger', 500000)
	TriggerEvent('statued:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('statued:set', 'hunger', 1000000)
	TriggerEvent('statued:set', 'thirst', 1000000)

	-- restore hp
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if isDead then
		TriggerEvent('esx_basicneeds:resetStatus')
	end

	isDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#cfac0f', function(status)
		return true
	end, function(status)
		status.remove(55)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#42a7f4', function(status)
		return true
	end, function(status)
		status.remove(35)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local prevHealth = GetEntityHealth(PlayerPedId())
			local health = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(PlayerPedId(), health)
			end
		end
	end)
end)

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(isAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat')
AddEventHandler('esx_basicneeds:onEat', function(prop_name)
	if not isAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		isAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				isAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink')
AddEventHandler('esx_basicneeds:onDrink', function(prop_name)
	if not isAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		isAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				isAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)