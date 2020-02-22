RegisterNetEvent('copyToClipboard')
AddEventHandler('copyToClipboard', function(toCopy)
	SendNUIMessage({coords = toCopy})
end)