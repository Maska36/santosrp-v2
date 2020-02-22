ESX = nil
local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local CopsConnected = 0

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

function CountCops()
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end
CountCops()

local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer ~= nil then
			local item = nil

			if zone == "WeedFarm" and CopsConnected >= 1 then
				item = "weed"
			elseif zone == "MethFarm" and CopsConnected >= 2 then
				item = "meth"
			elseif zone == "CocaineFarm" and CopsConnected >= 3 then
				item = "coke"
			elseif zone == "OpiumFarm" and CopsConnected >= 5 then
				item = "opium"
			else
				item = nil
				return
			end

			if item ~= nil then
				local itemQuantity = xPlayer.getInventoryItem(item).count
				if itemQuantity >= 100 then
					TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez plus de place sur vous..")
					return
				else
					SetTimeout(1800, function()
						xPlayer.addInventoryItem(item, 1)
						Harvest(source, zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_illegal_drugs:startFarm')
AddEventHandler('esx_illegal_drugs:startFarm', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_illegal_drugs:stopFarm')
AddEventHandler('esx_illegal_drugs:stopFarm', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source] = false
	else
		PlayersHarvesting[_source] = true
	end
end)

local function Transform(source, zone)
	if PlayersTransforming[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)
			
		if xPlayer ~= nil then
			local item = nil

			if zone == "WeedTraitement" and CopsConnected >= 2 then
				item = "weed"
			elseif zone == "MethTraitement" and CopsConnected >= 3 then
				item = "meth"
			elseif zone == "CocaineTraitement" and CopsConnected >= 5 then
				item = "coke"
			elseif zone == "OpiumTraitement" and CopsConnected >= 7 then
				item = "opium"
			else
				item = nil
				return
			end

			if item ~= nil then
				local itemQuantity = xPlayer.getInventoryItem(item).count
				if itemQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez plus assez de drogue a traiter..")
					return
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem(item, 1)
						xPlayer.addInventoryItem(item..'_pooch', 1)
			
						Transform(source, zone)	  
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_illegal_drugs:startTraitement')
AddEventHandler('esx_illegal_drugs:startTraitement', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		PlayersTransforming[_source] = false
	else
		PlayersTransforming[_source] = true
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_illegal_drugs:startTraitement')
AddEventHandler('esx_illegal_drugs:startTraitement', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source] = false		
	else
		PlayersTransforming[_source] = true
	end
end)

local function Sell(source, zone)
	if PlayersSelling[source] == true then
		local xPlayer = ESX.GetPlayerFromId(source)
			
		if xPlayer ~= nil then
			local item = nil
			local money = nil

			if zone == "WeedSell" and CopsConnected >= 3 then
				item = "weed_pooch"
				money = 45 + CopsConnected * 0.25
			elseif zone == "MethSell" and CopsConnected >= 4 then
				item = "meth_pooch"
				money = 73 + CopsConnected * 1.05
			elseif zone == "CocaineSell" and CopsConnected >= 6 then
				item = "coke_pooch"
				money = 125 + CopsConnected * 1.25
			elseif zone == "OpiumSell" and CopsConnected >= 9 then
				item = "opium_pooch"
				money = 349 + CopsConnected * 2.25
			else
				item = nil
				return
			end

			if item ~= nil then
				local itemQuantity = xPlayer.getInventoryItem(item).count
				if itemQuantity <= 2 then
					TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez rien a vendre..")
					return
				else
					SetTimeout(1100, function()
						xPlayer.removeInventoryItem(item, 3)
						xPlayer.addAccountMoney('black_money', money)

						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_illegal_drugs:startSell')
AddEventHandler('esx_illegal_drugs:startSell', function(zone)
	local _source = source
	
	if PlayersSelling[_source] == false then
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_illegal_drugs:stopSell')
AddEventHandler('esx_illegal_drugs:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source] = false		
	else
		PlayersSelling[_source] = true
	end
end)