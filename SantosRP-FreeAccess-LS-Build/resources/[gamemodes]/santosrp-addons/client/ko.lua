ESX = nil

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if not IsEntityDead(PlayerPedId()) then
			if IsPedInMeleeCombat(PlayerPedId()) then
				if GetEntityHealth(PlayerPedId()) < 115 then
					SetPlayerInvincible(PlayerId(), true)
					SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
					ESX.ShowNotification("~r~Vous êtes K.O !")
					wait = 15
					knockedOut = true
					SetEntityHealth(PlayerPedId(), 116)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Wait(0)

		if not IsEntityDead(PlayerPedId()) then
			if knockedOut then
				SetPlayerInvincible(PlayerId(), true)
				DisablePlayerFiring(PlayerId(), true)
				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
				ResetPedRagdollTimer(PlayerPedId())
				
				if wait >= 0 then
					count = count - 1
					if count == 0 then
						count = 60
						wait = wait - 1
						SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 4)
					end
				else
					SetPlayerInvincible(PlayerId(), false)
					knockedOut = false
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)
