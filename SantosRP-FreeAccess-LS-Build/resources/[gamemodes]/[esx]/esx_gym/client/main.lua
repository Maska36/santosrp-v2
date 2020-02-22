ESX = nil
local PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastZone
local CurrentAction
local CurrentActionMsg = ''
local CurrentActionData = {}
local training = false
local resting = false
local membership = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)
	
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-1201.2257, -1568.8670, 4.6101)
	SetBlipSprite(blip, 311)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 7)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Terrain de Muscu")
	EndTextCommandSetBlipName(blip)
end)

function OpenGymMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gym_menu',
    {
		css = "santos",
        title = 'Musculation',
        elements = {
			{label = 'Boutique', value = 'shop'},
			{label = 'Heures d\'ouverture', value = 'hours'},
			{label = 'Abonnement', value = 'ship'},
        }
    },
    function(data, menu)
        if data.current.value == 'shop' then
			OpenGymShopMenu()
        elseif data.current.value == 'hours' then
			menu.close()
				
			ESX.ShowNotification("Nous sommes ouvert ~g~24/24~w~.")
        elseif data.current.value == 'ship' then
			OpenGymShipMenu()
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function OpenGymShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gym_shop_menu',
    {
		css = "santos",
        title    = 'Muscu - Boutique',
        elements = {
			{label = 'Shaker de protéine <span style="color:green;">$6', value = 'protein_shake'},
			{label = 'Sportlunch <span style="color:green;">$2', value = 'sportlunch'},
			{label = 'Powerade <span style="color:green;">$4', value = 'powerade'},
			{label = 'Bandage <span style="color:green;">$50', value = 'bandage'},
        }
    },
    function(data, menu)
        if data.current.value == 'protein_shake' then
			TriggerServerEvent('esx_gym:buyProteinshake')
        elseif data.current.value == 'water' then
			TriggerServerEvent('esx_gym:buyWater')
        elseif data.current.value == 'sportlunch' then
			TriggerServerEvent('esx_gym:buySportlunch')
        elseif data.current.value == 'powerade' then
			TriggerServerEvent('esx_gym:buyPowerade')
        elseif data.current.value == 'bandage' then
			TriggerServerEvent('esx_gym:buyBandage')
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function OpenGymShipMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gym_ship_menu',
    {
		css = "santos",
        title = 'Muscu - Abonnement',
        elements = {
			{label = 'Abonnement <span style="color:green;">$800', value = 'membership'},
        }
    },
    function(data, menu)
        if data.current.value == 'membership' then
			menu.close()
			TriggerServerEvent('esx_gym:buyMembership')
        end
	end,
    function(data, menu)
        menu.close()
    end)
end

function CheckTraining()
	if resting == true then
		ESX.ShowNotification("Vous vous reposez...")
		
		resting = false
		Citizen.Wait(60000)
		training = false
	elseif resting == false then
		ESX.ShowNotification("Vous pouvez maintenant exercer à nouveau...")
	end
end

RegisterNetEvent('esx_gym:useBandage')
AddEventHandler('esx_gym:useBandage', function()
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)
	local health = GetEntityHealth(playerPed)
	local newHealth = math.min(maxHealth , math.floor(health + maxHealth/3))

	SetEntityHealth(playerPed, newHealth)
	--SetEntityHealth(playerPed, maxHealth) -- Give them full health by one bandage
	
	ESX.ShowNotification("Vous avez utilisé un ~g~bandage")
end)

RegisterNetEvent('esx_gym:trueMembership')
AddEventHandler('esx_gym:trueMembership', function()
	membership = true
end)

RegisterNetEvent('esx_gym:falseMembership')
AddEventHandler('esx_gym:falseMembership', function()
	membership = false
end)

