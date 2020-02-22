local guiEnabled = false
local myIdentity = {}
local myIdentifiers = {}
local hasIdentity = false
local isDead = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state
	})
end

RegisterNetEvent('esx_identity:showRegisterIdentity')
AddEventHandler('esx_identity:showRegisterIdentity', function()
	if not isDead then
		EnableGui(true)
	end
end)

RegisterNetEvent('esx_identity:identityCheck')
AddEventHandler('esx_identity:identityCheck', function(identityCheck)
	hasIdentity = identityCheck
end)

RegisterNetEvent('esx_identity:saveID')
AddEventHandler('esx_identity:saveID', function(data)
	myIdentifiers = data
end)

RegisterNUICallback('escape', function(data, cb)
	if hasIdentity then
		EnableGui(false)
	else
		ESX.ShowNotification("Vous devez créer votre personnage si vous voulez jouer.")
	end
end)

RegisterNUICallback('container', function(data, cb)
	local reason = ""
	myIdentity = data
	for theData, value in pairs(myIdentity) do
		if theData == "firstname" or theData == "lastname" then
			reason = verifyName(value)
			
			if reason ~= "" then
				break
			end
		elseif theData == "dateofbirth" then
			if value == "invalid" then
				reason = "Date de naissance invalide !"
				break
			end
		elseif theData == "height" then
			local height = tonumber(value)
			if height then
				if height > 200 or height < 140 then
					reason = "Taille invalide !"
					break
				end
			else
				reason = "Taille invalide !"
				break
			end
		end
	end
	
	if reason == "" then
		SetPedComponentVariation(PlayerPedId(), 0, i, 0, 0)
		TriggerServerEvent('esx_identity:setIdentity', data, myIdentifiers)
		EnableGui(false)
		Citizen.Wait(500)
		TriggerEvent('esx_skin:openSaveableMenu', myIdentifiers.id)
		Citizen.Wait(5000)
		ESX.ShowAdvancedNotification("Jeoffrey", "Message", "Salut mec !\nPour commencer, vas chercher un ~y~GPS~s~ et ce qu'il te faut dans les magasins a côté de toi !", "HC_N_KAR", 4)
		--ESX.ShowAdvancedNotification("~g~Si vous voulez de l'aide, le Menu F3 est la pour ça.")
	else
		ESX.ShowNotification(reason)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if guiEnabled then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function verifyName(name)
	-- Don't allow short user names
	local nameLength = string.len(name)
	if nameLength > 25 or nameLength < 2 then
		return 'Votre nom est trop court ou trop long.'
	end
	
	-- Don't allow special characters (doesn't always work)
	local count = 0
	for i in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do
		count = count + 1
	end
	if count ~= nameLength then
		return 'Votre nom contient des caracteres invalides.'
	end

	local spacesInName    = 0
	local spacesWithUpper = 0
	for word in string.gmatch(name, '%S+') do

		if string.match(word, '%u') then
			spacesWithUpper = spacesWithUpper + 1
		end

		spacesInName = spacesInName + 1
	end

	if spacesInName > 2 then
		return 'Votre nom contient deux espaces'
	end
	
	if spacesWithUpper ~= spacesInName then
		return 'Votre nom doit commencer par une lettre maj.'
	end

	return ''
end
