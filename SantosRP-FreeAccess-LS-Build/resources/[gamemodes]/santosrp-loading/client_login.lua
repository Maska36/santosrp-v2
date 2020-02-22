local logginIn = false

AddEventHandler('onPlayerJoining', function(playerId, name)
	TriggerServerEvent('foundation:onPlayerConnect')
end)

RegisterNetEvent('foundation:playerLog')
AddEventHandler('foundation:playerLog', function(loginStatus)
	logginIn = loginStatus
	SendNUIMessage({ })
end)



Citizen.CreateThread(function()
	Wait(500)
	
	if NetworkIsPlayerActive(PlayerId()) then
		if not logginIn then
			local ped = GetPlayerPed(PlayerId())
			if IsEntityVisible(ped) then
				SetEntityVisible(ped, false)
			end
			SetPlayerInvincible(PlayerId(), true)
			SetPlayerControl(PlayerId(), false, false)
		end
	end        
end)