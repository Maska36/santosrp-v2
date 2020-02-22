ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterServerEvent('esx_dmvschool:addItem')
AddEventHandler('esx_dmvschool:addItem', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
		if xPlayer ~= nil then
			xPlayer.addInventoryItem('code_route', 1)
		end
end)

RegisterServerEvent('esx_dmvschool:addItemA')
AddEventHandler('esx_dmvschool:addItemA', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
		if xPlayer ~= nil then
			xPlayer.addInventoryItem('permis_moto', 1)
		end
end)

RegisterServerEvent('esx_dmvschool:addItemB')
AddEventHandler('esx_dmvschool:addItemB', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
		if xPlayer ~= nil then
			xPlayer.addInventoryItem('permis_voiture', 1)
		end
end)

RegisterServerEvent('esx_dmvschool:addItemC')
AddEventHandler('esx_dmvschool:addItemC', function(item, count)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
		if xPlayer ~= nil then
			xPlayer.addInventoryItem('permis_camion', 1)
		end
end)

RegisterNetEvent('santos_dmvschool:addLicense')
AddEventHandler('santos_dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('santos_dmvschool:pay')
AddEventHandler('santos_dmvschool:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', ESX.Math.GroupDigits(price)))
end)
