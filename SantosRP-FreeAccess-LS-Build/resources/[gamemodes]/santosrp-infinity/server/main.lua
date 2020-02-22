ESX = nil
Players = {}

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

ESX.RegisterServerCallback('infinity:getPlayersInfos', function(source, cb)
	cb(Players)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	Players[playerId].job = job.name

	TriggerClientEvent('infinity:updatePlayers', -1, Players)
end)

AddEventHandler('esx:setOrg', function(playerId, org, lastOrg)
	Players[playerId].org = org.name

	TriggerClientEvent('infinity:updatePlayers', -1, Players)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if xPlayer then
		AddPlayerToTable(xPlayer, true)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId)
	Players[playerId] = nil
	
	TriggerClientEvent('infinity:updatePlayers', -1, Players)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToTable()
		end)
	end
end)

function AddPlayerToTable(xPlayer, update)
	local playerId = xPlayer.source

	Players.Count = GetNumPlayerIndices()

	Players[playerId]			 = {}
	Players[playerId].id		 = playerId

	Players[playerId].position	 = GetEntityCoords(GetPlayerPed(playerId))
	Players[playerId].heading	 = GetEntityHeading(GetPlayerPed(playerId))

	Players[playerId].steamName  = GetPlayerName(playerId)
	Players[playerId].name  	 = xPlayer.getName()

	Players[playerId].group		 = xPlayer.getGroup()
	Players[playerId].job		 = xPlayer.getJob()
	Players[playerId].org		 = xPlayer.getOrg()

	if update then
		TriggerClientEvent('infinity:updatePlayers', -1, Players)
	end
end

function AddPlayersToTable()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToTable(xPlayer, false)
	end

	TriggerClientEvent('infinity:updatePlayers', -1, Players)
end

ESX.RegisterServerCallback('infinity:updatePlyPos', function(source, cb, id)
	cb(GetEntityCoords(GetPlayerPed(id)))
end)