ESX 						   = nil
local PlayersHarvestingKoda    = {}
local PlayersTransformingKoda  = {}
local PlayersSellingKoda       = {}

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

local function HarvestKoda(source)

	SetTimeout(Config.TimeToFarm, function()
		if PlayersHarvestingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local koda = xPlayer.getInventoryItem('orange')

			if koda.limit ~= -1 and koda.count >= koda.limit then
				TriggerClientEvent('esx:showNotification', source, _U('bag_full'))
			else
				xPlayer.addInventoryItem('orange', 1)
				HarvestKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_farmoranges:startHarvestKoda')
AddEventHandler('esx_farmoranges:startHarvestKoda', function()
	local _source = source

	if not PlayersHarvestingKoda[_source] then
		PlayersHarvestingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('take_orange'))
		HarvestKoda(_source)
	else
		print(('esx_farmoranges: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_farmoranges:stopHarvestKoda')
AddEventHandler('esx_farmoranges:stopHarvestKoda', function()
	local _source = source

	PlayersHarvestingKoda[_source] = false
end)

local function TransformKoda(source)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersTransformingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local kodaQuantity = xPlayer.getInventoryItem('orange').count
			local pooch = xPlayer.getInventoryItem('juice_orange')

			if pooch.limit ~= -1 and pooch.count >= pooch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_enough_oranges'))
			elseif kodaQuantity < 2 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_any_more_oranges'))
			else
				xPlayer.removeInventoryItem('orange', 2)
				xPlayer.addInventoryItem('juice_orange', 1)

				TransformKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_farmoranges:startTransformKoda')
AddEventHandler('esx_farmoranges:startTransformKoda', function()
	local _source = source

	if not PlayersTransformingKoda[_source] then
		PlayersTransformingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('transform_juice_orange'))
		TransformKoda(_source)
	else
		print(('esx_farmoranges: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_farmoranges:stopTransformKoda')
AddEventHandler('esx_farmoranges:stopTransformKoda', function()
	local _source = source

	PlayersTransformingKoda[_source] = false
end)

local function SellKoda(source)

	SetTimeout(Config.TimeToSell, function()
		if PlayersSellingKoda[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local poochQuantity = xPlayer.getInventoryItem('juice_orange').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_juice_orange'))
			else
				xPlayer.removeInventoryItem('juice_orange', 1)
				xPlayer.addAccountMoney('bank', 20)
				TriggerClientEvent('esx:showNotification', source, _U('sell_juice'))

				SellKoda(source)
			end
		end
	end)
end

RegisterServerEvent('esx_farmoranges:startSellKoda')
AddEventHandler('esx_farmoranges:startSellKoda', function()
	local _source = source

	if not PlayersSellingKoda[_source] then
		PlayersSellingKoda[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('sell_juice_orange'))
		SellKoda(_source)
	else
		print(('esx_farmoranges: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_farmoranges:stopSellKoda')
AddEventHandler('esx_farmoranges:stopSellKoda', function()
	local _source = source

	PlayersSellingKoda[_source] = false
end)

RegisterServerEvent('esx_farmoranges:GetUserInventory')
AddEventHandler('esx_farmoranges:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_farmoranges:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('orange').count,
		xPlayer.getInventoryItem('juice_orange').count,
		xPlayer.job.name,
		currentZone
	)
end)

ESX.RegisterUsableItem('orange', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('orange', 1)

	TriggerClientEvent('esx_farmoranges:onPot', _source)
	TriggerClientEvent('esx:showNotification', _source, _U('used_one_koda'))
end)
