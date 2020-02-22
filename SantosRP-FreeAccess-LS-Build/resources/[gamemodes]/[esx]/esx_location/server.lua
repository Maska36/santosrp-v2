ESX                			 = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent('esx_location:buy')
AddEventHandler('esx_location:buy', function(price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(price)
    TriggerClientEvent('esx:showNotification', _source, '~g~Bonne route !')
end)