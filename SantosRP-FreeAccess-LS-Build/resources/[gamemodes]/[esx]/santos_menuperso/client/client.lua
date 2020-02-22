ESX = nil

Licenses = {}
carryingBackInProgress, piggyBackInProgress, holdingHostageInProgress = false, false, false
gunRemoveObj, gunAttachObj = false, false
freezed, plyLastPos = false, nil
CinematicCamMaxHeight, CinematicCamBool, w = 0.27, false, 0
currentVoice, currentNameVoice = 8.0, "Normal"
isAskingFouille, isRequestAnim, requestedemote, inTrunk = false, false, '', false
showname, currentNameShowPly = false, "Désactivé"

isAdmin = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().org == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('santos_menuperso:ServerLoadLicenses')
	Citizen.Wait(2000)
	ESX.TriggerServerCallback('infinity:getPlayersInfos', function(Players)
		UpdatePlayerTable(Players)
	end)
end)

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	local ems, police, taxi, mechanic, cardealer, estate, players = 0, 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do
		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' then
			police = police + 1
		elseif v.job == 'taxi' then
			taxi = taxi + 1
		elseif v.job == 'mecano' then
			mechanic = mechanic + 1
		elseif v.job == 'cardealer' then
			cardealer = cardealer + 1
		elseif v.job == 'realestateagent' then
			estate = estate + 1
		end
	end
end

