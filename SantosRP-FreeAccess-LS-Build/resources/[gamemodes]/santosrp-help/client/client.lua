local santosHelpGUI = false
local isOpened = false

function santosHelpstart()
	if not santosHelpGUI then
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'open'})
		santosHelpGUI = true
		isOpened = true
	end
end

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	santosHelpGUI = false
	isOpened = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if not isOpened then
			if IsControlJustReleased(0, 170) then
				santosHelpstart()
			end
		else
			Citizen.Wait(500)
		end
	end
end)