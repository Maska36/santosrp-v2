ESX = nil
local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local gpu = 1
local cm = 1

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'pcmaker', _U('vigneron_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'pcmaker', 'Vendeur Informatique', 'society_pcmaker', 'society_pcmaker', 'society_pcmaker', {type = 'private'})

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)

		if zone == "CircuitFarm" then
			local itemQuantity = xPlayer.getInventoryItem('circuit').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('circuit', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_pcmakerjob:startHarvest')
AddEventHandler('esx_pcmakerjob:startHarvest', function(zone)
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

RegisterServerEvent('esx_pcmakerjob:stopHarvest')
AddEventHandler('esx_pcmakerjob:stopHarvest', function()
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

		if zone == "TraitementGPU" then
			local itemQuantity = xPlayer.getInventoryItem('circuit').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisin'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('circuit', 1)
						xPlayer.addInventoryItem('cpu', 1)
						TriggerClientEvent('esx:showNotification', source, _U('grand_cru'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('circuit', 1)
						xPlayer.addInventoryItem('gpu', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementCM" then
			local itemQuantity = xPlayer.getInventoryItem('circuit').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisin'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('circuit', 1)
					xPlayer.addInventoryItem('cm', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_pcmakerjob:startTransform')
AddEventHandler('esx_pcmakerjob:startTransform', function(zone)
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

RegisterServerEvent('esx_pcmakerjob:stopTransform')
AddEventHandler('esx_pcmakerjob:stopTransform', function()
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
			if xPlayer.getInventoryItem('gpu').count <= 0 then
				gpu = 0
			else
				gpu = 1
			end
			
			if xPlayer.getInventoryItem('cm').count <= 0 then
				cm = 0
			else
				cm = 1
			end
		
			if gpu == 0 and cm == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('gpu').count <= 0 and cm == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_vin_sale'))
				gpu = 0
				return
			elseif xPlayer.getInventoryItem('cm').count <= 0 and gpu == 0then
				TriggerClientEvent('esx:showNotification', source, _U('no_jus_sale'))
				cm = 0
				return
			else
				if (cm == 1) then
					SetTimeout(1100, function()
						local money = math.random(57,87)
						xPlayer.removeInventoryItem('cm', 2)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pcmaker', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (gpu == 1) then
					SetTimeout(1100, function()
						local money = math.random(120,170)
						xPlayer.removeInventoryItem('gpu', 3)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pcmaker', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_pcmakerjob:startSell')
AddEventHandler('esx_pcmakerjob:startSell', function(zone)
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

RegisterServerEvent('esx_pcmakerjob:stopSell')
AddEventHandler('esx_pcmakerjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, '~r~Vous êtes sortis de la zone')
	else
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_pcmakerjob:getStockItem')
AddEventHandler('esx_pcmakerjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pcmaker', function(inventory)
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

ESX.RegisterServerCallback('esx_pcmakerjob:getStockItems', function(source, cb)
	TriggerEvent('esx_pcmakerjob:getSharedInventory', 'society_pcmaker', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_pcmakerjob:putStockItems')
AddEventHandler('esx_pcmakerjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pcmaker', function(inventory)
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

ESX.RegisterServerCallback('esx_pcmakerjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items
	})
end)