local ESX      = nil
local inMarker = false
local PlayerData = {}

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)



RegisterNetEvent('openMenuJudiciaire')
AddEventHandler('openMenuJudiciaire', function()
	ESX.TriggerServerCallback('jsfour-criminalrecord:fetch', function( d )
		SetNuiFocus(true, true)

		SendNUIMessage({
			action = "open",
			array  = d
		})
	end, data, 'start')
end)

-- NUI Callback - Close
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	cb('ok')
end)

-- NUI Callback - Fetch
RegisterNUICallback('fetch', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:fetch', function( d )
    cb(d)
  end, data, data.type)
end)

-- NUI Callback - Search
RegisterNUICallback('search', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:search', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Add
RegisterNUICallback('add', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:add', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Update
RegisterNUICallback('update', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:update', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - Remove
RegisterNUICallback('remove', function(data, cb)
	ESX.TriggerServerCallback('jsfour-criminalrecord:remove', function( d )
    cb(d)
  end, data)
end)
