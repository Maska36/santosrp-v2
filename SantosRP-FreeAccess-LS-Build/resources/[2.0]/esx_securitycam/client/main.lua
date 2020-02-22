ESX = nil
local PlayerData = {}
local isInMarker = false
local CurrentAction = nil
local CurrentActionMsg = ''
local HasAlreadyEnteredMarker = false
local LastZone = nil
local menuopen = false
local bankcamera = false
local policecamera = false
local blockbuttons = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_securitycam:hasEnteredMarker', function (zone)
	if zone == 'Cameras' and not menuopen then
		CurrentAction     = 'cameras'
		CurrentActionMsg  = _U('marker_hint')
	end
end)

AddEventHandler('esx_securitycam:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone = nil

		for k, v in pairs(Config.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == "police" then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)

					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.5 then
						DrawText3D(v.Pos.x, v.Pos.y, v.Pos.z+0.9, "~w~[~b~E~w~] Démarrer les caméras.", 0.80)
					end
				end
			end
		end

		for k,v in pairs(Config.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == "police" then
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 1.5) then
					isInMarker  = true
					currentZone = k
				end
			end
		end
			
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_securitycam:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_securitycam:hasExitedMarker', LastZone)
			CurrentAction = nil
			ESX.UI.Menu.CloseAll()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 38) and CurrentAction == 'cameras' then

			if not menuopen then
				CurrentAction, menuopen = nil, true

				local elements = {
					{label = _U('bank_menu_selection'),   value = 'bankmenu'},
					{label = _U('police_menu_selection'), value = 'policemenu'}
				}

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
				{
					css = 'santos',
					title    = _U('securitycams_menu'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)

					if data.current.value == 'bankmenu' then
						menu.close()

						bankcamera = true
						blockbuttons = true

						local firstCamx = Config.Locations[1].bankCameras[1].x
						local firstCamy = Config.Locations[1].bankCameras[1].y
						local firstCamz = Config.Locations[1].bankCameras[1].z
						local firstCamr = Config.Locations[1].bankCameras[1].r
							
						SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
						ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)

						if Config.HideRadar then
							StartHideHUD()
						end

						SendNUIMessage({
							type = "enablecam",
							label = Config.Locations[1].bankCameras[1].label,
							box = Config.Locations[1].bankCamLabel.label
						})

						currentCameraIndex = 1
						currentCameraIndexIndex = 1
						menuopen = false
							
						TriggerEvent('esx_securitycam:freeze', true)
					elseif data.current.value == 'policemenu' then
						menu.close()

						policecamera = true
						blockbuttons = true

						local firstCamx = Config.Locations[1].policeCameras[1].x
						local firstCamy = Config.Locations[1].policeCameras[1].y
						local firstCamz = Config.Locations[1].policeCameras[1].z
						local firstCamr = Config.Locations[1].policeCameras[1].r

						SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
						ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)

						if Config.HideRadar then
							StartHideHUD()
						end

						SendNUIMessage({
							type  = "enablecam",
							label = Config.Locations[1].policeCameras[1].label,
							box   = Config.Locations[1].policeCamLabel.label
						})

						currentCameraIndex = 1
						currentCameraIndexIndex = 1
						menuopen = false

						TriggerEvent('esx_securitycam:freeze', true)
					end
				end, function(data, menu)
					menu.close()
					menuopen = false
				end)
			end
		end

		if createdCamera ~= 0 then
			local instructions = CreateInstuctionScaleform("instructional_buttons")

			DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
			SetTimecycleModifier("scanline_cam_cheap")
			SetTimecycleModifierStrength(2.0)

			-- CLOSE CAMERAS
			if IsControlJustPressed(0, 177) then
				CloseSecurityCamera()
				SendNUIMessage({
					type = "disablecam",
				})

				CurrentAction = nil
				bankcamera = false
				policecamera = false
				blockbuttons = false
				if Config.HideRadar then
					StopHideHUD()
				end
				TriggerEvent('esx_securitycam:freeze', false)
			end

			-- GO BACK CAMERA
			if IsControlJustPressed(0, 174) then
				if bankcamera then
					local newCamIndex

					if currentCameraIndexIndex == 1 then
						newCamIndex = #Config.Locations[currentCameraIndex].bankCameras
					else
						newCamIndex = currentCameraIndexIndex - 1
					end

					local newCamx = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].x
					local newCamy = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].y
					local newCamz = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].z
					local newCamr = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].r

					SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
					SendNUIMessage({
						type = "updatecam",
						label = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].label
					})

					ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
					currentCameraIndexIndex = newCamIndex
				elseif policecamera then
					local newCamIndex

					if currentCameraIndexIndex == 1 then
						newCamIndex = #Config.Locations[currentCameraIndex].policeCameras
					else
						newCamIndex = currentCameraIndexIndex - 1
					end

					local newCamx = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].x
					local newCamy = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].y
					local newCamz = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].z
					local newCamr = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].r

					SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
					SendNUIMessage({
						type = "updatecam",
						label = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].label
					})

					ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
					currentCameraIndexIndex = newCamIndex
				end
			end

			-- GO FORWARD CAMERA
			if IsControlJustPressed(0, 175) then
				if bankcamera then
					local newCamIndex

					if currentCameraIndexIndex == #Config.Locations[currentCameraIndex].bankCameras then
						newCamIndex = 1
					else
						newCamIndex = currentCameraIndexIndex + 1
					end

					local newCamx = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].x
					local newCamy = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].y
					local newCamz = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].z
					local newCamr = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].r

					SendNUIMessage({
						type = "updatecam",
						label = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].label
					})

					ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
					currentCameraIndexIndex = newCamIndex
				elseif policecamera then
					local newCamIndex

					if currentCameraIndexIndex == #Config.Locations[currentCameraIndex].policeCameras then
						newCamIndex = 1
					else
						newCamIndex = currentCameraIndexIndex + 1
					end

					local newCamx = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].x
					local newCamy = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].y
					local newCamz = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].z
					local newCamr = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].r

					SendNUIMessage({
						type = "updatecam",
						label = Config.Locations[currentCameraIndex].policeCameras[newCamIndex].label
					})

					ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
					currentCameraIndexIndex = newCamIndex
				end
			end

			if Config.Locations[currentCameraIndex].bankCameras[currentCameraIndexIndex].canRotate then
				local getCameraRot = GetCamRot(createdCamera, 2)

				-- ROTATE LEFT
				if IsControlPressed(1, 108) then
					SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
				end

				-- ROTATE RIGHT
				if IsControlPressed(1, 107) then
					SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
				end

			elseif Config.Locations[currentCameraIndex].policeCameras[currentCameraIndexIndex].canRotate then
				local getCameraRot = GetCamRot(createdCamera, 2)

				-- ROTATE LEFT
				if IsControlPressed(1, 108) then
					SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
				end

				-- ROTATE RIGHT
				if IsControlPressed(1, 107) then
					SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
				end
			end

		end
	end
