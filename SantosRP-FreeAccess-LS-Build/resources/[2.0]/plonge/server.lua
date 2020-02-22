ESX = nil

TriggerEvent('esx:getSO', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_plongee:pay')
AddEventHandler('esx_plongee:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 100 then
		TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez payé $100")
		xPlayer.removeMoney(100)
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
	end
end)