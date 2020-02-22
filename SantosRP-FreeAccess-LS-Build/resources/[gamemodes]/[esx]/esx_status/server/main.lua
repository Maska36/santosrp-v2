ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	local players = ESX.GetPlayers()

	for _,playerId in ipairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local data = {}

				if result[1].status then
					data = json.decode(result[1].status)
				end

				xPlayer.set('status', data)
				TriggerClientEvent('esx_status:load', playerId, data)
			end)
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local data = {}

			if result[1].status ~= nil then
				data = json.decode(result[1].status)
			end

			xPlayer.set('status', data)
			TriggerClientEvent('esx_status:load', _source, data)
		end)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status = xPlayer.get('status')

	if xPlayer then
		MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
			['@status']     = json.encode(status),
			['@identifier'] = xPlayer.identifier
		})
	end
end)

AddEventHandler('esx_status:getStatus', function(source, statusName, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local status  = xPlayer.get('status')

	if xPlayer then
		for i=1, #status, 1 do
			if status[i].name == statusName then
				cb(status[i])
				break
			end
		end
	end
end)

RegisterServerEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.set('status', status)
	end
end)

function SaveData()
	Citizen.CreateThread(function()
		Citizen.Wait(300000 * 1) -- wait five minutes
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				local status = xPlayer.get('status')

	        	print('[esx_status] [^2INFO^7] Saved all players')

				MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
					['@status'] = json.encode(status),
					['@identifier'] = xPlayer.identifier
				})
			end
		end
	end)
end

SaveData()
