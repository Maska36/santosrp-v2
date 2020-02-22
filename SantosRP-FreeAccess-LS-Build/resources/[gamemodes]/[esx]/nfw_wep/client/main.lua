ESX = nil
local IsDead = false

pistol = {453432689, 3219281620, 1593441988, -1716589765, -1076751822, -771403250, 137902532, -598887786, -1045183535, 584646201}
mg = {324215364, -619010992, 736523883, 2024373456, -270015777, 171789620, -1660422300, 2144741730, 3686625920, 1627465347, -1121678507}
ar = {-1074790547, 961495388, -2084633992, 4208062921, -1357824103, -1063057011, 2132975508, 1649403952}
sg = {487013001, 2017895192, -1654528753, -494615257, -1466123874, 984333226, -275439685, 317205821}

supp1 = {-2084633992, -1357824103, 2132975508, -494615257}
supp2 = {-1716589765, 324215364, -270015777, -1074790547, -1063057011, -1654528753, 984333226}
supp3 = {1593441988, -771403250, 584646201, 137902532, 736523883}
supp4 = {487013001}

flash1 = {453432689, 1593441988, 584646201, -1716589765, -771403250, 324215364}
flash2 = {736523883, -270015777, 171789620, -1074790547, -2084633992, -1357824103, -1063057011, 2132975508, 487013001, -494615257, -1654528753, 984333226}

grip1 = {171789620, -1074790547, -2084633992, -1063057011, 2132975508, 2144741730, -494615257, -1654528753, 984333226}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSO', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('playerSpawned', function()
    used = 0
    used2 = 0
    used3 = 0
    used4 = 0
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

local used = 0

