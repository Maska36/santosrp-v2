ESX = nil

TriggerEvent('esx:getSO', function(obj) ESX = obj end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

AddEventHandler('esx:playerLoaded', function(source) 
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		if ( skillInfo and skillInfo[1] ) then
			TriggerClientEvent('stadus_skills:sendPlayerSkills', _source, skillInfo[1].stamina, skillInfo[1].strength, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].drugs)
			else
				MySQL.Async.execute('INSERT INTO `santosrp_main_fivem`.`stadus_skills` (`identifier`, `strength`, `stamina`, `driving`, `shooting`, `drugs`) VALUES (@identifier, @strength, @stamina, @driving, @shooting, @drugs);',
				{
				['@identifier'] = xPlayer.identifier,
				['@strength'] = 0,
				['@stamina'] = 0,
				['@driving'] = 0,
				['@shooting'] = 0,
				['@drugs'] = 0
				}, function ()
				end)
		end
	end)
end)

function updatePlayerInfo(source)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		if ( skillInfo and skillInfo[1] ) then
			TriggerClientEvent('stadus_skills:sendPlayerSkills', _source, skillInfo[1].stamina, skillInfo[1].strength, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].drugs)
		end
	end)
end

RegisterServerEvent("stadus_skills:addStamina")
AddEventHandler("stadus_skills:addStamina", function(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, 'Vous semblez ~g~' .. round(amount, 2) .. '% ~s~plus rapide !')
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `stadus_skills` SET `stamina` = @stamina WHERE `identifier` = @identifier',
			{
			['@stamina'] = (skillInfo[1].stamina + amount),
			['@identifier'] = xPlayer.identifier
			}, function ()
			updatePlayerInfo(source)
		end)
	end)
end)

RegisterServerEvent("stadus_skills:addStrength")
AddEventHandler("stadus_skills:addStrength", function(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, 'Vous semblez ~g~' .. round(amount, 2) .. '% ~s~plus fort !')
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `stadus_skills` SET `strength` = @strength WHERE `identifier` = @identifier',
			{
			['@strength'] = (skillInfo[1].strength + amount),
			['@identifier'] = xPlayer.identifier
			}, function ()
			updatePlayerInfo(source)
		end)
	end)
end)

RegisterServerEvent("stadus_skills:addDriving")
AddEventHandler("stadus_skills:addDriving", function(source, amount)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, 'Vous êtes devenu ~g~' .. round(amount, 2) .. '%~s~ meilleur en conduite !')
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		if (tonumber(skillInfo[1].driving) > 100.0) then
			MySQL.Async.execute('UPDATE `stadus_skills` SET `driving` = @driving WHERE `identifier` = @identifier',
				{
				['@driving'] = 100.0,
				['@identifier'] = xPlayer.identifier
				}, function ()
				updatePlayerInfo(source)
			end)
		else
			MySQL.Async.execute('UPDATE `stadus_skills` SET `driving` = @driving WHERE `identifier` = @identifier',
				{
				['@driving'] = (skillInfo[1].driving + amount),
				['@identifier'] = xPlayer.identifier
				}, function ()
				updatePlayerInfo(source)
			end)
		end
	end)
end)

RegisterServerEvent("stadus_skills:addDrugs")
AddEventHandler("stadus_skills:addDrugs", function(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx:showNotification', source, 'Vous êtes devenu(e) ~g~' .. round(amount, 2) .. '% ~s~meilleur à manipuler les drogues !')
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		MySQL.Async.execute('UPDATE `stadus_skills` SET `drugs` = @drugs WHERE `identifier` = @identifier',
			{
			['@drugs'] = (skillInfo[1].drugs + amount),
			['@identifier'] = xPlayer.identifier
			}, function ()
			updatePlayerInfo(source)
		end)
	end)
end)

ESX.RegisterServerCallback('stadus_skills:getSkills', function(source, cb)
  local xPlayer    = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM `stadus_skills` WHERE `identifier` = @identifier', {['@identifier'] = xPlayer.identifier}, function(skillInfo)
		cb(skillInfo[1].stamina, skillInfo[1].strength, skillInfo[1].driving, skillInfo[1].shooting, skillInfo[1].drugs)
	end)
end)