ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

ESX.RegisterServerCallback('assets:getUserJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local group = xPlayer.job.name
		cb(group)
	end
end)