RegisterNetEvent('nfw_wep:silencieux')
AddEventHandler('nfw_wep:silencieux', function()
    local inventory = ESX.GetPlayerData().inventory
    local silencieux = 0
    local item = 'silencieux'
    
    for i=1, #inventory, 1 do
        if inventory[i].name == 'silencieux' then
            silencieux = inventory[i].count
        end
    end

    local ped = PlayerPedId()
    local WepHash = GetSelectedPedWeapon(ped)

    if WepHash == `WEAPON_PISTOL` then
        GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_PISTOL`, `component_at_pi_supp_02`)
        ESX.ShowNotification('Ton silencieux est équipé !')
        used = used + 1
    elseif table.includes(supp1, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0x837445AA)
        ESX.ShowNotification('Ton silencieux est équipé !')
        used = used + 1
    elseif table.includes(supp2, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0xA73D4664)
        ESX.ShowNotification('Ton silencieux est équipé !')
        used = used + 1
    elseif table.includes(supp3, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0xC304849A)
        ESX.ShowNotification('Ton silencieux est équipé !')
        used = used + 1
    elseif table.includes(supp4, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0xE608B35E)
        ESX.ShowNotification('Ton silencieux est équipé !')
        used = used + 1
    else
        ESX.ShowNotification('Cette arme n\'est pas compatible avec le silencieux')
        TriggerServerEvent('returnItem', item)
    end
end)

local used2 = 0

RegisterNetEvent('nfw_wep:flashlight')
AddEventHandler('nfw_wep:flashlight', function() 
    local inventory = ESX.GetPlayerData().inventory
    local flashlight = 0
    local item = 'flashlight'
    
    for i=1, #inventory, 1 do
		if inventory[i].name == 'flashlight' then
			flashlight = inventory[i].count
		end
	end
    local ped = PlayerPedId()
    local WepHash = GetSelectedPedWeapon(ped)

    if table.includes(flash1, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0x359B7AAE)
        ESX.ShowNotification('Ta lampe est équipé !')
    elseif table.includes(flash2, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0x7BC4CDDC)
        ESX.ShowNotification('Ta lampe est équipé !')
    else
        ESX.ShowNotification('Cette arme n\'est pas compatible avec la lampe')
        TriggerServerEvent('returnItem', item)
    end
end)

local used3 = 0

RegisterNetEvent('nfw_wep:grip')
AddEventHandler('nfw_wep:grip', function()
    local inventory = ESX.GetPlayerData().inventory
    local grip = 0
    local item = 'grip'

    for i=1, #inventory, 1 do
        if inventory[i].name == 'grip' then
            grip = inventory[i].count
        end
    end

    local ped = PlayerPedId()
    local WepHash = GetSelectedPedWeapon(ped) 

    if table.includes(grip1, WepHash) then
        GiveWeaponComponentToPed(PlayerPedId(), WepHash, 0xC164F53)
        ESX.ShowNotification('Ta poignée est équipée !')
    else
        ESX.ShowNotification('Cette arme n\'est pas compatible avec la poignée')
        TriggerServerEvent('returnItem', item)
    end
end)

RegisterNetEvent('nfw_wep:yusuf')
AddEventHandler('nfw_wep:yusuf', function()
    local inventory = ESX.GetPlayerData().inventory
    local yusuf = 0
    for i=1, #inventory, 1 do
        if inventory[i].name == 'yusuf' then
            yusuf = inventory[i].count
        end
    end

    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    if used4 < yusuf then

        if currentWeaponHash == `WEAPON_PISTOL` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_PISTOL`, `COMPONENT_PISTOL_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1
        
        elseif currentWeaponHash == `WEAPON_PISTOL50` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_PISTOL50`, `COMPONENT_PISTOL50_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_APPISTOL` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_APPISTOL`, `COMPONENT_APPISTOL_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_HEAVYPISTOL` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_HEAVYPISTOL`, `COMPONENT_HEAVYPISTOL_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_SMG` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_SMG`, `COMPONENT_SMG_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_MICROSMG` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_MICROSMG`, `COMPONENT_MICROSMG_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_ASSAULTRIFLE` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_ASSAULTRIFLE`, `COMPONENT_ASSAULTRIFLE_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_CARBINERIFLE` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_CARBINERIFLE`, `COMPONENT_CARBINERIFLE_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1

        elseif currentWeaponHash == `WEAPON_ADVANCEDRIFLE` then
            GiveWeaponComponentToPed(PlayerPedId(), `WEAPON_ADVANCEDRIFLE`, `COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE`)
            ESX.ShowNotification('Ton Skin de Luxe est équipé !')
            used4 = used4 + 1
        else
            ESX.ShowNotification('Vous n\'avez pas d\'arme compatible en main')
        end
    else
        ESX.ShowNotification('Vous avez utilisé tous vos skins.')
    end
end)

RegisterNetEvent('nfw_wep:SmallArmor')
AddEventHandler('nfw_wep:SmallArmor', function()
    local inventory = ESX.GetPlayerData().inventory
    local ped = PlayerPedId()
    local armor = GetPedArmour(ped)
    local item = 'SmallArmor'

    if(armor >= 100) or (armor+30 > 100) then
        ESX.ShowNotification('Votre armure est déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    TriggerEvent('mythic_progbar:client:progress', {
        name = 'smallb_armor',
        duration = 5000,
        label = 'Vous mettez le Kevlar Léger...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_02",
        }
    }, function(status)
        if not status then
            SetPedComponentVariation(ped, 9, 10, 0, 0)
            AddArmourToPed(ped, 30)
            ESX.ShowNotification('Vous avez mis votre Kevlar léger !')
        end
    end)
end)

RegisterNetEvent('nfw_wep:MedArmor')
AddEventHandler('nfw_wep:MedArmor', function()
    local inventory = ESX.GetPlayerData().inventory
    local ped = PlayerPedId()
    local armor = GetPedArmour(ped)
    local item = 'MedArmor'

    if(armor >= 100) or (armor+60 > 100) then
        ESX.ShowNotification('Votre armure est déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    TriggerEvent('mythic_progbar:client:progress', {
        name = 'medb_armor',
        duration = 10000,
        label = 'Vous mettez le Kevlar Moyen...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_02",
        }
    }, function(status)
        if not status then
            SetPedComponentVariation(ped, 9, 10, 0, 0)
            AddArmourToPed(ped, 60)
            ESX.ShowNotification('Vous avez mis votre Kevlar moyen !')
        end
    end)
end)

RegisterNetEvent('nfw_wep:HeavyArmor')
AddEventHandler('nfw_wep:HeavyArmor', function()
    local inventory = ESX.GetPlayerData().inventory
    local ped = PlayerPedId()
    local armor = GetPedArmour(ped)
    local item = 'HeavyArmor'

    if(armor >= 100) or (armor+100 > 100) then
        ESX.ShowNotification('Votre armure est déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    TriggerEvent('mythic_progbar:client:progress', {
        name = 'heavyb_armor',
        duration = 15000,
        label = 'Vous mettez le Kevlar Lourd...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "rcmfanatic3",
            anim = "kneel_idle_a",
        },
        prop = {
            model = "prop_bodyarmour_02",
        }
    }, function(status)
        if not status then
            SetPedComponentVariation(ped, 9, 10, 0, 0)
            AddArmourToPed(ped, 100)
            ESX.ShowNotification('Vous avez mis votre Kevlar lourd !')
        end
    end)
end)

RegisterNetEvent('nfw_wep:pAmmo')
AddEventHandler('nfw_wep:pAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "pAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        ESX.ShowNotification('Vos munitions sont déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    if table.includes(pistol, currentWeaponHash) then
        ESX.ShowNotification('~g~Ajout de 50 munitions de pistolet supplémentaires')
        AddAmmoToPed(ped, currentWeaponHash, 50)
    else
        ESX.ShowNotification('~r~Cette arme n\'est pas compatible avec ce type d\'arme')
        TriggerServerEvent('returnItem', item)
    end
end)

RegisterNetEvent('nfw_wep:mgAmmo')
AddEventHandler('nfw_wep:mgAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "mgAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        ESX.ShowNotification('Vos munitions sont déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    if table.includes(mg, currentWeaponHash) then
        ESX.ShowNotification('~g~Ajout de 50 munitions de SMG supplémentaires')
        AddAmmoToPed(ped, currentWeaponHash, 50)
    else
        ESX.ShowNotification('~r~Cette arme n\'est pas compatible avec ce type d\'arme')
        TriggerServerEvent('returnItem', item)
    end
end)

RegisterNetEvent('nfw_wep:arAmmo')
AddEventHandler('nfw_wep:arAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "arAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        ESX.ShowNotification('Vos munitions sont déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    if table.includes(ar, currentWeaponHash) then
        ESX.ShowNotification('~g~Ajout de 50 munitions de Fusil d\'Assaut supplémentaires')
        AddAmmoToPed(ped, currentWeaponHash, 50)
    else
        ESX.ShowNotification('~r~Cette arme n\'est pas compatible avec ce type d\'arme')
        TriggerServerEvent('returnItem', item)
    end
end)

RegisterNetEvent('nfw_wep:sgAmmo')
AddEventHandler('nfw_wep:sgAmmo', function()
    local ped = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(ped)
    local ammo = GetAmmoInPedWeapon(ped, currentWeaponHash)
    local item = "sgAmmo"

    if(ammo >= 250 or ammo + 50 > 250) then
        ESX.ShowNotification('Vos munitions sont déja au max !')
        TriggerServerEvent('returnItem', item)
        return
    end

    if table.includes(sg, currentWeaponHash) then
        ESX.ShowNotification('~g~Ajout de 50 munitions de Shotgun supplémentaires')
        AddAmmoToPed(ped, currentWeaponHash, 50)
    else
        ESX.ShowNotification('~r~Cette arme n\'est pas compatible avec ce type d\'arme')
        TriggerServerEvent('returnItem', item)
    end
end)

function table.includes(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end