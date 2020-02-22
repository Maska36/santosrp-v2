-- RegisterCommand('me', function(playerId, args, rawCommand)
-- 	if playerId == 0 then
--     	print('3dme: you can\'t use this command from console!')
--   	else
--   		local text = table.concat(args, ' ')

-- 		if text ~= nil or text ~= "" then
--   			shareDisplay(playerId, text)
--   		end
--   	end
-- end, false)

function shareDisplay(playerId, text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, playerId)
end