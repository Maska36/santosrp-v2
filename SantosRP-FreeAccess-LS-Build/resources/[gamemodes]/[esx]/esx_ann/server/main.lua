ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent('esx_ann:annonce')
AddEventHandler('esx_ann:annonce', function(text, boolE)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayers.get('firstName')
	local isAno = boolE

	if isAno == false then
		if xPlayer.getMoney() >= 250 then
			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez payé $250 l'annonce")
			TriggerClientEvent('esx:showAdvancedNotification', -1, "ANNONCE", name, text, "CHAR_LIFEINVADER", 4)
			TriggerEvent('SendToDiscord', source, "ANNONCE", "**"..GetPlayerName(source).."/"..name.."** à fait une annonce: "..text, 16007897, "chat")
			xPlayer.removeMoney(250)
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
		end
	elseif isAno == true then
		if xPlayer.getMoney() >= 500 then
			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez payé $500 l'annonce")
			TriggerClientEvent('esx:showAdvancedNotification', -1, "ANNONCE", "Anonyme", text, "CHAR_ARTHUR", 4)
			TriggerEvent('SendToDiscord', source, "ANNONCE ANONYME", "**"..GetPlayerName(source).."/"..name.."** à fait une annonce: "..text, 16007897, "chat")
			xPlayer.removeMoney(500)
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
		end
	end
end)