end)

function StartHideHUD()
	Citizen.CreateThread(function()
		while blockbuttons do
			Citizen.Wait(100)
			DisplayRadar(false)
			ESX.UI.HUD.SetDisplay(0.0)
			TriggerEvent('es:setMoneyDisplay', 0.0)
			TriggerEvent('esx_status:setDisplay', 0.0)
		end
	end)
end

function StopHideHUD()
	Citizen.CreateThread(function()
		while not blockbuttons do
			Citizen.Wait(100)
			
    		ESX.TriggerServerCallback('esx_securitycam:itemCheck', function(hasItem)
        		if hasItem then
            		DisplayRadar(true)
        		end
    		end)
			ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('es:setMoneyDisplay', 1.0)
			TriggerEvent('esx_status:setDisplay', 0.9)
		end
	end)
end

function ChangeSecurityCamera(x, y, z, r)
	if createdCamera ~= 0 then
		DestroyCam(createdCamera, 0)
		createdCamera = 0
	end

	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, x, y, z)
	SetCamRot(cam, r.x, r.y, r.z, 2)
	RenderScriptCams(1, 0, 0, 1, 1)

	createdCamera = cam
end

function CloseSecurityCamera()
	DestroyCam(createdCamera, 0)
	RenderScriptCams(0, 0, 1, 1, 1)
	createdCamera = 0
	ClearTimecycleModifier("scanline_cam_cheap")
	SetFocusEntity(GetPlayerPed(PlayerId()))
end

function CreateInstuctionScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 175, true))
	InstructionButtonMessage(_U('next'))
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 174, true))
	InstructionButtonMessage(_U('previous'))
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(2)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 177, true))
	InstructionButtonMessage(_U('close'))
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

RegisterNetEvent('esx_securitycam:freeze')
AddEventHandler('esx_securitycam:freeze', function(freeze)
	FreezeEntityPosition(PlayerPedId(), freeze)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if blockbuttons then
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, 45, true)
			DisableControlAction(2, 22, true)
			DisableControlAction(2, 44, true)
			DisableControlAction(2, 37, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 57, true)
		else
			Citizen.Wait(1000)
		end
	end
end)

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)
end