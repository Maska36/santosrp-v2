ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	local GUI, MenuType = {}, 'default'
	GUI.Time = 0

	local openMenu = function(namespace, name, data)
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})
	end

	local closeMenu = function(namespace, name)
		PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})
	end

	ESX.UI.Menu.RegisterType(MenuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.submit then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)	
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		if menu.cancel then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(MenuType, data._namespace, data._name)
		
		for i=1, #data.elements, 1 do
			
			menu.setElement(i, 'value', data.elements[i].value)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			else
				menu.setElement(i, 'selected', false)
			end

		end

		if menu.change then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	Citizen.CreateThread(function()
		while true do
	  		Wait(0)
	  		if NetworkIsSessionStarted() then
				if IsControlPressed(0, 191) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'ENTER'
					})
					-- PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					GUI.Time = GetGameTimer()
				elseif IsControlPressed(0, 177) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					-- PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'BACKSPACE'
					})
					GUI.Time = GetGameTimer()
				elseif IsControlPressed(0, 27) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					-- PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'TOP'
					})
					GUI.Time = GetGameTimer()
				elseif IsControlPressed(0, 173) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'DOWN'
					})
					GUI.Time = GetGameTimer()
				elseif IsControlPressed(0, 174) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					-- PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'LEFT'
					})
					GUI.Time = GetGameTimer()
				elseif IsControlPressed(0, 175) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
					-- PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					SendNUIMessage({
						action  = 'controlPressed',
						control = 'RIGHT'
					})
					GUI.Time = GetGameTimer()
				end
			else
				Citizen.Wait(500)
			end
	  	end
	end)
end)