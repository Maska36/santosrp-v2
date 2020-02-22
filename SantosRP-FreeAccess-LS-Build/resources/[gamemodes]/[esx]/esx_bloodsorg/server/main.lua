ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'bloods', 'Bloods', 'society_bloods', 'society_bloods', 'society_bloods', {type = 'public'})

RegisterServerEvent('esx_bloodsjob:confiscatePlayerItem')
AddEventHandler('esx_bloodsjob:confiscatePlayerItem', function(target, itemType, itemName, amount)
  local _source = source
  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if sourceXPlayer.org.name ~= 'bloods' then
    print(('esx_bloodsjob: %s attempted to confiscate!'):format(xPlayer.identifier))
    return
  end

  if itemType == 'item_standard' then
    local targetItem = targetXPlayer.getInventoryItem(itemName)
    local sourceItem = sourceXPlayer.getInventoryItem(itemName)

    -- does the target player have enough in their inventory?
    if targetItem.count > 0 and targetItem.count <= amount then

      -- can the player carry the said amount of x item?
      if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
        TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
      else
        targetXPlayer.removeInventoryItem(itemName, amount)
        sourceXPlayer.addInventoryItem   (itemName, amount)
        TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
        TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
      end
    else
      TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
    end

  elseif itemType == 'item_account' then
    targetXPlayer.removeAccountMoney(itemName, amount)
    sourceXPlayer.addAccountMoney   (itemName, amount)

    TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

  elseif itemType == 'item_weapon' then
    if amount == nil then amount = 0 end
      targetXPlayer.removeWeapon(itemName, amount)
      sourceXPlayer.addWeapon   (itemName, amount)

      TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
      TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
    end
end)

RegisterServerEvent('esx_bloodsjob:handcuff')
AddEventHandler('esx_bloodsjob:handcuff', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.org.name == 'bloods' then
    TriggerClientEvent('esx_bloodsjob:handcuff', target)
  else
    print(('esx_bloodsjob: %s attempted to handcuff a player (not bloods)!'):format(xPlayer.identifier))
  end
end)

RegisterServerEvent('esx_bloodsjob:drag')
AddEventHandler('esx_bloodsjob:drag', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.org.name == 'bloods' then
    TriggerClientEvent('esx_bloodsjob:drag', target, source)
  else
    print(('esx_bloodsjob: %s attempted to drag (not bloods)!'):format(xPlayer.identifier))
  end
end)

RegisterServerEvent('esx_bloodsjob:putInVehicle')
AddEventHandler('esx_bloodsjob:putInVehicle', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.org.name == 'bloods' then
    TriggerClientEvent('esx_bloodsjob:putInVehicle', target)
  else
    print(('esx_bloodsjob: %s attempted to put in vehicle (not bloods)!'):format(xPlayer.identifier))
  end
end)

RegisterServerEvent('esx_bloodsjob:OutVehicle')
AddEventHandler('esx_bloodsjob:OutVehicle', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.org.name == 'bloods' then
    TriggerClientEvent('esx_bloodsjob:OutVehicle', target)
  else
    print(('esx_bloodsjob: %s attempted to drag out from vehicle (not bloods)!'):format(xPlayer.identifier))
  end
end)

RegisterServerEvent('esx_bloodsjob:getStockItem')
AddEventHandler('esx_bloodsjob:getStockItem', function(itemName, count)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bloods', function(inventory)
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

RegisterServerEvent('esx_bloodsjob:putStockItems')
AddEventHandler('esx_bloodsjob:putStockItems', function(itemName, count)
  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bloods', function(inventory)
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

ESX.RegisterServerCallback('esx_bloodsjob:getOtherPlayerData', function(source, cb, target)
  if Config.EnableESXIdentity then
    local xPlayer = ESX.GetPlayerFromId(target)
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
      ['@identifier'] = xPlayer.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname
    local sex       = result[1].sex
    local dob       = result[1].dateofbirth
    local height    = result[1].height

    local data = {
      name      = GetPlayerName(target),
      job       = xPlayer.job,
      org       = xPlayer.org,
      inventory = xPlayer.inventory,
      accounts  = xPlayer.accounts,
      weapons   = xPlayer.loadout,
      firstname = firstname,
      lastname  = lastname,
      sex       = sex,
      dob       = dob,
      height    = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)
      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end
    end)

    if Config.EnableLicenses then
      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)
    else
      cb(data)
    end
  else
    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      org        = xPlayer.org,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)
      if status ~= nil then
        data.drunk = status.getPercent()
      end
    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)
  end
end)

ESX.RegisterServerCallback('esx_bloodsjob:getArmoryWeapons', function(source, cb)
  TriggerEvent('esx_datastore:getSharedDataStore', 'society_bloods', function(store)
    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)
  end)
end)

ESX.RegisterServerCallback('esx_bloodsjob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)
  local xPlayer = ESX.GetPlayerFromId(source)

  if removeWeapon then
    xPlayer.removeWeapon(weaponName)
  end

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_bloods', function(store)
    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
        break
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)
     cb()
  end)
end)

ESX.RegisterServerCallback('esx_bloodsjob:removeArmoryWeapon', function(source, cb, weaponName)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weaponName, 500)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_bloods', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
        break
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

    store.set('weapons', weapons)
    cb()
  end)
end)

ESX.RegisterServerCallback('esx_bloodsjob:getStockItems', function(source, cb)
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bloods', function(inventory)
    cb(inventory.items)
  end)
end)

ESX.RegisterServerCallback('esx_bloodsjob:getPlayerInventory', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({items = items})
end)

RegisterServerEvent('esx_bloodsjob:message')
AddEventHandler('esx_bloodsjob:message', function(target, msg)
  TriggerClientEvent('esx:showNotification', target, msg)
end)
