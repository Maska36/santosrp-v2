ESX = nil

TriggerEvent('esx:getSO', function(obj)
	ESX = obj
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	source = source
	if item == 'gps' then
		TriggerClientEvent('esx_gps:setGPS', source, true)
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	source = source
	if item == 'gps' and count < 1 then
		TriggerClientEvent('esx_gps:setGPS', source, false)
	end
end)