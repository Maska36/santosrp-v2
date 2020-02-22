function CreateExtendedPlayer(player, accounts, inventory, job, org, loadout, name, coords)
	local self = {}

	self.player    = player
	self.accounts  = accounts
	self.inventory = inventory
	self.job       = job
  	self.org       = org
	self.loadout   = loadout
	self.name      = name
	self.coords    = coords

	self.source     = self.player.get('source')
	self.identifier = self.player.get('identifier')

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.player.setMoney(money)
			TriggerClientEvent('esx:UpdateMoneyHUD', self.source)
		end
	end

	self.getMoney = function()
		return self.player.get('money')
	end

	self.setCoords = function(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	self.updateCoords = function(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.player.addMoney(money)
			TriggerClientEvent('esx:UpdateMoneyHUD', self.source)
		end
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)

		if money > 0 then
			self.player.removeMoney(money)
			TriggerClientEvent('esx:UpdateMoneyHUD', self.source)
		end
	end

	self.displayMoney = function(money)
		self.player.displayMoney(money)
	end

	self.getPermissions = function()
		return self.player.getPermissions()
	end

	self.setPermissions = function(p)
		self.player.setPermissions(p)
	end

	self.getIdentifier = function()
		return self.player.getIdentifier()
	end

	self.getGroup = function()
		return self.player.getGroup()
	end

	self.get = function(k)
		return self.player.get(k)
	end

	self.set = function(k, v)
		self.player.set(k, v)
	end

	self.getPlayer = function()
		return self.player
	end

	self.getAccounts = function()
		local accounts = {}

		for k,account in ipairs(Config.Accounts) do
			if account == 'bank' then
				table.insert(accounts, {
					name  = 'bank',
					money = self.get('bank'),
					label = Config.AccountLabels.bank
				})
			else
				for k2,v2 in ipairs(self.accounts) do
					if v2.name == account then
						table.insert(accounts, v2)
						break
					end
				end
			end
		end

		return accounts
	end

	self.getAccount = function(account)
		if account == 'bank' then
			return {
				name  = 'bank',
				money = self.get('bank'),
				label = Config.AccountLabels.bank
			}
		end

		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function()
		return self.inventory
	end

	self.getJob = function()
		return self.job
	end

  	self.getOrg = function()
    	return self.org
  	end

	self.getLoadout = function()
		return self.loadout
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setLastPosition = function(position)
		self.lastPosition = position
	end

	self.getMissingAccounts = function(cb)
		MySQL.Async.fetchAll('SELECT name FROM user_accounts WHERE identifier = @identifier', {
			['@identifier'] = self.getIdentifier()
		}, function(result)
			local missingAccounts = {}

			for k,v in ipairs(Config.Accounts) do
				if v ~= 'bank' then
					local found = false

					for k2,v2 in ipairs(result) do
						if v == v2.name then
							found = true
							break
						end
					end

					if not found then
						table.insert(missingAccounts, v)
					end
				end
			end

			cb(missingAccounts)
		end)
	end

	self.createAccounts = function(missingAccounts, cb)
		for k,v in ipairs(missingAccounts) do
			MySQL.Async.execute('INSERT INTO user_accounts (identifier, name) VALUES (@identifier, @name)', {
				['@identifier'] = self.getIdentifier(),
				['@name'] = v
			}, function(rowsChanged)
				if cb then
					cb()
				end
			end)
		end
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)

				account.money = newMoney

				if accountName == 'bank' then
					self.set('bank', newMoney)
				end

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney
	
				if accountName == 'bank' then
					self.set('bank', newMoney)
				end
	
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney
	
				if accountName == 'bank' then
					self.set('bank', newMoney)
				end
	
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end
	end

	self.addInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)

			local newCount = item.count + count
			item.count = newCount

			TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
			self.triggerEvent('esx:addInventoryItem', item.name, item.count)
		end
	end

	self.removeInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount

				TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
				self.triggerEvent('esx:removeAnInventoryItem', item.name, item.count)
			end
		end
	end

	self.setInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.setOrg = function(org, orggrade)
		orggrade = tostring(orggrade)
		local lastOrg = json.decode(json.encode(self.org))

		if ESX.DoesOrgExist(org, orggrade) then
			local orgObject, orggradeObject = ESX.Orgs[org], ESX.Orgs[org].grades[orggrade]

			self.org.id    = orgObject.id
			self.org.name  = orgObject.name
			self.org.label = orgObject.label

			self.org.grade        = tonumber(orggrade)
			self.org.grade_name   = orggradeObject.name
			self.org.grade_label  = orggradeObject.label
			self.org.grade_salary = orggradeObject.salary

			if orggradeObject.skin_male then
				self.org.skin_male = json.decode(orggradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if orggradeObject.skin_female then
				self.org.skin_female = json.decode(orggradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setOrg', self.source, self.org, lastOrg)
			self.triggerEvent('esx:setOrg', self.org)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setOrg() usage for "%s"'):format(self.identifier))
		end
	end

	self.addWeapon = function(weaponName, ammo)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			self.triggerEvent('esx:addWeapon', weaponName, ammo)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.setWeaponTint = function(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	self.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.removeWeapon = function(weaponName, ammo)
		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName, ammo)
			self.triggerEvent('esx:removeAnInventoryItem', weaponLabel, false, true)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v.name == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:removeAnInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return nil
	end

	self.showNotification = function(msg, flash, saveToBrief)
		self.triggerEvent('esx:showNotification', msg, flash, saveToBrief)
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	return self
end
