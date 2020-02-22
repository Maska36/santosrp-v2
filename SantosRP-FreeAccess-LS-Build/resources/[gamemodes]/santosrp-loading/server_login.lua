
-- Custom event gets called when a client joins
RegisterServerEvent('foundation:onPlayerConnect')
AddEventHandler('foundation:onPlayerConnect', function()
	local name = GetPlayerName(source)
	
	print('Player ' .. name .. ' connecting with playerId ' .. source)
	
	TriggerClientEvent('foundation:playerLog', source, true)
end)

-- Hook into the chat event to handle messages (requires chat resource)
AddEventHandler('chatMessageEntered', function(name, color, message)
    if message:sub(1, 1) == '!' and string.len(message) >= 2 then
		print("Executed command: " .. message .. " by " .. name)
		
		if message == "!login" then
			TriggerClientEvent('foundation:playerLog', source, false)
			TriggerClientEvent('chatMessage', source, '', { 255, 255, 255 }, "Successfully logged in")
		end
	end
end)
