secondsUntilKick = 1140
kickWarning = true

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		if not IsEntityDead(PlayerPedId()) then
			currentPos = GetEntityCoords(PlayerPedId(), true)

			if currentPos == prevPos then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						TriggerEvent('esx:showNotification', 'Vous allez être kick dans '..time..' secondes pour AFK !')
					end

					time = time - 1
				else
					TriggerServerEvent("antiafk:kick")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)