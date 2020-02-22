local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_status:onTick')
AddEventHandler('esx_status:onTick', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)