-- LOCATION
locations = {
	Arms = {
		vector3(-1202.9837, -1565.1718, 4.6115)
	},
	
	PushUp = {
		vector3(-1203.3242, -1570.6184, 4.6115)
	},
	
	Yoga = {
		vector3(-1204.7958, -1560.1906, 4.6115)
	},
	
	SitUps = {
		vector3(-1206.1055, -1565.1589, 4.6115)
	},
	
	Gym = {
		vector3(-1195.6551, -1577.7689, 4.6115)
	},
	
	Chins = {
		vector3(-1200.1284, -1570.9903, 4.6115)
	}
}
-- END LOCATION

function doExec(zone)
	local anim = nil
	if zone == "Arms" then
		anim = "world_human_muscle_free_weights"
	elseif zone == "PushUp" then
		anim = "world_human_push_ups"
	elseif zone == "Yoga" then
		anim = "world_human_yoga"
	elseif zone == "SitUps" then
		anim = "world_human_sit_ups"
	elseif zone == "Chins" then
		anim = "prop_human_muscle_chin_ups"
	end
	
	if training == false then	
		TriggerServerEvent('esx_gym:checkChip')
		ESX.ShowNotification("~g~Préparation de l\'exercice...~w~")
		Wait(1000)
		if membership == true then
			TaskStartScenarioInPlace(PlayerPedId(), anim, 0, true)
			Wait(30000)
			ClearPedTasksImmediately(PlayerPedId())
			ESX.ShowNotification("~r~Vous devez vous reposer 60 secondes avant de faire un autre exercice.~w~")
			TriggerServerEvent('stadus_skills:addStrength', GetPlayerServerId(PlayerId()), (math.random() + 0))
						
			training = true
		elseif membership == false then
			ESX.ShowNotification("~r~Vous avez besoin d'un abonnement pour faire un exercice")
		end							
	elseif training == true then
		ESX.ShowNotification("~y~Vous devez vous reposer...")
		resting = true
		CheckTraining()
	end
end

AddEventHandler('esx_gym:hasEnteredMarker', function(zone)
	if zone == 'Arms' then
		CurrentAction = 'arms'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour travailler vos ~g~bras~w~"
		CurrentActionData = {zone= zone}
	elseif zone == 'PushUp' then
		CurrentAction = 'pushup'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour faire des ~g~tractions~w~"
		CurrentActionData = {zone= zone}
	elseif zone == 'Yoga' then
		CurrentAction = 'yoga'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour faire de la Muscu"
		CurrentActionData = {zone = zone}
	elseif zone == 'SitUps' then
		CurrentAction = 'situps'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour faire de la Muscu"
		CurrentActionData = {zone = zone}
	elseif zone == 'Gym' then
		CurrentAction = 'gym'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour l'abonnement Muscu"
		CurrentActionData = {zone = zone}
	elseif zone == 'Chins' then
		CurrentAction = 'chins'
		CurrentActionMsg = "Appuyez sur ~INPUT_CONTEXT~ pour faire de la Muscu"
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('esx_gym:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local isInMarker, letSleep, currentZone = false, true

		for k,v in pairs(locations)  do
	        local distance = #(playerCoords - v[1])

	        if distance < 40 then
				letSleep = false

				DrawMarker(21, v[1], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 200, 0, 100, false, true, 2, false, false, false, false)

	            if distance < 0.5 then
	                isInMarker, currentZone = true, k
	            end
	        end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			TriggerEvent('esx_gym:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_gym:hasExitedMarker', LastZone)
		end

	    if letSleep then
	        Citizen.Wait(500)
	    end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlPressed(0, 38) then
				if CurrentAction == 'arms' then
					doExec(CurrentActionData.zone)
				elseif CurrentAction == 'pushup' then
					doExec(CurrentActionData.zone)
				elseif CurrentAction == 'yoga' then
					doExec(CurrentActionData.zone)
				elseif CurrentAction == 'situps' then
					doExec(CurrentActionData.zone)
				elseif CurrentAction == 'gym' then
					OpenGymMenu()
				elseif CurrentAction == 'chins' then
					doExec(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
      	else
        	Citizen.Wait(500)
		end
	end
end)