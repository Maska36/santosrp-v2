ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler("playerSpawned", function()
	TriggerServerEvent('loadAttitudeSQL')
end)

local voice = {
	default = 8.0,
	shout = 15.0,
	whisper = 2.0,
	current = 0,
	level = nil
}

local DrawHUD = true

local x = 0.185
local y = 0.969

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x, y, width, height, r, g, b, a)
end

function drawLevel(r, g, b, a)
	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(_U('voice', voice.level))
	EndTextCommandDisplayText(0.162, 0.954)
end

AddEventHandler('onClientMapStart', function()
	if voice.current == 0 then
		NetworkSetTalkerProximity(voice.default)
	elseif voice.current == 1 then
		NetworkSetTalkerProximity(voice.shout)
	elseif voice.current == 2 then
		NetworkSetTalkerProximity(voice.whisper)
	end
end)

RegisterNetEvent('ToggleVoiceHUD')
AddEventHandler('ToggleVoiceHUD', function()
	DrawHUD = not DrawHUD
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(8)

		if IsControlJustPressed(1, 20) and IsControlPressed(1, 21) then
			voice.current = (voice.current + 1) % 3
			if voice.current == 0 then
				NetworkSetTalkerProximity(voice.default)
				ESX.ShowNotification('~y~Votre portée de voix est désormais sur : Parler')
				voice.level = _U('normal')
			elseif voice.current == 1 then
				NetworkSetTalkerProximity(voice.shout)
				ESX.ShowNotification('~y~Votre portée de voix est désormais sur : Chuchoter')
				voice.level = _U('shout')
			elseif voice.current == 2 then
				NetworkSetTalkerProximity(voice.whisper)
				ESX.ShowNotification('~y~Votre portée de voix est désormais sur : Crier')
				voice.level = _U('whisper')
			end
		end

		if DrawHUD then
			if voice.current == 0 then
				voice.level = _U('normal')
			elseif voice.current == 1 then
				voice.level = _U('shout')
			elseif voice.current == 2 then
				voice.level = _U('whisper')
			end
		end
	end
end)
