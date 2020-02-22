TriggerEvent('es:addGroupCommand', 'tp', 'admin', function(source, args, user)
	local x = tonumber(args[1])
	local y = tonumber(args[2])
	local z = tonumber(args[3])
	
	if x and y and z then
		TriggerClientEvent('esx:teleport', source, {
			x = x,
			y = y,
			z = z
		})
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Invalid coordinates!")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Teleport to coordinates', params = {
	{name = 'x', help = 'X coords'},
	{name = 'y', help = 'Y coords'},
	{name = 'z', help = 'Z coords'}
}})

TriggerEvent('es:addGroupCommand', 'setjob', 'admin', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesJobExist(args[2], args[3]) then
				xPlayer.setJob(args[2], args[3])
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That job does not exist.' } })
			end

		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('setjob'), params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'job', help = _U('setjob_param2')},
	{name = 'grade_id', help = _U('setjob_param3')}
}})

TriggerEvent('es:addGroupCommand', 'setorg', 'admin', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if ESX.DoesOrgExist(args[2], args[3]) then
				xPlayer.setOrg(args[2], args[3])
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That org does not exist.' } })
			end

		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('setorg'), params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'org', help = _U('setorg_param2')},
	{name = 'grade_id', help = _U('setorg_param3')}
}})

TriggerEvent('es:addGroupCommand', 'loadipl', 'admin', function(source, args, user)
	TriggerClientEvent('esx:loadIPL', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('load_ipl')})

TriggerEvent('es:addGroupCommand', 'unloadipl', 'admin', function(source, args, user)
	TriggerClientEvent('esx:unloadIPL', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('unload_ipl')})

TriggerEvent('es:addGroupCommand', 'playanim', 'admin', function(source, args, user)
	TriggerClientEvent('esx:playAnim', -1, args[1], args[3])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('play_anim')})

TriggerEvent('es:addGroupCommand', 'playemote', 'admin', function(source, args, user)
	TriggerClientEvent('esx:playEmote', -1, args[1])
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('play_emote')})

TriggerEvent('es:addGroupCommand', 'car', 'admin', function(source, args, user)
	TriggerClientEvent('esx:spawnVehicle', source, args[1])
	TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à fait spawn "..args[1], 16007897, "admin")
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('spawn_car'), params = {{name = "car", help = _U('spawn_car_param')}}})

TriggerEvent('es:addGroupCommand', 'cardel', 'admin', function(source, args, user)
	TriggerClientEvent('esx:deleteVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('delete_vehicle')})

TriggerEvent('es:addGroupCommand', 'dv', 'admin', function(source, args, user)
	TriggerClientEvent('esx:deleteVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('delete_vehicle')})

TriggerEvent('es:addGroupCommand', 'giveaccountmoney', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local account = args[2]
		local amount = tonumber(args[3])

		if amount then
			if account == 'cash' then
				xPlayer.addMoney(amount)
			elseif xPlayer.getAccount(account) then
				xPlayer.addAccountMoney(account, amount)
			else
				TriggerClientEvent('esx:showNotification', source, _U('invalid_account'))
			end
		else
			TriggerClientEvent('esx:showNotification', source, _U('amount_invalid'))
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveaccountmoney'), params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'account', help = _U('account')},
	{name = 'amount', help = _U('money_amount')}
}})

TriggerEvent('es:addGroupCommand', 'giveitem', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local item = args[2]
		local count = tonumber(args[3])

		if count then
			if xPlayer.getInventoryItem(item) then
				xPlayer.addInventoryItem(item, count)
			else
				TriggerClientEvent('esx:showNotification', source, _U('invalid_item'))
			end
		else
			TriggerClientEvent('esx:showNotification', source, _U('invalid_amount'))
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'item', help = _U('item')},
	{name = 'amount', help = _U('amount')}
}})

TriggerEvent('es:addGroupCommand', 'giveweapon', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			weaponName = string.upper(weaponName)

			if xPlayer.hasWeapon(weaponName) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player already has that weapon.' } })
			else
				if tonumber(args[3]) then
					xPlayer.addWeapon(weaponName, tonumber(args[3]))
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid ammo amount.' } })
				end
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid weapon.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveweapon'), params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'weapon', help = _U('weapon')},
	{name = 'ammo', help = _U('amountammo')}
}})

TriggerEvent('es:addGroupCommand', 'giveweaponcomponent', 'admin', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])

	if xPlayer then
		local weaponName = args[2] or 'unknown'

		if ESX.GetWeapon(weaponName) then
			weaponName = string.upper(weaponName)

			if xPlayer.hasWeapon(weaponName) then
				local component = ESX.GetWeaponComponent(weaponName, args[3] or 'unknown')

				if component then
					if xPlayer.hasWeaponComponent(weaponName, args[3]) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player already has that weapon component.' } })
					else
						xPlayer.addWeaponComponent(weaponName, args[3])
					end
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid weapon component.' } })
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player does not have that weapon.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid weapon.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Give weapon component', params = {
	{name = 'playerId', help = _U('id_param')},
	{name = 'weaponName', help = _U('weapon')},
	{name = 'componentName', help = 'weapon component'}
}})

