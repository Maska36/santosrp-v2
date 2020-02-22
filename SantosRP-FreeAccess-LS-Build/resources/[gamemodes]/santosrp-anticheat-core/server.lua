ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent('santoscheat:ban')
AddEventHandler('santoscheat:ban', function(reason, eventName)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == 'user' then
			if eventName and reason then
				TriggerEvent('SendToDiscord', source, "Ban Client", "**"..GetPlayerName(source).."** à été ban du serveur psk l'anti cheat a trigger son event pété au sol aka: "..eventName.."\n**Raison:** "..reason, 16007897, "cheat")
				TriggerEvent('BanSql:Ban', source, reason)
			else
				return
			end
		end
	end
end)

-- local BlockedExplosions = { 1, 2, 3, 4, 5, 6, 25, 32, 33, 35, 36, 37, 38 }
recentExplosions = {}

Citizen.CreateThread(function()
	while true do 
		Wait(2000)
		clientExplosionCount = {}
		for i, expl in ipairs(recentExplosions) do 
			if not clientExplosionCount[expl.sender] then clientExplosionCount[expl.sender] = 0 end
			clientExplosionCount[expl.sender] = clientExplosionCount[expl.sender]+1
			table.remove(recentExplosions,i)
		end 
		recentExplosions = {}
		for c, count in pairs(clientExplosionCount) do 
			if count > 1 then
				TriggerEvent("SendToDiscord", c, "EXPLOSION DETECTED", "**EXPLOSION PAR:** "..GetPlayerName(c).."\nSpawned "..count.." Explosions in <2s.", 65280, "cheat")
			end
		end
	end
end)

Citizen.CreateThread(function()
	AddEventHandler('explosionEvent', function(sender, ev)
		if ev.damageScale ~= 0.0 and ev.ownerNetId == 0 then -- make sure component is enabled, damage isnt 0 and owner is the sender
			ev.time = os.time()
			table.insert(recentExplosions, {sender = sender, data = ev})
			CancelEvent()
			return
		end
	end)
end)