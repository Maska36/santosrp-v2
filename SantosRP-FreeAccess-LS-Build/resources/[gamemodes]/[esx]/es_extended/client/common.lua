AddEventHandler('esx:getSO', function(cb)
	cb(ESX)
end)

function getSO()
	return ESX
end
