RegisterNetEvent('rlUpdateNames')

AddEventHandler('rlUpdateNames', function()
    local names = {}

    for _, player in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(player) then
            names[GetPlayerServerId(player)] = { id = player, name = GetPlayerName(player) }
        end
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('rlPlayerActivated')

			return
		end
	end
end)