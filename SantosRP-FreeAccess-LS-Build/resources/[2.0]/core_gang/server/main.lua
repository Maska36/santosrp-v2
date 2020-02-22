ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

local ganggetname = {
	"ballas",
	"famillies",
	"vagos",
	"cripz",
	"white",
	"cosanostra",
	"sinaloa",
	"aiglerouge",
	"nueva",
	"ms13",
	"yakuza",
	"camorra",
}

local gangFouille = {
	ballas = false,
	famillies = false,
	vagos = false,
	cripz = false,
	white = false,
	cosanostra = false,
	sinaloa = false,
	aiglerouge = false,
	nueva = false,
	ms13 = false,
	yakuza = false,
	camorra = false,
}

local gangs = {
	"esx_ballasjob",
	"esx_familliesjob",
	"esx_vagosjob",
	"esx_cripzjob",
	"esx_whitejob",
	"esx_cosanostrajob",
	"esx_sinaloajob",
	"esx_aiglerougejob",
	"esx_nuevajob",
	"esx_ms13job",
	"esx_yakuzajob",
	"esx_camorrajob",
}

for i, gangSoc in ipairs(ganggetname) do
	TriggerEvent('esx_society:registerSociety', gangSoc, gangSoc, 'society_'..gangSoc, 'society_'..gangSoc, 'society_'..gangSoc, {type = 'public'})
end

RegisterServerEvent('core_gang:setFouille')
AddEventHandler("core_gang:setFouille", function(gang, val)
	gangFouille[gang] = val
end)

ESX.RegisterServerCallback('core_gang:checkArmory', function(source, cb, gang)
	cb(gangFouille[gang])
end)

for i, gangss in ipairs(gangs) do
	RegisterServerEvent(gangss..":getStockItem")
	AddEventHandler(gangss..":getStockItem", function(societyName, itemName, count)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..societyName, function(inventory)
	    	local inventoryItem = inventory.getItem(itemName)
	    	if count > 0 and inventoryItem.count >= count then
	      		if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
	        		TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
	      		else
	        		inventory.removeItem(itemName, count)
	        		xPlayer.addInventoryItem(itemName, count)
	        		TriggerClientEvent('esx:showNotification', _source, "Vous avez retiré ~y~"..count.."x~s~ ~b~"..inventoryItem.label.."~s~")
	      		end
	    	else
	        	TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
	    	end
	    end)
	end)

	RegisterServerEvent(gangss..":putStockItems")
	AddEventHandler(gangss..":putStockItems", function(societyName, itemName, count)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..societyName, function(inventory)
	    	local inventoryItem = inventory.getItem(itemName)
	    	
	    	if sourceItem.count >= count and count > 0 then
	    		xPlayer.removeInventoryItem(itemName, count)
	    		inventory.addItem(itemName, count)
	        	TriggerClientEvent('esx:showNotification', _source, "Vous avez déposé ~y~"..count.."x~s~ ~b~"..inventoryItem.label.."~s~")
	    	else
	        	TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
	    	end
	  	end)
	end)

	ESX.RegisterServerCallback(gangss..':getArmoryWeapons', function(source, cb, societyName)
	  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..societyName, function(store)
	    local weapons = store.get('weapons')

	    if weapons == nil then
	      weapons = {}
	    end

	    cb(weapons)
	  end)
	end)

	ESX.RegisterServerCallback(gangss..':addArmoryWeapon', function(source, cb, societyName, weaponName)
	  local xPlayer = ESX.GetPlayerFromId(source)

	  xPlayer.removeWeapon(weaponName)

	  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..societyName, function(store)
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

	ESX.RegisterServerCallback(gangss..':removeArmoryWeapon', function(source, cb, societyName, weaponName)
	  local xPlayer = ESX.GetPlayerFromId(source)
	  xPlayer.addWeapon(weaponName, 500)

	  TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..societyName, function(store)

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

	ESX.RegisterServerCallback(gangss..':getStockItems', function(source, cb, societyName)
	  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..societyName, function(inventory)
	    cb(inventory.items)
	  end)
	end)

	ESX.RegisterServerCallback(gangss..':getPlayerInventory', function(source, cb)
	  local xPlayer = ESX.GetPlayerFromId(source)
	  local items   = xPlayer.inventory

	  cb({items = items})
	end)
end