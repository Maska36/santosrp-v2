ESX = nil
local Jobs = {}
local Orgs = {}
local RegisteredSocieties = {}

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})
	for i=1, #result, 1 do
		Jobs[result[i].name] = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})
	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end

	local resultt = MySQL.Sync.fetchAll('SELECT * FROM orgs', {})
	for i=1, #resultt, 1 do
		Orgs[resultt[i].name] = resultt[i]
		Orgs[resultt[i].name].grades = {}
	end

	local resultt2 = MySQL.Sync.fetchAll('SELECT * FROM org_grades', {})
	for i=1, #resultt2, 1 do
		Orgs[resultt2[i].org_name].grades[tostring(resultt2[i].org_grade)] = resultt2[i]
	end
end)

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('esx_society:withdrawMoney')
AddEventHandler('esx_society:withdrawMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call withdrawMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerEvent('SendToDiscord', xPlayer.source, "Logs", "**"..xPlayer.name.."** à retiré **$"..ESX.Math.GroupDigits(amount).."** de l'entreprise **"..society.name.."**", 16007897, "inv")
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_society:withdrawOrgMoney')
AddEventHandler('esx_society:withdrawOrgMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.org.name ~= society.name then
		print(('esx_society: %s attempted to call withdrawOrgMoney!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney')
AddEventHandler('esx_society:depositMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerEvent('SendToDiscord', xPlayer.source, "Logs", "**"..xPlayer.name.."** à déposé **$"..ESX.Math.GroupDigits(amount).."** dans l'entreprise **"..society.name.."**", 16007897, "inv")
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:depositOrgMoney')
AddEventHandler('esx_society:depositOrgMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.org.name ~= society.name then
		print(('esx_society: %s attempted to call depositOrgMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount / 2))

	if xPlayer.job.name ~= society then
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		TriggerEvent("esx:washingmoneyalert", xPlayer.name, amount)
		xPlayer.removeAccountMoney('black_money', amount)

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society']    = society,
			['@amount']     = amount
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', ESX.Math.GroupDigits(amount)))
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end

end)

RegisterServerEvent('esx_society:washOrgMoney')
AddEventHandler('esx_society:washOrgMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.org.name ~= society then
		print(('esx_society: %s attempted to call washOrgMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		TriggerEvent("esx:washingmoneyalert", xPlayer.name, amount)
		xPlayer.removeAccountMoney('black_money', amount)

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society']    = society,
			['@amount']     = amount
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', ESX.Math.GroupDigits(amount)))
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_society:putVehicleInGarage')
AddEventHandler('esx_society:putVehicleInGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_society:removeVehicleFromGarage')
AddEventHandler('esx_society:removeVehicleFromGarage', function(societyName, vehicle)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_society:getEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					job = {
						name        = results[i].job,
						label       = Jobs[results[i].job].label,
						grade       = results[i].job_grade,
						grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
						grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
			['@job'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name       = result[i].name,
					identifier = result[i].identifier,
					job = {
						name        = result[i].job,
						label       = Jobs[result[i].job].label,
						grade       = result[i].job_grade,
						grade_name  = Jobs[result[i].job].grades[tostring(result[i].job_grade)].name,
						grade_label = Jobs[result[i].job].grades[tostring(result[i].job_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_society:getOrgEmployees', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, org, org_grade FROM users WHERE org = @org ORDER BY org_grade DESC', {
			['@org'] = society
		}, function (resultts)
			local employees = {}

			for i=1, #resultts, 1 do
				table.insert(employees, {
					name       = resultts[i].firstname .. ' ' .. resultts[i].lastname,
					identifier = resultts[i].identifier,
					org = {
						name        = resultts[i].org,
						label       = Orgs[resultts[i].org].label,
						grade       = resultts[i].org_grade,
						grade_name  = Orgs[resultts[i].org].grades[tostring(resultts[i].org_grade)].name,
						grade_label = Orgs[resultts[i].org].grades[tostring(resultts[i].org_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, org, org_grade FROM users WHERE org = @org ORDER BY org_grade DESC', {
			['@org'] = society
		}, function (resultt)
			local employees = {}

			for i=1, #resultt, 1 do
				table.insert(employees, {
					name       = resultt[i].name,
					identifier = resultt[i].identifier,
					org = {
						name        = resultt[i].org,
						label       = Orgs[resultt[i].org].label,
						grade       = resultt[i].org_grade,
						grade_name  = Orgs[resultt[i].org].grades[tostring(resultt[i].org_grade)].name,
						grade_label = Orgs[resultt[i].org].grades[tostring(resultt[i].org_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

-- Society
ESX.RegisterServerCallback('esx_society:setOrg', function(source, cb, identifier, org, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.org.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setOrg(org, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', org))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getOrg().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET org = @org, org_grade = @org_grade WHERE identifier = @identifier', {
				['@org']        = org,
				['@org_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setOrg'):format(xPlayer.identifier))
		cb()
	end
end)


ESX.RegisterServerCallback('esx_society:getOrg', function(source, cb, society)
	local org    = json.decode(json.encode(Orgs[society]))
	local grades = {}

	for k,v in pairs(org.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.org_grade < b.org_grade
	end)

	org.grades = grades

	cb(org)
end)

-- Job
ESX.RegisterServerCallback('esx_society:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)


ESX.RegisterServerCallback('esx_society:setAnJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setJob(job, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_society: %s attempted to setJob'):format(xPlayer.identifier))
		cb()
	end
end)


ESX.RegisterServerCallback('esx_society:setOrgSalary', function(source, cb, org_name, org_grade, salarys)
	local isBoss = isPlayerOrgBoss(source, org_name)
	local identifier = GetPlayerIdentifier(source, 0)

	if isBoss then
		if salarys <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE org_grades SET salary = @salary WHERE org_name = @org_name AND org_grade = @org_grade', {
				['@salary']   = salarys,
				['@org_name'] = org_name,
				['@org_grade'] = org_grade
			}, function(rowsChanged)
				Orgs[org_name].grades[tostring(org_grade)].salary = salarys
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.org.name == org_name and xPlayer.org.grade == org_grade then
						xPlayer.setOrg(org_name, org_grade)
					end
				end
				cb()
			end)
		else
			print(('esx_society: %s attempted to setOrgSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setOrgSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:setAnJobSalary', function(source, cb, job, grade, salary)
	local isBoss = isPlayerBoss(source, job)
	local identifier = GetPlayerIdentifier(source, 0)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE job_grades SET salary = @salary WHERE job_name = @job_name AND grade = @grade', {
				['@salary']   = salary,
				['@job_name'] = job,
				['@grade']    = grade
			}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.job.name == job and xPlayer.job.grade == grade then
						xPlayer.setJob(job, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_society: %s attempted to setJobSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_society: %s attempted to setJobSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_society:getOrgOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			org        = xPlayer.org
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_society:getAllOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_society:getVehiclesInGarage', function(source, cb, societyName)
	local society = GetSociety(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

ESX.RegisterServerCallback('esx_society:isOrgBoss', function(source, cb, org)
	cb(isPlayerOrgBoss(source, org))
end)

function isPlayerOrgBoss(playerId, org)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.org.name == org and xPlayer.org.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society org boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRON(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM society_moneywash', {}, function(result)
		for i=1, #result, 1 do
			local society = GetSociety(result[i].society)
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			if xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', ESX.Math.GroupDigits(result[i].amount)))
			end

			MySQL.Async.execute('DELETE FROM society_moneywash WHERE id = @id', {
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRON)
