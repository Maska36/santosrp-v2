ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_securitycam:itemCheck', function(src, cb)
 	local xPlayer = ESX.GetPlayerFromId(src)
 	local item = xPlayer.getInventoryItem('gps').count
	if item > 0 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_securitycam:unhackanimserver')
AddEventHandler('esx_securitycam:unhackanimserver', function()
	local _source = source
	TriggerClientEvent('esx_securitycam:unhackanim', _source)
end)

RegisterServerEvent('esx_securitycam:setBankHackedState')
AddEventHandler('esx_securitycam:setBankHackedState', function(state)
	TriggerClientEvent('esx_securitycam:setBankHackedState', -1, state)
end)

RegisterServerEvent('esx_securitycam:setPoliceHackedState')
AddEventHandler('esx_securitycam:setPoliceHackedState', function(state)
	TriggerClientEvent('esx_securitycam:setPoliceHackedState', -1, state)
end)