ESX = nil
local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local orp = 1

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'orpailleurs', _U('orpailleurs_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'orpailleurs', 'Orpailleurs', 'society_orpailleurs', 'society_orpailleurs', 'society_orpailleurs', {type = 'private'})

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if xPlayer then
			if zone == "PepiteDorFarm" then
				local itemQuantity = xPlayer.getInventoryItem('pepite_dor').count
				if itemQuantity >= 100 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
					return
				else
					SetTimeout(1800, function()
						xPlayer.addInventoryItem('pepite_dor', 1)
						Harvest(source, zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_orpailleurs:startHarvest')
AddEventHandler('esx_orpailleurs:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('pepite_dor_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_orpailleurs:stopHarvest')
AddEventHandler('esx_orpailleurs:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, zone)
    if PlayersTransforming[source] == true then
        local xPlayer  = ESX.GetPlayerFromId(source)

		if xPlayer then
	        if zone == "TraitementLingotDor" then
	            local itemQuantity = xPlayer.getInventoryItem('pepite_dor').count

	            if itemQuantity <= 0 then
	                TriggerClientEvent('esx:showNotification', source, _U('not_enough_pepitedor'))
	                return
	            else
	                SetTimeout(1800, function()
	                    xPlayer.removeInventoryItem('pepite_dor', 1)
	                    xPlayer.addInventoryItem('lingot_dor', 1)

	                    Transform(source, zone)
	                end)
	            end
	        end
	    end
    end
end

RegisterServerEvent('esx_orpailleurs:startTransform')
AddEventHandler('esx_orpailleurs:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_orpailleurs:stopTransform')
AddEventHandler('esx_orpailleurs:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer vos pepitesdor')
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)
	if PlayersSelling[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)
		
		if xPlayer then
			if zone == 'SellFarm' then
				if xPlayer.getInventoryItem('lingot_dor').count <= 0 then
					orp = 0
				else
					orp = 1
				end

				if orp == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
					return
				elseif xPlayer.getInventoryItem('lingot_dor').count <= 0 and argent == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_orp_sale'))
					orp = 0
					return
				elseif orp == 1 then
					SetTimeout(1100, function()
						local money = math.random(85,115)
						xPlayer.removeInventoryItem('lingot_dor', 2)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_orpailleurs', function(account)
							societyAccount = account
						end)
							
						if societyAccount then
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

RegisterServerEvent('esx_orpailleurs:startSell')
AddEventHandler('esx_orpailleurs:startSell', function(zone)
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

RegisterServerEvent('esx_orpailleurs:stopSell')
AddEventHandler('esx_orpailleurs:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_orpailleurs:getStockItem')
AddEventHandler('esx_orpailleurs:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleurs', function(inventory)

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

ESX.RegisterServerCallback('esx_orpailleurs:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleurs', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_orpailleurs:putStockItems')
AddEventHandler('esx_orpailleurs:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleurs', function(inventory)
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

ESX.RegisterServerCallback('esx_orpailleurs:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({ items = items })
end)