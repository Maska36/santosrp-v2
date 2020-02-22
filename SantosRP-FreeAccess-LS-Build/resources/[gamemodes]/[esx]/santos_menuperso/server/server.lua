ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

RegisterServerEvent("ServerEmoteRequest")
AddEventHandler("ServerEmoteRequest", function(target, emotename, etype)
	TriggerClientEvent("ClientEmoteRequestReceive", target, emotename, etype)
end)

RegisterServerEvent("ServerValidEmote") 
AddEventHandler("ServerValidEmote", function(target, requestedemote)
	TriggerClientEvent("SyncPlayEmote", source, requestedemote, source)
	TriggerClientEvent("SyncPlayEmoteSource", target, requestedemote)
end)

RegisterServerEvent("santos_menuperso:openClothes")
AddEventHandler('santos_menuperso:openClothes', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			TriggerClientEvent('esx_skin:openSaveableMenu', source)
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à changé d'habit avec le menu admin", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de changer d'habits avec le menu admin", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:TeleportPlayerToCoords")
AddEventHandler('santos_menuperso:TeleportPlayerToCoords', function(playerId, px, py, pz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			TriggerClientEvent("santos_menuperso:TeleportRequest", playerId, px, py, pz)
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** s'est TP à "..px..", "..py..", "..pz, 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de se tp", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent('santos_menuperso:requestFouille')
AddEventHandler('santos_menuperso:requestFouille', function(target)
	TriggerClientEvent('santos_menuperso:receiveFouille', target)
end)

RegisterServerEvent('santos_menuperso:OpenBodySearchMenu')
AddEventHandler('santos_menuperso:OpenBodySearchMenu', function(target)
	local playerId = source
	TriggerClientEvent('santos_menuperso:openMenu', target, playerId)
end)

RegisterServerEvent("alertRv")
AddEventHandler("alertRv", function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			TriggerClientEvent("alert:Send", playerId)
		else
			TriggerEvent('SendToDiscord', playerId, "Event Exec", "**"..GetPlayerName(playerId).."** essaie d'exec l'event tsunami", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("tremblementRv")
AddEventHandler("tremblementRv", function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			TriggerClientEvent("tremblemen:Send", -1)
		else
			TriggerEvent('SendToDiscord', playerId, "Event Exec", "**"..GetPlayerName(playerId).."** essaie d'exec l'event tsunami", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent('santos_menuperso:annonce')
AddEventHandler('santos_menuperso:annonce', function(result)
	local text = result

	TriggerClientEvent('esx:showAdvancedNotification', -1, "SantosRP", "Annonce", text, "CHAR_SOCIAL_CLUB", 4)

	TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à lancé une Annonce: **"..text.."**", 16007897, "admin")
end)

RegisterServerEvent("santos_menuperso:FreezePlayer")
AddEventHandler('santos_menuperso:FreezePlayer', function(playerId, toggle)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			if toggle then
				xPlayer.showNotification('Vous avez ~g~freeze~w~ ~b~['..playerId..'] '..GetPlayerName(playerId)..'~w~')
				TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à freeze **"..GetPlayerName(playerId).."**", 16007897, "admin")
			else
				xPlayer.showNotification('Vous avez ~g~un-freeze~w~ ~b~['..playerId..'] '..GetPlayerName(playerId)..'~w~')
				TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à un-freeze **"..GetPlayerName(playerId).."**", 16007897, "admin")
			end
			TriggerClientEvent("santos_menuperso:FreezePlayer", playerId, toggle)
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de freeze un joueur", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:requestSpectate")
AddEventHandler('santos_menuperso:requestSpectate', function(playerId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			TriggerClientEvent("santos_menuperso:requestSpectate", source, NetworkGetNetworkIdFromEntity(GetPlayerPed(playerId)), playerId, GetPlayerName(playerId))
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** spectate **"..GetPlayerName(playerId).."**", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de spectate un joueur", 16007897, "cheat")
		end
	end
end)

ESX.RegisterServerCallback('santos_menuperso:isAdmin', function(source, cb)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('santos_menuperso:getUsergroup', function(source, cb)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local group = xPlayer.getGroup()
		
		cb(group)
	end
end)

RegisterServerEvent('santos_menuperso:CheckSac')
AddEventHandler('santos_menuperso:CheckSac', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
  	local item = xPlayer.getInventoryItem('blindfold').count
  	if xPlayer and item > 0 then
    	TriggerClientEvent('hasSac', _source)
  	else
    	TriggerClientEvent('DontHaveSac', _source)
  	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_licenseshop:loadLicenses', source, licenses)
	end)
end)

local function getTime()
    local date = os.date("%H:%M")
    return date
end

TriggerEvent('es:addCommand', 'report', function(source, args, user)
	local time = getTime()
	local players = ESX.GetPlayers()
	TriggerClientEvent('chatMessage', source, "^0"..time.." - [^2REPORT^0]", {255, 0, 0}, " [^2" .. GetPlayerName(source) .." | "..source.."^0] "..table.concat(args, " "))

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		local playerId = xPlayer.source
		
		if xPlayer then
			local playergroup = xPlayer.getGroup()

			if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
				if playerId ~= source then
					TriggerClientEvent('chatMessage', playerId, "^0"..time.." - [^2REPORT^0]", {255, 0, 0}, " [^2" .. GetPlayerName(source) .." | "..source.."^0] "..table.concat(args, " "))
					TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à fait un **/report**\n**Report : **"..table.concat(args, " "), 16007897, "report")
				end
			end
		end
	end
end, {help = "Faire un report", params = {{name = "raison", help = "Ce que vous voulez report"}}})

function LoadLicenses(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_licenseshop:loadLicenses', source, licenses)
	end)
end

RegisterServerEvent('santos_menuperso:ServerLoadLicenses')
AddEventHandler('santos_menuperso:ServerLoadLicenses', function()
	local _source = source
	LoadLicenses(_source)
end)

RegisterServerEvent('santos_menuperso:addjob')
AddEventHandler('santos_menuperso:addjob', function(plyID, job, grade)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			if tonumber(plyID) and job and tonumber(grade) then
				local targetPlayer = ESX.GetPlayerFromId(plyID)

				if targetPlayer then
					if ESX.DoesJobExist(job, grade) then
						xPlayer.showNotification('Vous avez ~g~setJob~w~ ~b~['..plyID..'] '..GetPlayerName(plyID)..'~w~ en ~b~'..job..' '..grade..'~w~')
						targetPlayer.showNotification('Vous avez été ~g~setJob~w~ en ~b~'..job..'~w~')
						targetPlayer.setJob(job, grade)
						TriggerEvent('SendToDiscord', playerId, "Logs", "**"..GetPlayerName(playerId).."** à setJob **"..GetPlayerName(plyID).."** en **"..job.." "..grade.."**", 16007897, "admin")
					else
						xPlayer.showNotification('~r~Ce job n\'existe pas.')
					end
				else
					xPlayer.showNotification('~r~Joueur déconnecté.')
				end
			end
		else
			TriggerEvent('SendToDiscord', playerId, "Event Exec", "**"..GetPlayerName(playerId).."** essaie de setjob un joueur", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent('santos_menuperso:addorg')
AddEventHandler('santos_menuperso:addorg', function(plyID, org, grade)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			if tonumber(plyID) and org and tonumber(grade) then
				local targetPlayer = ESX.GetPlayerFromId(plyID)

				if targetPlayer then
					if ESX.DoesOrgExist(org, grade) then
						xPlayer.showNotification('Vous avez ~g~setOrg~w~ ~b~['..plyID..'] '..GetPlayerName(plyID)..'~w~ en ~b~'..org.. ' '..grade..'~w~')
						targetPlayer.showNotification('Vous avez été ~g~setOrg~w~ en ~b~'..org..'~w~')
						targetPlayer.setOrg(org, grade)
						TriggerEvent('SendToDiscord', playerId, "Logs", "**"..GetPlayerName(playerId).."** à setOrg **"..GetPlayerName(plyID).."** en **"..org.." "..grade.."**", 16007897, "admin")
					else
						xPlayer.showNotification('~r~Cette Organisation n\'existe pas.')
					end
				else
					xPlayer.showNotification('~r~Joueur déconnecté.')
				end
			end
		else
			TriggerEvent('SendToDiscord', playerId, "Event Exec", "**"..GetPlayerName(playerId).."** essaie de setorg un joueur", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent('santos_menuperso:addgroup')
AddEventHandler('santos_menuperso:addgroup', function(plyID, group, grade)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == "superadmin" or playergroup == "owner" then
			if tonumber(plyID) and group and tonumber(grade) then
				local targetPlayer = ESX.GetPlayerFromId(plyID)

				if targetPlayer then
					MySQL.Async.execute('UPDATE users SET users.group = @group, permission_level = @grade WHERE identifier = @identifier', {
						['@group'] = group,
						['@grade'] = grade,
						['@identifier'] = targetPlayer.identifier
					}, function(rowsChanged)
						xPlayer.showNotification('Vous avez ~g~setGroup~w~ ~b~['..plyID..'] '..GetPlayerName(plyID)..'~w~ en ~b~'..group.. ' '..grade..'~w~')
						targetPlayer.showNotification('Vous avez été ~g~setGroup~w~ en ~b~'..group..'~w~\n~y~Veuillez déco-reco.~w~')
					end)
				else
					xPlayer.showNotification('~r~Joueur déconnecté.')
				end
			end
		else
			TriggerEvent('SendToDiscord', playerId, "Event Exec", "**"..GetPlayerName(playerId).."** essaie de setgroup un joueur", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent('santos_menuperso:confiscatePlayerItem')
AddEventHandler('santos_menuperso:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))
	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon(itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent("santos_menuperso:setHealth")
AddEventHandler("santos_menuperso:setHealth", function(id, health)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			xPlayer.showNotification('Vous avez ~g~setHealth~w~ ~b~['..id..'] '..GetPlayerName(id)..'~w~ a ~r~'..health..'~w~')
	    	TriggerClientEvent("killMe", id, health)
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à set Health **"..GetPlayerName(id).."** a **"..health.."**", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de kill un joueur", 16007897, "cheat")
	    end
	end
end)

RegisterServerEvent("sendPM")
AddEventHandler("sendPM", function(id, model)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
			xPlayer.showNotification('Vous avez ~g~setPlayerModel~w~ ~b~['..id..'] '..GetPlayerName(id)..'~w~ en ~b~'..model..'~w~')
	    	TriggerClientEvent("sendtoP", id, model)
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à set PlayerModel **"..GetPlayerName(id).."** en **"..model.."**", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de set PlayerModel un joueur", 16007897, "cheat")
	    end
	end
end)

ESX.RegisterServerCallback('santos_menuperso:itemCheck', function(src, cb)
 	local xPlayer = ESX.GetPlayerFromId(src)
 	local item = xPlayer.getInventoryItem('gps').count
	if item > 0 then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('santos_menuperso:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	
	if xPlayer then
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			org        = xPlayer.org,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			money      = xPlayer.getMoney(),
			bank       = xPlayer.getAccount('bank').money,
			black      = xPlayer.getAccount('black_money').money,
			weapons    = xPlayer.loadout,
			firstname  = firstname,
			lastname   = lastname,
			sex        = sex,
			dob        = dob,
			height     = height,
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	end
end)

ESX.RegisterServerCallback('santos_menuperso:getAdminOtherPlayerData', function(source, cb, target)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
	
		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			if targetPlayer then
				local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
					['@identifier'] = targetPlayer.identifier
				})

				local firstname = result[1].firstname
				local lastname  = result[1].lastname
				local sex       = result[1].sex
				local dob       = result[1].dateofbirth
				local height    = result[1].height

				local data = {
					name       = GetPlayerName(target),
					group      = targetPlayer.getGroup(),
					job        = targetPlayer.job,
					org        = targetPlayer.org,
					inventory  = targetPlayer.inventory,
					accounts   = targetPlayer.accounts,
					money      = targetPlayer.getMoney(),
					bank       = targetPlayer.getAccount('bank').money,
					black      = targetPlayer.getAccount('black_money').money,
					weapons    = targetPlayer.loadout,
					firstname  = firstname,
					lastname   = lastname,
					sex        = sex,
					dob        = dob,
					height     = height,
					ip 		   = GetPlayerEndpoint(target),
					identifier = targetPlayer.identifier
				}

				TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
					if status then
						data.drunk = math.floor(status.percent)
					end
				end)

				TriggerEvent('esx_license:getLicenses', target, function(licenses)
					data.licenses = licenses
					cb(data)
				end)
			end
		end
	end
end)

function getMaximumGrade(jobname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;", {
        ['@jobname'] = jobname
    })
    if result[1] ~= nil then
        return result[1].grade
    end
    return nil
end

function getMaximumOrgGrade(orgname)
    local result = MySQL.Sync.fetchAll("SELECT * FROM org_grades WHERE org_name=@orgname  ORDER BY `org_grade` DESC ;", {
        ['@orgname'] = orgname
    })
    if result[1] ~= nil then
        return result[1].org_grade
    end
    return nil
end

-------------------------------------------------------------------------------Admin Menu

RegisterServerEvent("SendToAdminLogs")
AddEventHandler("SendToAdminLogs", function(stringType, unk)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		unk = unk or ""

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			if stringType == "spawnveh" then
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à fait spawn "..unk, 16007897, "admin")
			elseif stringType == "flipveh" then
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à flip un véhicule", 16007897, "admin")
			elseif stringType == "repairveh" then
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à réparer un véhicule", 16007897, "admin")
			elseif stringType == "custommaxveh" then
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** à Custom Max son véhicule", 16007897, "admin")
			end
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie d'exec un log event", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:giveC")
AddEventHandler("santos_menuperso:giveC", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		local total = tonumber(money)

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			xPlayer.addMoney(total)
			TriggerClientEvent('esx:showNotification', _source, "~g~Tu t'es give "..total.. "$")
			TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** s'est give **$"..total.."** en **liquide**", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de se give de l'argent", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:giveB")
AddEventHandler("santos_menuperso:giveB", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		local total = tonumber(money)

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showNotification', _source, "~g~Tu t'es give "..total.. "$")
			TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** s'est give **$"..total.."** en **banque**", 16007897, "admin")
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de se give de l'argent en banque", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:GivePack")
AddEventHandler("santos_menuperso:GivePack", function(id, pack_name, vehName)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehName = vehName or nil

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		local targetPlayer = ESX.GetPlayerFromId(id)
		
		if targetPlayer then
			if playergroup == "admin" or playergroup == "superadmin" or playergroup == "owner" then
				if pack_name == "pack_boost"  then
					targetPlayer.addAccountMoney("bank", 1000000)
					TriggerClientEvent('esx:showNotification', id, "~g~Vous avez reçu un Pack Discord Boost.")
					TriggerClientEvent('esx:showNotification', source, "~g~Vous avez give un Pack Discord Boost à "..GetPlayerName(id))
				elseif pack_name == "pack_starter"  then
					targetPlayer.addInventoryItem("gps", 1)
					targetPlayer.addInventoryItem("phone", 1)
					targetPlayer.addInventoryItem("water", 300)
					targetPlayer.addInventoryItem("bread", 300)
					targetPlayer.addAccountMoney("bank", 100000)
					TriggerClientEvent('esx:showNotification', id, "~g~Vous avez reçu un Starter Pack.")
					TriggerClientEvent('esx:showNotification', source, "~g~Vous avez give un Starter Pack à "..GetPlayerName(id))
				elseif pack_name == "pack_vehicule"  then
					if vehName then
						TriggerClientEvent("santos_menuperso:packCar", id, vehName)
						TriggerClientEvent('esx:showNotification', id, "~g~Vous avez reçu un Pack Véhicule.")
						TriggerClientEvent('esx:showNotification', source, "~g~Vous avez give un Pack Véhicule à "..GetPlayerName(id))
					end
				elseif pack_name == "pack_arme"  then
					TriggerEvent('esx_license:addLicenseTest', id, "weapon")
					targetPlayer.addWeapon("weapon_combatpistol", 150)
					targetPlayer.addWeapon("weapon_combatpistol", 150)
					TriggerClientEvent('esx:showNotification', id, "~g~Vous avez reçu un Pack Arme.")
					TriggerClientEvent('esx:showNotification', source, "~g~Vous avez give un Pack Arme à "..GetPlayerName(id))
				end
				TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à give un **"..pack_name.."** à **"..GetPlayerName(id).."**", 16007897, "admin")
			else
				TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(source).."** essaie de se give des packs", 16007897, "cheat")
			end
		end
	end
end)

RegisterServerEvent("santos_menuperso:addItem")
AddEventHandler("santos_menuperso:addItem", function(item, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			if item ~= nil and amount ~= nil and item ~= "" and amount ~= "" then
				xPlayer.addInventoryItem(item, tonumber(amount))
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** s'est give un item **"..item.." x"..amount.."**", 16007897, "admin")
			end
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de se give un item", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:addWeapon")
AddEventHandler("santos_menuperso:addWeapon", function(weapon)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			if weapon ~= nil and weapon ~= "" then
				xPlayer.addWeapon(weapon, 150)
				TriggerEvent('SendToDiscord', _source, "Logs", "**"..GetPlayerName(_source).."** s'est give **"..weapon.."**", 16007897, "admin")
			end
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de se give une arme", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("santos_menuperso:kickPly")
AddEventHandler("santos_menuperso:kickPly", function(playerID, reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		
		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			xPlayer.showNotification('Vous avez ~g~kick~w~ ~b~['..playerID..'] '..GetPlayerName(playerID).."~w~\nRaison: ~g~"..reason.."~w~")
			TriggerEvent('SendToDiscord', source, "Logs", "**"..GetPlayerName(source).."** à kick **"..GetPlayerName(playerID).."** - **"..reason.."**", 16007897, "admin")
			DropPlayer(playerID, reason)
		else
			TriggerEvent('SendToDiscord', source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de kick quelqu'un", 16007897, "cheat")
		end
	end
end)

RegisterServerEvent("loadMenuPersoSQL")
AddEventHandler("loadMenuPersoSQL", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local result = MySQL.Sync.fetchAll('SELECT voice, attitude_lib, attitude_anim FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	local voice = tonumber(result[1].voice)
	local lib = result[1].attitude_lib
	local anim = result[1].attitude_anim

	TriggerClientEvent('santos_menuperso:loadMenuPersoSQL', _source, voice, lib, anim)
end)

RegisterServerEvent("UpdateVoice")
AddEventHandler("UpdateVoice", function(voice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('UPDATE users SET voice = @voice WHERE identifier = @identifier', {
		['@voice'] = voice,
		['@identifier'] = xPlayer.identifier
	}, function(rowsChanged)
	end)
end)

RegisterServerEvent("updateAttitudeSQL")
AddEventHandler("updateAttitudeSQL", function(lib, anim)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('UPDATE users SET attitude_lib = @attitude_lib, attitude_anim = @attitude_anim WHERE identifier = @identifier', {
		['@attitude_lib'] = lib,
		['@attitude_anim'] = anim,
		['@identifier'] = xPlayer.identifier
	}, function(rowsChanged)
		TriggerClientEvent('esx:showNotification', _source, "~g~Votre attitude par défaut à été changé.")
	end)
end)
  
RegisterServerEvent('cmg_animations:sync')
AddEventHandler('cmg_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg_animations:stop')
AddEventHandler('cmg_animations:stop', function(target)
	if target then
		TriggerClientEvent('cmg_animations:cl_stop', target)
	end
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	local source = source
	if target and targetSrc then
		TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	end
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(target)
	if target then
		TriggerClientEvent('cmg2_animations:cl_stop', target)
	end
end)

RegisterServerEvent('cmg3_animations:sync')
AddEventHandler('cmg3_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	local _source = source
	if target and targetSrc then
		TriggerClientEvent('cmg3_animations:syncTarget', targetSrc, _source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	end
	TriggerClientEvent('cmg3_animations:syncMe', _source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('cmg3_animations:stop')
AddEventHandler('cmg3_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations:cl_stop', targetSrc)
end)

RegisterServerEvent("reviveEv")
AddEventHandler("reviveEv", function(Type)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			if Type == "All" then
				TriggerClientEvent('ambujob:revive', -1)
			elseif Type == "Me" then
				TriggerClientEvent('ambujob:revive', source)
			end
		end
	end
end)

RegisterServerEvent("santos_menuperso:giveDM")
AddEventHandler("santos_menuperso:giveDM", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		local playergroup = xPlayer.getGroup()
		local total = money

		if playergroup == 'superadmin' or playergroup == 'owner' or playergroup == 'admin' then
			xPlayer.addAccountMoney('black_money', tonumber(total))
			local item = '$~s~ !'
			local message = 'Tu t\'es give ~g~'
			TriggerClientEvent('esx:showNotification', _source, message.." "..total.." "..item)
		else
			TriggerEvent('SendToDiscord', _source, "Event Exec", "**"..GetPlayerName(_source).."** essaie de se give de l'argent sale", 16007897, "cheat")
		end
	end
end)

--- Grade Menu ---
RegisterServerEvent('santos_menuperso:promouvoirply')
AddEventHandler('santos_menuperso:promouvoirply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.job.name)) -1 

	if(targetXPlayer.job.grade == maximumgrade)then
		TriggerClientEvent('esx:showNotification', _source, "~y~Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if(sourceXPlayer.job.name == targetXPlayer.job.name)then

			local grade = tonumber(targetXPlayer.job.grade) + 1 
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez promu "..identitytarget.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "~g~Vous avez été ~g~promu par ".. identitysource.."~w~.")		
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
		end
	end 
end)

RegisterServerEvent('santos_menuperso:promouvoirorgply')
AddEventHandler('santos_menuperso:promouvoirorgply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	local maximumgrade = tonumber(getMaximumOrgGrade(sourceXPlayer.org.name)) -1 

	if(targetXPlayer.org.grade == maximumgrade)then
		TriggerClientEvent('esx:showNotification', _source, "~y~Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if(sourceXPlayer.org.name == targetXPlayer.org.name)then

			local grade = tonumber(targetXPlayer.org.grade) + 1 
			local org = targetXPlayer.org.name

			targetXPlayer.setOrg(org, grade)

			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez promu "..identitytarget.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "~g~Vous avez été promu par ".. identitysource.."~w~.")		
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
		end
	end 
end)

RegisterServerEvent('santos_menuperso:destituerply')
AddEventHandler('santos_menuperso:destituerply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	if(targetXPlayer.job.grade == 0)then
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas rétrograder davantage.")
	else
		if(sourceXPlayer.job.name == targetXPlayer.job.name)then
			local grade = tonumber(targetXPlayer.job.grade) - 1 
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez rétrogradé "..identitytarget.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "~r~Vous avez été rétrogradé par ".. identitysource.."~w~.")
		else	
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
		end
	end 	
end)

RegisterServerEvent('santos_menuperso:destituerorgply')
AddEventHandler('santos_menuperso:destituerorgply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	if(targetXPlayer.org.grade == 0)then
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous ne pouvez pas plus rétrograder davantage.")
	else
		if (sourceXPlayer.org.name == targetXPlayer.org.name) then
			local grade = tonumber(targetXPlayer.org.grade) - 1 
			local org = targetXPlayer.org.name

			targetXPlayer.setOrg(org, grade)

			TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez rétrogradé "..identitytarget.."~w~.")
			TriggerClientEvent('esx:showNotification', target,  "~r~Vous avez été rétrogradé par ".. identitysource.."~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
		end
	end 	
end)

RegisterServerEvent('santos_menuperso:recruterply')
AddEventHandler('santos_menuperso:recruterply', function(target, job, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	targetXPlayer.setJob(job, grade)
	TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez recruté "..identitytarget.."~w~.")
	TriggerClientEvent('esx:showNotification', target,  "~g~Vous avez été embauché par ".. identitysource.."~w~.")		
end)

RegisterServerEvent('santos_menuperso:virerply')
AddEventHandler('santos_menuperso:virerply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	local job = "chomeur"
	local grade = "0"

	if(sourceXPlayer.job.name == targetXPlayer.job.name)then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez viré "..identitytarget.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "~r~Vous avez été viré par ".. identitysource.."~w~.")	
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
	end
end)

RegisterServerEvent('santos_menuperso:recruterorgply')
AddEventHandler('santos_menuperso:recruterorgply', function(target, org, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	targetXPlayer.setOrg(org, grade)
	TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez recruté "..identitytarget.."~w~.")
	TriggerClientEvent('esx:showNotification', target,  "~g~Vous avez été embauché par ".. identitysource.."~w~.")		
end)

RegisterServerEvent('santos_menuperso:virerorgply')
AddEventHandler('santos_menuperso:virerorgply', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local identitysource = sourceXPlayer.get('firstName')
	local identitytarget = targetXPlayer.get('firstName')

	local org = "santos"
	local grade = "0"

	if(sourceXPlayer.org.name == targetXPlayer.org.name)then
		targetXPlayer.setOrg(org, grade)
		TriggerClientEvent('esx:showNotification', _source, "~g~Vous avez viré "..identitytarget.."~w~.")
		TriggerClientEvent('esx:showNotification', target,  "~r~Vous avez été viré par ".. identitysource.."~w~.")	
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Vous n'avez pas l'autorisation~w~.")
	end
end)