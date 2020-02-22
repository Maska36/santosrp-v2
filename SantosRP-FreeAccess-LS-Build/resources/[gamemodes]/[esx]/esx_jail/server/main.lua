ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

-- jail command
TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) then
		TriggerEvent('esx_jail:sendToJail', tonumber(args[1]), tonumber(args[2]))
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID or jail time!' } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Put a player in jail", params = {{name = "id", help = "target id"}, {name = "time", help = "jail time in minutes"}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'admin', function(source, args, user)
	if args[1] then
		if GetPlayerName(args[1]) ~= nil then
			TriggerEvent('esx_jail:unjailQuest', tonumber(args[1]))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID!' } } )
		end
	else
		TriggerEvent('esx_jail:unjailQuest', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Unjail people from jail", params = {{name = "id", help = "target id"}}})

-- send to jail and register in database
RegisterServerEvent('esx_jl:sendToJail')
AddEventHandler('esx_jl:sendToJail', function(target, jailTime)
	local identifier = GetPlayerIdentifiers(target)[1]
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then
		MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE jail SET jail_time = @jail_time WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@jail_time'] = jailTime
				})
			else
				MySQL.Async.execute('INSERT INTO jail (identifier, jail_time) VALUES (@identifier, @jail_time)', {
					['@identifier'] = identifier,
					['@jail_time'] = jailTime
				})
			end
		end)
		TriggerClientEvent('esx_policejob:unrestrain', target)
		TriggerClientEvent('esx_jl:jail', target, jailTime)
	end
end)

-- should the player be in jail?
RegisterServerEvent('esx_jl:checkJail')
AddEventHandler('esx_jl:checkJail', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil then
			TriggerClientEvent('esx_jl:jail', _source, tonumber(result[1].jail_time))
		end
	end)
end)

-- unjail via command
RegisterServerEvent('esx_jl:unjailQuest')
AddEventHandler('esx_jl:unjailQuest', function(source)
	if source ~= nil then
		unjail(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_jl:unjailTime')
AddEventHandler('esx_jl:unjailTime', function()
	unjail(source)
end)

-- keep jailtime updated
RegisterServerEvent('esx_jl:updateRemaining')
AddEventHandler('esx_jl:updateRemaining', function(jailTime)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE jail SET jail_time = @jailTime WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@jailTime'] = jailTime
			})
		end
	end)
end)

function unjail(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE from jail WHERE identifier = @identifier', {
				['@identifier'] = identifier
			})

		end
	end)

	TriggerClientEvent('esx_jl:unjail', target)
end