TriggerEvent('es:addGroupCommand', 'clear', 'user', function(source, args, user)
	TriggerClientEvent('chat:clear', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('chat_clear')})

TriggerEvent('es:addGroupCommand', 'cls', 'user', function(source, args, user)
	TriggerClientEvent('chat:clear', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

TriggerEvent('es:addGroupCommand', 'clsall', 'admin', function(source, args, user)
	TriggerClientEvent('chat:clear', -1)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

TriggerEvent('es:addGroupCommand', 'clearall', 'admin', function(source, args, user)
	TriggerClientEvent('chat:clear', -1)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('chat_clear_all')})

TriggerEvent('es:addGroupCommand', 'clearinventory', 'admin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if not xPlayer then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		return
	end

	for i=1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i].count > 0 then
			xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('command_clearinventory'), params = {{name = "playerId", help = _U('command_playerid_param')}}})

TriggerEvent('es:addGroupCommand', 'clearmoney', 'admin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if not xPlayer then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		return
	end

	xPlayer.setMoney(0)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('command_clearinventory'), params = {{name = "playerId", help = _U('command_playerid_param')}}})

TriggerEvent('es:addGroupCommand', 'clearloadout', 'admin', function(source, args, user)
	local xPlayer

	if args[1] then
		xPlayer = ESX.GetPlayerFromId(args[1])
	else
		xPlayer = ESX.GetPlayerFromId(source)
	end

	if not xPlayer then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		return
	end

	for i=#xPlayer.loadout, 1, -1 do
		xPlayer.removeWeapon(xPlayer.loadout[i].name)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('command_clearloadout'), params = {{name = "playerId", help = _U('command_playerid_param')}}})

TriggerEvent('es:addGroupCommand', 'kick', 'admin', function(source, args, user)
	local reason = table.concat(args, " ", 2)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			if reason then
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You Kicked '..GetPlayerName(playerId)..' for '..reason } })
				DropPlayer(playerId, "Kicked: "..reason)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You need to specify a reason.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('kick'), params = {{name = "playerId", help = _U('id_param')}, {name = "reason", help = "Raison"}}})

TriggerEvent('es:addGroupCommand', 'reviveall', 'admin', function(source, args, user)
	TriggerClientEvent('ambujob:revive', -1)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('revive_all')})

TriggerEvent('es:addGroupCommand', 'fixcar', 'admin', function(source, args, user)
	TriggerClientEvent('fixVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Fix un véhicule"})

TriggerEvent('es:addGroupCommand', 'flipcar', 'admin', function(source, args, user)
	TriggerClientEvent('flipVehicle', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Flip un véhicule"})

TriggerEvent('es:addGroupCommand', 'debug', 'admin', function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			TriggerClientEvent('ambujob:revive', playerId)
			Wait(1000)
			TriggerClientEvent("santos_menuperso:TeleportRequest", playerId, 615.921, 88.554, 91.886)
			TriggerClientEvent("esx:showNotification", source, "~g~Vous avez debug ["..playerId.."] "..GetPlayerName(playerId).." !")
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à debug **"..GetPlayerName(playerId).."**", 16007897, "admin")
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Debug un joueur", params = {{name = "playerId", help = _U('id_param')}}})

TriggerEvent('es:addGroupCommand', 'spectate', 'admin', function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			TriggerClientEvent("santos_menuperso:requestSpectate", source, playerId)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Spectate un joueur", params = {{name = "playerId", help = _U('id_param')}}})

TriggerEvent('es:addGroupCommand', 'teleport', 'admin', function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			TriggerClientEvent("santos_menuperso:requestSpectate", source, playerId)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Spectate un joueur", params = {{name = "playerId", help = _U('id_param')}}})

TriggerEvent('es:addGroupCommand', 'teleport', 'admin', function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			local coords = GetEntityCoords(GetPlayerPed(source))
			TriggerClientEvent("santos_menuperso:TeleportRequest", playerId, coords)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Téléporter un joueur", params = {{name = "playerId", help = _U('id_param')}}})

TriggerEvent('es:addGroupCommand', 'teleportto', 'admin', function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])
		if playerId and ESX.GetPlayerFromId(playerId) then
			local coords = GetEntityCoords(GetPlayerPed(playerId))
			TriggerClientEvent("santos_menuperso:TeleportRequest", source, coords)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Se téléporter à un joueur", params = {{name = "playerId", help = _U('id_param')}}})