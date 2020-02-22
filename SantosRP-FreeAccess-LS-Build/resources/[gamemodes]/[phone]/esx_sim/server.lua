ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent('BuyPhone')
AddEventHandler('BuyPhone', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = "1000"

	if xPlayer.getInventoryItem('phone').count < 5 then
		if xPlayer.getMoney() >= tonumber(price) then
	     	xPlayer.removeMoney(tonumber(price))
	  		xPlayer.addInventoryItem('phone', 1)
			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez acheté un iPhone X !")
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous avez déjà 5 iPhone sur vous.")
	end
end)

RegisterServerEvent('BuySIM')
AddEventHandler('BuySIM', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = "20"
	phoneNumber = GenerateUniquePhoneNumber()

	if xPlayer.getMoney() >= tonumber(price) then
	    xPlayer.removeMoney(tonumber(price))
		TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez acheté une carte SIM !")
	    TriggerClientEvent('santos_menuperso:UpdateNumber', _source, phoneNumber)
	    MySQL.Async.execute('INSERT INTO user_sim (identifier,number,label) VALUES(@identifier,@phone_number,@label)', {
	        ['@identifier']   = xPlayer.identifier,
	        ['@phone_number'] = phoneNumber,
	        ['@label'] = "SIM "..phoneNumber,
	    })
	    TriggerClientEvent("esx:showNotification", _source, "~y~Nouvelle carte SIM : " .. phoneNumber)      
	    TriggerClientEvent("santos_menuperso:syncSim", _source)
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
	end
end)

function GenerateUniquePhoneNumber()
    local running = true
    local phone = nil
    while running do
        local rand = '555' .. math.random(1111,9999)
        local count = MySQL.Sync.fetchScalar("SELECT COUNT(number) FROM user_sim WHERE number = @phone_number", { ['@phone_number'] = rand })
        if count < 1 then
            phone = rand
            running = false
        end
    end
    return phone
end

-- RegisterServerEvent('BuySIM')
-- AddEventHandler('BuySIM', function()
--     local _source = source
--     local xPlayer = ESX.GetPlayerFromId(_source)

-- 	if xPlayer.getMoney() >= 50 then
-- 		local result = MySQL.Sync.fetchAll('SELECT sim_number, sim2_number FROM users WHERE identifier = @identifier', {
-- 			['@identifier'] = xPlayer.identifier
-- 		})
-- 		local sim = result[1].sim_number
-- 		local sim2 = result[1].sim2_number

-- 		if sim == nil and sim2 == nil then
-- 			local simNumber = getPhoneRandomNumber()
-- 			MySQL.Async.execute('UPDATE users SET sim_number = @sim_number WHERE identifier = @identifier', {
-- 				['@sim_number'] = simNumber,
-- 				['@identifier'] = xPlayer.identifier
-- 			}, function(rowsChanged)
--     			xPlayer.removeMoney(50)
--     			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez acheté une SIM !")
-- 			end)
-- 		elseif sim ~= nil and sim2 == nil then
-- 			local sim2Number = getPhoneRandomNumber()
-- 			MySQL.Async.execute('UPDATE users SET sim2_number = @sim2_number WHERE identifier = @identifier', {
-- 				['@sim2_number'] = sim2Number,
-- 				['@identifier'] = xPlayer.identifier
-- 			}, function(rowsChanged)
--     			xPlayer.removeMoney(50)
--     			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez acheté une deuxième SIM !")
-- 			end)
-- 		elseif sim ~= nil and sim2 ~= nil then
--     		TriggerClientEvent('esx:showNotification', _source, "~r~Vous avez déja deux sims.")
-- 		end
--     else
--     	TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas assez d'argent.")
--     end
-- end)