RegisterNetEvent('smp:getSim')
AddEventHandler('smp:getSim', function()
	ESX.TriggerServerCallback("santos_menuperso:getSim", function(result2)
		SimTab = result2
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setOrg')
AddEventHandler('esx:setOrg', function(org)
	ESX.PlayerData.org = org
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('loadMenuPersoSQL')

	ESX.TriggerServerCallback("santos_menuperso:getSim", function(result2)
    	SimTab = result2
	end)
	ESX.TriggerServerCallback('santos_menuperso:isAdmin', function(Bool)
		isAdmin = Bool
	end)
end)

RegisterNetEvent('santos_menuperso:syncSim')
AddEventHandler('santos_menuperso:syncSim', function()
    ESX.TriggerServerCallback("santos_menuperso:getSim", function(result)
        SimTab = result
    end)
end)

RegisterNetEvent('santos_menuperso:loadMenuPersoSQL')
AddEventHandler('santos_menuperso:loadMenuPersoSQL', function(voice, lib, anim)
	Citizen.Wait(3000)

	if NetworkIsSessionStarted() then
		if ESX then
			if (lib ~= "" and anim ~= "") or lib ~= nil and anim ~= nil then
				ESX.Streaming.RequestAnimSet(lib, function()
					SetPedMovementClipset(PlayerPedId(), anim, true)
				end)
			end
		end
		
		currentVoice = voice
		NetworkSetTalkerProximity(currentVoice)
		loadVoice()
	end
end)

function loadVoice()
	if currentVoice == 3.0 then
		currentNameVoice = "Chuchoter"
	elseif currentVoice == 8.0 then
		currentNameVoice = "Normal"
	elseif currentVoice == 15.0 then
		currentNameVoice = "Crier"
	end

	TriggerEvent('SendVoiceDistance', currentNameVoice)
end

function CinematicCamDisplay(bool) -- [[Handles Displaying Radar, Body Armour and the rects themselves.]]
    Wait(0)
    if bool then
        DisplayRadar(false)
        for i = 0, CinematicCamMaxHeight, 0.01 do 
            Wait(10)
            w = i
        end
    else
		ESX.TriggerServerCallback('santos_menuperso:itemCheck', function(hasItem)
			if hasItem then
	        	DisplayRadar(true)
	        end
		end)
        for i = CinematicCamMaxHeight, 0, -0.09 do
            Wait(10)
            w = i
        end 
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if w > 0 then
            DrawRects(w)
	        if CinematicCamBool then
	            DESTROYHudComponents()
	        end
	    else
	    	Citizen.Wait(500)
        end
    end
end)


function OpenPersonnelMenu()
	ESX.UI.Menu.CloseAll()

	local elements = {}
	
	if isAdmin then
		table.insert(elements, {label = '🔨 Modération', value = 'menuperso_modo'})
	end

	table.insert(elements, {label = '👦🏽 Moi', value = 'menuperso_moi'})
	table.insert(elements, {label = '💪 Corps', value = 'menuperso_corps'})
		
		if (IsInVehicle()) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if (GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()) then
				table.insert(elements, {label = '🚗 Véhicule', value = 'menuperso_vehicule'})
			end
		end

		table.insert(elements, {label = '🎬 Actions', value = 'menuperso_acti'})
		
		if ESX.PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = '🏢 Gérer mon entreprise', value = 'menuperso_grade'})
		end
		
		if ESX.PlayerData.org.grade_name == 'boss' then
			table.insert(elements, {label = '🔪 Gérer mon organisation', value = 'menuperso_orggrade'})
		end

		table.insert(elements, {label = '👉 Autres', value = 'menuperso_moi_autres'})
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_perso',
		{
			css = 'santos',
			title    = '['..GetPlayerServerId(PlayerId())..'] - '..GetPlayerName(PlayerId()),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			local elements = {}
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
			if data.current.value == 'menuperso_modo' then
				table.insert(elements, {label = '🙎‍♂️ Joueurs', value = 'menuperso_modo_joueurs'})
				table.insert(elements, {label = '🚗 Véhicules', value = 'menuperso_modo_vehicules'})

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo',
				{
					css = 'santos',
					title    = 'Modération',
					align    = 'top-left',
					elements = elements
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_modo_joueurs' then
						openModoJoueurs()
					elseif data2.current.value == 'menuperso_modo_vehicules' then
						openModoVehicules()
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_moi' then
				TriggerServerEvent('santos_menuperso:ServerLoadLicenses')
				ESX.TriggerServerCallback("santos_menuperso:getSim", function(result2)
					SimTab = result2
				end)
				SimTab = {}
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi',
				{
					css = 'santos',
					title = 'Moi',
					align = 'top-left',
					elements = {
						{label = "💳 Portefeuille", value = "menuperso_moi_papiers"},
						{label = "📱 Carte SIM", value = "menuperso_moi_phone"},
						--{label = "🚗 Mes véhicules [SOON]", value = "menuperso_moi_voiture"},
						--{label = "👕 Vêtements", value = "menuperso_moi_accessoire"},
						{label = "📝 Factures", value = "menuperso_moi_factures"},
					},
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_moi_papiers' then
						openPapiers()
					elseif data2.current.value == 'menuperso_moi_phone' then
						local res = SimTab
						if #res == 0 then
							local elements = {}
							table.insert(elements, {label = 'Aucune SIM', value = 'no-sim'})
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi_phone', {
								css = 'santos',
								title = 'Mon Téléphone',
								align = 'top-left',
								elements = elements
							},
							function (data3, menu3)
								ESX.ShowNotification('~g~Tu peux acheter une carte SIM au Santos-Mobile.')
							end,
							function (data3, menu3)
								menu3.close()
							end)
						end
						local elements = {}
						local number = {}

						for i=1, #res, 1 do
							table.insert(number, {number = res[i].number, label = res[i].label, id = res[i].id})
							table.insert(elements, {label = res[i].label, value = res[i].number, id =  res[i].id})

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), "phone",
							{
								css = 'santos',
								title = 'Mon Téléphone',
								align = 'top-left',
								elements = elements
							},
							function(data3, menu3)
								local elementss = {}

								table.insert(elementss, {label = 'Utiliser', value = 'use-sim'})
								table.insert(elementss, {label = 'Renommer', value = 'rename-sim'})
								table.insert(elementss, {label = 'Donner', value = 'give-sim'})
								table.insert(elementss, {label = 'Supprimer', value = 'remove-sim'})

								ESX.UI.Menu.Open('default', GetCurrentResourceName(), data3.current.value,
								{
									css = 'santos',
									title = data3.current.label,
									align = 'top-left',
									elements = elementss
								},
								function(data4, menu4)
									if data4.current.value == "use-sim" then
										ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
										    if qtty >= 0 then
										        TriggerServerEvent("santos_menuperso:SetNumber", data3.current.value)
										        else
										        ESX.ShowNotification("~r~Vous n'avez pas de téléphone !")
										    end
										end, 'phone')
									elseif data4.current.value == "rename-sim" then
										local txt = nil
													
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename-sim', {
											title = 'Nouveau nom de votre SIM',
											value = ''
										},
										function (data, menu)
											local resu = data.value

											if resu and resu ~= "" then
												resu = resu
											else
												resu = data3.current.label
											end

											if resu == "" then
												resu = data3.current.label
											end

											txt = resu
											menu.close()

											if txt ~= nil then
											    TriggerServerEvent('santos_menuperso:RenameSim', data3.current.id, txt)
											    data3.current.label = txt
												menu.close()
												menu2.close()
												menu3.close()
												menu4.close()
											end
										end,
										function (data, menu)
											menu.close()
										end)
									elseif data4.current.value == "give-sim" then
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
										local closestPed = GetPlayerPed(closestPlayer)
										            
										if IsPedSittingInAnyVehicle(closestPed) then
										    ESX.ShowNotification('~r~Vous ne pouvez pas donner quelque chose à quelqu\'un dans un véhicule')
										    return
										end

										if closestPlayer ~= -1 and closestDistance < 3.0 then
										    TriggerServerEvent('santos_menuperso:GiveNumber', GetPlayerServerId(closestPlayer), data3.current.value)
										    animPlay("mp_common", "givetake1_a")
										    table.remove(SimTab, i)
											menu.close()
											menu2.close()
											menu3.close()
											menu4.close()
										else
										    ESX.ShowNotification("~r~Il n'y a personne à proximité.")
										end
									elseif data4.current.value == "remove-sim" then
										TriggerServerEvent('santos_menuperso:Throw', data3.current.value)
										table.remove(SimTab, i)
										menu.close()
										menu2.close()
										menu3.close()
										menu4.close()
									end
								end,
								function(data4, menu4)
									menu4.close()
								end)
							end,
							function(data3, menu3)
								menu3.close()
							end)
						end
					elseif data2.current.value == 'menuperso_moi_factures' then
						openFacture()
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_corps' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi',
				{
					css = 'santos',
					title = 'Mon corps',
					align = 'top-left',
					elements = {
						{label = "👕 Vêtements", value = "menuperso_moi_accessoire"},
						{label = "🕺 Animations", value = "menuperso_actions"},
						{label = "😀 Expressions faciales", value = "menuperso_expf"},
						{label = "🚶 Démarches", value = "menuperso_attitudes"},
					},
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_moi_accessoire' then
						openAccesoire()
					elseif data2.current.value == 'menuperso_attitudes' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_attitudes',
						{
							css = 'santos',
							title    = 'Démarches',
							align    = 'top-left',
							elements = {
								{label = 'Par défaut [Homme]', value = 'move_m@multiplayer'},
								{label = 'Par défaut [Femme]', value = 'move_f@multiplayer'},
								{label = 'Alien', value = 'move_m@alien'},
								{label = 'Arrogante', value = 'move_f@arrogant@a'},
								{label = 'Blindé', value = 'anim_group_move_ballistic'},
								{label = 'Brave', value = 'move_m@brave'},
								{label = 'Casual', value = 'move_m@casual@a'},
								{label = 'Casual #2', value = 'move_m@casual@b'},
								{label = 'Casual #3', value = 'move_m@casual@c'},
								{label = 'Casual #4', value = 'move_m@casual@d'},
								{label = 'Casual #5', value = 'move_m@casual@e'},
								{label = 'Casual #6', value = 'move_m@casual@f'},
								{label = 'Chichi', value = 'move_f@chichi'},
								{label = 'Sûr de soi', value = 'move_m@confident'},
								{label = 'Police', value = 'move_m@business@a'},
								{label = 'Police #2', value = 'move_m@business@b'},
								{label = 'Police #3', value = 'move_m@business@c'},
								{label = 'Légèrement bourré', value = 'move_m@drunk@slightlydrunk'},
								{label = 'Bourré', value = 'move_m@drunk@a'},
								{label = 'Bourré #2', value = 'move_m@buzzed'},
								{label = 'Trop Bourrhzoifr', value = 'move_m@drunk@verydrunk'},
								{label = 'Femme', value = 'move_f@femme@'},
								{label = 'Franklin énervé', value = 'move_characters@franklin@fire'},
								{label = 'Michael énervé', value = 'move_characters@michael@fire'},
								{label = 'Enervé', value = "move_m@fire"},
								{label = 'Fuir', value = 'move_f@flee@a'},
								{label = 'Franklin', value = 'move_p_m_one'},
								{label = 'Gangster', value = 'move_m@gangster@generic'},
								{label = 'Gangster #2', value = 'move_m@gangster@ng'},
								{label = 'Gangster #3', value = 'move_m@gangster@var_e'},
								{label = 'Gangster #4', value = 'move_m@gangster@var_f'},
								{label = 'Gangster #5', value = 'move_m@gangster@var_i'},
								{label = 'Rainurage', value = 'anim@move_m@grooving@'},
								{label = 'Talons', value = 'move_f@heels@c'},
								{label = 'Talons #2', value = 'move_f@heels@d'},
								{label = 'Randonnée', value = 'move_m@hiking'},
								{label = 'Hipster', value = 'move_m@hipster@a'},
								{label = 'Clochard', value = 'move_m@hobo@a'},
								{label = 'Concierge', value = 'move_p_m_zero_janitor'},
								{label = 'Concierge #2', value = 'move_p_m_zero_slow'},
								{label = 'Jogging', value = 'move_m@jog@'},
								{label = 'Lamar', value = 'anim_group_move_lemar_alley'},
								{label = 'Lester', value = 'move_heist_lester'},
								{label = 'Lester #2', value = 'move_lester_caneup'},
								{label = 'Mangeuse d\'Hommes', value = 'move_f@maneater'},
								{label = 'Michael', value = 'move_ped_bucket'},
								{label = 'Riche', value = 'move_m@money'},
								{label = 'Musclé', value = 'move_m@muscle@a'},
								{label = 'Chic [Homme]', value = 'move_m@posh@'},
								{label = 'Chic [Femme]', value = 'move_f@posh@'},
								{label = 'Rapide', value = 'move_m@quick'},
								{label = 'Pressé [Homme]', value = 'move_m@hurry@a'},
								{label = 'Pressée [Femme]', value = 'move_f@hurry@a'},
								{label = 'Pressé x2', value = 'move_m@hurry_butch@a'},
								{label = 'Coureuse', value = 'female_fast_runner'},
								{label = 'Triste', value = 'move_m@sad@a'},
								{label = 'Impertinent [Homme]', value = 'move_m@sassy'},
								{label = 'Impertinente [Femme]', value = 'move_f@sassy'},
								{label = 'Effrayée', value = 'move_f@scared'},
								{label = 'Sexy', value = 'move_f@scared'},
								{label = 'Arouf Gangsta', value = 'move_m@shadyped@a'},
								{label = 'Lent', value = 'move_characters@jimmy@slow@'},
								{label = 'Bg', value = 'move_m@swagger'},
								{label = 'Dur [Homme]', value = 'move_m@tough_guy@'},
								{label = 'Dure [Femme]', value = 'move_f@tough_guy@'},
								{label = 'Trash', value = 'clipset@move@trash_fast_turn'},
								{label = 'Trash #2', value = 'missfbi4prepp1_garbageman'},
								{label = 'Trevor', value = 'move_p_m_two'},
								{label = 'Large', value = 'move_m@bag'},
								{label = 'Depressif [Homme]', value = 'move_m@depressed@a'},
								{label = 'Depressif [Femme]', value = 'move_f@depressed@a'},
								{label = 'Trop mangé', value = 'move_m@fat@a'},
								{label = 'Blessé', value = 'move_m@injured'},
							},
						}, function(data3, menu3)
							animsActionAttitude(data3.current.value, data3.current.value)
						end, function(data3, menu3)
							menu3.close()
						end)
					elseif data2.current.value == 'menuperso_expf' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_expf',
						{
							css = 'santos',
							title    = 'Expressions faciales',
							align    = 'top-left',
							elements = {
								{label = 'Par défaut', mood = 'default'},
								{label = 'Énervé', mood = 'mood_angry_1'},
								{label = 'Bourré', mood = 'mood_drunk_1'},
								{label = 'Tebé', mood = 'pose_injured_1'},
								{label = 'Électrocuté', mood = 'electrocuted_1'},
								{label = 'Grincheux', mood = 'effort_1'},
								{label = 'Grincheux #2', mood = 'mood_drivefast_1'},
								{label = 'Grincheux #3', mood = 'pose_angry_1'},
								{label = 'Heureux', mood = 'mood_happy_1'},
								{label = 'Blessé', mood = 'mood_injured_1'},
								{label = 'Joyeux', mood = 'mood_dancing_low_1'},
								{label = 'Respirer par la bouche', mood = 'smoking_hold_1'},
								{label = 'Ne jamais cligner des yeux', mood = 'pose_normal_1'},
								{label = 'Un oeil', mood = 'pose_aiming_1'},
								{label = 'Choqué', mood = 'shocked_1'},
								{label = 'Choqué #2', mood = 'shocked_2'},
								{label = 'Dormir', mood = 'mood_sleeping_1'},
								{label = 'Mort #1', mood = 'dead_1'},
								{label = 'Mort #2', mood = 'dead_2'},
								{label = 'Suffisant', mood = 'mood_smug_1'},
								{label = 'Spéculatif', mood = 'mood_aiming_1'},
								{label = 'Stressé', mood = 'mood_stressed_1'},
								{label = 'Bizarre', mood = 'effort_2'},
								{label = 'Bizarre #2', mood = 'effort_3'},
							},
						},
						function(data3, menu3)
							if data3.current.mood == "default" then
								ClearFacialIdleAnimOverride(PlayerPedId())
							else
								SetFacialIdleAnimOverride(PlayerPedId(), data3.current.mood)
							end
						end,
						function(data3, menu3)
							menu3.close()
						end)
					elseif data2.current.value == 'menuperso_actions' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions',
						{
							css = 'santos',
							title    = 'Animations',
							align    = 'top-left',
							elements = {
								{label = '❌ Arreter l\'animation',  value = 'menuperso_actions_annuler'},
								{label = 'Salutations',  value = 'menuperso_actions_Salute'},
								{label = 'Humeurs',  value = 'menuperso_actions_Humor'},
								{label = 'Travails',  value = 'menuperso_actions_Travail'},
								{label = 'Festives',  value = 'menuperso_actions_Festives'},
								{label = 'Sports',  value = 'menuperso_actions_Sports'},
								{label = 'Danses',  value = 'menuperso_actions_danses'},
								{label = 'PEGI 🔞',  value = 'menuperso_actions_Pegi'},
								-- {label = 'Trivia',  value = 'menuperso_actions_Trivia'},
								{label = 'Autres',  value = 'menuperso_actions_Others'},
							},
						},
						function(data2, menu2)
							if data2.current.value == 'menuperso_actions_annuler' then
								playAnim = false
								ClearPedTasks(PlayerPedId())
							elseif data2.current.value == 'menuperso_actions_Salute' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Salute',
								{
									css = 'santos',
									title    = 'Animations de salutations',
									align    = 'top-left',
									elements = {
										{label = 'Saluer', lib = 'gestures@m@standing@casual', anim = 'gesture_hello'},
										{label = 'Serrer la main', lib = 'mp_common', anim = 'givetake1_a'},
										{label = 'Tape m\'en 5', lib = 'mp_ped_interaction', anim = 'highfive_guy_a'},
										{label = 'Tchek', lib = 'mp_ped_interaction', anim = 'handshake_guy_a'},
										{label = 'Salut bandit', lib = 'mp_ped_interaction', anim = 'hugs_guy_a'},
										{label = 'Salut militaire', lib = 'mp_player_int_uppersalute', anim = 'mp_player_int_salute'},
									},
								},
								function(data3, menu3)
									animsAction({ lib = data3.current.lib, anim = data3.current.anim })
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Trivia' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Trivia',
								{
									css = 'santos',
									title    = 'Animations de salutations',
									align    = 'top-left',
									elements = {
										{label = 'Serrer la main', lib = 'mp_ped_interaction', anim = 'handshake_guy_a', moving = true, duration = 3000, syncOffFront = 0.9},
										{label = 'Serrer la main 2', lib = 'mp_ped_interaction', anim = 'handshake_guy_b', moving = true, duration = 3000},
										{label = 'Calin', lib = 'mp_ped_interaction', anim = 'kisses_guy_a', moving = false, duration = 5000, syncOffFront = 1.05},
										{label = 'Calin 2', lib = 'mp_ped_interaction', anim = 'kisses_guy_b', moving = false, duration = 5000, syncOffFront = 1.13},
										{label = 'Bro', lib = 'mp_ped_interaction', anim = 'hugs_guy_a', syncOffFront = 1.14},
										{label = 'Bro 2', lib = 'mp_ped_interaction', anim = 'hugs_guy_b', syncOffFront = 1.14},
										{label = 'Give', lib = 'mp_ped_interaction', anim = 'hugs_guy_b', moving = true, duration = 2000},
										{label = 'Give 2', lib = 'mp_ped_interaction', anim = 'hugs_guy_b', moving = true, duration = 2000},
									},
								},
								function(data3, menu3)
									local closestPly, closestDist = ESX.Game.GetClosestPlayer()
									local target = GetPlayerServerId(closestPly)

									if (closestPly ~= -1 and closestDist < 3) then
										TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), data3.current)
										ESX.ShowNotification('~g~Demande de Trivia envoyée à '..GetPlayerName(closestPly))
									else
										ESX.ShowNotification("~r~Il n'y a personne à proximité.")
									end
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_danses' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_danses',
								{
									css = 'santos',
									title    = 'Animations de danses',
									align    = 'top-left',
									elements = {
										{label = 'Danse', lib = 'anim@amb@nightclub@dancers@podium_dancers@', anim = 'hi_dance_facedj_17_v2_male^5'},
										{label = 'Danse 2', lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', anim = 'high_center_down'},
										{label = 'Danse 3', lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', anim = 'high_center'},
										{label = 'Danse 4', lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', anim = 'high_center_up'},
										{label = 'Danse 5', lib = 'anim@amb@casino@mini@dance@dance_solo@female@var_a@', anim = 'med_center'},
										{label = 'Danse 6', lib = 'misschinese2_crystalmazemcs1_cs', anim = 'dance_loop_tao'},
										{label = 'Danse 7', lib = 'misschinese2_crystalmazemcs1_ig', anim = 'dance_loop_tao'},
										{label = 'Danse 8', lib = 'missfbi3_sniping', anim = 'dance_m_default'},
										{label = 'Danse 9', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'med_center_up'},
										{label = 'Danse [Femme]', lib = 'anim@amb@nightclub@dancers@solomun_entourage@', anim = 'mi_dance_facedj_17_v1_female^1'},
										{label = 'Danse [Femme] 2', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'high_center'},
										{label = 'Danse [Femme] 3', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'high_center_up'},
										{label = 'Danse [Femme] 4', lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v2_female^1'},
										{label = 'Danse [Femme] 5', lib = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', anim = 'hi_dance_facedj_09_v2_female^3'},
										{label = 'Danse [Femme] 6', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'high_center_up'},
										{label = 'Danse Slow [Homme]', lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', anim = 'low_center'},
										{label = 'Danse Slow [Femme]', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'low_center'},
										{label = 'Danse Slow [Femme] 2', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', anim = 'low_center_down'},
										{label = 'Danse Slow [Femme] 3', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'low_center'},
										{label = 'Danse Upper [Femme]', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'high_center'},
										{label = 'Danse Upper [Femme] 2', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'high_center_up'},
										{label = 'Danse Shy [Homme]', lib = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', anim = 'low_center'},
										{label = 'Danse Shy [Femme]', lib = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', anim = 'low_center'},
										{label = 'Danse Silly', lib = 'special_ped@mountain_dancer@monologue_3@monologue_3a', anim = 'mnt_dnc_buttwag'},
										{label = 'Danse Silly 2', lib = 'move_clown@p_m_zero_idles@', anim = 'fidget_short_dance'},
										{label = 'Danse Silly 3', lib = 'move_clown@p_m_two_idles@', anim = 'fidget_short_dance'},
										{label = 'Danse Silly 4', lib = 'anim@amb@nightclub@lazlow@hi_podium@', anim = 'danceidle_hi_11_buttwiggle_b_laz'},
										{label = 'Danse Silly 5', lib = 'timetable@tracy@ig_5@idle_a', anim = 'idle_a'},
										{label = 'Danse Silly 6', lib = 'timetable@tracy@ig_8@idle_b', anim = 'idle_d'},
										{label = 'Danse Silly 7', lib = 'rcmnigel1bnmt_1b', anim = 'dance_loop_tyler'},
									},
								},
								function(data3, menu3)
									animsAction({ lib = data3.current.lib, anim = data3.current.anim })
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Sports' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Sports',
								{
									css = 'santos',
									title    = 'Sports',
									align    = 'top-left',
									elements = {
										{label = 'Montrer ses muscles', lib = 'amb@world_human_muscle_flex@arms_at_side@base', anim = 'base'},
										{label = 'Barre de muscu', lib = 'amb@world_human_muscle_free_weights@male@barbell@base', anim = 'base'},
										{label = 'Faire des pompes', lib = 'amb@world_human_push_ups@male@base', anim = 'base'},
										{label = 'Faire les abdos', lib = 'amb@world_human_sit_ups@male@base', anim = 'base'},
										{label = 'Faire du yoga', lib = 'amb@world_human_yoga@male@base', anim = 'base_a'},
									},
								},
								function(data3, menu3)
									animsAction({ lib = data3.current.lib, anim = data3.current.anim })
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Pegi' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Pegi',
								{
									css = 'santos',
									title    = 'PEGI 🔞',
									align    = 'top-left',
									elements = {
										{label = 'Homme qui se fait sucer en voiture', lib = 'oddjobs@towing', anim = 'm_blow_job_loop'},
										{label = 'Femme qui suce en voiture', lib = "oddjobs@towing", anim = "f_blow_job_loop"},
										{label = 'Homme qui baise en voiture', lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"},
										{label = 'Femme qui baise en voiture', lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"},
										{label = 'Se gratter les couilles', lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"},
										{label = 'Charmer', lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"},
										{label = 'Pose de Michto', anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"},
										{label = 'Montrer sa poitrine', lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"},
										{label = 'Strip-Tease 1', lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"},
										{label = 'Strip-Tease 2', lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"},
										{label = 'Strip-Tease au sol', lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"},
									},
								},
								function(data3, menu3)
									if data3.current.anim ~= "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS" then
										animsAction({ lib = data3.current.lib, anim = data3.current.anim })
									else
										animsActionScenario({ anim = data3.current.anim })
									end
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Humor' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Humor',
								{
									css = 'santos',
									title    = 'Animations d\'humeurs',
									align    = 'top-left',
									elements = {
										{label = 'Féliciter', anim = "WORLD_HUMAN_CHEERING"},
										{label = 'Super', lib = "mp_action", anim = "thanks_male_06"},
										{label = 'Toi', lib = "gestures@m@standing@casual", anim = "gesture_point"},
										{label = 'Viens', lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"},
										{label = 'Keskya ?', lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"},
										{label = 'A moi', lib = "gestures@m@standing@casual", anim = "gesture_me"},
										{label = 'J\'le savais putain', lib = "anim@am_hold_up@male", anim = "shoplift_high"},
										{label = 'Être épuisé', lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"},
										{label = 'J\'suis dans la merde', lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"},
										{label = 'Facepalm', lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"},
										{label = 'Calme-toi', lib = "gestures@m@standing@casual", anim = "gesture_easy_now"},
										{label = 'J\'ai fais quoi ?', lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"},
										{label = 'Avoir peur', lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"},
										{label = 'Fight ?', lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"},
										{label = 'C\'est pas possible !', lib = "gestures@m@standing@casual", anim = "gesture_damn" },
										{label = 'Enlacer', lib = "mp_ped_interaction", anim = "kisses_guy_a"},
										{label = 'Fuck', lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"},
										{label = 'Branleur', lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"},
										{label = 'Balle dans la tête', lib = "mp_suicide", anim = "pistol"},
									},
								},
								function(data3, menu3)
									if data3.current.anim ~= "WORLD_HUMAN_CHEERING" then
										animsAction({ lib = data3.current.lib, anim = data3.current.anim })
									else
										animsActionScenario({ anim = data3.current.anim })
									end
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Travail' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Travail',
								{
									css = 'santos',
									title    = 'Animations de travail',
									align    = 'top-left',
									elements = {
										{label = 'Suspect : se rendre à la police', lib = "random@arrests@busted", anim = "idle_c"},
										{label = 'Pêcheur', anim = "WORLD_HUMAN_STAND_FISHING"},
										{label = 'Police : enquêter', lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"},
										{label = 'Police : parler à la radio', lib = "random@arrests", anim = "generic_radio_chatter"},
										{label = 'Police : circulation', anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"},
										{label = 'Police : jumelles', anim = "WORLD_HUMAN_BINOCULARS"},
										{label = 'Dépanneur : réparer le moteur', lib = "mini@repair", anim = "fixing_a_ped"},
										{label = 'Médecin : observer', anim = "CODE_HUMAN_MEDIC_KNEEL"},
										{label = 'Taxi : parler au client', lib = "oddjobs@taxi@driver", anim = "leanover_idle"},
										{label = 'Taxi : donner la facture', lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"},
										{label = 'Epicier : donner les courses', lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"},
										{label = 'Barman : servir un shot', lib = "mini@drinking", anim = "shots_barman_b"},
										{label = 'Journaliste : Prendre une photo', anim = "WORLD_HUMAN_PAPARAZZI"},
										{label = 'Prendre des notes', anim = "WORLD_HUMAN_CLIPBOARD"},
										{label = 'Coup de marteau', anim = "WORLD_HUMAN_HAMMERING"},
										{label = 'SDF : Faire la manche', anim = "WORLD_HUMAN_BUM_FREEWAY"},
										{label = 'SDF : Faire la statue', anim = "WORLD_HUMAN_HUMAN_STATUE"},
									},
								},
								function(data3, menu3)
									if data3.current.anim ~= "WORLD_HUMAN_STAND_FISHING" and data3.current.anim ~= "WORLD_HUMAN_CAR_PARK_ATTENDANT" and data3.current.anim ~= "WORLD_HUMAN_BINOCULARS" and data3.current.anim ~= "world_human_gardener_plant" and data3.current.anim ~= "CODE_HUMAN_MEDIC_KNEEL" and data3.current.anim ~= "WORLD_HUMAN_PAPARAZZI" and data3.current.anim ~= "WORLD_HUMAN_HAMMERING" and data3.current.anim ~= "WORLD_HUMAN_BUM_FREEWAY" and data3.current.anim ~= "WORLD_HUMAN_HUMAN_STATUE" then
										animsAction({ lib = data3.current.lib, anim = data3.current.anim })
									else
										animsActionScenario({ anim = data3.current.anim })
									end
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Festives' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Festives',
								{
									css = 'santos',
									title    = 'Animations festives',
									align    = 'top-left',
									elements = {
										{label = 'Fumer une cigarette', anim = "WORLD_HUMAN_SMOKING"},
										{label = 'Jouer de la musique', anim = "WORLD_HUMAN_MUSICIAN"},
										{label = 'DJ', lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"},
										{label = 'Boire une bière', anim = "WORLD_HUMAN_DRINKING"},
										{label = 'Bière en zik', anim = "WORLD_HUMAN_PARTYING"},
										{label = 'Air Guitar', lib = "anim@mp_player_intcelebrationfemale@air_guitar", anim = "air_guitar"},
										{label = 'Air Shagging', lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"},
										{label = "Rock'n roll", lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"},
										{label = 'Bourré sur place', lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"},
										{label = 'Vomir en voiture', lib = "oddjobs@taxi@tie", anim = "vomit_outside"},
									},
								},
								function(data3, menu3)
									if data3.current.anim ~= "WORLD_HUMAN_SMOKING" and data3.current.anim ~= "WORLD_HUMAN_MUSICIAN" and data3.current.anim ~= "WORLD_HUMAN_DRINKING" and data3.current.anim ~= "WORLD_HUMAN_PARTYING" then
										animsAction({ lib = data3.current.lib, anim = data3.current.anim })
									else
										animsActionScenario({ anim = data3.current.anim })
									end
								end,
								function(data3, menu3)
									menu3.close()
								end)
							elseif data2.current.value == 'menuperso_actions_Others' then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_actions_Others',
								{
									css = 'santos',
									title    = 'Animations diverses',
									align    = 'top-left',
									elements = {
										{label = 'Boire un café', lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"},
										{label = 'S\'asseoir', lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"},
										{label = 'Attendre contre un mur', anim = "WORLD_HUMAN_LEANING"},
										{label = 'Couché sur le dos', anim = "WORLD_HUMAN_SUNBATHE_BACK"},
										{label = 'Couché sur le ventre', anim = "WORLD_HUMAN_SUNBATHE"},
										{label = 'Nettoyer quelque chose', anim = "WORLD_HUMAN_MAID_CLEAN"},
										{label = 'Préparer à manger', anim = "PROP_HUMAN_BBQ"},
										{label = 'Position de Fouille', lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"},
										{label = 'Prendre un selfie', anim = "WORLD_HUMAN_TOURIST_MOBILE"},
										{label = 'Ecouter à une porte', lib = "mini@safe_cracking", anim = "idle_base"},
									},
								},
								function(data3, menu3)
									if data3.current.anim ~= "WORLD_HUMAN_LEANING" and data3.current.anim ~= "WORLD_HUMAN_SUNBATHE_BACK" and data3.current.anim ~= "WORLD_HUMAN_SUNBATHE" and data3.current.anim ~= "WORLD_HUMAN_MAID_CLEAN" and data3.current.anim ~= "PROP_HUMAN_BBQ" and data3.current.anim ~= "WORLD_HUMAN_TOURIST_MOBILE" then
										animsAction({ lib = data3.current.lib, anim = data3.current.anim })
									else
										animsActionScenario({ anim = data3.current.anim })
									end
								end,
								function(data3, menu3)
									menu3.close()
									end)
								end
							end,
							function(data2, menu2)
								menu2.close()
							end)
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_vehicule' then
				OpenVehiculeMenu()
			elseif data.current.value == 'menuperso_moi_autres'  then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi_autres',
				{
					css = 'santos',
					title = 'Moi',
					align = 'top-left',
					elements = {
						{label = "👪 Besoin d\'aide", value = "menuperso_bdaide"},
						{label = "📰 Informations", value = "infostab"},
						{label = "⚙️ Paramètres", value = "menuperso_infos"},
					},
				},
				function(data2, menu2)
					if data2.current.value == "infostab" then
						local onlineplayers = 0

						ESX.TriggerServerCallback('infinity:getPlayersInfos', function(ply)
							onlineplayers = ply.Count
									
							local police, ambulance, cardealer, mechanic, realestateagent, ammu, avocat, staff = 0, 0, 0, 0, 0, 0, 0, 0
											
							for k,v in pairs(ply) do
								if type(v) == 'table' then
									if v.job.name == 'police' then
										police = police + 1
									elseif v.job.name == 'ambulance' then
										ambulance = ambulance + 1
									elseif v.job.name == 'cardealer' then
										cardealer = cardealer + 1
									elseif v.job.name == 'mechanic' then
										mechanic = mechanic + 1
									elseif v.job.name == 'realestateagent' then
										realestateagent = realestateagent + 1
									elseif v.job.name == 'ammu' then
										ammu = ammu + 1
									elseif v.job.name == 'avocat' then
										avocat = avocat + 1
									end

									if v.group == 'admin' or v.group == 'superadmin' or v.group == 'owner' then
										staff = staff + 1
									end
								end
							end

							local steam_hex = ESX.Table.Split(":", ESX.PlayerData.identifier)
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'infostab',
							{
								css      = 'santos',
								title    = 'Informations',
								align    = 'top-left',
								elements = {
									{label = "Jobs<span> >>", value = "JobsList"},
									{label = "Mon ID :<span><b> "..GetPlayerServerId(PlayerId()).."</b>", value = GetPlayerServerId(PlayerId())},
									{label = "Steam HEX :<span><b> "..steam_hex[2].."</b>", value = steam_hex[2]},
									{label = "IP du serveur :<span><b> play.santosrp.fr</b>", value = "play.santosrp.fr"},
									{label = "Discord :<span><b> discord.gg/santosroleplay</b>", value = "discord.gg/santosroleplay"},
									{label = "----------------------------------------------------------------"},
									{label = "Tip : <span>Entrer pour copier un des champs"},
								},
							}, function(data3, menu3)
								if data3.current.value and data3.current.value ~= "JobsList" then
									ESX.ShowNotification('Vous avez copié ~b~'..data3.current.value)
									TriggerEvent('copyToClipboard', data3.current.value)
								elseif data3.current.value == "JobsList" then
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'JobsList',
									{
										css = 'santos',
										title    = 'Jobs',
										align    = 'top-left',
										elements = {
											{label = "Nombre de joueurs :<span><b> "..onlineplayers.."</b>", value = onlineplayers},
											{label = "Nombre de Staff :<span><b> "..staff.."</b>", value = staff},
											{label = "----------------------------------------------------------------"},
											{label = "Police :<span><b> "..police.."</b>", value = police},
											{label = "EMS :<span><b> "..ambulance.."</b>", value = ambulance},
											{label = "Concessionnaire :<span><b> "..cardealer.."</b>", value = cardealer},
											{label = "Mécano :<span><b> "..mechanic.."</b>", value = mechanic},
											{label = "Agent Immobilier :<span><b> "..realestateagent.."</b>", value = realestateagent},
											{label = "Armurier :<span><b> "..ammu.."</b>", value = ammu},
											{label = "Avocat :<span><b> "..avocat.."</b>", value = avocat},
										},
									}, function(data4, menu4)
										if data4.current.value then
											ESX.ShowNotification('Vous avez copié ~b~'..data4.current.value)
											TriggerEvent('copyToClipboard', data4.current.value)
										end
									end, function(data4, menu4)
										menu4.close()
									end)
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						end)
					elseif data2.current.value == 'menuperso_bdaide' then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_bdaide',
						{
							css = 'santos',
							title    = 'Besoin d\'aide',
							align    = 'top-left',
							elements = {
								{label = "Comment voir la carte/GPS",  notif = "~g~Dirigez-vous au Supermarché"},
								{label = "Comment acheter un téléphone", notif = "~g~Dirigez-vous au Santos-Mobile(a côté du comico)"},
								{label = "Comment acheter une SIM", notif = "~g~Dirigez-vous au Santos-Mobile(a côté du comico)"},
								{label = "Comment insérer une SIM", notif = "~g~F5 >> Moi >> Mon téléphone >> 555 XXX >> Insérer"},
								{label = "Comment faire une annonce", notif = "~g~Dirigez-vous au 'Publier une annonce'(le grand A)"},
							},
						},
						function(data2, menu2)
							ESX.ShowNotification(data2.current.notif)
						end,
						function(data2, menu2)
							menu2.close()
						end)
					elseif data2.current.value == 'menuperso_infos' then
						ESX.TriggerServerCallback('santos_menuperso:getUsergroup', function(group)
							playergroup = group

							local elementss = {}
							loadVoice()
							if CinematicCamBool then
								table.insert(elementss, {label = 'Bandes Noires <span style="color:green;">Activé', value = 'cinema_effect'})
							elseif CinematicCamBool == false then
								table.insert(elementss, {label = 'Bandes Noires <span style="color:red;">Désactivé', value = 'cinema_effect'})
							end
							table.insert(elementss, {label = 'Voix <span style="color:green;">'..currentNameVoice, value = 'menu_voice'})
							if playergroup == "mod" or isAdmin then
								if showname then
									table.insert(elementss, {label = 'Afficher Joueurs <span style="color:green;">'..currentNameShowPly, value = 'menu_ply'})
								elseif showname == false then
									table.insert(elementss, {label = 'Afficher Joueurs <span style="color:red;">'..currentNameShowPly, value = 'menu_ply'})
								end
							end

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_infos',
							{
								css = 'santos',
								title    = 'Paramètres',
								align    = 'top-left',
								elements = elementss
							},
							function(data2, menu2)
								if data2.current.value == "cinema_effect" then
									CinematicCamBool = not CinematicCamBool
									CinematicCamDisplay(CinematicCamBool)
									
									if CinematicCamBool then
	            						TriggerEvent('ToggleHUDUI')
									    TriggerEvent('TriggerHUD')
									    TriggerEvent('esx_status:setDisplay', 0.0)
									else
	            						TriggerEvent('ToggleHUDUI')
									    TriggerEvent('TriggerHUD')
									    TriggerEvent('esx_status:setDisplay', 0.9)
									end
								elseif data2.current.value == "menu_voice" then
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_voice',
									{
										css = 'santos',
										title    = 'Voix',
										align    = 'top-left',
										elements = {
											{label = "Chuchoter", value = "chuchoter"},
											{label = "Normal", value = "normal"},
											{label = "Crier", value = "crier"},
										},
									},
									function(data3, menu3)
										if data3.current.value == 'chuchoter' then
											currentVoice = 3.0
											NetworkSetTalkerProximity(currentVoice)
											ESX.ShowNotification('~y~Votre portée de voix est désormais sur : Chuchoter')
											TriggerServerEvent('UpdateVoice', tostring(currentVoice))
										elseif data3.current.value == 'normal' then
											currentVoice = 8.0
											NetworkSetTalkerProximity(currentVoice)
											ESX.ShowNotification('~g~Votre portée de voix est désormais sur : Normal')
											TriggerServerEvent('UpdateVoice', tostring(currentVoice))
										elseif data3.current.value == 'crier' then
											currentVoice = 15.0
											NetworkSetTalkerProximity(currentVoice)
											ESX.ShowNotification('~r~Votre portée de voix est désormais sur : Crier')
											TriggerServerEvent('UpdateVoice', tostring(currentVoice))
										end
										loadVoice()
										menu3.close()
									end,
									function(data3, menu3)
										menu3.close()
									end)
								elseif data2.current.value == "menu_ply" then
									showname = not showname

									if not showname then
										currentNameShowPly = "Désactivé"
									else
										currentNameShowPly = "Activé"
									end
								end
								menu2.close()
							end, function(data2, menu2)
								menu2.close()
							end)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_acti' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_acti',
				{
					css = 'santos',
					title    = 'Actions',
					align    = 'top-left',
					elements = {
						{label = 'Se mettre dans le coffre', value = 'menuperso_moi_coffre'},
						{label = 'Mettre un sac sur la tête', value = 'menuperso_moi_saccc'},
						{label = 'Fouiller', value = 'menuperso_moi_fouiller'},
						{label = 'Porter sur l\'épaule',  value = 'menuperso_acti_porter1'},
						{label = 'Porter sur le dos',  value = 'menuperso_acti_porter2'},
						{label = 'Prendre en otage', value = 'menuperso_moi_otage'},
					},
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_moi_coffre' then
						goCoffre()
					elseif data2.current.value == 'menuperso_moi_fouiller' then
						askFouille()
					elseif data2.current.value == 'menuperso_acti_porter1' then
						if not carryingBackInProgress then
							carryingBackInProgress = true
									local player = PlayerPedId()	
									local lib = 'missfinale_c2mcs_1'
									local anim1 = 'fin_c2_mcs_1_camman'
									local lib2 = 'nm'
									local anim2 = 'firemans_carry'
									local distans = 0.15
									local distans2 = 0.27
									local height = 0.63
									local spin = 0.0		
									local length = 100000
									local controlFlagMe = 49
									local controlFlagTarget = 33
									local animFlagTarget = 1
									local closestPly, closestDist = ESX.Game.GetClosestPlayer()
									local target = GetPlayerServerId(closestPly)
									if closestPly ~= nil and closestDist <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), true) then
										TriggerServerEvent('cmg2_animations:sync', closestPly, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
									end
								else
									carryingBackInProgress = false
									ClearPedSecondaryTask(PlayerPedId())
									DetachEntity(PlayerPedId(), true, false)
									local closestPly, closestDist = ESX.Game.GetClosestPlayer()
									local target = GetPlayerServerId(closestPly)
									TriggerServerEvent("cmg2_animations:stop", target)
								end
						elseif data2.current.value == 'menuperso_moi_saccc' then
							local closestPly, closestDist = ESX.Game.GetClosestPlayer()
							if closestPly ~= nil and closestDist <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), true) then
								ESX.TriggerServerCallback('jsfour-blindfold:itemCheck', function( hasItem )
									TriggerServerEvent('jsfour-blindfold', GetPlayerServerId(closestPly), hasItem)
								end)
							else
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							end
					elseif data2.current.value == 'menuperso_moi_otage' then
						takeHostage()
					elseif data2.current.value == 'menuperso_acti_porter2' then
						if not piggyBackInProgress then
							piggyBackInProgress = true
							local player = PlayerPedId()	
							local lib = 'anim@arena@celeb@flat@paired@no_props@'
							local anim1 = 'piggyback_c_player_a'
							local anim2 = 'piggyback_c_player_b'
							local distans = -0.07
							local distans2 = 0.0
							local height = 0.45
							local spin = 0.0		
							local length = 100000
							local controlFlagMe = 49
							local controlFlagTarget = 33
							local animFlagTarget = 1
							local closestPly, closestDist = ESX.Game.GetClosestPlayer()
							local target = GetPlayerServerId(closestPly)
							if closestPly ~= -1 and closestDist <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), true) then
								TriggerServerEvent('cmg_animations:sync', closestPly, lib, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget)
							end
						else
							piggyBackInProgress = false
							ClearPedSecondaryTask(PlayerPedId())
							DetachEntity(PlayerPedId(), true, false)
							local closestPly, closestDist = ESX.Game.GetClosestPlayer()
							local target = GetPlayerServerId(closestPly)
							TriggerServerEvent("cmg_animations:stop",target)
						end
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_grade' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_grade',
				{
					css = 'santos',
					title    = 'Gestion d\'entreprise',
					align    = 'top-left',
					elements = {
						{label = 'Recruter', value = 'menuperso_grade_recruter'},
						{label = 'Virer', value = 'menuperso_grade_virer'},
						{label = 'Promouvoir', value = 'menuperso_grade_promouvoir'},
						{label = 'Destituer',  value = 'menuperso_grade_destituer'}
					},
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_grade_recruter' then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									
							if closestPlayer ~= -1 and closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:recruterply', GetPlayerServerId(closestPlayer), job, grade)
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_virer' then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local job =  ESX.PlayerData.job.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:virerply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_promouvoir' then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:promouvoirply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_destituer' then
						if ESX.PlayerData.job.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:destituerply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'menuperso_orggrade' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_orggrade',
				{
					css = 'santos',
					title    = 'Gestion Gang/Organisation',
					align    = 'top-left',
					elements = {
						{label = 'Recruter', value = 'menuperso_grade_org_recruter'},
						{label = 'Virer', value = 'menuperso_grade_org_virer'},
						{label = 'Promouvoir', value = 'menuperso_grade_org_promouvoir'},
						{label = 'Destituer',  value = 'menuperso_grade_org_destituer'}
					},
				},
				function(data2, menu2)
					if data2.current.value == 'menuperso_grade_org_recruter' then
						if ESX.PlayerData.org.grade_name == 'boss' then
							local org =  ESX.PlayerData.org.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:recruterorgply', GetPlayerServerId(closestPlayer), org, grade)
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_org_virer' then
						if ESX.PlayerData.org.grade_name == 'boss' then
							local org =  PlayerData.org.name
							local grade = 0
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:virerorgply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_org_promouvoir' then
						if ESX.PlayerData.org.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:promouvoirorgply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					elseif data2.current.value == 'menuperso_grade_org_destituer' then
						if ESX.PlayerData.org.grade_name == 'boss' then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
								
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification("~r~Il n'y a personne à proximité.")
							else
								TriggerServerEvent('santos_menuperso:destituerorgply', GetPlayerServerId(closestPlayer))
							end
						else
							ESX.ShowNotification("~r~Vous n'avez pas les droits.")
						end
					end
				end,
				function(data2, menu2)
					menu2.close()
				end)
			end	
		end,
		function(data, menu)
			menu.close()
		end)
end

---------------------------------------------------------------------------Vehicule Menu

function OpenVehiculeMenu()
	ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
		local elements = {}
		
		table.insert(elements, {label = '🚘 Moteur', value = 'menuperso_vehicule_moteur'})
		table.insert(elements, {label = '🚨 Limiteur de vitesse', value = 'menuperso_vehicule_vitesse'})
		table.insert(elements, {label = '🚪 Portes', value = 'menuperso_vehicule_portes'})
		if owner then
			table.insert(elements, {label = '🔑 Donner les clefs du véhicule', value = 'menuperso_vehicule_clefs'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_vehicule',
		{
			css = 'santos',
			title    = 'Véhicule',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'menuperso_vehicule_moteur' then
				openMoteurMenu()
			elseif data.current.value == 'menuperso_vehicule_vitesse' then
				openVitesseMenu()
			elseif data.current.value == 'menuperso_vehicule_portes' then
				openPortesMenu()
			elseif data.current.value == 'menuperso_vehicule_clefs' then
				TriggerServerEvent('esx_givecarkeys:frommenu')
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
end

function openMoteurMenu()
	local elements = {}

	if IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false)) then
		table.insert(elements, {label = 'Couper le moteur', value = 'menuperso_vehicule_MoteurOff'})
	else
		table.insert(elements, {label = 'Démarrer le moteur', value = 'menuperso_vehicule_MoteurOn'})
	end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_vehicule_moteur',
		{
			css = 'santos',
			title    = 'Moteur',
			align    = 'top-left',
			elements = elements
		},
		function(data2, menu2)
			if data2.current.value == 'menuperso_vehicule_MoteurOn' then
				SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false), true, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(), false), false)
				menu2.close()
			elseif data2.current.value == 'menuperso_vehicule_MoteurOff' then
				SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false), false, false, true)
				SetVehicleUndriveable(GetVehiclePedIsIn(PlayerPedId(), false), true)
				menu2.close()
			end
		end,
		function(data2, menu2)
			menu2.close()
		end
	)
end

function openVitesseMenu()
	local elements = {}

	table.insert(elements, {label = '❌ Désactiver le limiteur', value = 'menuperso_vehicule_desaclimit'})
	table.insert(elements, {label = '30 Km/h', value = 'menuperso_vehicule_30'})
	table.insert(elements, {label = '50 Km/h', value = 'menuperso_vehicule_50'})
	table.insert(elements, {label = '70 Km/h', value = 'menuperso_vehicule_70'})
	table.insert(elements, {label = '90 Km/h', value = 'menuperso_vehicule_90'})
	table.insert(elements, {label = '110 Km/h', value = 'menuperso_vehicule_110'})
	table.insert(elements, {label = '130 Km/h', value = 'menuperso_vehicule_130'})

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_vehicule_moteur',
		{
			css = 'santos',
			title    = 'Limiteur de vitesse',
			align    = 'top-left',
			elements = elements
		},
		function(data2, menu2)

			if data2.current.value == 'menuperso_vehicule_desaclimit' then
				vitesse(0)
			elseif data2.current.value == 'menuperso_vehicule_30' then
				vitesse(30)
			elseif data2.current.value == 'menuperso_vehicule_50' then
				vitesse(50)
			elseif data2.current.value == 'menuperso_vehicule_70' then
				vitesse(70)
			elseif data2.current.value == 'menuperso_vehicule_90' then
				vitesse(90)
			elseif data2.current.value == 'menuperso_vehicule_110' then
				vitesse(110)
			elseif data2.current.value == 'menuperso_vehicule_130' then
				vitesse(130)
			end

		end,
		function(data2, menu2)
			menu2.close()
		end
	)
end

function goCoffre()
	local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
	if DoesEntityExist(vehicle) then
		local trunk = GetEntityBoneIndexByName(vehicle, 'boot')
		if trunk ~= -1 then
			local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) <= 1.5 then
				if GetVehicleDoorLockStatus(vehicle) == 1 then
					-- if not inTrunk then
					-- 	if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
					-- 		ESX.ShowHelpNotification('[E] Hide in trunk\n[H] Open trunk')
					-- 		if IsControlJustReleased(0, 74) then
					-- 			SetCarBootOpen(vehicle)
					-- 		end
					-- 	else
					-- 		ESX.ShowHelpNotification('[E] Hide in trunk\n[H] Close trunk')
					-- 		if IsControlJustReleased(0, 74) then
					-- 			SetVehicleDoorShut(vehicle, 5)
					-- 		end
					-- 	end
					-- end
					if not inTrunk then
						local player = ESX.Game.GetClosestPlayer()
						local playerPed = GetPlayerPed(player)
						if DoesEntityExist(playerPed) then
							if not IsEntityAttached(playerPed) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
								SetCarBootOpen(vehicle)
								Wait(350)
								AttachEntityToEntity(PlayerPedId(), vehicle, -1, 0.0, -1.5, 0.2, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
								ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
								TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
								Wait(50)
								inTrunk = true
								Wait(1500)
								SetVehicleDoorShut(vehicle, 5)
							else
								ESX.ShowNotification('~r~Il y à déjà quelqu\'un dans ce véhicule mais Shhhhh !')
							end
						end
					end
				end
			end
		end
    end
end


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inTrunk then
            local vehicle = GetEntityAttachedTo(PlayerPedId())
            if DoesEntityExist(vehicle) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
                local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
                SetEntityCollision(PlayerPedId(), false, false)
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour sortir')

                if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
                    SetEntityVisible(PlayerPedId(), false, false)
                else
                    if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                        ESX.Streaming.RequestAnimDict('timetable@floyd@cryingonbed@base')
                        TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

                        SetEntityVisible(PlayerPedId(), true, false)
                    end
                end
                if IsControlJustReleased(0, 38) and inTrunk then
                    SetCarBootOpen(vehicle)
                    SetEntityCollision(PlayerPedId(), true, true)
                    Wait(750)
                    inTrunk = false
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityVisible(PlayerPedId(), true, false)
                    ClearPedTasks(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
                    Wait(250)
                    SetVehicleDoorShut(vehicle, 5)
                end
            else
                SetEntityCollision(PlayerPedId(), true, true)
                DetachEntity(PlayerPedId(), true, true)
                SetEntityVisible(PlayerPedId(), true, false)
                ClearPedTasks(PlayerPedId())
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
            end
        else
        	Citizen.Wait(500)
        end
    end
end)

function askFouille()
	local closestPly, closestDist = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPly)

	if (closestPly ~= -1 and closestDist < 3) then
		TriggerServerEvent('santos_menuperso:requestFouille', target)
		ESX.ShowNotification('~g~Demande de fouille envoyée.')
	else
		ESX.ShowNotification("~r~Il n'y a personne à proximité.")
	end
end

RegisterNetEvent('santos_menuperso:receiveFouille')
AddEventHandler('santos_menuperso:receiveFouille', function()
	isAskingFouille = true
    ESX.ShowNotification("Acceptez-vous d'être fouillé(e) ?")
    ESX.ShowNotification("~g~Y~w~ accepter, ~r~L~w~ refuser~w~.")

    Citizen.CreateThread(function()
	    while true do
	        Citizen.Wait(5)
	        if IsControlJustPressed(1, 246) and isAskingFouille then
	        	local closestPly, closestDist = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPly)

	            if (closestPly ~= -1 and closestDist < 3) then
					ESX.ShowNotification("~g~Vous avez accepté(e).")
	                TriggerServerEvent("santos_menuperso:OpenBodySearchMenu", target)
	                isAskingFouille = false
	            else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
	                isAskingFouille = false
	            end
	        elseif IsControlJustPressed(1, 182) and isAskingFouille then
				ESX.ShowNotification("~r~Vous avez refusé(e).")
	            isAskingFouille = false
	        end
	    end
	end)
end)

RegisterNetEvent("ClientEmoteRequestReceive")
AddEventHandler("ClientEmoteRequestReceive", function(emotename)
    isRequestAnim = true
    requestedemote = emotename
    ESX.ShowNotification("Acceptez-vous de Trivia ?")
    ESX.ShowNotification("~y~Y~w~ accepter, ~r~L~w~ refuser~w~.")

	Citizen.CreateThread(function()
	    while true do
	        Citizen.Wait(5)
	        if IsControlJustPressed(1, 246) and isRequestAnim then
		        local closestPly, closestDist = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPly)
	            
	            if (closestPly ~= -1 and closestDist < 3) then
					ESX.ShowNotification("~g~Vous avez accepté(e).")
	                TriggerServerEvent("ServerValidEmote", GetPlayerServerId(target), requestedemote, requestedemote)
	                isRequestAnim = false
	            else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
	            end
	        elseif IsControlJustPressed(1, 182) and isRequestAnim then
				ESX.ShowNotification("~r~Vous avez refusé(e).")
	            isRequestAnim = false
	        end
	    end
	end)
end)

RegisterNetEvent("SyncPlayEmote")
AddEventHandler("SyncPlayEmote", function(emote, player)
    ClearPedTasksImmediately(PlayerPedId())
    Wait(300)

    if OnEmotePlay(DP.Shared[emote]) then end return
end)

RegisterNetEvent("SyncPlayEmoteSource")
AddEventHandler("SyncPlayEmoteSource", function(emote, player)
    local pedInFront = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local heading = GetEntityHeading(pedInFront)
    local coords = GetOffsetFromEntityInWorldCoords(pedInFront, 0.0, 1.0, 0.0)
    local SyncOffsetFront = DP.Shared[emote].AnimationOptions.SyncOffsetFront

    if SyncOffsetFront then
        coords = GetOffsetFromEntityInWorldCoords(pedInFront, 0.0, SyncOffsetFront, 0.0)
    end

    SetEntityHeading(PlayerPedId(), heading - 180.1)
    SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, 0)
    ClearPedTasksImmediately(PlayerPedId())
    
    Wait(300)

    if OnEmotePlay(emote) then end return
end)

RegisterNetEvent('santos_menuperso:openMenu')
AddEventHandler('santos_menuperso:openMenu', function(src)
	OpenBodySearchMenu2(src)
end)

function vitesse(vit)
    local speed = vit / 3.6
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
   
    local vehicleModel = GetEntityModel(vehicle)
    local Max = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")

	if vit == 0 then
		if IsEntityInAir(vehicle) then 
			ESX.ShowNotification("~r~Vous ne pouvez pas changer le limiteur de vitesse dans les airs !")
		else
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				SetVehicleMaxSpeed(vehicle, Max)
				ESX.ShowNotification("~g~Limiteur désactivé")
			end
		end
	else
		if IsEntityInAir(vehicle) then 
			ESX.ShowNotification("~r~Vous ne pouvez pas changer le limiteur de vitesse dans les airs !")
		else
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				SetVehicleMaxSpeed(vehicle, speed)
				ESX.ShowNotification("~g~Limiteur activé à "..vit.. " Km/h")
			end
		end
	end
end

function openPortesMenu()
	local elements = {}

	if porteAvantGaucheOuverte then
		table.insert(elements, {label = 'Fermer la porte gauche',	value = 'menuperso_vehicule_fermerportes_fermerportegauche'})
	else
		table.insert(elements, {label = 'Ouvrir la porte gauche',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportegauche'})
	end
	
	if porteAvantDroiteOuverte then
		table.insert(elements, {label = 'Fermer la porte droite',	value = 'menuperso_vehicule_fermerportes_fermerportedroite'})
	else
		table.insert(elements, {label = 'Ouvrir la porte droite',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportedroite'})
	end
	
	if porteArriereGaucheOuverte then
		table.insert(elements, {label = 'Fermer la porte arrière gauche',	value = 'menuperso_vehicule_fermerportes_fermerportearrieregauche'})
	else
		table.insert(elements, {label = 'Ouvrir la porte arrière gauche',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche'})
	end
	
	if porteArriereDroiteOuverte then
		table.insert(elements, {label = 'Fermer la porte arrière droite',	value = 'menuperso_vehicule_fermerportes_fermerportearrieredroite'})
	else
		table.insert(elements, {label = 'Ouvrir la porte arrière droite',		value = 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite'})
	end
	
	if porteCapotOuvert then
		table.insert(elements, {label = 'Fermer le capot',	value = 'menuperso_vehicule_fermerportes_fermercapot'})
	else
		table.insert(elements, {label = 'Ouvrir le capot',		value = 'menuperso_vehicule_ouvrirportes_ouvrircapot'})
	end
	
	if porteCoffreOuvert then
		table.insert(elements, {label = 'Fermer le coffre',	value = 'menuperso_vehicule_fermerportes_fermercoffre'})
	else
		table.insert(elements, {label = 'Ouvrir le coffre',		value = 'menuperso_vehicule_ouvrirportes_ouvrircoffre'})
	end
	
	if porteAutre1Ouvert then
		table.insert(elements, {label = 'Fermer autre 1',	value = 'menuperso_vehicule_fermerportes_fermerAutre1'})
	else
		table.insert(elements, {label = 'Ouvrir autre 1',		value = 'menuperso_vehicule_ouvrirportes_ouvrirAutre1'})
	end
	
	if porteAutre2Ouvert then
		table.insert(elements, {label = 'Fermer autre 2',	value = 'menuperso_vehicule_fermerportes_fermerAutre2'})
	else
		table.insert(elements, {label = 'Ouvrir autre 2', value = 'menuperso_vehicule_ouvrirportes_ouvrirAutre2'})
	end
	
	if porteToutOuvert then
		table.insert(elements, {label = 'Tout fermer', value = 'menuperso_vehicule_fermerportes_fermerTout'})
	else
		table.insert(elements, {label = 'Tout ouvrir', value = 'menuperso_vehicule_ouvrirportes_ouvrirTout'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_vehicule_portes',
	{
		css = 'santos',
		title    = 'Portes',
		align    = 'top-left',
		elements = elements
	},
	function(data2, menu2)
		if data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportegauche' then
			porteAvantGaucheOuverte = true
			SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false ), 0, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportedroite' then
			porteAvantDroiteOuverte = true
			SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false ), 1, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieregauche' then
			porteArriereGaucheOuverte = true
			SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false ), 2, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirportearrieredroite' then
			porteArriereDroiteOuverte = true
			SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false ), 3, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircapot' then
			porteCapotOuvert = true
			SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 4, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrircoffre' then
			porteCoffreOuvert = true
			SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 5, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre1' then
			porteAutre1Ouvert = true
			SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 6, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirAutre2' then
			porteAutre2Ouvert = true
			SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 7, false, false)
			openPortesMenu()
		elseif data2.current.value == 'menuperso_vehicule_ouvrirportes_ouvrirTout' then
				porteAvantGaucheOuverte = true
				porteAvantDroiteOuverte = true
				porteArriereGaucheOuverte = true
				porteArriereDroiteOuverte = true
				porteCapotOuvert = true
				porteCoffreOuvert = true
				porteAutre1Ouvert = true
				porteAutre2Ouvert = true
				porteToutOuvert = true
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 0, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 1, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 2, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 3, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 4, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 5, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 6, false, false)
				SetVehicleDoorOpen(GetVehiclePedIsIn( PlayerPedId(), false ), 7, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerportegauche' then
				porteAvantGaucheOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 0, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerportedroite' then
				porteAvantDroiteOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 1, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieregauche' then
				porteArriereGaucheOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 2, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerportearrieredroite' then
				porteArriereDroiteOuverte = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 3, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermercapot' then
				porteCapotOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 4, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermercoffre' then
				porteCoffreOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 5, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerAutre1' then
				porteAutre1Ouvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 6, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerAutre2' then
				porteAutre2Ouvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 7, false, false)
				openPortesMenu()
			elseif data2.current.value == 'menuperso_vehicule_fermerportes_fermerTout' then
				porteAvantGaucheOuverte = false
				porteAvantDroiteOuverte = false
				porteArriereGaucheOuverte = false
				porteArriereDroiteOuverte = false
				porteCapotOuvert = false
				porteCoffreOuvert = false
				porteAutre1Ouvert = false
				porteAutre2Ouvert = false
				porteToutOuvert = false
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 0, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 1, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 2, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 3, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 4, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 5, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 6, false, false)
				SetVehicleDoorShut(GetVehiclePedIsIn( PlayerPedId(), false ), 7, false, false)
				openPortesMenu()
			end

		end,
		function(data2, menu2)
			menu2.close()
		end)
end

-- FONCTION NOCLIP 
local noclip = false
local noclip_speed = 0.8
local noclip_sprint_speed = 3.5

function admin_no_clip()
	noclip = not noclip
	local plyPed = PlayerPedId()

	if noclip then -- activé
		FreezeEntityPosition(plyPed, true)
		SetPlayerInvincible(PlayerId(), true)
		SetEntityCollision(plyPed, false, false)

		SetEntityVisible(plyPed, false, false)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification("~g~Noclip activé")
	else -- désactivé
		FreezeEntityPosition(plyPed, false)
		SetPlayerInvincible(PlayerId(), false)
		SetEntityCollision(plyPed, true, true)

		SetEntityVisible(plyPed, true, false)

		SetEveryoneIgnorePlayer(PlayerId(), false)
		SetPoliceIgnorePlayer(PlayerId(), false)
		ESX.ShowNotification("~r~Noclip désactivé")
  	end
end

function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
	return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

-- noclip/invisible
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    if noclip then
			local x,y,z = getPosition()
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed

	      	-- reset du velocity
			SetEntityVelocity(PlayerPedId(), 0.0001, 0.0001, 0.0001)

	      	-- sprint
			if IsControlPressed(0,21) then -- SPRINT
				speed = noclip_sprint_speed
			end

	      	-- aller vers le haut
			if IsControlPressed(0,32) then -- MOVE UP
				x = x+speed*dx
				y = y+speed*dy
	        	z = z+speed*dz
			end

	      	-- aller vers le bas
			if IsControlPressed(0,269) then -- MOVE DOWN
	        	x = x-speed*dx
	        	y = y-speed*dy
	        	z = z-speed*dz
			end

	      	SetEntityCoordsNoOffset(PlayerPedId(),x,y,z,true,true,true)
	    else
	    	Citizen.Wait(500)
	    end
	end
end)
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
	godmode = not godmode

  	local ped = PlayerPedId()
	if godmode then -- activé
  		SetPlayerInvincible(PlayerId(), true)
		SetEntityInvincible(PlayerPedId(), true)
		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification("~g~God Mode activé")
	else
  		SetPlayerInvincible(PlayerId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEveryoneIgnorePlayer(PlayerId(), false)
		SetPoliceIgnorePlayer(PlayerId(), false)
		ESX.ShowNotification("~r~God Mode désactivé")
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible
	local ped = PlayerPedId()
  
	if invisible then -- activé
		SetEntityLocallyInvisible(ped)
		SetEntityVisible(ped, false)
  		SetPlayerInvincible(PlayerId(), true)
		SetEntityInvincible(PlayerPedId(), true)
		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification("~g~Invisibilité activé")
	else
		SetEntityLocallyVisible(ped)
		SetEntityVisible(ped, true)
  		SetPlayerInvincible(PlayerId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEveryoneIgnorePlayer(PlayerId(), false)
		SetPoliceIgnorePlayer(PlayerId(), false)
		ESX.ShowNotification("~r~Invisibilité désactivé")
	end
end
-- FIN INVISIBLE

-- Réparer vehicule
RegisterNetEvent('fixVehicle')
AddEventHandler('fixVehicle', function()
    local car = GetVehiclePedIsUsing(PlayerPedId())
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		SetVehicleFixed(car)
		SetVehicleDirtLevel(car, 0.0)
		SetVehicleFuelLevel(car, 65.0)
		TriggerServerEvent('SendToAdminLogs', "repairveh")
	end
end)
-- FIN Réparer vehicule

-- Réparer vehicule
-- function admin_vehicle_acheter()
-- 	local playerPed = PlayerPedId()
-- 	ESX.Game.SpawnVehicle("aperta", GetEntityCoords(playerPed,true), 0, function (vehicle)
-- 		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

-- 		local newPlate = GeneratePlate()
-- 		print(newPlate)
-- 		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
-- 		vehicleProps.plate = newPlate
-- 		SetVehicleNumberPlateText(vehicle, newPlate)

-- 		TriggerServerEvent('esx_vehshop:setVehicleOwned', vehicleProps)
-- 	end)
-- end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_vehicule_spawn', {
		title = 'Entrez le nom du véhicule',
		value = ''
	},
	function (data, menu)
		menu.close()
		local result = data.value

		if result and result ~= "" then
			nomvehicule = result
		else
			nomvehicule = "bf400"
		end

		if nomvehicule == "" then
			nomvehicule = "bf400"
		end

		local car = GetHashKey(nomvehicule)
  		local ped = PlayerPedId()

		RequestModel(car)
		while not HasModelLoaded(car) do
			Citizen.Wait(0)
		end
		local x,y,z = table.unpack(GetEntityCoords(ped,true))
		veh = CreateVehicle(car, x,y,z, 0.0, true, false)
		SetEntityVelocity(veh, 2000)
		SetVehicleOnGroundProperly(veh)
		SetVehicleHasBeenOwnedByPlayer(veh,true)
		local id = NetworkGetNetworkIdFromEntity(veh)
		SetNetworkIdCanMigrate(id, true)
		SetVehRadioStation(veh, "OFF")
		SetPedIntoVehicle(ped,  veh,  -1)
		SetVehicleNumberPlateText(veh, GetPlayerName(PlayerId()))
		TriggerServerEvent('SendToAdminLogs', "spawnveh", result)
	end,
	function (data, menu)
		menu.close()
	end)
end
-- FIN Spawn vehicule

-- flipVehicle
RegisterNetEvent('flipVehicle')
AddEventHandler('flipVehicle', function()
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped,true))
    local vehicle = ESX.Game.GetVehicleInDirection()

    if vehicle then
    	x,y,z = x,y,z + vector3(0, 2, 0)
		SetEntityCoords(vehicle, x,y,z)
		TriggerServerEvent('SendToAdminLogs', "flipveh")
	end
end)
-- FIN flipVehicle

-- unlockVehicle
function admin_vehicle_unlock()
	local dict = "anim@mp_player_intmenu@key_fob@"
    local vehicle = ESX.Game.GetVehicleInDirection()

    if vehicle then
		ESX.Streaming.RequestAnimDict(dict)
	    SetVehicleDoorsLocked(vehicle, 1)
		PlayVehicleDoorOpenSound(vehicle, 0)
		ESX.ShowNotification('Vous avez ouvert le ~g~véhicule~s~ !')
		if not IsPedInAnyVehicle(PlayerPedId(), true) then
			TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
		end
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end
end
-- FIN unlockVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_money', {
		title = 'Entrez le montant',
		value = ''
	},
	function (data, menu)
		menu.close()
		local result = data.value

		if result and result ~= "" then
			montant = result
		else
			montant = "1"
		end

		if montant == "" then
			montant = "1"
		end
		tonumber(montant)
		TriggerServerEvent('santos_menuperso:giveC', montant)
	end,
	function (data, menu)
		menu.close()
	end)
end
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_moneybank', {
		title = 'Entrez le montant',
		value = ''
	},
	function (data, menu)
		menu.close()
		local result = data.value

		if result and result ~= "" then
			montant = result
		else
			montant = "1"
		end

		if montant == "" then
			montant = "1"
		end
		tonumber(montant)
		TriggerServerEvent('santos_menuperso:giveB', montant)
	end,
	function (data, menu)
		menu.close()
	end)
end
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_moneydirty', {
		title = 'Entrez le montant',
		value = ''
	},
	function (data, menu)
		menu.close()
		local result = data.value

		if result and result ~= "" then
			montant = result
		else
			montant = "1"
		end

		if montant == "" then
			montant = "1"
		end
		tonumber(montant)
		TriggerServerEvent('santos_menuperso:giveDM', montant)
	end,
	function (data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
    while true do
		if showcoord then
			local playerPos, playerHeading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())
			ESX.Game.Utils.DrawText2D(0.000 + 0.1000, -0.001 + 0.565, 1.0, 1.0, 0.4, "~r~X~s~: " ..playerPos.x.." ~b~Y~s~: " ..playerPos.y.." ~g~Z~s~: " ..playerPos.z.." ~y~Heading~s~: " ..playerHeading, 255, 255, 255, 255)
		else
			Citizen.Wait(1500)
		end
        Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
		if showname then
			for _, maxPlayers in ipairs(GetActivePlayers()) do
				if NetworkIsPlayerActive(maxPlayers) and GetPlayerPed(maxPlayers) ~= PlayerPedId() then
					CreateFakeMpGamerTag(GetPlayerPed(maxPlayers), ('['..GetPlayerServerId(maxPlayers)..'] '..GetPlayerName(maxPlayers)), false, false, "", false )
				end
		 	end
		else
			Citizen.Wait(1500)
		end
        Citizen.Wait(0)
    end
end)

-- TP MARCKER
function admin_tp_marcker()
	local blip = GetFirstBlipInfoId(8)
	if DoesBlipExist(blip) then
		local playerPed = PlayerPedId()
		local teleportEntity = playerPed

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then
			teleportEntity = GetVehiclePedIsIn(playerPed, false)
		end
		
		NetworkFadeOutEntity(teleportEntity, true, false)

		local coord = GetBlipInfoIdCoord(blip)
		local groundFound, coordZ = false, 0
		local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

		for _,height in ipairs(groundCheckHeights) do
			ESX.Game.Teleport(teleportEntity, {x = coord.x, y = coord.y, z = height})

			local foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)

			if foundGround then
				coordZ = z + 3.01
				groundFound = true
				break
			end
		end

		if groundFound then
			ESX.Game.Teleport(teleportEntity, {x = coord.x, y = coord.y, z = coordZ})

			NetworkFadeInEntity(teleportEntity, true)
		else
			local retval, outPosition = GetNthClosestVehicleNode(coord.x, coord.y, coordZ, 0, 0, 0, 0)

			ESX.Game.Teleport(teleportEntity, {x = outPosition.x, y = outPosition.y, z = outPosition.z})
			NetworkFadeInEntity(teleportEntity, true)
		end
	end
end
-- FIN TP MARCKER

---------------------------------------------------------------------------Me concernant


RegisterNetEvent('smerfikubrania:koszulka')
AddEventHandler('smerfikubrania:koszulka', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local lib, anim = 'clothingtie', 'try_tie_neutral_a'
		ESX.Streaming.RequestAnimDict(lib, function()
    		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())

        local clothesSkin = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
        ['torso_1'] = 15, ['torso_2'] = 0,
        ['arms'] = 15, ['arms_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)
RegisterNetEvent('smerfikubrania:spodnie')
AddEventHandler('smerfikubrania:spodnie', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)


        local clothesSkin = {
        	['pants_1'] = 21, ['pants_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent('smerfikubrania:buty')
AddEventHandler('smerfikubrania:buty', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local lib, anim = 'clothingshoes', 'try_shoes_positive_a'

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)

        local clothesSkin = {
        ['shoes_1'] = 34, ['shoes_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent('smerfikubrania:sac')
AddEventHandler('smerfikubrania:sac', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local lib, anim = 'clothingtie', 'try_tie_neutral_a'

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
        local clothesSkin = {
        	['bags_1'] = 0, ['bags_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

RegisterNetEvent('smerfikubrania:bproof')
AddEventHandler('smerfikubrania:bproof', function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local lib, anim = 'clothingtie', 'try_tie_neutral_a'

        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())

        local clothesSkin = {
        	['bproof_1'] = 0, ['bproof_2'] = 0
        }
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end)

function openAccesoire()
	local elements = {}
	table.insert(elements, {label = '🛍️ Accessoires', value = 'menuperso_moi_accessoires'})
	table.insert(elements, {label = '👕👖 Remettre ses vêtements', value = 'menuperso_moi_remettrevetement'})
    table.insert(elements, {label = '👕 Retirer le haut', value = 'menuperso_moi_retirerhaut'})
    table.insert(elements, {label = '👖 Retirer le bas', value = 'menuperso_moi_retirerbas'})
    table.insert(elements, {label = '👟 Retirer les chaussures', value = 'menuperso_moi_retirerchaussures'})
    table.insert(elements, {label = '👜 Retirer le sac', value = 'menuperso_moi_retirersac'})
    table.insert(elements, {label = '🦺 Retirer le gilet par balle', value = 'menuperso_moi_retirerbproof'})

   	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_moi_accessoire',
    {
		css = 'santos',
		title    = 'Vêtements',
        align    = 'top-left',
        elements = elements
    },
    function(data3, menu3)
        if data3.current.value == 'menuperso_moi_accessoires' then
			openAccesoires()
        elseif data3.current.value == 'menuperso_moi_remettrevetement' then
	        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	        	TriggerEvent('skinchanger:loadSkin', skin)
	        end)
        elseif data3.current.value == 'menuperso_moi_retirerhaut' then
			TriggerEvent('smerfikubrania:koszulka')
		elseif data3.current.value == 'menuperso_moi_retirerbas' then
			TriggerEvent('smerfikubrania:spodnie')
		elseif data3.current.value == 'menuperso_moi_retirerchaussures' then
			TriggerEvent('smerfikubrania:buty')
		elseif data3.current.value == 'menuperso_moi_retirersac' then
			TriggerEvent('smerfikubrania:sac')
		elseif data3.current.value == 'menuperso_moi_retirerbproof' then
			TriggerEvent('smerfikubrania:bproof')
		end			
	end,
	function(data3, menu3)
		menu3.close()
	end)
end

RegisterNetEvent('esx_licenseshop:loadLicenses')
AddEventHandler('esx_licenseshop:loadLicenses', function(licenses)
	Licenses = licenses
end)

function openPapiers()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	table.insert(elements, {label = '👦🏽 Carte d\'identité', value = 'menuperso_moi_identity'})	
	if ownedLicenses['aircraft'] then
		table.insert(elements, {label = '🛫 Permis d\'Avion', value = 'menuperso_moi_permisavion'})
	end
	if ownedLicenses['boating'] then
		table.insert(elements, {label = '🛶 Permis bateau', value = 'menuperso_moi_permisbateau'})
	end
	if ownedLicenses['dmv'] then
		table.insert(elements, {label = '🚗 Code de la route', value = 'menuperso_moi_code'})
	end
	if ownedLicenses['drive'] then
		table.insert(elements, {label = '🚙 Permis de conduire', value = 'menuperso_moi_permis'})
	end
	if ownedLicenses['drive_bike'] then
		table.insert(elements, {label = '🏍️ Permis Moto', value = 'menuperso_moi_permismoto'})
	end
	if ownedLicenses['drive_truck'] then
		table.insert(elements, {label = '🚌 Permis Camion', value = 'menuperso_moi_permiscamion'})
	end
	if ownedLicenses['weapon'] then
		table.insert(elements, {label = '🔫 Permis de port d\'Armes', value = 'menuperso_moi_ppa'})
	end
	if ownedLicenses['chasse'] then
		table.insert(elements, {label = '💥 Permis de Chasse', value = 'menuperso_moi_pc'})
	end
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menuperso_moi_papiers',
		{
			css = 'santos',
			title    = 'Papiers',
			align    = 'top-left',
			elements = elements
		},
		function(data3, menu3)
			if data3.current.value == 'menuperso_moi_identity' then
				openIdentity()
			elseif data3.current.value == 'menuperso_moi_permisavion' then
				openPA()
			elseif data3.current.value == 'menuperso_moi_permisbateau' then
				openPBateau()
			elseif data3.current.value == 'menuperso_moi_code' then
				openDMV()
			elseif data3.current.value == 'menuperso_moi_permis' then
				openPermis()
			elseif data3.current.value == 'menuperso_moi_permismoto' then
				openPMoto()
			elseif data3.current.value == 'menuperso_moi_permiscamion' then
				openPCamion()
			elseif data3.current.value == 'menuperso_moi_ppa' then
				openPPA()
			elseif data3.current.value == 'menuperso_moi_pc' then
				openPC()
			end			
		end,
		function(data3, menu3)
			menu3.close()
		end
	)
end

function openModoJoueurs()
	local elements = {}
	local onlineplayers = 0

	ESX.TriggerServerCallback('infinity:getPlayersInfos', function(ply)
		onlineplayers = ply.Count

		table.insert(elements, {label = 'Gestion des Joueurs<span> >>', value = 'menuperso_modo_playerslist'})
		table.insert(elements, {label = 'Admin Tools<span> >>', value = 'menuperso_modo_admintools'})
		table.insert(elements, {label = 'Gun Tools<span> >>', value = 'menuperso_modo_guntools'})
		table.insert(elements, {label = 'Give Tools<span> >>', value = 'menuperso_modo_give'})
		table.insert(elements, {label = 'Character Tools<span> >>', value = 'menuperso_modo_char'})
		table.insert(elements, {label = 'Revive Tools<span> >>', value = 'menuperso_modo_revive'})
		if GetResourceState('esx_whitelist') == 'started' then
			table.insert(elements, {label = 'WhiteList Tools<span> >>', value = 'menuperso_modo_wltools'})
		end
		table.insert(elements, {label = 'Ban Tools<span> >>', value = 'menuperso_modo_bantools'})
		table.insert(elements, {label = 'Teleport Tools<span> >>', value = 'menuperso_modo_tp'})
		table.insert(elements, {label = 'Coords Tools<span> >>', value = 'menuperso_modo_coords'})
		if (GetPlayerName(PlayerId()) == "SNIKRS") and GetResourceState('v3-secret') == 'started' then
			table.insert(elements, {label = 'V3 Tools<span> >>', value = 'menuperso_modo_v3tools'})
		end
		table.insert(elements, {label = 'Show Players Name & ID', value = 'menuperso_modo_showname'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_joueurs',
		{
			css = 'santos',
			title    = 'Joueurs - '..onlineplayers..' / 256',
			align    = 'top-left',
			elements = elements
		},
		function(data3, menu3)
			if data3.current.value == 'menuperso_modo_playerslist' then
				openModoPlayersList()
			elseif data3.current.value == "menuperso_modo_admintools" then
				openAdminTools()
			elseif data3.current.value == "menuperso_modo_guntools" then
				openGunTools()
			elseif data3.current.value == "menuperso_modo_wltools" then
				openWLTools()
			elseif data3.current.value == "menuperso_modo_give" then
				openGiveTools()
			elseif data3.current.value == "menuperso_modo_char" then
				openCharTools()
			elseif data3.current.value == "menuperso_modo_revive" then
				openReviveTools()
			elseif data3.current.value == "menuperso_modo_tp" then
				openTPTools()
			elseif data3.current.value == "menuperso_modo_coords" then
				openCoordsTools()
			elseif data3.current.value == "menuperso_modo_bantools" then
				openBanTools()
			elseif data3.current.value == 'menuperso_modo_v3tools' then
				openV3Tools()
			elseif data3.current.value == 'menuperso_modo_showname' then
				showname = not showname

				if not showname then
					ESX.ShowNotification('~r~ShowName désactivé')
				else
					ESX.ShowNotification('~g~ShowName activé, faites Echap pour l\'afficher')
				end
			end
		end, function(data3, menu3)
			menu3.close()
		end)
	end)
end

function openAdminTools()
	local elements = {}

	table.insert(elements, {label = 'No-clip', value = 'menuperso_modo_no_clip'})
	table.insert(elements, {label = 'God Mode', value = 'menuperso_modo_godmode'})
	table.insert(elements, {label = 'Invisible', value = 'menuperso_modo_mode_fantome'})
	table.insert(elements, {label = 'Notification SantosRP', value = 'menuperso_modo_notif'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_admintools',
	{
		css = 'santos',
		title    = 'Admin Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_no_clip' then
			admin_no_clip()
		elseif data.current.value == 'menuperso_modo_godmode' then
			admin_godmode()
		elseif data.current.value == 'menuperso_modo_mode_fantome' then
			admin_mode_fantome()
		elseif data.current.value == 'menuperso_modo_notif' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_notif', {
				title = "Entrez le contenu de l'annonce",
				value = ''
			},
			function (data, menu)
				menu.close()
				local contenu = data.value

				if contenu and contenu ~= "" then
					ContenuReason = contenu
				else
					ContenuReason = "salut"
				end

				if ContenuReason == "" then
					ContenuReason = "salut"
				end

				TriggerServerEvent('santos_menuperso:annonce', ContenuReason)
			end,
			function (data, menu)
				menu.close()
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openGunTools()
	local elements = {}

	table.insert(elements, {label = 'Delete Object', value = 'menuperso_modo_deleteobj'})
	table.insert(elements, {label = 'Attach Object', value = 'menuperso_modo_attachobj'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_guntools',
	{
		css = 'santos',
		title    = 'Gun Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_deleteobj' then
			gunRemoveObj = not gunRemoveObj
			if gunRemoveObj then
				ESX.ShowNotification('~g~Tirer sur un objet pour le supprimer')
			else
				ESX.ShowNotification('~r~Gun Remove Obj désactiver.')
			end
		elseif data.current.value == 'menuperso_modo_attachobj' then
			gunAttachObj = not gunAttachObj
			if gunAttachObj then
				ESX.ShowNotification("~g~Tirer sur un objet pour l'Attacher")
			else
				ESX.ShowNotification('~r~Gun Attach Obj désactiver.')
			end
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openV3ToolsMenu()
	local elements = {}

	table.insert(elements, {label = 'Open Piano<span> >>', value = 'menuperso_modo_piano'})
	table.insert(elements, {label = 'Open Jobs List<span> >>', value = 'menuperso_modo_job_lists'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_v3toolsmenu',
	{
		css = 'santos',
		title    = 'V3 Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_piano' then
			TriggerEvent('openPiano')
		elseif data.current.value == 'menuperso_modo_job_lists' then
			TriggerEvent('openJobList')
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openV3Tools()
	local elements = {}

	table.insert(elements, {label = 'The End Of Santos-City [EVENT]', value = 'menuperso_modo_lossantosevent'})
	table.insert(elements, {label = 'V3 Test<span> >>', value = 'menuperso_modo_v3'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_v3tools',
	{
		css = 'santos',
		title    = 'V3 Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_lossantosevent' then
			TriggerEvent('riftRoll')
		elseif data.current.value == 'menuperso_modo_v3' then
			openV3ToolsMenu()
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openBanTools()
	local elements = {}

	table.insert(elements, {label = 'Unban', value = 'menuperso_modo_unban'})
	table.insert(elements, {label = 'Ban-List [Soon]<span> >>', value = 'menuperso_modo_banlist'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_bantools',
	{
		css = 'santos',
		title    = 'Ban Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_unban' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_unban', {
				title = 'Entrez le nom Steam du joueur',
				value = ''
			},
			function (data, menu)
				local result = data.value
				TriggerServerEvent("bansql:sqlunban", result)
				menu.close()
			end, function (data, menu)
				menu.close()
			end)
		elseif data.current.value == 'menuperso_modo_banlist' then
			menu.close()
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openWLTools()
	local elements = {}

	table.insert(elements, {label = 'WL un joueur', value = 'menuperso_modo_wl'})
	table.insert(elements, {label = 'Un-WL un joueur', value = 'menuperso_modo_unwl'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_wltools',
	{
		css = 'santos',
		title    = 'WhiteList Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_wl' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_wl', {
				title = 'Entrez le Steam ID HEX du joueur',
				value = ''
			}, function (data2, menu2)
				local resultwl = data2.value
				TriggerServerEvent("esx_whitelist:wladd", resultwl)
				menu2.close()
				Wait(5000)
				TriggerServerEvent("esx_whitelist:wlrefresh")
			end, function (data2, menu2)
				menu2.close()
				TriggerServerEvent("esx_whitelist:wlrefresh")
			end)
		elseif data.current.value == 'menuperso_modo_unwl' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_unwl', {
				title = 'Entrez le Steam ID HEX du joueur',
				value = ''
			},
			function (data, menu)
				local result = data.value
				TriggerServerEvent("esx_whitelist:wlremove", result)
				menu.close()
				Wait(1000)
				TriggerServerEvent("esx_whitelist:wlrefresh")
			end, function (data, menu)
				menu.close()
				TriggerServerEvent("esx_whitelist:wlrefresh")
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openGiveTools()
	local elements = {}

	table.insert(elements, {label = 'Give Money', value = 'menuperso_modo_give_money'})
	table.insert(elements, {label = 'Give Bank Money', value = 'menuperso_modo_give_moneybank'})
	table.insert(elements, {label = 'Give Argent sale', value = 'menuperso_modo_give_moneydirty'})
	table.insert(elements, {label = 'Give Item', value = 'menuperso_modo_give_item'})
	table.insert(elements, {label = 'Give Weapon', value = 'menuperso_modo_give_weapon'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_givetools',
	{
		css = 'santos',
		title    = 'Give Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_give_money' then
			admin_give_money()
		elseif data.current.value == 'menuperso_modo_give_moneybank' then
			admin_give_bank()
		elseif data.current.value == 'menuperso_modo_give_moneydirty' then
			admin_give_dirty()
		elseif data.current.value == 'menuperso_modo_give_item' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_item', {
				title = 'Entrez le nom de l\'item',
				value = ''
			},
			function (data, menu)
				local result = data.value
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_item2', {
					title = 'Entrez le montant',
					value = ''
				},
				function (data2, menu2)
					local result2 = data2.value
					TriggerServerEvent("santos_menuperso:addItem", result, result2)
					menu2.close()
				end,
				function (data2, menu2)
					menu2.close()
				end)
			end,
			function (data, menu)
				menu.close()
			end)
		elseif data.current.value == 'menuperso_modo_give_weapon' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_give_weapon', {
				title = 'Entrez le nom de l\'arme',
				value = ''
			},
			function (data, menu)
				local result = data.value
				TriggerServerEvent("santos_menuperso:addWeapon", result)
				menu.close()
			end,
			function (data, menu)
				menu.close()
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openCharTools()
	local elements = {}

	table.insert(elements, {label = 'Change PlayerModel', value = 'menuperso_modo_changer_PM'})
	table.insert(elements, {label = 'Change Clothes', value = 'menuperso_modo_changer_skin'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_chartools',
	{
		css = 'santos',
		title    = 'Character Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_changer_PM' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_changer_PM', {
				title = 'Entrez le nom du player-model',
				value = ''
			}, function (data, menu)
				local result = data.value
					
				if IsModelInCdimage(result) and IsModelValid(result) then
				    ESX.Streaming.RequestModel(result)

					SetPlayerModel(PlayerId(), result)
					SetPedRandomComponentVariation(PlayerPedId(), true)
					SetModelAsNoLongerNeeded(result)
				end

				menu.close()
			end, function (data, menu)
				menu.close()
			end)
		elseif data.current.value == 'menuperso_modo_changer_skin' then
			TriggerServerEvent('santos_menuperso:openClothes')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openReviveTools()
	local elements = {}

	table.insert(elements, {label = "Revive All", value = 'menuperso_modo_reviveall' })
	table.insert(elements, {label = "Revive Me", value = 'menuperso_modo_revivemy' })

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_revivetools',
	{
		css = 'santos',
		title    = 'Revive Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_revivemy' then
			TriggerServerEvent('reviveEv', "Me")
		elseif data.current.value == 'menuperso_modo_reviveall' then
			TriggerServerEvent('reviveEv', "All")
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openTPTools()
	local elements = {}

	table.insert(elements, {label = 'TP to Marker', value = 'menuperso_modo_tp_marcker'})
	table.insert(elements, {label = 'TP to Coords', value = 'menuperso_modo_tp_pos'})
	table.insert(elements, {label = 'TP to POI\'s', value = 'menuperso_modo_tp_poi'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_tp',
	{
		css = 'santos',
		title    = 'Teleport Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_tp_marcker' then
			admin_tp_marcker()
		elseif data.current.value == 'menuperso_modo_tp_pos' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_tp_pos', {
				title = 'Entrez une position (exemple: 0 0 0)',
				value = ''
			},
			function (data, menu)
				local tt = data.value
				local coords = {}

				for coord in string.gmatch(tt or "0,0,0","[^,]+") do
				    table.insert(coords,tonumber(coord))
				end

				local posx,posy,posz = 0,0,0
				if coords[1] ~= nil then posx = coords[1] end
				if coords[2] ~= nil then posy = coords[2] end
				if coords[3] ~= nil then posz = coords[3] end

				SetEntityCoords(PlayerPedId(), posx+0.0001,posy+0.0001,posz+0.0001,0,0,0, false)
				menu.close()
			end, function (data, menu)
				menu.close()
			end)
		elseif data.current.value == 'menuperso_modo_tp_poi' then
			local elem = {}
			table.insert(elem, {label = 'Parking Central', pos = { x = 615.921, y = 88.554, z = 91.886 }})
			table.insert(elem, {label = 'Comico', pos = { x = 637.193, y = -5.355, z = 82.787 }})
			table.insert(elem, {label = 'Concessionnaire', pos = { x = -805.709, y = -220.686, z = 37.258 }})
			table.insert(elem, {label = 'Mécano', pos = { x = -363.639, y = -139.890, z = 38.683 }})
			table.insert(elem, {label = 'Pole Emploi', pos = { x = -538.840, y = -207.588, z = 37.652 }})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_tp_poi',
			{
				css = 'santos',
				title    = 'Liste des PoI\'s',
				align    = 'top-left',
				elements = elem
			}, function(data4, menu4)
				ESX.Game.Teleport(PlayerPedId(), {x = data4.current.pos.x, y = data4.current.pos.y, z = data4.current.pos.z})
			end, function(data4, menu4)
				menu4.close()
			end)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function openCoordsTools()
	local elements = {}

	table.insert(elements, {label = 'Copy Coords to Clipboard', value = 'menuperso_modo_copycoords'})
	table.insert(elements, {label = 'Show Coords', value = 'menuperso_modo_showcoord'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_coords',
	{
		css = 'santos',
		title    = 'Coords Tools',
		align    = 'top-left',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'menuperso_modo_copycoords' then
			local coords = tostring(GetEntityCoords(PlayerPedId()))
			TriggerEvent('copyToClipboard', coords)
		elseif data.current.value == 'menuperso_modo_showcoord' then
			showcoord = not showcoord
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() and ESX then	
 		ESX.UI.Menu.CloseAll()
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and ESX then	
 		ESX.UI.Menu.CloseAll()
	end
end)

function openModoPlayersList()
	ESX.TriggerServerCallback('infinity:getPlayersInfos', function(ply)
		local elements = {}
		local plySelected = nil

		for k,v in pairs(ply) do
			if type(v) == 'table' then
				table.insert(elements, {label = "["..v.id.."] "..v.steamName, 
					id = v.id,
					-- ped = v.ped,
					-- ping = v.ping,

					positionX = v.position.x,
					positionY = v.position.y,
					positionZ = v.position.z,
					heading = v.heading,

					steamName = v.steamName,
					--firstname = v.firstname,
					--name = v.name,
					group = v.group,
					job = v.job,
					org = v.org
				})
			end
		end
		
		table.sort(elements, (function(v, v2)
			return v.id > v2.id
		end))

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_player',
		{
			css = 'santos',
			title    = 'Liste des Joueurs',
			align    = 'top-left',
			elements = elements
		}, function(data4, menu4)
			plySelected = data4.current
			openModoPlayersListFunctions(plySelected)
		end, function(data4, menu4)
			menu4.close()
		end)
	end)
end

function openModoPlayersListFunctions(plyTable)
	if type(plyTable) == 'table' then 
		local elements = {}

		ESX.TriggerServerCallback('santos_menuperso:getUsergroup', function(group)
			playergroup = group

			ply = GetPlayerFromServerId(plyTable.id)
			playerID = plyTable.id

			table.insert(elements, {label = "Infos<span> >>", value = 'menuperso_modo_infos' })
			table.insert(elements, {label = "Fouille a distance<span> >>", value = 'menuperso_modo_fouilledist' })
			table.insert(elements, {label = "Freeze", value = 'menuperso_modo_freeze' })
			table.insert(elements, {label = "Set Health", value = 'menuperso_modo_kill' })
			if playergroup == "superadmin" then
				table.insert(elements, {label = "Set Group", value = 'menuperso_modo_group' })
			end
			table.insert(elements, {label = "Set Job", value = 'menuperso_modo_job' })
			table.insert(elements, {label = "Set Org/Gang", value = 'menuperso_modo_org' })
			table.insert(elements, {label = "Set PlayerModel", value = 'menuperso_modo_pm' })
			table.insert(elements, {label = "Give Pack", value = 'menuperso_modo_givepack' })
			table.insert(elements, {label = "Kick", value = 'menuperso_modo_kick' })
			table.insert(elements, {label = "Ban", value = 'menuperso_modo_ban' })
			table.insert(elements, {label = "TP à lui", value = 'menuperso_modo_tpto' })
			table.insert(elements, {label = "TP à moi", value = 'menuperso_modo_tpmy' })
			table.insert(elements, {label = "Return last pos", value = 'menuperso_modo_retlp' })
			table.insert(elements, {label = "Revive", value = 'menuperso_modo_revive' })
			table.insert(elements, {label = "--------------------- -100 mètres ---------------------" })
			table.insert(elements, {label = "Spectate", value = 'menuperso_modo_spectate' })

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), playerID,
			{
				css = 'santos',
				title    = '['..playerID..'] '..plyTable.steamName,
				align    = 'top-left',
				elements = elements
			}, function(data5, menu5)
				ESX.TriggerServerCallback('infinity:updatePlyPos', function(pos)
					plyTable.positionX, plyTable.positionY, plyTable.positionZ = pos.x, pos.y, pos.z

					local plyCoords = GetEntityCoords(PlayerPedId())
					local targetCoords = vector3(plyTable.positionX, plyTable.positionY, plyTable.positionZ)
					local distance = #(plyCoords - targetCoords)
						
					if data5.current.value == 'menuperso_modo_infos' then
						OpenInfosMenu(playerID)
					elseif data5.current.value == 'menuperso_modo_fouilledist' then
						OpenBodySearchMenu(playerID)
					elseif data5.current.value == 'menuperso_modo_pm' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_pm', {
							title = 'Entrez le nom du player-model',
							value = ''
						}, function (data, menu)
							local result = data.value
										
							if IsModelInCdimage(result) and IsModelValid(result) then
								TriggerServerEvent('sendPM', playerID, result)
							else
								ESX.ShowNotification('~r~Model invalide')
							end

							menu.close()
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_tpto' then
						local targetCoords = vector3(plyTable.positionX, plyTable.positionY, plyTable.positionZ)
						local targetHeading = plyTable.heading
						local targetVeh = GetVehiclePedIsIn(GetPlayerPed(ply), false)
						local seat = -1

						if targetVeh then
							local numSeats = GetVehicleModelNumberOfSeats(GetEntityModel(targetVeh))
									
							if numSeats > 1 then
								for i = 0, numSeats do
									if seat == -1 and IsVehicleSeatFree(targetVeh, i) then
										seat = i
									end
								end
							end

							if seat == -1 then
								SetEntityCoords(PlayerPedId(), targetCoords, 0, 0, targetHeading, true)
							else
								SetPedIntoVehicle(PlayerPedId(), targetVeh, seat)
							end
						end
					elseif data5.current.value == 'menuperso_modo_tpmy' then
						local px, py, pz = table.unpack(GetEntityCoords(PlayerPedId()))
						local pLastx, pLasty, pLastz = plyTable.positionX, plyTable.positionY, plyTable.positionZ
						plyLastPos = vector3(pLastx, pLasty, pLastz)
						TriggerServerEvent("santos_menuperso:TeleportPlayerToCoords", playerID, px, py, pz)
					elseif data5.current.value == 'menuperso_modo_retlp' then
						if plyLastPos ~= nil and plyLastPos ~= "" then
							TriggerServerEvent("santos_menuperso:TeleportPlayerToCoords", playerID, plyLastPos.x, plyLastPos.y, plyLastPos.z)
							plyLastPos = nil
						else
							ESX.ShowNotification("~r~Vous devez d'abord TP cette personne à vous.")
						end
					elseif data5.current.value == 'menuperso_modo_kill' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_health', {
							title = 'Entrez la valeur de vie',
							value = ''
						}, function (data, menu)
							local health = data.value
									
							if health then
								Health = health
							else
								Health = "200"
							end

							TriggerServerEvent("santos_menuperso:setHealth", playerID, Health)
							menu.close()
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_givepack' then
						openModoGivePack(playerID)
					elseif data5.current.value == 'menuperso_modo_freeze' then
						freezed = not freezed
						TriggerServerEvent("santos_menuperso:FreezePlayer", playerID, freezed)
					elseif data5.current.value == 'menuperso_modo_kick' then 
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_kick', {
							title = 'Entrez la raison du kick',
							value = ''
						}, function (data, menu)
							local result = data.value

							if result and result ~= "" then
								KickReason = "Kicked: "..result
							else
								KickReason = "Aucune raison de Kick"
							end

							TriggerServerEvent("santos_menuperso:kickPly", playerID, KickReason)
							menu.close()
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_ban' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_ban', {
							title = 'Entrez la raison du ban',
							value = ''
						}, function (data, menu)
							local result = data.value

							if result and result ~= "" then
								BanReason = result
							else
								BanReason = "Aucune raison de Ban"
							end

							TriggerServerEvent("BanSql:Ban", playerID, BanReason)
							menu.close()
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_group' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_group', {
							title = 'Entrez le nom du Groupe',
							value = ''
						}, function (data, menu)
							local group = data.value

							if group and group ~= "" then
								Group = group
							else
								Group = "user"
							end

							menu.close()
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_org', {
								title = 'Entrez le numéro du grade(4=max)',
								value = ''
							}, function (data, menu)
								local groupgrade = data.value

								if groupgrade then
									GradeGroup = groupgrade
								else
									GradeGroup = "0"
								end

								TriggerServerEvent("santos_menuperso:addgroup", playerID, Group, GradeGroup)
								menu.close()
							end, function (data, menu)
								menu.close()
							end)
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_org' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_org', {
							title = 'Entrez le nom du Gang/Org',
							value = ''
						}, function (data, menu)
							local org = data.value

							if org and org ~= "" then
								Org = org
							else
								Org = "santos"
							end

							menu.close()
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_org', {
								title = 'Entrez le numéro du grade',
								value = ''
							}, function (data, menu)
								local orggrade = data.value

								if orggrade then
									GradeOrg = orggrade
								else
									GradeOrg = "0"
								end

								TriggerServerEvent("santos_menuperso:addorg", playerID, Org, GradeOrg)
								menu.close()
							end, function (data, menu)
								menu.close()
							end)
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_job' then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_job', {
							title = 'Entrez le nom du job',
							value = ''
						}, function (data, menu)
							local job = data.value

							if job and job ~= "" then
								Job = job
							else
								Job = "chomeur"
							end

							menu.close()
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menuperso_modo_job', {
								title = 'Entrez le numéro du grade',
								value = ''
							}, function (data, menu)
								local grade = data.value

								if grade then
									Grade = grade
								else
									Grade = "0"
								end

								TriggerServerEvent("santos_menuperso:addjob", playerID, Job, Grade)
								menu.close()
							end, function (data, menu)
								menu.close()
							end)
						end, function (data, menu)
							menu.close()
						end)
					elseif data5.current.value == 'menuperso_modo_revive' then
						TriggerServerEvent('ambujob:revive', playerID)
					end

					if distance <= 100 then
						if data5.current.value == 'menuperso_modo_spectate' then
							TriggerServerEvent("santos_menuperso:requestSpectate", playerID)
						end
					elseif distance > 100 and data5.current.value == 'menuperso_modo_spectate' then
						ESX.ShowNotification('~r~Vous devez être a moins de 100m du joueur.~w~\nDistance actuelle: ~b~'..distance)
					end
				end, tonumber(plyTable.id))
			end, function(data5, menu5)
				menu5.close()
			end)
		end)
	end
end

RegisterNetEvent("santos_menuperso:TeleportRequest")
AddEventHandler('santos_menuperso:TeleportRequest', function(px, py, pz)
	SetEntityCoords(PlayerPedId(), px, py, pz, 0, 0, 0, false)
end)

RegisterNetEvent("santos_menuperso:requestSpectate")
AddEventHandler('santos_menuperso:requestSpectate', function(playerPed, playerId, playerName)
	spectatePlayer(NetworkGetEntityFromNetworkId(playerPed), GetPlayerFromServerId(playerId), playerName)
end)

function spectatePlayer(targetPed, target, name)
	local playerPed = PlayerPedId()
	enable = true

	if targetPed == playerPed then
		enable = false
	end

	if enable then
		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(true, targetPed)

		drawTargetPed = targetPed
		drawTarget = target
		drawTargetName = name
		drawInfo = true
		ESX.ShowNotification("~g~Vous regardez "..name..".")
	else
		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(false, targetPed)

		drawInfo = false
		drawTargetPed = nil
		drawTarget = nil
		drawTargetName = nil
		ESX.ShowNotification("~r~Vous avez arrêter de regarder "..name..".")
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			-- cheat checks
			local targetPed = drawTargetPed
			local targetGod = GetPlayerInvincible(drawTarget)

			if targetGod then
				table.insert(text,"God-Mode : ~r~Détecté~w~")
			else
				table.insert(text,"God-Mode : ~g~Non détecté~w~")
			end

			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text,"~r~Anti-Ragdoll~w~")
			end

			-- health info
			table.insert(text,"Vie: "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,"Armure: "..GetPedArmour(targetPed))

			-- misc info
			table.insert(text,"[E] pour quitter le mode spectateur")
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if IsControlJustPressed(0, 103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
	
				StopDrawPlayerInfo()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent("santos_menuperso:FreezePlayer")
AddEventHandler('santos_menuperso:FreezePlayer', function(toggle)
	frozen = toggle
	FreezeEntityPosition(PlayerPedId(), frozen)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), frozen)
	end 
end)

function OpenInfosMenu(playerID)
	ESX.TriggerServerCallback('santos_menuperso:getUsergroup', function(group)
		playergroup = group
		
		ESX.TriggerServerCallback('santos_menuperso:getAdminOtherPlayerData', function(data)
			local elements = {}
			table.insert(elements, {
				label    = 'ID:<span> '..playerID,
				value    = playerID
			})
			table.insert(elements, {
				label    = 'Steam:<span> '..data.name,
				value    = data.name
			})
			table.insert(elements, {
				label    = 'Nom RP:<span> '..data.firstname..' '..data.lastname,
				value    = data.firstname..' '..data.lastname
			})
			table.insert(elements, {
				label    = 'Groupe:<span> '..data.group,
				value    = data.group
			})
			table.insert(elements, {
				label    = 'Job:<span> '..data.job.label.. ' - ' ..data.job.grade_label,
				value    = data.job.label.. ' - ' ..data.job.grade_label
			})
			table.insert(elements, {
				label    = 'Org:<span> '..data.org.label.. ' - ' ..data.org.grade_label,
				value    = data.org.label.. ' - ' ..data.org.grade_label
			})
			table.insert(elements, {
				label    = 'Argent: <span style="color:green;">$'..ESX.Math.GroupDigits(data.money)..'</span>',
				value    = data.money
			})
			table.insert(elements, {
				label    = 'Bank: <span style="color:blue;">$'..ESX.Math.GroupDigits(data.bank)..'</span>',
				value    = data.bank
			})
			table.insert(elements, {
				label    = 'Argent Sale: <span style="color:red;">$'..ESX.Math.GroupDigits(data.black)..'</span>',
				value    = data.black
			})
			if playergroup == "superadmin" and data.name ~= "SNIKRS" then -- :)
				table.insert(elements, {
					label    = 'IP:<span> '..data.ip,
					value    = data.ip
				})
			end

			local steam_hex = ESX.Table.Split(":", data.identifier)
			table.insert(elements, {
				label    = 'Steam HEX:<span> '..steam_hex[2],
				value    = steam_hex[2]
			})

			local steam_link = "http://steamcommunity.com/profiles/"..tonumber("0x"..steam_hex[2])
			table.insert(elements, {
				label    = 'Steam Profile:<span> '..tonumber("0x"..steam_hex[2]),
				value    = steam_link
			})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_perso_infos_players',
			{
				css = 'santos',
				title = data.name,
				align = 'top-left',
				elements = elements
			}, function(data1, menu1)
				ESX.ShowNotification('Vous avez copié ~b~'..data1.current.value)
				TriggerEvent('copyToClipboard', data1.current.value)
			end, function(data1, menu1)
				menu1.close()
			end)
		end, playerID)
	end)
end

-- local spawnedPeds = {}

-- RegisterCommand("spawnPeds", function()
-- 	Citizen.CreateThread(function()
-- 		ESX.Streaming.RequestModel(`mp_m_freemode_01`)
-- 		local pos = GetEntityCoords(PlayerPedId())
-- 		for i=1, 180 do
-- 			local a, b = i, 0
-- 			while a >= 10 do
-- 				b = b + 1
-- 				a = a - 10
-- 			end

-- 			local ped = CreatePed(4, `mp_m_freemode_01`, pos.x + a * 1.0, pos.y + 1.0 * b, pos.z - 1.0, 0.0, true, true)
-- 			SetPedHeadBlendData(ped, math.random(4, 20), math.random(4, 20), math.random(4, 20), math.random(4, 20), math.random(4, 20), math.random(4, 20), 1.0, 0.5, 1.0)
-- 			FreezeEntityPosition(ped, true)
-- 			SetBlockingOfNonTemporaryEvents(ped, true)

-- 			spawnedPeds[#spawnedPeds + 1] = ped
-- 		end

-- 		RegisterCommand("testReset", function()
-- 			for _, v in pairs(spawnedPeds) do
-- 				SetPedDefaultComponentVariation(v)
-- 				SetPedHeadBlendData(v)
-- 				SetPedComponentVariation(v, 0)
-- 			end
-- 		end)
-- 	end)
-- end)

-- AddEventHandler("onResourceStop", function(r)
-- 	if r ~= GetCurrentResourceName() then return end

-- 	for _, v in pairs(spawnedPeds) do
-- 		DeletePed(v)
-- 	end
-- end)

function OpenBodySearchMenu2(player)
	ESX.TriggerServerCallback('santos_menuperso:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = 'Confisqué Argent Sale: <span style="color:red;">$'..ESX.Math.Round(data.accounts[i].money)..'</span>',
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})
				break
			end
		end

		table.insert(elements, {label = '--- Armes ---'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = 'Confisqué '..ESX.GetWeaponLabel(data.weapons[i].name)..' avec '..data.weapons[i].ammo..' balles',
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
			break
		end

		table.insert(elements, {label = '--- Inventaire ---'})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = 'Confisqué '..data.inventory[i].count..'x '..data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
				break
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
    		css = 'santos',
			title    = 'Fouiller',
			align    = 'top-left',
			elements = elements
		}, function(data7, menu7)
			if data7.current.value then
				TriggerServerEvent('santos_menuperso:confiscatePlayerItem', player, data7.current.itemType, data7.current.value, data7.current.amount)
				OpenBodySearchMenu2(player)
			end
		end, function(data7, menu7)
			menu7.close()
		end)
	end, player)
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('santos_menuperso:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = 'Confisqué Argent Sale: <span style="color:red;">$'..ESX.Math.Round(data.accounts[i].money)..'</span>',
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = '--- Armes ---'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = 'Confisqué '..ESX.GetWeaponLabel(data.weapons[i].name)..' avec '..data.weapons[i].ammo..' balles',
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = '--- Inventaire ---'})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = 'Confisqué '..data.inventory[i].count..'x '..data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
    		css = 'santos',
			title    = 'Fouiller',
			align    = 'top-left',
			elements = elements
		}, function(data7, menu7)
			if data7.current.value then
				TriggerServerEvent('santos_menuperso:confiscatePlayerItem', player, data7.current.itemType, data7.current.value, data7.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data7, menu7)
			menu7.close()
		end)
	end, player)
end

function openModoGivePack(id)
	local elements = {}

	table.insert(elements, {label = 'Server Boost', pack = 'pack_boost'})
	table.insert(elements, {label = 'Starter Pack', pack = 'pack_starter'})
	table.insert(elements, {label = 'Pack Véhicule', pack = 'pack_vehicule'})
	table.insert(elements, {label = 'Pack Arme', pack = 'pack_arme'})
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_give_pack',
	{
		css = 'santos',
		title = 'Pack',
		align = 'top-left',
		elements = elements
	},
	function(data3, menu3)
		if data3.current.pack == 'pack_vehicule' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pack-vehicule', {
				title = 'Entrez le nom d\'un véhicule',
				value = ''
			}, function (data, menu)
				local model = (type(vehidata.valuecle) == 'number' and data.value or GetHashKey(data.value))
				
				if IsModelInCdimage(model) then
					TriggerServerEvent('santos_menuperso:GivePack', id, 'pack_vehicule')
					menu.close()
				else
					ESX.ShowNotification('~r~Model invalide.')
				end
			end, function (data, menu)
				menu.close()
			end)
		else
			TriggerServerEvent('santos_menuperso:GivePack', id, data3.current.value)
		end
	end,
	function(data3, menu3)
		menu3.close()
	end)
end

function openModoVehicules()
	local elements = {}

	table.insert(elements, {label = 'Custom<span> >>', value = 'menuperso_modo_vehicle_colors'})
	table.insert(elements, {label = 'Spawn', value = 'menuperso_modo_vehicle_spawn'})
	table.insert(elements, {label = 'Fix', value = 'menuperso_modo_vehicle_repair'})
	table.insert(elements, {label = 'Flip', value = 'menuperso_modo_vehicle_flip'})
	table.insert(elements, {label = 'Delete', value = 'menuperso_modo_vehicle_del'})
	table.insert(elements, {label = 'Dévérouiller', value = 'menuperso_modo_vehicle_unlock'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_vehicules',
	{
		css = 'santos',
		title = 'Véhicules',
		align = 'top-left',
		elements = elements
	},
	function(data3, menu3)
		if data3.current.value == 'menuperso_modo_vehicle_del' then
			TriggerEvent('esx:deleteVehicle')
		elseif data3.current.value == 'menuperso_modo_vehicle_colors' then
			openColorsVehicle()
		elseif data3.current.value == 'menuperso_modo_vehicle_repair' then
			TriggerEvent('fixVehicle')
		elseif data3.current.value == 'menuperso_modo_vehicle_unlock' then
			admin_vehicle_unlock()
		elseif data3.current.value == 'menuperso_modo_vehicle_spawn' then
			admin_vehicle_spawn()
		elseif data3.current.value == 'menuperso_modo_vehicle_flip' then
			TriggerEvent('flipVehicle')
		end
	end,
	function(data3, menu3)
		menu3.close()
	end)
end

local colorNames = {
    ['0'] = "Metallic Black",
    ['1'] = "Metallic Graphite Black",
    ['2'] = "Metallic Black Steal",
    ['3'] = "Metallic Dark Silver",
    ['4'] = "Metallic Silver",
    ['5'] = "Metallic Blue Silver",
    ['6'] = "Metallic Steel Gray",
    ['7'] = "Metallic Shadow Silver",
    ['8'] = "Metallic Stone Silver",
    ['9'] = "Metallic Midnight Silver",
    ['10'] = "Metallic Gun Metal",
    ['11'] = "Metallic Anthracite Grey",
    ['12'] = "Matte Black",
    ['13'] = "Matte Gray",
    ['14'] = "Matte Light Grey",
    ['15'] = "Util Black",
    ['16'] = "Util Black Poly",
    ['17'] = "Util Dark silver",
    ['18'] = "Util Silver",
    ['19'] = "Util Gun Metal",
    ['20'] = "Util Shadow Silver",
    ['21'] = "Worn Black",
    ['22'] = "Worn Graphite",
    ['23'] = "Worn Silver Grey",
    ['24'] = "Worn Silver",
    ['25'] = "Worn Blue Silver",
    ['26'] = "Worn Shadow Silver",
    ['27'] = "Metallic Red",
    ['28'] = "Metallic Torino Red",
    ['29'] = "Metallic Formula Red",
    ['30'] = "Metallic Blaze Red",
    ['31'] = "Metallic Graceful Red",
    ['32'] = "Metallic Garnet Red",
    ['33'] = "Metallic Desert Red",
    ['34'] = "Metallic Cabernet Red",
    ['35'] = "Metallic Candy Red",
    ['36'] = "Metallic Sunrise Orange",
    ['37'] = "Metallic Classic Gold",
    ['38'] = "Metallic Orange",
    ['39'] = "Matte Red",
    ['40'] = "Matte Dark Red",
    ['41'] = "Matte Orange",
    ['42'] = "Matte Yellow",
    ['43'] = "Util Red",
    ['44'] = "Util Bright Red",
    ['45'] = "Util Garnet Red",
    ['46'] = "Worn Red",
    ['47'] = "Worn Golden Red",
    ['48'] = "Worn Dark Red",
    ['49'] = "Metallic Dark Green",
    ['50'] = "Metallic Racing Green",
    ['51'] = "Metallic Sea Green",
    ['52'] = "Metallic Olive Green",
    ['53'] = "Metallic Green",
    ['54'] = "Metallic Gasoline Blue Green",
    ['55'] = "Matte Lime Green",
    ['56'] = "Util Dark Green",
    ['57'] = "Util Green",
    ['58'] = "Worn Dark Green",
    ['59'] = "Worn Green",
    ['60'] = "Worn Sea Wash",
    ['61'] = "Metallic Midnight Blue",
    ['62'] = "Metallic Dark Blue",
    ['63'] = "Metallic Saxony Blue",
    ['64'] = "Metallic Blue",
    ['65'] = "Metallic Mariner Blue",
    ['66'] = "Metallic Harbor Blue",
    ['67'] = "Metallic Diamond Blue",
    ['68'] = "Metallic Surf Blue",
    ['69'] = "Metallic Nautical Blue",
    ['70'] = "Metallic Bright Blue",
    ['71'] = "Metallic Purple Blue",
    ['72'] = "Metallic Spinnaker Blue",
    ['73'] = "Metallic Ultra Blue",
    ['74'] = "Metallic Bright Blue",
    ['75'] = "Util Dark Blue",
    ['76'] = "Util Midnight Blue",
    ['77'] = "Util Blue",
    ['78'] = "Util Sea Foam Blue",
    ['79'] = "Util Lightning blue",
    ['80'] = "Util Maui Blue Poly",
    ['81'] = "Util Bright Blue",
    ['82'] = "Matte Dark Blue",
    ['83'] = "Matte Blue",
    ['84'] = "Matte Midnight Blue",
    ['85'] = "Worn Dark blue",
    ['86'] = "Worn Blue",
    ['87'] = "Worn Light blue",
    ['88'] = "Metallic Taxi Yellow",
    ['89'] = "Metallic Race Yellow",
    ['90'] = "Metallic Bronze",
    ['91'] = "Metallic Yellow Bird",
    ['92'] = "Metallic Lime",
    ['93'] = "Metallic Champagne",
    ['94'] = "Metallic Pueblo Beige",
    ['95'] = "Metallic Dark Ivory",
    ['96'] = "Metallic Choco Brown",
    ['97'] = "Metallic Golden Brown",
    ['98'] = "Metallic Light Brown",
    ['99'] = "Metallic Straw Beige",
    ['100'] = "Metallic Moss Brown",
    ['101'] = "Metallic Biston Brown",
    ['102'] = "Metallic Beechwood",
    ['103'] = "Metallic Dark Beechwood",
    ['104'] = "Metallic Choco Orange",
    ['105'] = "Metallic Beach Sand",
    ['106'] = "Metallic Sun Bleeched Sand",
    ['107'] = "Metallic Cream",
    ['108'] = "Util Brown",
    ['109'] = "Util Medium Brown",
    ['110'] = "Util Light Brown",
    ['111'] = "Metallic White",
    ['112'] = "Metallic Frost White",
    ['113'] = "Worn Honey Beige",
    ['114'] = "Worn Brown",
    ['115'] = "Worn Dark Brown",
    ['116'] = "Worn straw beige",
    ['117'] = "Brushed Steel",
    ['118'] = "Brushed Black steel",
    ['119'] = "Brushed Aluminium",
    ['120'] = "Chrome",
    ['121'] = "Worn Off White",
    ['122'] = "Util Off White",
    ['123'] = "Worn Orange",
    ['124'] = "Worn Light Orange",
    ['125'] = "Metallic Securicor Green",
    ['126'] = "Worn Taxi Yellow",
    ['127'] = "Police Blue",
    ['128'] = "Matte Green",
    ['129'] = "Matte Brown",
    ['130'] = "Worn Orange",
    ['131'] = "Matte White",
    ['132'] = "Worn White",
    ['133'] = "Worn Olive Army Green",
    ['134'] = "Pure White",
    ['135'] = "Hot Pink",
    ['136'] = "Salmon pink",
    ['137'] = "Metallic Vermillion Pink",
    ['138'] = "Orange",
    ['139'] = "Green",
    ['140'] = "Blue",
    ['141'] = "Mettalic Black Blue",
    ['142'] = "Metallic Black Purple",
    ['143'] = "Metallic Black Red",
    ['144'] = "Hunter Green",
    ['145'] = "Metallic Purple",
    ['146'] = "Metaillic V Dark Blue",
    ['147'] = "ModShop Black",
    ['148'] = "Matte Purple",
    ['149'] = "Matte Dark Purple",
    ['150'] = "Metallic Lava Red",
    ['151'] = "Matte Forest Green",
    ['152'] = "Matte Olive Drab",
    ['153'] = "Matte Desert Brown",
    ['154'] = "Matte Desert Tan",
    ['155'] = "Matte Foilage Green",
    ['156'] = "Default Alloy",
    ['157'] = "Epsilon Blue",
}

function openColorsVehicle()
	local elements = {}

	table.insert(elements, {label = 'Custom Max', value = 'menuperso_modo_custommax'})
	table.insert(elements, {label = 'Primary Color<span> >>', value = 'pri_col'})
	table.insert(elements, {label = 'Secondary Color<span> >>', value = 'sec_col'})
	table.insert(elements, {label = 'Nacré Color [Soon]', value = 'nac_col'})
	table.insert(elements, {label = 'Neon Color', value = 'neon_col'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_vehicle_colors',
	{
		css = 'santos',
		title = 'Custom Vehicle',
		align = 'top-left',
		elements = elements
	},
	function(data3, menu3)
		local Colorelements = {}

		for k,v in pairs(colorNames) do
			table.insert(Colorelements, {label = v, value = tonumber(k)})
		end

		table.sort(Colorelements, (function(value, value2)
			return value.label < value2.label
	    end))

		if data3.current.value == "pri_col" then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_vehicle_primary_color',
			{
				css = 'santos',
				title = 'Primary Color',
				align = 'top-left',
				elements = Colorelements
			},
			function(data4, menu4)
				local vehicle = IsPedSittingInAnyVehicle(PlayerPedId())
				if vehicle then
					local veh = GetVehiclePedIsIn(PlayerPedId(), false)
					local primary, secondary = GetVehicleColours(veh)
					if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
						SetVehicleColours(veh, data4.current.value, secondary)
					else
						ESX.ShowNotification('~r~Vous devez être conducteur du véhicule.')
					end
				else
					ESX.ShowNotification('~r~Vous devez être dans un véhicule.')
				end
			end, function(data4, menu4)
				menu4.close()
			end)
		elseif data3.current.value == "sec_col" then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menuperso_modo_vehicle_secondary_color',
			{
				css = 'santos',
				title = 'Secondary Color',
				align = 'top-left',
				elements = Colorelements
			},
			function(data4, menu4)
				local vehicle = IsPedSittingInAnyVehicle(PlayerPedId())
				if vehicle then
					local veh = GetVehiclePedIsIn(PlayerPedId(), false)
					local primary, secondary = GetVehicleColours(veh)
					if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
						SetVehicleColours(veh, primary, data4.current.value)
					else
						ESX.ShowNotification('~r~Vous devez être conducteur du véhicule.')
					end
				else
					ESX.ShowNotification('~r~Vous devez être dans un véhicule.')
				end
			end, function(data4, menu4)
				menu4.close()
			end)
		elseif data3.current.value == 'menuperso_modo_custommax' then
			SetVehicleMaxMods()
		elseif data3.current.value == 'nac_col' then
		elseif data3.current.value == 'neon_col' then
			local vehicle = IsPedSittingInAnyVehicle(PlayerPedId())
			if vehicle then
				local veh = GetVehiclePedIsIn(PlayerPedId(), false)
				if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'rename-sim',
					{
						title = 'Entrez une valeur RGB ex: 0,0,0',
						value = ''
					},
					function (data, menu)
						local color = data.value
						local colors = {}

						for clr in string.gmatch(color or "0,0,0","[^,]+") do
						    table.insert(colors, tonumber(clr))
						end

						local r, g, b = 0,0,0
						if colors[1] ~= nil then r = colors[1] end
						if colors[2] ~= nil then g = colors[2] end
						if colors[3] ~= nil then b = colors[3] end

						menu.close()

						if r and g and b then
							for i = 0, 3 do
								if not IsVehicleNeonLightEnabled(veh, i) then
									SetVehicleNeonLightEnabled(veh, i, true)
								end
							end
							SetVehicleNeonLightsColour(veh, r, g, b)
						end
					end, function (data, menu)
						menu.close()
					end)
				else
					ESX.ShowNotification('~r~Vous devez être conducteur du véhicule.')
				end
			else
				ESX.ShowNotification('~r~Vous devez être dans un véhicule.')
			end
		end
	end, function(data3, menu3)
		menu3.close()
	end)
end

RegisterNetEvent("killMe")
AddEventHandler("killMe", function(health)
    SetEntityHealth(PlayerPedId(), tonumber(health))
end)

RegisterNetEvent("sendtoP")
AddEventHandler("sendtoP", function(result)
    SetPlayerModel(PlayerId(), result)
	SetPedRandomComponentVariation(PlayerPedId(), true)
	SetModelAsNoLongerNeeded(result)
end)

function GunRemoveObj()
	if gunRemoveObj then
		if IsPlayerFreeAiming(PlayerId()) then -- checks if player is aiming around
			local entity = ESX.Game.GetObjectPlayerIsFreeAimingAt(PlayerId()) -- gets the entity
			if IsPedShooting(PlayerPedId()) then -- checks if ped is shooting
				NetworkRequestControlOfEntity(entity)
	    
				if not IsEntityAMissionEntity(entity) then
				    SetEntityAsMissionEntity(entity)        
				end

				if (DoesEntityExist(entity)) then
					Citizen.Wait(100)
					DeleteEntity(entity)
					DeleteObject(entity)
		    		ESX.ShowNotification('~r~Objet supprimé !')
		    	end 
			end
		end
	end
end

function GunAttachObj()
	if gunAttachObj then
		if IsPlayerFreeAiming(PlayerId()) then -- checks if player is aiming around
			local entity = ESX.Game.GetObjectPlayerIsFreeAimingAt(PlayerId()) -- gets the entity
			if IsPedShooting(PlayerPedId()) then -- checks if ped is shooting
				NetworkRequestControlOfEntity(entity)

				if not IsEntityAMissionEntity(entity) then
				    SetEntityAsMissionEntity(entity)        
				end

				Citizen.Wait(100)
				AttachEntityToEntity(entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844),0.2, 0.04, 0, 0, 270.0, 20.0, true, true, false, true, 1, true) -- deletes the entity
				ESX.ShowNotification('~g~Objet attaché !')
			end
		end
	end
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if gunRemoveObj then
			GunRemoveObj()
		else
			Citizen.Wait(500)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if gunAttachObj then
			GunAttachObj()
		else
			Citizen.Wait(500)
		end
	end
end)


function openIdentity()
	local elements = {}
	table.insert(elements, {label = '💳 Voir ma carte d\'identité', value = 'checkID'})
	table.insert(elements, {label = '💳 Montrer ma carte d\'identité', value = 'showID'})
				
	ESX.UI.Menu.Open(			
		'default', GetCurrentResourceName(), 'menuperso_moi_identity',
		{
			css = 'santos',
			title    = 'Carte d\'identité',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkID' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			end
			if data4.current.value == 'showID' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openDMV()
	local elements = {}
	table.insert(elements, {label = '🚗 Voir mon code de la route', value = 'checkDriverDMV'})
	table.insert(elements, {label = '🚗 Montrer mon code de la route', value = 'showDriverDMV'})
	ESX.UI.Menu.Open(			
		'default', GetCurrentResourceName(), 'menuperso_moi_code',
		{
			css = 'santos',
			title    = '🚗 Code de la route',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkDriverDMV' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'dmv')
			end
			if data4.current.value == 'showDriverDMV' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'dmv')								
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPermis()
	local elements = {}
	table.insert(elements, {label = '🚙 Voir mon permis de conduire', value = 'checkDriver'})
	table.insert(elements, {label = '🚙 Montrer mon permis de conduire', value = 'showDriver'})
	ESX.UI.Menu.Open(			
		'default', GetCurrentResourceName(), 'menuperso_moi_permis',
		{
			css = 'santos',
			title    = '🚙 Permis de conduire',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkDriver' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive')
			end
			if data4.current.value == 'showDriver' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'drive')								
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPA()
	local elements = {}
	table.insert(elements, {label = '🛫 Voir mon permis d\'avion', value = 'checkaircraft'})
	table.insert(elements, {label = '🛫 Montrer mon permis d\'avion', value = 'showaircraft'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_permisavion',
		{
			css = 'santos',
			title    = '🛫 Permis d\'avion',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkaircraft' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'aircraft')
			end
			if data4.current.value == 'showaircraft' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'aircraft')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end


function openPBateau()
	local elements = {}
	table.insert(elements, {label = '🛶 Voir mon permis bateau', value = 'checkbateau'})
	table.insert(elements, {label = '🛶 Montrer mon permis bateau', value = 'showbateau'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_permisbateau',
		{
			css = 'santos',
			title    = '🛶 Permis bateau',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkbateau' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'boating')
			end
			if data4.current.value == 'showbateau' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'boating')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPCamion()
	local elements = {}
	table.insert(elements, {label = '🚌 Voir mon permis camion', value = 'checkcamion'})
	table.insert(elements, {label = '🚌 Montrer mon permis camion', value = 'showcamion'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_permiscamion',
		{
			css = 'santos',
			title    = '🚌 Permis camion',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkcamion' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive_truck')
			end
			if data4.current.value == 'showcamion' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'drive_truck')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPMoto()
	local elements = {}
	table.insert(elements, {label = '🏍️ Voir mon permis moto', value = 'checkmoto'})
	table.insert(elements, {label = '🏍️ Montrer mon permis moto', value = 'showmoto'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_permismoto',
		{
			css = 'santos',
			title    = '🏍️ Permis moto',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkmoto' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'drive_bike')
			end
			if data4.current.value == 'showmoto' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'drive_bike')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPPA()
	local elements = {}
	table.insert(elements, {label = '🔫 Voir mon PPA', value = 'checkFirearms'})
	table.insert(elements, {label = '🔫 Montrer mon PPA', value = 'showFirearms'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_ppa',
		{
			css = 'santos',
			title    = '🔫 Permis port d\'Armes',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkFirearms' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
			end
			if data4.current.value == 'showFirearms' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openPC()
	local elements = {}
	table.insert(elements, {label = '💥 Voir mon Permis de Chasse', value = 'checkChasse'})
	table.insert(elements, {label = '💥 Montrer mon Permis de Chasse', value = 'showChasse'})	
	ESX.UI.Menu.Open(					
		'default', GetCurrentResourceName(), 'menuperso_moi_pc',
		{
			css = 'santos',
			title    = '💥 Permis de Chasse',
			align    = 'top-left',
			elements = elements
		},
		function(data4, menu4)
			if data4.current.value == 'checkChasse' then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'chasse')
			end
			if data4.current.value == 'showChasse' then
				local player, distance = ESX.Game.GetClosestPlayer()
				if distance ~= -1 and distance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'chasse')
				else
					ESX.ShowNotification("~r~Il n'y a personne à proximité.")
				end
			end	
		end,
		function(data4, menu4)
			menu4.close()
		end
	)
end

function openAccesoires()
	TriggerEvent('santos_menuperso:OpenAccessoryMenu')
end

function openFacture()
	TriggerEvent('santos_menuperso:openMenuFactures')
end
---------------------------------------------------------------------------Actions

local playAnim = false
local dataAnim = {}

function animsAction(animObj)
	if not IsInVehicle() then
		Citizen.CreateThread(function()
			if not playAnim then
				local playerPed = PlayerPedId()
				if DoesEntityExist(playerPed) then -- Ckeck if ped exist
					dataAnim = animObj

					-- Play Animation
					RequestAnimDict(dataAnim.lib)
					while not HasAnimDictLoaded(dataAnim.lib) do
						Citizen.Wait(0)
					end
					if HasAnimDictLoaded(dataAnim.lib) then
						local flag = 0
						if dataAnim.loop ~= nil and dataAnim.loop then
							flag = 1
						elseif dataAnim.move ~= nil and dataAnim.move then
							flag = 49
						end

						TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
						playAnimation = true
					end

					-- Wait end annimation
					while true do
						Citizen.Wait(0)
						if playAnim then
							if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) and not IsPedUsingAnyScenario(playerPed) then
								playAnim = false
								break
							end
						end
					end
				end
			end
		end)
	end
end

function animPlay(lib, anim)
	if (not IsInVehicle()) and not IsPlayerDead(PlayerId()) then
		ESX.Streaming.RequestAnimDict(lib)

		TaskPlayAnim(PlayerPedId(), lib, anim, 4.0, -1, -1, 50, 0, false, false, false)
		Citizen.Wait(2500)
		ClearPedTasks(PlayerPedId())
	end
end
	
function animsActionAttitude(lib, anim)
	if not IsInVehicle() then
		ESX.Streaming.RequestAnimSet(lib, function()
			SetPedMovementClipset(PlayerPedId(), anim, true)
		end)

		TriggerServerEvent('updateAttitudeSQL', lib, anim)
	end
end

function animsActionScenario(animObj)
	if not IsInVehicle() then
		if not IsPedUsingAnyScenario(PlayerPedId()) then
			if DoesEntityExist(PlayerPedId()) then
				dataAnim = animObj
				TaskStartScenarioInPlace(PlayerPedId(), dataAnim.anim, 0, false)
			end
		end
	end
end

function IsInVehicle()
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		return true
	else
		return false
	end
end

local hostageAllowedWeapons = {
	`WEAPON_PISTOL`,
	`WEAPON_COMBATPISTOL`,
}

function takeHostage()
	local playerPed = PlayerPedId()

	ClearPedSecondaryTask(playerPed)
	DetachEntity(playerPed, true, false)

	for i=1, #hostageAllowedWeapons do
		if HasPedGotWeapon(playerPed, hostageAllowedWeapons[i], false) then
			if GetAmmoInPedWeapon(playerPed, hostageAllowedWeapons[i]) > 0 then
				canTakeHostage = true 
				foundWeapon = hostageAllowedWeapons[i]
				break
			end 					
		end
	end

	if not canTakeHostage then 
		ESX.ShowNotification("~r~Vous avez besoin d'un pistolet avec des munitions pour prendre quelqu'un en otage !")
	end

	if not holdingHostageInProgress and canTakeHostage then
		lib = 'anim@gangops@hostage@'
		anim1 = 'perp_idle'
		lib2 = 'anim@gangops@hostage@'
		anim2 = 'victim_idle'
		distans = 0.11 --Higher = closer to camera
		distans2 = -0.24 --higher = left
		height = 0.0
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 49
		animFlagTarget = 50
		attachFlag = true 
		local closestPly, closestDist = ESX.Game.GetClosestPlayer()
		local target = GetPlayerServerId(closestPly)
		
		if closestPly ~= nil and closestPly ~= -1 and closestDist <= 3.0 and not IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(target)), true) then
			SetCurrentPedWeapon(playerPed, foundWeapon, true)
			holdingHostageInProgress = true
			holdingHostage = true 
			TriggerServerEvent('cmg3_animations:sync', closestPly, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
		else
			ESX.ShowNotification("~r~Il n'y a personne à proximité")
		end 
	end
	canTakeHostage = false 
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		if holdingHostage then
    		local playerPed = PlayerPedId()
			if IsEntityDead(playerPed) then		
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPly, closestDist = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPly)
				if closestDist <= 3.0 then
					TriggerServerEvent("cmg3_animations:stop", target)
					Wait(100)
					releaseHostage()
				end
			end 
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisablePlayerFiring(playerPed,true)
			local playerCoords = GetEntityCoords(playerPed)
			ESX.Game.Utils.DrawText3D({ x = playerCoords.x, y = playerCoords.y, z = playerCoords.z}, "Appuyez sur [C] pour le relacher, [H] pour l'abattre",1,4)
			if IsDisabledControlJustPressed(0,26) then
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPly, closestDist = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPly)
				if closestDist <= 3.0 then
					TriggerServerEvent("cmg3_animations:stop",target)
					Wait(100)
					releaseHostage()
				end
			elseif IsDisabledControlJustPressed(0,74) then
				holdingHostage = false
				holdingHostageInProgress = false 		
				local closestPly, closestDist = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPly)
				if closestDist <= 3.0 then
					TriggerServerEvent("cmg3_animations:stop",target)				
					killHostage()
				end
			end
		else
			Citizen.Wait(500)
		end
		if beingHeldHostage then 
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,22,true) -- disable jump
			DisableControlAction(0,32,true) -- disable move up
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true) -- disable move down
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true) -- disable move left
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true) -- disable move right
			DisableControlAction(0,271,true)
		else
			Citizen.Wait(500)
		end
	end
end)

function releaseHostage()
	local player = PlayerPedId()	
	local lib = 'reaction@shove'
	local anim1 = 'shove_var_a'
	local lib2 = 'reaction@shove'
	local anim2 = 'shoved_back'
	local distans = 0.11 --Higher = closer to camera
	local distans2 = -0.24 --higher = left
	local height = 0.0
	local spin = 0.0		
	local length = 100000
	local controlFlagMe = 120
	local controlFlagTarget = 0
	local animFlagTarget = 1
	local attachFlag = false
	local closestPly, closestDist = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPly)
	if closestPly ~= nil and closestPly ~= -1 then
		TriggerServerEvent('cmg3_animations:sync', closestPly, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end
end 

function killHostage()
	local player = PlayerPedId()	
	local lib = 'anim@gangops@hostage@'
	local anim1 = 'perp_fail'
	local lib2 = 'anim@gangops@hostage@'
	local anim2 = 'victim_fail'
	local distans = 0.11 --Higher = closer to camera
	local distans2 = -0.24 --higher = left
	local height = 0.0
	local spin = 0.0		
	local length = 0.2
	local controlFlagMe = 168
	local controlFlagTarget = 0
	local animFlagTarget = 1
	local attachFlag = false
	local closestPly, closestDist = ESX.Game.GetClosestPlayer()
	local target = GetPlayerServerId(closestPly)
	if closestPly ~= nil and closestPly ~= -1 then
		TriggerServerEvent('cmg3_animations:sync', closestPly, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end	
end

RegisterNetEvent('santos_menuperso:openMenuPersonnel')
AddEventHandler('santos_menuperso:openMenuPersonnel', function()
	if not isAdmin then
		ESX.TriggerServerCallback('santos_menuperso:isAdmin', function(Bool)
			isAdmin = Bool
		end)
		Citizen.Wait(100)
	end
	OpenPersonnelMenu()
end)
