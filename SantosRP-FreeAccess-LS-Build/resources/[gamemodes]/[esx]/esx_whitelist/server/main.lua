WhiteList = {}

RegisterNetEvent('esx_whitelist:wlrefresh')
AddEventHandler('esx_whitelist:wlrefresh', function()
	_source = source
	loadWhiteList(function()
		TriggerClientEvent('esx:showNotification', _source, '~y~Whitelist rafraichit')
	end)
end)

RegisterNetEvent('esx_whitelist:wladd')
AddEventHandler('esx_whitelist:wladd', function(argz)
	_source = source
	local steamID = 'steam:' .. argz:lower()

	if string.len(steamID) ~= 21 then
		TriggerClientEvent('esx:showNotification', _source, '~r~Steam ID invalide')
		return
	end

	MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		if result[1] ~= nil then
			TriggerClientEvent('esx:showNotification', _source, '~y~Ce joueur est déja WL.')
		else
			MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
				['@identifier'] = steamID
			}, function (rowsChanged)
				table.insert(WhiteList, steamID)
				print(steamID..' à été WL.')
				TriggerClientEvent('esx:showNotification', _source, '~g~Le joueur à été WL.')
			end)
		end
	end)
end)

RegisterNetEvent('esx_whitelist:wlremove')
AddEventHandler('esx_whitelist:wlremove', function(args)
	_source = source
	local steamID = 'steam:' .. args:lower()

	if string.len(steamID) ~= 21 then
		TriggerClientEvent('esx:showNotification', _source, '~r~Steam ID invalide')
		return
	end

	MySQL.Async.fetchAll('DELETE FROM whitelist WHERE identifier = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		table.insert(WhiteList, steamID)
		print(steamID..' à été Un-WL.')
		TriggerClientEvent('esx:showNotification', _source, '~g~Le joueur à été Un-WL.')
	end)
end)

function loadWhiteList(cb)
	Whitelist = {}

	MySQL.Async.fetchAll('SELECT * FROM whitelist', {}, function (identifiers)
		for i=1, #identifiers, 1 do
			table.insert(WhiteList, tostring(identifiers[i].identifier):lower())
		end

		if cb ~= nil then
			cb()
		end
	end)
end

MySQL.ready(function()
	loadWhiteList()
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	-- Mark this connection as deferred, this is to prevent problems while checking player identifiers.
	deferrals.defer()

	local _source = source
	
	-- Letting the user know what's going on.
	deferrals.update("Recherche de votre SteamID dans la base de données")
	
	-- Needed, not sure why.
	Citizen.Wait(100)

	local whitelisted, kickReason, steamID = false, nil, GetPlayerIdentifiers(_source)[1]

	if #WhiteList == 0 then
		kickReason = "La WhiteList n'a pas encore été chargée !"
	else
		if steamID then 
			for i = 1, #WhiteList, 1 do
				if tostring(WhiteList[i]) == tostring(steamID) then
					whitelisted = true
					break
				end
			end

			if not whitelisted then
				kickReason = Config.DevServMessage.." "..steamID
			end
		elseif steamID == nil or steamID == "" then
			kickReason = "Ce serveur est sous WhiteList, veuillez rejoindre le discord pour plus d\'infos : discord.gg/santosroleplay"
		end

	end

	if whitelisted then
		print('Whitelist Connection: '..GetPlayerName(_source)..'('..GetPlayerEndpoint(_source)..') - '..GetPlayerIdentifiers(_source)[1])
		TriggerEvent('SendToDiscord', _source, "Whitelist Connection", "**"..GetPlayerName(_source).."**", 16007897, "logs")
		deferrals.done()
	else
		print('Non-Whitelist try Connection: '..GetPlayerName(_source)..'('..GetPlayerEndpoint(_source)..')')
		TriggerEvent('SendToDiscord', _source, "Non-Whitelist try Connection", "**"..GetPlayerName(_source).."**", 16007897, "logs")
		deferrals.done(kickReason)
	end
end)
