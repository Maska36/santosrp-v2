ESX = nil
local PlayersHarvesting  = {}
local PlayersCrafting = {}
local PlayersCrafting2 = {}
local PlayersCrafting3 = {}
local Vehicles = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'mechanic', _U('mechanic'), true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'public'})

RegisterServerEvent('mechjob:annonce')
AddEventHandler('mechjob:annonce', function(result)
	local xPlayers = ESX.GetPlayers()
	local text = result
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "MECANO", "Annonce", text, "CHAR_CARSITE3", 4)
	end
end)

RegisterServerEvent('mechjob:buyMod')
AddEventHandler('mechjob:buyMod', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		if account.money >= price then
			account.removeMoney(price)
			TriggerClientEvent('mechjob:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
		else
			TriggerClientEvent('mechjob:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
    	end
  	end)
end)

function Harvest(source,item)
	if PlayersHarvesting[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)
		local CaroToolQuantity = 0
		CaroToolQuantity = xPlayer.getInventoryItem(item).count
		if CaroToolQuantity < 5 then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
				if account.money >= Config.BuyItems then
					account.removeMoney(Config.BuyItems)
					xPlayer.addInventoryItem(item, 1)
					CaroToolQuantity = xPlayer.getInventoryItem(item).count
					TriggerEvent('mechjob:stopHarvest', source)
				end
			end)
		end
	end
end

RegisterServerEvent('mechjob:startHarvest')
AddEventHandler('mechjob:startHarvest', function(item)
	local _source = source
	local _item = item
	PlayersHarvesting[_source] = true
	Harvest(_source,_item)
end)

RegisterServerEvent('mechjob:stopHarvest')
AddEventHandler('mechjob:stopHarvest', function()
	local _source = source
	PlayersHarvesting[_source] = false
end)

local function Craft(source)
	SetTimeout(4000, function()

		if PlayersCrafting[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local GazBottleQuantity = xPlayer.getInventoryItem('gazbottle').count
			if GazBottleQuantity > 0 then
				xPlayer.removeInventoryItem('gazbottle', 1)
				xPlayer.addInventoryItem('blowpipe', 1)
				Craft(source)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_gas_can'))
				PlayersCrafting[source] = false
			end
		end

	end)
end

RegisterServerEvent('mechjob:startCraft')
AddEventHandler('mechjob:startCraft', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_blowtorch'))
	Craft(_source)
end)

RegisterServerEvent('mechjob:stopCraft')
AddEventHandler('mechjob:stopCraft', function()
	local _source = source
	PlayersCrafting[_source] = false
end)

local function Craft2(source)
	SetTimeout(4000, function()

		if PlayersCrafting2[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local FixToolQuantity = xPlayer.getInventoryItem('fixtool').count

			if FixToolQuantity > 0 then
				xPlayer.removeInventoryItem('fixtool', 1)
				xPlayer.addInventoryItem('fixkit', 1)
				Craft2(source)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_repair_tools'))
				PlayersCrafting2[source] = false
			end
		end

	end)
end

RegisterServerEvent('mechjob:startCraft2')
AddEventHandler('mechjob:startCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_repair_kit'))
	Craft2(_source)
end)

RegisterServerEvent('mechjob:stopCraft2')
AddEventHandler('mechjob:stopCraft2', function()
	local _source = source
	PlayersCrafting2[_source] = false
end)

local function Craft3(source)
	SetTimeout(4000, function()

		if PlayersCrafting3[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			local CaroToolQuantity = xPlayer.getInventoryItem('carotool').count

			if CaroToolQuantity > 0 then
				xPlayer.removeInventoryItem('carotool', 1)
				xPlayer.addInventoryItem('carokit', 1)
				Craft3(source)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_body_tools'))
				PlayersCrafting3[source] = false
			end
		end

	end)
end

RegisterServerEvent('mechjob:startCraft3')
AddEventHandler('mechjob:startCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = true
	TriggerClientEvent('esx:showNotification', _source, _U('assembling_body_kit'))
	Craft3(_source)
end)

RegisterServerEvent('mechjob:setJob')
AddEventHandler('mechjob:setJob', function(identifier, job, grade)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if xTarget then
		xTarget.setJob(job, grade)
	end
end)


RegisterServerEvent('mechjob:stopCraft3')
AddEventHandler('mechjob:stopCraft3', function()
	local _source = source
	PlayersCrafting3[_source] = false
end)

RegisterServerEvent('mechjob:getStockItem')
AddEventHandler('mechjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('mechjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('mechjob:forceBlip')
AddEventHandler('mechjob:forceBlip', function()
	TriggerClientEvent('mechjob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('mechjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'mechanic')
	end
end)

RegisterServerEvent('mechjob:message')
AddEventHandler('mechjob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('mechjob:putStockItems')
AddEventHandler('mechjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
	end)
end)

ESX.RegisterServerCallback('mechjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent('mechjob:SVdestroyDoor')
AddEventHandler('mechjob:SVdestroyDoor', function()
	local id = source
	TriggerClientEvent('mechjob:destroyDoor', id)
end)

RegisterServerEvent('mechjob:refreshOwnedVehicle')
AddEventHandler('mechjob:refreshOwnedVehicle', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('mechjob: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)

ESX.RegisterServerCallback('mechjob:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

ESX.RegisterUsableItem('blowpipe', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('blowpipe', 1)

	TriggerClientEvent('mechjob:onHijack', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_blowtorch'))
end)

ESX.RegisterUsableItem('fixkit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fixkit', 1)

	TriggerClientEvent('mechjob:onFixkit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))
end)

ESX.RegisterUsableItem('carokit', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('carokit', 1)

	TriggerClientEvent('mechjob:onCarokit', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))
end)

