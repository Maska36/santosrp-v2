--local GUI = {}
--GUI.Time = 0
local IsOpen = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(1, 166) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso') then
			TriggerEvent('smp:getSim')
			TriggerEvent('santos_menuperso:openMenuPersonnel')
		end
	end
end)

RegisterNetEvent('santos_menuperso:closeAllSubMenu')
AddEventHandler('santos_menuperso:closeAllSubMenu', function()
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('santos_menuperso:closeAllMenu')
AddEventHandler('santos_menuperso:closeAllMenu', function()
	ESX.UI.Menu.CloseAll()
end)

--------------------------------------------------------------------------------------------
-- Fermeture des Menu
--------------------------------------------------------------------------------------------
-- Menu Perso
RegisterNetEvent('santos_menuperso:closeMenuPersonnel')
AddEventHandler('santos_menuperso:closeMenuPersonnel', function()
	ESX.UI.Menu.CloseAll()
end)

-- Factures
RegisterNetEvent('santos_menuperso:closeMenuFactures')
AddEventHandler('santos_menuperso:closeMenuFactures', function()
	TriggerEvent('santos_menuperso:closeAllMenu')
end)

-- Police
RegisterNetEvent('santos_menuperso:closeMenuPolice')
AddEventHandler('santos_menuperso:closeMenuPolice', function()
	ESX.UI.Menu.CloseAll()
end)

-- Ambulance
RegisterNetEvent('santos_menuperso:closeMenuAmbulance')
AddEventHandler('santos_menuperso:closeMenuAmbulance', function()
	ESX.UI.Menu.CloseAll()
end)

-- Mecano
RegisterNetEvent('santos_menuperso:closeMenuMecano')
AddEventHandler('santos_menuperso:closeMenuMecano', function()
	ESX.UI.Menu.CloseAll()
end)

--------------------------------------------------------------------------------------------
-- Pause menu Cache L'HUD et ferme les menu
--------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		if (IsPauseMenuActive() or IsControlPressed(1, 37)) and not IsPaused then
			IsPaused = true
			TriggerEvent('santos_menuperso:closeAllSubMenu')
			TriggerEvent('santos_menuperso:closeAllMenu')
			IsOpen = false
			TriggerEvent('es:setMoneyDisplay', 0.0)
			ESX.UI.HUD.SetDisplay(0.0)
		elseif not (IsPauseMenuActive() or IsControlPressed(1, 37)) and IsPaused then
			IsPaused = false
			IsOpen = false
			TriggerEvent('es:setMoneyDisplay', 1.0)
			ESX.UI.HUD.SetDisplay(1.0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Wait(0)
		
		if (ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menu_perso')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_moi')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Salute')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Humor')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Travail')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Festives')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_actions_Others')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_ouvrirportes')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_vehicule_fermerportes')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_gpsrapide')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_grade')) or
		(ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'menuperso_modo')) or
		
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_give')) or
		(ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item_count_remove')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_phone', 'main')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_billing', 'billing')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'police_actions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'citizen_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'vehicle_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_policejob', 'object_spawner')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'mobile_ambulance_actions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_ambulancejob', 'citizen_interaction')) or
		
		(ESX.UI.Menu.IsOpen('default', 'esx_MJ', 'MecanoActions')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_MJ', 'citizen_interaction')) or
		(ESX.UI.Menu.IsOpen('default', 'esx_shops', 'shop')) 
		then
			IsOpen = true
		else
			IsOpen = false
		end
		
		if IsOpen then
			local ply = PlayerPedId()
			local active = true

			DisablePlayerFiring(ply, active) -- desactive armes a feu
			DisableControlAction(0, 24, active) -- attaque
			DisableControlAction(0, 142, active) -- attaque de melee
			
			DisableControlAction(0, 12, active) -- Selection d'arme roue
			DisableControlAction(0, 14, active) -- Selection d'arme suivante roue
			DisableControlAction(0, 15, active) -- Selection d'arme precedente roue
			DisableControlAction(0, 16, active) -- Selection d'arme suivante
			DisableControlAction(0, 17, active) -- Selection d'arme precedente
			DisableControlAction(0, 140, active) -- coup de poing
			DisableControlAction(0, 80, active) -- Camera aleatoire en voiture
			DisableControlAction(0, 73, active) -- Camera aleatoire en voiture
		end
		break
	end
end)