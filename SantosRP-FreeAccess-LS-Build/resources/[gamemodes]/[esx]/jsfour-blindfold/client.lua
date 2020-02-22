ESX  = nil
local open = false
local HaveBagOnHead = false

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Öppnar/stänger ögonbindel
RegisterNetEvent('jsfour-blindfold')
AddEventHandler('jsfour-blindfold', function( hasItem, src )
	if not open and hasItem then
		local playerPed = PlayerPedId()
    	Worek = CreateObject(`prop_money_bag_01`, 0, 0, 0, true, true, true) -- Create head bag object!
    	AttachEntityToEntity(Worek, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.2, 0.04, 0, 0, 270.0, 20.0, true, true, false, true, 1, true) -- Attach object to head
    	open = true
		SendNUIMessage({
			action = "open"
		})
	elseif open then
    	ESX.ShowNotification('~g~Quelqu\'un vous a enlevé le sac sur votre tête')
    	DeleteEntity(Worek)
    	SetEntityAsNoLongerNeeded(Worek)
		open = false
		SendNUIMessage({
			action = "close"
		})
		TriggerServerEvent('jsfour-blindfold:giveItem', src)
	else
		TriggerServerEvent('jsfour-blindfold:notis', src)
	end
end)
