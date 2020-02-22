ESX = nil
local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local liquide = 1
local batterie = 1

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'cigelec', 'Vape', 'society_cigelec', 'society_cigelec', 'society_cigelec', {type = 'private'})

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)

		if zone == "NicotineFarm" then
			local itemQuantity = xPlayer.getInventoryItem('nicotine').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('nicotine', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_cigelecjob:startHarvest')
AddEventHandler('esx_cigelecjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_cigelecjob:stopHarvest')
AddEventHandler('esx_cigelecjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source] = false
	else
		PlayersHarvesting[_source] = true
	end
end)

local function Transform(source, zone)
	if PlayersTransforming[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)

		if zone == "TraitementLiquide" then
			local itemQuantity = xPlayer.getInventoryItem('nicotine').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisin'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('nicotine', 1)
					xPlayer.addInventoryItem('liquide', 1)
				
					Transform(source, zone)
				end)
			end
		elseif zone == "TraitementBatterie" then
			local itemQuantity = xPlayer.getInventoryItem('nicotine').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisin'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('nicotine', 1)
					xPlayer.addInventoryItem('batterie', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_cigelecjob:startTransform')
AddEventHandler('esx_cigelecjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_cigelecjob:stopTransform')
AddEventHandler('esx_cigelecjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)
	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('liquide').count <= 0 then
				liquide = 0
			else
				liquide = 1
			end
			
			if xPlayer.getInventoryItem('batterie').count <= 0 then
				batterie = 0
			else
				batterie = 1
			end
		
			if liquide == 0 and batterie == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('liquide').count <= 0 and batterie == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_vin_sale'))
				liquide = 0
				return
			elseif xPlayer.getInventoryItem('batterie').count <= 0 and liquide == 0then
				TriggerClientEvent('esx:showNotification', source, _U('no_jus_sale'))
				batterie = 0
				return
			else
				if (batterie == 1) then
					SetTimeout(1100, function()
						local money = math.random(57,87)
						xPlayer.removeInventoryItem('batterie', 2)

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cigelec', function(account)
							if account ~= nil then
								account.addMoney(money)
								TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
							end
						end)
						Sell(source, zone)
					end)
				elseif (liquide == 1) then
					SetTimeout(1100, function()
						local money = math.random(120,170)
						xPlayer.removeInventoryItem('liquide', 3)

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cigelec', function(account)
							if account ~= nil then
								account.addMoney(money)
								TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
							end
						end)
						Sell(source, zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_cigelecjob:startSell')
AddEventHandler('esx_cigelecjob:startSell', function(zone)
	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_cigelecjob:stopSell')
AddEventHandler('esx_cigelecjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, '~r~Vous êtes sortis de la zone')
	else
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_cigelecjob:getStockItem')
AddEventHandler('esx_cigelecjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cigelec', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_cigelecjob:getStockItems', function(source, cb)
	TriggerEvent('esx_cigelecjob:getSharedInventory', 'society_cigelec', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_cigelecjob:putStockItems')
AddEventHandler('esx_cigelecjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cigelec', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_cigelecjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items
	})
end)