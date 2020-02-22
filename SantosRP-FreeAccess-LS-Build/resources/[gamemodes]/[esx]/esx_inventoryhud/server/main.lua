ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if targetXPlayer ~= nil then
		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
	else
		cb(nil)
	end
end)

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem", function(source, target, type, itemName, itemCount)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == "item_standard" then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetItem.limit == -1 or (targetItem.count + itemCount) < targetItem.limit then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)

				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à donné "..itemName.." x"..itemCount.." a "..GetPlayerName(target), 16007897, "inv")
			end
		end
	elseif type == "item_money" then
		if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
			sourceXPlayer.removeMoney(itemCount)
			targetXPlayer.addMoney(itemCount)
			
			TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à donné "..itemName.." x"..itemCount.." a "..GetPlayerName(target), 16007897, "inv")
		end
	elseif type == "item_account" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)
			
			TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à donné "..itemName.." x"..itemCount.." a "..GetPlayerName(target), 16007897, "inv")
		end
	elseif type == "item_weapon" then
		if not targetXPlayer.hasWeapon(itemName) then
			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)
			
			TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à donné "..itemName.." x"..itemCount.." a "..GetPlayerName(target), 16007897, "inv")
		end
	end
end)