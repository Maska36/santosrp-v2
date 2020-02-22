ESX = nil

local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenplongeeActionsMenu(zone)
	ESX.UI.Menu.CloseAll()
	
	local elements = {
		{label = 'Mettre la tenue <span style="color:green;">$100', value = 'cloakroom'},
		{label = 'Retirer la tenue', value = 'cloakroom2'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'plongee_actions',
	{
		css = "santos",
		title    = 'plongee',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'cloakroom' then
			menu.close()
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
	            		['tshirt_1'] = 15,
	            		['tshirt_2'] = 0,
						['ears_1'] = -1, 	  
						['ears_2'] = 0,
	            		['torso_1'] = 243,     
	            		['torso_2'] = 20,
	            		['decals_1'] = 0,     
	            		['decals_2']= 0,
	            		['mask_1'] = 36, 	  
	            		['mask_2'] = 0,
	            		['arms'] = 12,
	            		['pants_1'] = 94, 	  
	            		['pants_2'] = 20,
	            		['shoes_1'] = 67,     
	            		['shoes_2'] = 20,
	            		['helmet_1'] = 8,  
	            		['helmet_2'] = 0,
	            		['bags_1'] = 43,      
	            		['bags_2'] = 0,
						['glasses_1'] = 26,    
						['glasses_2'] = 4,
						['chain_1'] = 0,      
						['chain_2'] = 0,
	            		['bproof_1'] = 0,     
	            		['bproof_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
	            		['tshirt_1'] = 2,    
	            		['tshirt_2'] = 0,
						['ears_1'] = -1,      
						['ears_2'] = 0,
	            		['torso_1'] = 251,     
	            		['torso_2'] = 19,
	            		['decals_1'] = 0,     
	            		['decals_2'] = 0,
	            		['mask_1'] = 0,      
	            		['mask_2'] 	= 0,
	            		['arms'] = 7,
	            		['pants_1'] = 97,     
	            		['pants_2'] = 19,
	            		['shoes_1'] = 70,     
	            		['shoes_2'] = 19,
	            		['helmet_1']= -1,     
	            		['helmet_2'] = 0,
	            		['bags_1'] = 43,      
	            		['bags_2']	= 0,
						['glasses_1'] = 28,    
						['glasses_2'] = 3,
						['chain_1'] = 0,      
						['chain_2'] = 0,
	            		['bproof_1'] = 0,     
	            		['bproof_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
				TriggerServerEvent('esx_plongee:pay')
				local playerPed = PlayerPedId()
				SetEnableScuba(PlayerPedId(),true)
				SetPedMaxTimeUnderwater(PlayerPedId(), 1500.00)
			end)
		elseif data.current.value == 'cloakroom2' then
			menu.close()

			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, hasSkin)
					if hasSkin then
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('esx:restoreLoadout')
						SetPedMaxTimeUnderwater(PlayerPedId(), 20.00)
					end
				end)
			end)
		end
	end,
	function(data, menu)
		menu.close()

		CurrentAction     = 'plongee_actions_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
		CurrentActionData = {zone = zone}
	end)
end



AddEventHandler('esx_plongee:hasEnteredMarker', function(zone)
	CurrentAction     = 'plongee_actions_menu'
	CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
	CurrentActionData = {zone = zone}
end)



AddEventHandler('esx_plongee:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)



-- Create Blips

Citizen.CreateThread(function()		
	for k,v in pairs(ConfigPlonge.Zones) do
  		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

			SetBlipSprite (blip, 267)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.8)
			SetBlipColour (blip, 3)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Plongée")
			EndTextCommandSetBlipName(blip)
		end
	end
end)



Citizen.CreateThread(function()
	while true do		
		Citizen.Wait(5)		
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(ConfigPlonge.Zones) do
			for i = 1, #v.Pos, 1 do
				if(ConfigPlonge.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < ConfigPlonge.DrawDistance) then
					DrawMarker(ConfigPlonge.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ConfigPlonge.Size.x, ConfigPlonge.Size.y, ConfigPlonge.Size.z, ConfigPlonge.Color.r, ConfigPlonge.Color.g, ConfigPlonge.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(ConfigPlonge.Zones) do
			for i = 1, #v.Pos, 1 do
				if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < ConfigPlonge.Size.x) then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_plongee:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_plongee:hasExitedMarker', LastZone)
		end
	end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg)
            
            if IsControlJustReleased(0, 38) then                
                if CurrentAction == 'plongee_actions_menu' then
                    OpenplongeeActionsMenu()
                end

                CurrentAction = nil               
            end
        else
        	Citizen.Wait(500)
        end
    end
end)