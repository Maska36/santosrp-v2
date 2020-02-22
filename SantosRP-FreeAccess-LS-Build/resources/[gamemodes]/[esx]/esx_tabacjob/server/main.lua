ESX = nil
local PlayersTransforming = {}
local PlayersSelling = {}
local PlayersHarvesting = {}
local cm = 1

TriggerEvent('esx:getSO', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'tabac', 'Tabac', 'society_tabac', 'society_tabac', 'society_tabac', {type = 'private'})

local function Harvest(source, zone)
  if PlayersHarvesting[source] == true then
    local xPlayer  = ESX.GetPlayerFromId(source)

    if zone == "TabacFarm" then
      local itemQuantity = xPlayer.getInventoryItem('tabacblond').count
      if itemQuantity >= 100 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
        return
      else
        SetTimeout(1800, function()
          xPlayer.addInventoryItem('tabacblond', 1)
          Harvest(source, zone)
        end)
      end
    end
  end
end

RegisterServerEvent('esx_tabac:startHarvest')
AddEventHandler('esx_tabac:startHarvest', function(zone)
  local _source = source
    
  if PlayersHarvesting[_source] == false then
    TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
    PlayersHarvesting[_source] = false
  else
    PlayersHarvesting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
    Harvest(_source,zone)
  end
end)

RegisterServerEvent('esx_tabac:stopHarvest')
AddEventHandler('esx_tabac:stopHarvest', function()
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

    if zone == "TraitementTabac" then
      local itemQuantity = xPlayer.getInventoryItem('tabacblond').count
      
      if itemQuantity <= 0 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_tabac'))
        return
      else
        local rand = math.random(0,100)
        if (rand >= 98) then
          SetTimeout(1800, function()
            xPlayer.removeInventoryItem('tabacblond', 1)
            xPlayer.addInventoryItem('cigare', 1)
            TriggerClientEvent('esx:showNotification', source, _U('grand_cru'))

            Transform(source, zone)
          end)
        else
          SetTimeout(1800, function()
            xPlayer.removeInventoryItem('tabacblond', 1)
            xPlayer.addInventoryItem('tabacblondsec', 1)
        
            Transform(source, zone)
          end)
        end
      end
    elseif zone == "TraitementCigarette" then
      local itemQuantity = xPlayer.getInventoryItem('tabacblondsec').count
      if itemQuantity <= 0 then
        TriggerClientEvent('esx:showNotification', source, _U('not_enough_tabacsec'))
        return
      else
        SetTimeout(1800, function()
          xPlayer.removeInventoryItem('tabacblondsec', 1)
          xPlayer.addInventoryItem('malbora', 1)
      
          Transform(source, zone)   
        end)
      end
    end
  end 
end

RegisterServerEvent('esx_tabac:startTransform')
AddEventHandler('esx_tabac:startTransform', function(zone)
  local _source = source
    
  if PlayersTransforming[_source] == false then
    TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch~w~')
    PlayersTransforming[_source] = false
  else
    PlayersTransforming[_source] = true
    TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
    Transform(_source,zone)
  end
end)

RegisterServerEvent('esx_tabac:stopTransform')
AddEventHandler('esx_tabac:stopTransform', function()
  local _source = source
  
  if PlayersTransforming[_source] == true then
    PlayersTransforming[_source] = false
  else
    PlayersTransforming[_source] = true
  end
end)

local function Sell(source, zone)
  if PlayersSelling[source] == true then
    local xPlayer  = ESX.GetPlayerFromId(source)
    
    if zone == 'SellFarm' then
      if xPlayer.getInventoryItem('malbora').count <= 0 then
        cm = 0
      else
        cm = 1
      end
    
      if cm == 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
        return
      elseif xPlayer.getInventoryItem('malbora').count <= 0 then
        TriggerClientEvent('esx:showNotification', source, _U('no_jus_sale'))
        cm = 0
        return
      else
        if (cm == 1) then
          SetTimeout(1100, function()
            local money = math.random(57,87)
            xPlayer.removeInventoryItem('malbora', 2)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tabac', function(account)
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

RegisterServerEvent('esx_tabac:startSell')
AddEventHandler('esx_tabac:startSell', function(zone)
  local _source = source
  
  if PlayersSelling[_source] == false then
    TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
    PlayersSelling[_source] = false
  else
    PlayersSelling[_source] = true
    TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
    Sell(_source, zone)
  end
end)

RegisterServerEvent('esx_tabac:stopSell')
AddEventHandler('esx_tabac:stopSell', function()
  local _source = source
  
  if PlayersSelling[_source] == true then
    PlayersSelling[_source] = false
    TriggerClientEvent('esx:showNotification', _source, '~r~Vous êtes sortis de la zone')
  else
    PlayersSelling[_source] = true
  end
end)

RegisterServerEvent('esx_tabac:getStockItem')
AddEventHandler('esx_tabac:getStockItem', function(itemName, count)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)
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

ESX.RegisterServerCallback('esx_tabac:getStockItems', function(source, cb)
  TriggerEvent('esx_tabac:getSharedInventory', 'society_tabac', function(inventory)
    cb(inventory.items)
  end)
end)

RegisterServerEvent('esx_tabac:putStockItems')
AddEventHandler('esx_tabac:putStockItems', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tabac', function(inventory)
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

ESX.RegisterServerCallback('esx_tabac:getPlayerInventory', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local items = xPlayer.inventory

  cb({
    items = items
  })
end)