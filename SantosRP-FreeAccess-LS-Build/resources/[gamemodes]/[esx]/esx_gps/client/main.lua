ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_gps:setGPS', false)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer

	TriggerEvent('esx_gps:setGPS', false)

	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].name == 'gps' then
			if ESX.PlayerData.inventory[i].count > 0 then
				TriggerEvent('esx_gps:setGPS', true)
			end
		end
	end
end)

RegisterNetEvent('esx_gps:setGPS')
AddEventHandler('esx_gps:setGPS', function(value)
	DisplayRadar(value)
end)